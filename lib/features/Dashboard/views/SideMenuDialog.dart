import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SideMenuDialog extends StatelessWidget {
  const SideMenuDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuViewModel(),
      child: Consumer<MenuViewModel>(
        builder: (context, menuViewModel, child) {
          return Dialog(
            alignment: Alignment.centerLeft,
            insetPadding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.25,
            ),
            backgroundColor: Colors.transparent,
            child: Container(
              width: 280,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(5, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: _buildMenuItems(menuViewModel, context),
                  ),
                  _buildUserProfile(menuViewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0CD97),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0CD97),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0CD97),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context),
            color: const Color(0xFF1B2B3E),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(MenuViewModel viewModel, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Dashboard (highlighted)
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B2B3E), Color(0xFF243441)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B2B3E).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            leading: const Icon(
              Icons.dashboard_rounded,
              color: Color(0xFFF0CD97),
              size: 22,
            ),
            title: Text(
              'Dashboard',
              style: GoogleFonts.poppins(
                color: Color(0xFFF0CD97),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            onTap: () {
              viewModel.selectMenuItem('/dashboard');
              Navigator.pop(context);
            },
          ),
        ),

        // Other menu items
        for (var item in viewModel.menuItems.skip(1))
          _MenuItemTile(
            icon: item.icon,
            title: item.title,
            isSelected: viewModel.selectedRoute == item.route,
            onTap: () {
              viewModel.selectMenuItem(item.route!);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }

  Widget _buildUserProfile(MenuViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFF0CD97),
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFF8F9FA),
              child: Icon(
                Icons.person,
                color: Color(0xFF1B2B3E),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.userProfile.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFFF0CD97),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      viewModel.userProfile.planType,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFF0CD97),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _MenuItemTile({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF1B2B3E).withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFFF0CD97) : const Color(0xFF6B7280),
          size: 22,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: isSelected ? const Color(0xFF1B2B3E) : const Color(0xFF6B7280),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 15,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

// ==================== MENU VIEWMODEL ====================
class MenuViewModel extends ChangeNotifier {
  UserProfile _userProfile = UserProfile(
    name: 'Andrew Ainsley',
    planType: 'Pro Plan',
  );

  List<MenuItem> _menuItems = [
    MenuItem(title: 'Dashboard', icon: Icons.dashboard_rounded, route: '/dashboard'),
    MenuItem(title: 'Appointments', icon: Icons.calendar_today_rounded, route: '/appointments'),
    MenuItem(title: 'Requests', icon: Icons.description_outlined, route: '/requests'),
    MenuItem(title: 'Messages', icon: Icons.message_outlined, route: '/messages'),
    MenuItem(title: 'Calendar', icon: Icons.calendar_month_rounded, route: '/calendar'),
    MenuItem(title: 'Services', icon: Icons.work_outline_rounded, route: '/services'),
    MenuItem(title: 'Clients', icon: Icons.people_outline_rounded, route: '/clients'),
    MenuItem(title: 'Team', icon: Icons.groups_outlined, route: '/team'),
    MenuItem(title: 'Earnings', icon: Icons.attach_money_rounded, route: '/earnings'),
    MenuItem(title: 'Reviews', icon: Icons.star_outline_rounded, route: '/reviews'),
  ];

  String _selectedRoute = '/dashboard';

  UserProfile get userProfile => _userProfile;
  List<MenuItem> get menuItems => _menuItems;
  String get selectedRoute => _selectedRoute;

  void selectMenuItem(String route) {
    _selectedRoute = route;
    notifyListeners();
  }
}

// ==================== MODELS ====================
class MenuItem {
  final String title;
  final IconData icon;
  final String? route;

  MenuItem({
    required this.title,
    required this.icon,
    this.route,
  });
}

class UserProfile {
  final String name;
  final String planType;

  UserProfile({
    required this.name,
    required this.planType,
  });
}