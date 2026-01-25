import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/config_size.dart';
import '../../../routes/routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light grey background
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.mediumText1,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
           icon: const Icon(Icons.arrow_back, color: Colors.white),
           onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.normalpadding * 2),
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: EdgeInsets.all(SizeConfig.normalpadding * 2),
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
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'), // Dummy image
                  ),
                  SizedBox(width: SizeConfig.normalpadding * 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subaida Rahman',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.mediumText2,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'subaidarahman22@gmail.com',
                          style: GoogleFonts.inter(
                            fontSize: SizeConfig.smallText2,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.normalpadding * 2),

            // Settings Options
            _buildSettingsItem('Edit Profile', Icons.edit_outlined, context),
            SizedBox(height: SizeConfig.normalpadding * 1.5),
            _buildSettingsItem('Currency', Icons.attach_money, context),
            SizedBox(height: SizeConfig.normalpadding * 1.5),
            _buildSettingsItem('Change Password', Icons.lock_outline, context),
            SizedBox(height: SizeConfig.normalpadding * 1.5),
            _buildSettingsItem('Log Out', Icons.logout, context, isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, BuildContext context,
      {bool isDestructive = false}) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (title == 'Log Out') {
               // Handle logout
               Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.normalpadding * 2,
              vertical: SizeConfig.normalpadding * 1.5,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDestructive ? Colors.red : AppColors.grey,
                  size: 24,
                ),
                SizedBox(width: SizeConfig.normalpadding * 2),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.mediumText2,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? Colors.red : AppColors.text,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.grey,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
