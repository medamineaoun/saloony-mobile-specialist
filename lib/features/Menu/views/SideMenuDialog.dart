import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:saloony/features/Menu/viewmodels/MenuViewModel.dart';

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
                  _buildUserProfile(menuViewModel, context),
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
        // Dashboard
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
                color: const Color(0xFFF0CD97),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            onTap: () {
              viewModel.selectMenuItem('/home');
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),

        // autres items
        for (var item in viewModel.menuItems.where((item) {
          if (item.title == 'Create Salon') {
            return !viewModel.hasSalon; 
          }
          return true;
        }))
          _MenuItemTile(
            icon: item.icon,
            title: item.title,
            isSelected: viewModel.selectedRoute == item.route,
            onTap: () {
              viewModel.selectMenuItem(item.route!);
              Navigator.pop(context);
              if (item.route != null) {
                Navigator.pushNamed(context, item.route!);
              }
            },
          ),
      ],
    );
  }

  Widget _buildUserProfile(MenuViewModel viewModel, BuildContext context) {
    // Afficher un loader pendant le chargement
    if (viewModel.isLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF0CD97)),
          ),
        ),
      );
    }

    // Afficher le profil de l'utilisateur
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/profile');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
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
                child: _buildUserAvatar(viewModel),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.userName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: const Color(0xFF1B2B3E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium_rounded,
                          color: Color(0xFFF0CD97),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            viewModel.userRole,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFF0CD97),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
        ),
      ),
    );
  }

  Widget _buildUserAvatar(MenuViewModel viewModel) {
    final String? photoPath = viewModel.currentUser?.profilePhotoPath;
    
    // Si une photo de profil existe
    if (photoPath != null && photoPath.isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundColor: const Color(0xFFF8F9FA),
        backgroundImage: NetworkImage(
          photoPath,
        ),
        onBackgroundImageError: (exception, stackTrace) {
          // Log l'erreur
          debugPrint('❌ Erreur de chargement image profil: $exception');
        },
        child: _buildImageLoadingIndicator(),
      );
    }
    
    // Photo par défaut si aucune photo n'est disponible
    return _buildDefaultAvatar();
  }

  Widget _buildImageLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF0CD97)),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFFF8F9FA),
      child: Icon(
        Icons.person,
        color: const Color(0xFF1B2B3E).withOpacity(0.6),
        size: 24,
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