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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Itiner',
                            style: GoogleFonts.inter(
                              color: AppColors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.public,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications,
                          color: AppColors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.normalpadding),
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
                  SizedBox(height: SizeConfig.normalpadding * 2),
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
                  SizedBox(height: SizeConfig.normalpadding),
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
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: AppColors.primary),
                onPressed: () {},
              ),
              const SizedBox(width: 48), // Space for FAB
              IconButton(
                icon: const Icon(Icons.settings, color: AppColors.grey),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.settings);
                },
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
                          : const Color(0xFF8CC63F), // Green for completed
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isUpcoming ? 'Upcoming' : 'Completed',
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.originAddress ?? 'Origin',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'From',
                          style: GoogleFonts.inter(
                            color: AppColors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: AppColors.secondary,
                                thickness: 1,
                                indent: 5,
                                endIndent: 5,
                              ),
                            ),
                            const Icon(
                              Icons.flight_takeoff, // Plane icon
                              color: AppColors.secondary,
                              size: 16,
                            ),
                            const Expanded(
                              child: Divider(
                                color: AppColors.secondary,
                                thickness: 1,
                                indent: 5,
                                endIndent: 5,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          distanceStr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          trip.destination,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'To',
                          style: GoogleFonts.inter(
                            color: AppColors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
