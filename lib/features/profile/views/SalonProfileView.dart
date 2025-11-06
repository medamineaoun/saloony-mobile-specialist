import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/constants/app_routes.dart';
import 'package:saloony/features/Menu/views/SideMenuDialog.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/features/profile/views/LogoutButton.dart';

bool notificationsEnabled = true;

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  void _showSideMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const SideMenuDialog(),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1B2B3E),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      // Logout
      await AuthService().signOut();
      
      // Navigate to login page
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    }
  }

  void _showSalonSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      color: const Color(0xFF1B2B3E),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Salon Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B2B3E),
                      ),
                    ),
                  ],
                ),
              ),
              // Menu Items
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    _buildSalonSettingsMenuItem(
                      context,
                      icon: Icons.calendar_today_outlined,
                      title: 'Appointments',
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to appointments page
                      },
                    ),
                    _buildSalonSettingsMenuItem(
                      context,
                      icon: Icons.edit_outlined,
                      title: 'Edit Salon',
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to edit salon page
                      },
                    ),
                    _buildSalonSettingsMenuItem(
                      context,
                      icon: Icons.room_service_outlined,
                      title: 'Services',
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to services page
                      },
                    ),
                    _buildSalonSettingsMenuItem(
                      context,
                      icon: Icons.people_outlined,
                      title: 'Clients',
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to clients page
                      },
                    ),
                    _buildSalonSettingsMenuItem(
                      context,
                      icon: Icons.group_outlined,
                      title: 'Team',
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to team page
                      },
                    ),
                    _buildSalonSettingsMenuItem(
                      context,
                      icon: Icons.attach_money_outlined,
                      title: 'Commodity',
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to commodity page
                      },
                    ),
                  ],
                ),
              ),
              // Close Button
              Container(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B2B3E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalonSettingsMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2B3E).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: const Color(0xFF1B2B3E),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF1B2B3E)),
          onPressed: () => _showSideMenu(context),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF1B2B3E)),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF1B2B3E)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              
              // Salon Card
              _buildSalonCard(),
              const SizedBox(height: 24),
              
              // Application Section
              _buildSection(
                title: 'Application',
                items: [
                  _MenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Salon Settings',
                    onTap: () {
                      _showSalonSettingsMenu(context);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.editProfile);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Change Password',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.ResetPasswordP);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Change Email',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.ChangeEmail);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Availability',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.Disponibilite);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // About Section
              _buildSection(
                title: 'About',
                items: [
                  _MenuItem(
                    icon: Icons.description_outlined,
                    title: 'Terms of Use',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.HelpCenterScreen);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.PrivacyPolicy);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Other Section
              _buildSection(
                title: 'Other',
                items: [
                  _MenuItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'App Theme',
                    trailing: 'Light',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.language_outlined,
                    title: 'App Language',
                    trailing: 'English',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LogoutButtonWidget(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalonCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Salon image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=800',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.store, size: 60, color: Colors.grey),
                    );
                  },
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: Color(0xFF1B2B3E),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Salon information
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Captain\'s Barber Shop',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1B2B3E),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        size: 20,
                        color: Color(0xFFF0CD97),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.language, 'www.reallygreatsite.com'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.phone_outlined, '+1 234 567 890 000'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.email_outlined, 'example@mybarbershop.com'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.location_on_outlined, 'KK 15 AVE, Kigali, RW'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF1B2B3E).withOpacity(0.6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF1B2B3E).withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<_MenuItem> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B2B3E),
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...List.generate(items.length, (index) {
            final item = items[index];
            final isLast = index == items.length - 1;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.vertical(
                    bottom: isLast ? const Radius.circular(20) : Radius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B2B3E).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item.icon,
                            size: 20,
                            color: const Color(0xFF1B2B3E),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item.title,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1B2B3E),
                            ),
                          ),
                        ),
                        if (item.trailing != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              item.trailing!,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.only(left: 66),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey[200],
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });
}