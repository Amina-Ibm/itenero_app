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
            SizedBox(
              height: SizeConfig.normalpadding * 4,
            ),
            // Profile Card
            Container(
              padding: EdgeInsets.all(SizeConfig.normalpadding * 2),
              height: 91,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.6,
                      ),
                    ),
                    child: const CircleAvatar(
                      foregroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=5',
                      ),
                      radius: 30,
                      backgroundColor: Colors.transparent,
                    ),
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
                            height: 2,
                          ),
                        ),
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
            SizedBox(height: SizeConfig.normalpadding * 8),

            // Settings Options
            _buildSettingsItem('Edit Profile', Icons.edit_outlined, context),
            SizedBox(height: SizeConfig.normalpadding * 6),
            _buildSettingsItem('Currency', Icons.attach_money, context),
            SizedBox(height: SizeConfig.normalpadding * 6),
            _buildSettingsItem('Change Password', Icons.lock_outline, context),
            SizedBox(height: SizeConfig.normalpadding * 6),
            _buildSettingsItem(
              'Log Out',
              Icons.logout,
              context,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    IconData icon,
    BuildContext context, {
    bool isDestructive = false,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1.2,
          color: Color(0xFF252525).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 1,
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
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
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
                SizedBox(width: SizeConfig.normalpadding * 4),
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
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
