import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:flutter_calenders/flutter_calenders.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/app_colors.dart';

class AddTripPage extends StatefulWidget {
  const AddTripPage({Key? key}) : super(key: key);

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  String _destination = '';
  LatLong? _selectedLocation;
  DateTime? _startDate;
  DateTime? _endDate;
  int _daysCount = 1;
  String _travelersType = 'solo';
  String? _budget;
  final Set<String> _selectedInterests = {};
  final TextEditingController _descriptionController = TextEditingController();
  bool _isListening = false;

  final List<Map<String, String>> _interestOptions = [
    {'id': 'food', 'label': 'Food'},
    {'id': 'nature', 'label': 'Nature'},
    {'id': 'adventure', 'label': 'Adventure'},
    {'id': 'shopping', 'label': 'Shopping'},
    {'id': 'culture', 'label': 'Culture'},
    {'id': 'relaxation', 'label': 'Relaxation'},
  ];

  final List<Map<String, String>> _travelerTypes = [
    {'id': 'solo', 'label': 'Solo Traveler'},
    {'id': 'couple', 'label': 'Couple'},
    {'id': 'family', 'label': 'Family'},
    {'id': 'friends', 'label': 'Friends'},
  ];

  final List<Map<String, String>> _budgetOptions = [
    {'id': 'budget', 'label': 'Budget'},
    {'id': 'moderate', 'label': 'Moderate'},
    {'id': 'luxury', 'label': 'Luxury'},
  ];

  void _calculateDays() {
    if (_startDate != null && _endDate != null) {
      setState(() {
        _daysCount = _endDate!.difference(_startDate!).inDays + 1;
      });
    }
  }

