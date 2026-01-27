import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itenero_app_client/itenero_app_client.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/config_size.dart';
import '../../../packages/client_provider.dart';
import '../../../routes/routes.dart';
import '../../trip/view/add_trip.dart';
import '../../trip/view/trip_details_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<List<Trip>> _tripsFuture;

  @override
  void initState() {
    super.initState();
    _refreshTrips();
  }

  void _refreshTrips() {
    setState(() {
      _tripsFuture = ref.read(clientProvider).trip.listTrips();
    });
  }

  // Haversine formula to calculate distance
  int _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const Distance distance = Distance();
    return distance
        .as(
          LengthUnit.Kilometer,
          LatLng(lat1, lon1),
          LatLng(lat2, lon2),
        )
        .toInt();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // Dummy user name
    const userName = "Alex";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(SizeConfig.normalpadding * 2),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Image.asset(
                        'assets/images/logo-small.png',
                      ),

                      //Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications,
                          color: AppColors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hi ',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        TextSpan(
                          text: '$userName,',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.normalpadding * 3),
                  // Search Bar
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.normalpadding * 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search your trip',
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.grey,
                        ),
                        border: InputBorder.none,
                        icon: const Icon(
                          Icons.search,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.normalpadding * 2),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.normalpadding * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All trips',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: SizeConfig.normalpadding * 2),
                    Expanded(
                      child: FutureBuilder<List<Trip>>(
                        future: _tripsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          final trips = snapshot.data ?? [];

                          if (trips.isEmpty) {
                            return _buildEmptyState();
                          }

                          return ListView.builder(
                            itemCount: trips.length,
                            itemBuilder: (context, index) {
                              return _buildTripCard(trips[index]);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTripPage()),
          );
          _refreshTrips();
        },
        shape: const CircleBorder(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.0,
        height: 60,
        color: Color(0xFFF6F6F6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home button
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: SvgPicture.asset('assets/images/home.svg'),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    //constraints: const BoxConstraints(),
                  ),
                  const Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              // Empty space for FAB
              const SizedBox(width: 40),
              // Settings button
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: SvgPicture.asset('assets/images/settings.svg'),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.settings);
                    },
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    //constraints: const BoxConstraints(),
                  ),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/trip_placeholder.png',
          height: 200,
        ),
        SizedBox(height: SizeConfig.normalpadding * 2),
        Text(
          'No trips yet',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTripCard(Trip trip) {
    // Calculate distance
    String distanceStr = 'N/A';
    if (trip.originLat != null &&
        trip.originLon != null &&
        trip.latitude != 0 &&
        trip.longitude != 0) {
      final km = _calculateDistance(
        trip.originLat!,
        trip.originLon!,
        trip.latitude,
        trip.longitude,
      );
      distanceStr = '$km km';
    }

    final isUpcoming = trip.startDate.isAfter(DateTime.now());
    final isOngoing =
        trip.startDate.isBefore(DateTime.now()) &&
        trip.endDate.isAfter(DateTime.now());

    return GestureDetector(
      onTap: () async {
        // Fetch trip plan and navigate
        try {
          final client = ref.read(clientProvider);
          final tripWithPlan = await client.trip.getTripWithPlan(
            tripId: trip.id!,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TripDetailsPage(tripWithPlan: tripWithPlan),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load trip: $e')),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.normalpadding * 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.normalpadding * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isUpcoming
                          ? Colors.amber
                          : isOngoing
                          ? AppColors.primary
                          : const Color(0xFF8CC63F), // Green for completed
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isUpcoming
                          ? 'Upcoming'
                          : isOngoing
                          ? 'Ongoing'
                          : 'Completed',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${trip.startDate.day} ${_getMonthName(trip.startDate.month)} ${trip.startDate.year}',
                    style: GoogleFonts.inter(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.normalpadding * 2),

              // Route visualization
              Row(
                children: [
                  // ORIGIN
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        trip.originAddress?.split(',').last ?? 'Origin',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),

                  // CENTER DIVIDER (fixed width)
                  SizedBox(
                    width: 120, // 👈 tweak this once, done forever
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(
                              child: Divider(
                                color: AppColors.secondary,
                                thickness: 1,
                              ),
                            ),
                            Icon(
                              Icons.flight_takeoff,
                              size: 16,
                              color: AppColors.secondary,
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColors.secondary,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          distanceStr,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // DESTINATION
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        trip.destination.split(',').last,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.normalpadding * 2),

              // Footer style info
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Travel Budget: ${trip.budget ?? 'Flexible'}',
                        style: GoogleFonts.inter(
                          color: AppColors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
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

  Widget _buildDetailItem(String label, String value, {bool isLast = false}) {
    return Column(
      crossAxisAlignment: isLast
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.grey,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            color: AppColors.text,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
