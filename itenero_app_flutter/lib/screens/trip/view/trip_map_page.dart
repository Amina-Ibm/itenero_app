import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itenero_app_client/itenero_app_client.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/config_size.dart';

class TripMapPage extends StatefulWidget {
  final TripWithPlan tripWithPlan;

  const TripMapPage({Key? key, required this.tripWithPlan}) : super(key: key);

  @override
  State<TripMapPage> createState() => _TripMapPageState();
}

class _TripMapPageState extends State<TripMapPage> {
  late final MapController _mapController;
  final ScrollController _scrollController = ScrollController();

  // Calculate distance between two points
  int _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const Distance distance = Distance();
    return distance
        .as(
          LengthUnit.Kilometer,
          LatLng(lat1, lon1),
          LatLng(lat2, lon2),
        )
        .toInt();
  }

  Map<String, dynamic> get _travelDetails {
    final budget = widget.tripWithPlan.trip.budget ?? 'Moderate';

    // Get origin name
    String originName = 'Origin';
    if (widget.tripWithPlan.trip.originAddress != null) {
      originName = widget.tripWithPlan.trip.originAddress!;
      // Try to get just the country or city if the address is long
      if (originName.contains(',')) {
        originName = originName.split(',').last.trim();
      }
    }

    // Get destination name
    String destName = widget.tripWithPlan.trip.destination;
    // Try to get just the country or city if the address is long
    if (destName.contains(',')) {
      destName = destName.split(',').last.trim();
    }

    // Calculate distance
    String distanceStr = 'N/A';
    if (widget.tripWithPlan.trip.originLat != null &&
        widget.tripWithPlan.trip.originLon != null) {
      final dist = _calculateDistance(
        widget.tripWithPlan.trip.originLat!,
        widget.tripWithPlan.trip.originLon!,
        widget.tripWithPlan.trip.latitude,
        widget.tripWithPlan.trip.longitude,
      );
      distanceStr = '$dist km';
    }

    return {
      'budget': budget,
      'origin': originName,
      'destination': destName,
      'distance': distanceStr,
    };
  }

  double get _totalCost {
    double total = 0;
    for (var activity in widget.tripWithPlan.activities) {
      total += activity.estimatedCost ?? 0;
    }
    // Add dummy simulation for other costs if not strictly in activities
    // Or just assume activities cover everything.
    // For the UI to look populated like the design:
    return total > 0 ? total : 2000;
  }

  // Cost breakdown
  Map<String, double> get _costBreakdown {
    // Distribute total cost or use dummy values if total is 0
    double total = _totalCost;

    // Ratios
    return {
      'Flight': total * 0.2, // 200
      'Lodging': total * 0.4, // 700ish
      'Food': total * 0.15, // 300ish
      'Transit': total * 0.25, // 650ish
    };
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Collect all points
    final points = <LatLng>[];
    // Add Trip location
    points.add(
      LatLng(
        widget.tripWithPlan.trip.latitude,
        widget.tripWithPlan.trip.longitude,
      ),
    );

    // Add activities locations
    for (var act in widget.tripWithPlan.activities) {
      if (act.lat != null && act.lon != null) {
        points.add(LatLng(act.lat!, act.lon!));
      }
    }

    Trip? trip = widget.tripWithPlan.trip;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Trip',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.mediumText1,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            Colors.transparent, // Let map or header color show through
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // MAP Background
          Positioned.fill(
            bottom:
                SizeConfig.screenHeight * 0.45, // Leave space for bottom sheet
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(trip.latitude, trip.longitude),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=Xwa8y7vAh45BBBBTOXcU',

                  tileDimension: 512, // 256, 512, 1024, 2048
                  zoomOffset: -2,
                ),

                MarkerLayer(
                  markers: points
                      .map(
                        (point) => Marker(
                          point: point,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: AppColors.error,
                            size: 40,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),

          // Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.55,
            maxChildSize: 0.65,
            builder: (context, scrollController) {
              final travel = _travelDetails;
              final costs = _costBreakdown;
              final total = _totalCost;

              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FB), // Light greyish white
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(SizeConfig.normalpadding * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.normalpadding * 2),

                      // Flight Route
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildLocationNode(
                              travel['origin'],
                              Icons.flight_takeoff,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: AppColors.secondary,
                                        thickness: 1,
                                        indent: 10,
                                        endIndent: 5,
                                      ),
                                    ),
                                    Icon(
                                      Icons.flight_takeoff,
                                      color: AppColors.secondary,
                                      size: 16,
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: AppColors.secondary,
                                        thickness: 1,
                                        indent: 5,
                                        endIndent: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  travel['distance'],
                                  style: GoogleFonts.inter(
                                    fontSize: SizeConfig.smallText3,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildLocationNode(
                              travel['destination'],
                              Icons.flight_land,
                              isRight: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.normalpadding),
                      Center(
                        child: Text(
                          'Travel Budget: ${travel['budget']}',
                          style: GoogleFonts.inter(
                            color: AppColors.grey,
                            fontSize: SizeConfig.smallText2,
                          ),
                        ),
                      ),

                      SizedBox(height: SizeConfig.normalpadding * 3),

                      // Estimated Costs
                      Text(
                        'Estimated costs',
                        style: GoogleFonts.inter(
                          fontSize: SizeConfig.mediumText1,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: SizeConfig.normalpadding * 2),

                      _buildCostItem(
                        'Flight',
                        costs['Flight']!,
                        Icons.flight_takeoff,
                      ),
                      _buildCostItem('Lodging', costs['Lodging']!, Icons.hotel),
                      _buildCostItem('Food', costs['Food']!, Icons.restaurant),
                      _buildCostItem(
                        'Transit',
                        costs['Transit']!,
                        Icons.directions_car,
                      ),

                      SizedBox(height: SizeConfig.normalpadding * 2),

                      // Total
                      Row(
                        children: [
                          Text(
                            '= ',
                            style: GoogleFonts.inter(
                              fontSize: SizeConfig.mediumText1,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success, // Green color
                            ),
                          ),
                          Text(
                            '${total.toStringAsFixed(0)}\$',
                            style: GoogleFonts.inter(
                              fontSize: SizeConfig.mediumText1,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.normalpadding * 2),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationNode(
    String name,
    IconData icon, {
    bool isRight = false,
  }) {
    return Column(
      crossAxisAlignment: isRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isRight) ...[
              Icon(icon, size: 20, color: AppColors.primary),
              SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                name,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig
                      .mediumText2, // Slightly smaller than before to fit names
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: isRight ? TextAlign.right : TextAlign.left,
              ),
            ),
            if (isRight) ...[
              SizedBox(width: 4),
              Icon(icon, size: 20, color: AppColors.primary),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildCostItem(String label, double amount, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.normalpadding),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4CC), // Light yellow/orange bg
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.orange, size: 20),
          ),
          SizedBox(width: SizeConfig.normalpadding * 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: AppColors.grey,
                  fontSize: SizeConfig.smallText2,
                ),
              ),
              Text(
                '${amount.toStringAsFixed(0)}\$',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.mediumText2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
