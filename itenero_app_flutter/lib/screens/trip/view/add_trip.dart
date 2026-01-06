import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:flutter_calenders/flutter_calenders.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/config_size.dart';

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
            title: const Text(
              'Select Destination',
            ),
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
            showCurrentLocationPointer: true,
            mapLanguage: 'en',
            searchBarHintText: 'Search destination...',
            searchBarBackgroundColor: AppColors.white,
            selectLocationButtonPositionBottom: 16.0,
            selectLocationButtonStyle: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.normalpadding,
                vertical: SizeConfig.normalpadding * 1.25,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  SizeConfig.simpleBorderRadius * 3,
                ),
              ),
            ),
            zoomButtonsColor: AppColors.white,
            zoomButtonsBackgroundColor: AppColors.primary,
            markerIcon: const Icon(
              Icons.location_on,
              color: AppColors.error,
              size: 60,
            ),
            onPicked: (pickedData) {
              Navigator.pop(context, pickedData);
            },
            onError: (exception) {
              // Handle errors gracefully
              print('Location picker error: $exception');
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
          borderRadius: BorderRadius.circular(SizeConfig.simpleBorderRadius),
        ),
        child: Container(
          padding: EdgeInsets.all(SizeConfig.normalpadding * 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Travel Dates',
                    style: TextStyle(
                      fontSize: SizeConfig.mediumText2,
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
              SizedBox(height: SizeConfig.normalpadding * 2),
              EventBasedCalender(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.all(SizeConfig.normalpadding * 2),
                events: [],
                primaryColor: AppColors.primary,
                backgroundColor: AppColors.primary.withOpacity(0.05),
                chooserColor: AppColors.text,
                endYear: 2030,
                startYear: 2025,
                currentMonthDateColor: AppColors.text,
                pastFutureMonthDateColor: AppColors.grey,
                isSelectedColor: AppColors.secondary,
                isSelectedShow: true,
                showEvent: false,
                onDateTap: (date) {
                  setState(() {
                    if (_startDate == null ||
                        (_startDate != null && _endDate != null)) {
                      _startDate = date;
                      _endDate = null;
                    } else if (_endDate == null) {
                      if (date.isBefore(_startDate!)) {
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
              SizedBox(height: SizeConfig.normalpadding * 2),
              if (_startDate != null)
                Container(
                  padding: EdgeInsets.all(SizeConfig.normalpadding * 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      SizeConfig.simpleBorderRadius,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Start:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: SizeConfig.smallText2,
                            ),
                          ),
                          Text(
                            '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.smallText2,
                            ),
                          ),
                        ],
                      ),
                      if (_endDate != null) ...[
                        SizedBox(height: SizeConfig.normalpadding),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'End:',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.smallText2,
                              ),
                            ),
                            Text(
                              '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.smallText2,
                              ),
                            ),
                          ],
                        ),
                      ] else
                        SizedBox(height: SizeConfig.normalpadding),
                      if (_endDate == null)
                        Text(
                          'Tap another date to set end date',
                          style: TextStyle(
                            fontSize: SizeConfig.smallText3,
                            color: AppColors.grey,
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

  void _handleVoiceInput() {
    setState(() {
      _isListening = !_isListening;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Voice input feature - integrate with speech_to_text package',
          style: TextStyle(fontSize: SizeConfig.smallText2),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _generateItinerary() {
    if (_destination.isEmpty ||
        _startDate == null ||
        _endDate == null ||
        _selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all required fields',
            style: TextStyle(fontSize: SizeConfig.smallText2),
          ),
          backgroundColor: AppColors.error,
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Trip created! Generating itinerary...',
          style: TextStyle(fontSize: SizeConfig.smallText2),
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
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
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 2,
        centerTitle: true,
        title: Text(
          'Plan a New Trip',
          style: GoogleFonts.inter(
            fontSize: SizeConfig.mediumText1,
            fontWeight: FontWeight.w700,
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
          padding: EdgeInsets.all(SizeConfig.normalpadding * 4),
          child: Column(
            children: [
              // Voice Input Section
              Text(
                'Answer a few questions or use your voice',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                  fontSize: SizeConfig.smallText2,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: SizeConfig.normalpadding * 5),
              GestureDetector(
                onTap: _handleVoiceInput,
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 20,
                  height: SizeConfig.blockSizeHorizontal * 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening
                        ? AppColors.secondary
                        : AppColors.lightSuccess,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/images/mic.svg',
                      color: _isListening
                          ? AppColors.white
                          : AppColors.secondary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.normalpadding * 6),
              Text(
                'Speak your travel preferences',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                  height: SizeConfig.smallText1 / 170,
                  color: AppColors.darkGrey,
                  fontSize: SizeConfig.smallText1,
                ),
              ),
              SizedBox(height: SizeConfig.normalpadding * 8),

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
                        padding: EdgeInsets.all(
                          SizeConfig.normalpadding * 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightGrey),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.simpleBorderRadius,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _destination.isEmpty
                                    ? 'Search destination'
                                    : _destination,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: SizeConfig.smallText2,
                                  color: _destination.isEmpty
                                      ? Color(0xFF6C757D80)
                                      : AppColors.text,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.search,
                              color: AppColors.grey,
                              size: SizeConfig.mediumText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.normalpadding * 2),

              // Date Range
              _buildCard(
                title: 'Travel Dates',
                icon: Icons.calendar_today_outlined,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _selectDateRange,
                      child: Container(
                        padding: EdgeInsets.all(
                          SizeConfig.normalpadding * 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightGrey),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.simpleBorderRadius,
                          ),
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
                                style: GoogleFonts.inter(
                                  fontSize: SizeConfig.smallText2,
                                  color: _startDate == null
                                      ? Color(0xFF6C757D80)
                                      : AppColors.text,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.grey,
                              size: SizeConfig.mediumText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.normalpadding * 1.5),
                    Text(
                      'Duration: $_daysCount ${_daysCount == 1 ? 'day' : 'days'}',
                      style: GoogleFonts.inter(
                        fontSize: SizeConfig.smallText1,
                        color: AppColors.text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.normalpadding * 2),

              // Travelers Type
              _buildCard(
                title: 'Traveling As',
                icon: Icons.people_outline,
                child: Wrap(
                  spacing: SizeConfig.normalpadding,
                  runSpacing: SizeConfig.normalpadding,
                  children: _travelerTypes.map((type) {
                    final isSelected = _travelersType == type['id'];
                    return GestureDetector(
                      onTap: () => setState(() => _travelersType = type['id']!),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.normalpadding * 3.25,
                          vertical: SizeConfig.normalpadding * 1.75,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.lightGrey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.simpleBorderRadius * 2,
                          ),
                        ),
                        child: Text(
                          type['label']!,
                          style: TextStyle(
                            fontSize: SizeConfig.smallText1,
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
              SizedBox(height: SizeConfig.normalpadding * 2),

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
                          right: entry.key < _budgetOptions.length - 1
                              ? SizeConfig.normalpadding
                              : 0,
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() => _budget = option['id']),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.normalpadding * 3.25,
                              vertical: SizeConfig.normalpadding * 1.75,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.secondary
                                  : AppColors.white,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.secondary
                                    : AppColors.lightGrey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                SizeConfig.simpleBorderRadius,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                option['label']!,
                                style: TextStyle(
                                  fontSize: SizeConfig.smallText1,
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
              SizedBox(height: SizeConfig.normalpadding * 2),

              // Interests
              _buildCard(
                title: 'Interests',
                icon: Icons.favorite_outline,
                child: Wrap(
                  spacing: SizeConfig.normalpadding,
                  runSpacing: SizeConfig.normalpadding,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.normalpadding * 3.25,
                          vertical: SizeConfig.normalpadding * 1.75,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.lightGrey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.simpleBorderRadius * 2,
                          ),
                        ),
                        child: Text(
                          interest['label']!,
                          style: TextStyle(
                            fontSize: SizeConfig.smallText1,
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
              SizedBox(height: SizeConfig.normalpadding * 2),

              // Additional Description
              _buildCard(
                title: 'Additional Details (Optional)',
                icon: Icons.description_outlined,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: GoogleFonts.inter(fontSize: SizeConfig.smallText2),
                  decoration: InputDecoration(
                    hintText: 'Tell us more about your trip preferences',
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.grey,
                      fontSize: SizeConfig.smallText2,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.simpleBorderRadius,
                      ),
                      borderSide: BorderSide(color: AppColors.lightGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.simpleBorderRadius,
                      ),
                      borderSide: BorderSide(color: AppColors.lightGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.simpleBorderRadius,
                      ),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),

                    contentPadding: EdgeInsets.all(
                      SizeConfig.normalpadding * 1.75,
                    ),
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.normalpadding * 3),

              // Submit Button
              ElevatedButton(
                onPressed: _generateItinerary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  foregroundColor: AppColors.white,
                  minimumSize: Size(
                    double.infinity,
                    SizeConfig.blockSizeVertical * 5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.simpleBorderRadius * 3,
                    ),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.buttonColor.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/star.svg',
                    ),
                    SizedBox(width: SizeConfig.normalpadding),
                    Text(
                      'Generate my itinerary',
                      style: GoogleFonts.inter(
                        fontSize: SizeConfig.smallText2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.normalpadding * 3),
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
      margin: EdgeInsets.only(bottom: SizeConfig.normalpadding * 2),
      padding: EdgeInsets.all(SizeConfig.normalpadding * 3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          SizeConfig.simpleBorderRadius * 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
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
              Icon(
                icon,
                size: SizeConfig.mediumText1,
                color: AppColors.text,
              ),
              SizedBox(width: SizeConfig.normalpadding),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.smallText2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.normalpadding * 2),
          child,
        ],
      ),
    );
  }
}