  Future<void> _selectDestination() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text('Select Destination'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: FlutterLocationPicker(
            userAgent: 'IteneroApp/1.0 (contact: amina.github.io)',
            initPosition: _selectedLocation ?? LatLong(23.5880, 58.3829),
            selectLocationButtonText: 'Select This Location',
            initZoom: 11,
            minZoomLevel: 5,
            maxZoomLevel: 16,
            trackMyPosition: true,
            mapLanguage: 'en',
            searchBarHintText: 'Search destination...',
            searchBarBackgroundColor: Colors.white,
            selectLocationButtonPositionBottom: 16.0,
            //showSearchBar: false,
            selectLocationButtonStyle: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            zoomButtonsColor: AppColors.white,
            zoomButtonsBackgroundColor: AppColors.primary,
            //locationMarkerTextColor: AppColors.white,
            markerIcon: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 60,
            ),
            onPicked: (pickedData) {
              Navigator.pop(context, pickedData);
            },
          ),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result.latLong;
        _destination = result.address;
      });
    }
  }

  Future<void> _selectDateRange() async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Travel Dates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              EventBasedCalender(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(10),
                events: [],
                primaryColor: AppColors.primary,
                backgroundColor: AppColors.primary.withOpacity(0.05),
                chooserColor: AppColors.text,
                endYear: 2030,
                startYear: 2025,
                currentMonthDateColor: AppColors.text,
                pastFutureMonthDateColor: Colors.grey,
                isSelectedColor: AppColors.secondary,
                isSelectedShow: true,
                showEvent: false,
                onDateTap: (date) {
                  setState(() {
                    if (_startDate == null ||
                        (_startDate != null && _endDate != null)) {
                      // Start new selection
                      _startDate = date;
                      _endDate = null;
                    } else if (_endDate == null) {
                      // Set end date
                      if (date.isBefore(_startDate!)) {
                        // If selected date is before start, swap them
                        _endDate = _startDate;
                        _startDate = date;
                      } else {
                        _endDate = date;
                      }
                      _calculateDays();
                      Navigator.pop(context);
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_startDate != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Start:',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (_endDate != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'End:',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ] else
                        const SizedBox(height: 8),
                      if (_endDate == null)
                        const Text(
                          'Tap another date to set end date',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleVoiceInput() {
    setState(() {
      _isListening = !_isListening;
    });
    // Implement speech recognition here with speech_to_text package
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Voice input feature - integrate with speech_to_text package',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _generateItinerary() {
    if (_destination.isEmpty ||
        _startDate == null ||
        _endDate == null ||
        _selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final tripData = {
      'destination': _destination,
      'daysCount': _daysCount,
      'focus': _selectedInterests.join(','),
      'travelersType': _travelersType,
      'budget': _budget,
      'startDate': _startDate?.toIso8601String(),
      'endDate': _endDate?.toIso8601String(),
      'userDescription': _descriptionController.text,
      'latitude': _selectedLocation?.latitude,
      'longitude': _selectedLocation?.longitude,
    };

    debugPrint('Creating trip with data: $tripData');

    // TODO: Call your Serverpod endpoint here
    // Example:
    // final trip = await tripEndpoint.createTrip(
    //   session,
    //   destination: _destination,
    //   daysCount: _daysCount,
    //   focus: _selectedInterests.join(','),
    //   travelersType: _travelersType,
    //   budget: _budget,
    // );
    //
    // final result = await tripEndpoint.generateItinerary(
    //   session,
    //   tripId: trip.id!,
    //   userDescription: _descriptionController.text,
    // );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Trip created! Generating itinerary...'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 2,
        title: const Text(
          'Plan a New Trip',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),

        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/notification.svg',
              color: AppColors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Voice Input Section
              const Text(
                'Answer a few questions or use your voice',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _handleVoiceInput,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening
                        ? AppColors.secondary
                        : const Color(0xFFE8F5E9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.mic,
                    size: 48,
                    color: _isListening ? AppColors.white : AppColors.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Speak your travel preferences',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              // Destination Field
              _buildCard(
                title: 'Destination',
                icon: Icons.place_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _selectDestination,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _destination.isEmpty
                                    ? 'Search destination'
                                    : _destination,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _destination.isEmpty
                                      ? const Color(0xFF9CA3AF)
                                      : AppColors.text,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap to search and select from map',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),

              // Date Range
              _buildCard(
                title: 'Travel Dates',
                icon: Icons.calendar_today_outlined,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _selectDateRange,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _startDate == null
                                    ? 'Select dates'
                                    : _endDate == null
                                    ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - Select end date'
                                    : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _startDate == null
                                      ? const Color(0xFF9CA3AF)
                                      : AppColors.text,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF9CA3AF),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Duration: $_daysCount ${_daysCount == 1 ? 'day' : 'days'}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Travelers Type
              _buildCard(
                title: 'Traveling As',
                icon: Icons.people_outline,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _travelerTypes.map((type) {
                    final isSelected = _travelersType == type['id'];
                    return GestureDetector(
                      onTap: () => setState(() => _travelersType = type['id']!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFFE5E7EB),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          type['label']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.text,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Budget
              _buildCard(
                title: 'Budget',
                icon: Icons.attach_money,
                child: Row(
                  children: _budgetOptions.asMap().entries.map((entry) {
                    final option = entry.value;
                    final isSelected = _budget == option['id'];
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: entry.key < _budgetOptions.length - 1 ? 8 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() => _budget = option['id']),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.secondary
                                  : AppColors.white,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.secondary
                                    : const Color(0xFFE5E7EB),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                option['label']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Interests
              _buildCard(
                title: 'Interests',
                icon: Icons.favorite_outline,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _interestOptions.map((interest) {
                    final isSelected = _selectedInterests.contains(
                      interest['id'],
                    );
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedInterests.remove(interest['id']);
                          } else {
                            _selectedInterests.add(interest['id']!);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFFE5E7EB),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          interest['label']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.text,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Additional Description
              _buildCard(
                title: 'Additional Details (Optional)',
                icon: Icons.description_outlined,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Tell us more about your trip preferences...',
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _generateItinerary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  foregroundColor: AppColors.text,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.buttonColor.withOpacity(0.3),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '⭐',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Generate my itinerary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.text),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
