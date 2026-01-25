import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itenero_app_client/itenero_app_client.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/config_size.dart';
import 'trip_map_page.dart';
import 'add_trip.dart';

class TripDetailsPage extends StatelessWidget {
  final TripWithPlan tripWithPlan;

  const TripDetailsPage({Key? key, required this.tripWithPlan})
    : super(key: key);

  double get _totalCost {
    double total = 0;
    for (var activity in tripWithPlan.activities) {
      total += activity.estimatedCost ?? 0;
    }
    return total;
  }

  String _formatDateShort(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String get _formattedDateRange {
    final start = tripWithPlan.trip.startDate;
    final end = tripWithPlan.trip.endDate;
    return '${_formatDateShort(start)} - ${_formatDateShort(end)}';
  }

  @override
  Widget build(BuildContext context) {
    // Organize activities by day
    final activitiesByDay = <int, List<Activity>>{};
    for (var activity in tripWithPlan.activities) {
      activitiesByDay.putIfAbsent(activity.tripDayId, () => []).add(activity);
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Header Background
          Container(
            height: SizeConfig.screenHeight * 0.25,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.8),
                    const Color(0xFF1E3A8A).withOpacity(0.6), // Darker blue
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // AppBar Content
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.normalpadding * 2,
                    vertical: SizeConfig.normalpadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        tripWithPlan.trip.destination,
                        style: GoogleFonts.inter(
                          fontSize: SizeConfig.mediumText1,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Date and Cost
                Padding(
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.normalpadding * 2,
                  ),
                  child: Text(
                    '$_formattedDateRange. Cost: \$${_totalCost.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.mediumText1,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ),

                // Expanded List
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.all(SizeConfig.normalpadding * 2),
                      itemCount: tripWithPlan.days.length,
                      itemBuilder: (context, index) {
                        final day = tripWithPlan.days[index];
                        final dayActivities = activitiesByDay[day.id] ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.normalpadding,
                              ),
                              child: Text(
                                'Day ${day.dayIndex} - ${day.summary ?? "Day Plan"}',
                                style: GoogleFonts.inter(
                                  fontSize: SizeConfig.mediumText1,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                            const Divider(),
                            ...dayActivities
                                .map((activity) => _buildActivityItem(activity))
                                .toList(),
                            SizedBox(height: SizeConfig.normalpadding * 2),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Buttons
          Positioned(
            bottom: SizeConfig.safeBlockVertical * 4,
            left: SizeConfig.normalpadding * 2,
            right: SizeConfig.normalpadding * 2,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TripMapPage(tripWithPlan: tripWithPlan),
                        ),
                      );
                    },
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Open Map'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.normalpadding * 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: SizeConfig.mediumText1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.normalpadding * 2),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddTripPage(tripToEdit: tripWithPlan),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.normalpadding * 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: SizeConfig.mediumText1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;
    final int minute = time.minute;
    final String period = hour >= 12 ? 'PM' : 'AM';

    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    final String minuteStr = minute.toString().padLeft(2, '0');
    return '${hour.toString().padLeft(2, '0')}:$minuteStr $period';
  }

  Widget _buildActivityItem(Activity activity) {
    Color dotColor;
    switch (activity.category) {
      case 'hotel':
        dotColor = Colors.blue;
        break;
      case 'food':
        dotColor = Colors.orange;
        break;
      case 'sightseeing':
        dotColor = AppColors.secondary;
        break;
      default:
        dotColor = AppColors.secondary;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.normalpadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: SizeConfig.normalpadding * 6),

          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: AppColors.lightGrey,
              ),
            ],
          ),
          SizedBox(width: SizeConfig.normalpadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: GoogleFonts.inter(
                    fontSize: SizeConfig.smallText2,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                  ),
                ),
                if (activity.estimatedCost != null &&
                    activity.estimatedCost! > 0)
                  Text(
                    ' - \$${activity.estimatedCost!.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.smallText2,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkGrey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
