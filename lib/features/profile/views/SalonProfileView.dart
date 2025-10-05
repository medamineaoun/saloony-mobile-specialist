import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/constants/app_routes.dart';
import 'package:saloony/features/Menu/views/SideMenuDialog.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/features/profile/views/LogoutButton.dart';

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
    // Afficher une boîte de dialogue de confirmation
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Déconnexion',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1B2B3E),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Annuler',
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
              'Déconnexion',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      // Déconnexion
      await AuthService().signOut();
      
      // Navigation vers la page de connexion
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', // Remplacez par votre route de connexion
          (route) => false,
        );
      }
    }
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Salon Card
            _buildSalonCard(),
            const SizedBox(height: 24),
            
            // Trial Banner
            _buildTrialBanner(),
            const SizedBox(height: 24),
            
            // Application Section
            _buildSection(
              title: 'Application',
              items: [
                _MenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Paramètres du salon',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Modifier le profil',
                   onTap: () {
          Navigator.pushNamed(context, AppRoutes.editProfile);
        },
                ),
                   _MenuItem(
                  icon: Icons.person_outline_rounded,
                  title: 'changer le mots de passe',
                   onTap: () {
          Navigator.pushNamed(context, AppRoutes.ResetPasswordP);
        },
                ),
                   _MenuItem(
                  icon: Icons.person_outline_rounded,
                  title: 'changer email',
                   onTap: () {
          Navigator.pushNamed(context, AppRoutes.ChangeEmail);
        },
                ),
                _MenuItem(
                  icon: Icons.calendar_today_outlined,
                  title: 'Disponibilité',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.workspace_premium_outlined,
                  title: 'Mon abonnement',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Paramètres de notification',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // À propos Section
            _buildSection(
              title: 'À propos',
              items: [
                _MenuItem(
                  icon: Icons.description_outlined,
                  title: 'Conditions d\'utilisation',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Politique de confidentialité',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Aide et support Section
            _buildSection(
              title: 'Aide et support',
              items: [
                _MenuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Centre d\'aide',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.headset_mic_outlined,
                  title: 'Service client',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Autre Section
            _buildSection(
              title: 'Autre',
              items: [
                _MenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Thème de l\'application',
                  trailing: 'Light',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.language_outlined,
                  title: 'Langue de l\'application',
                  trailing: 'Anglais',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Logout Button
            LogoutButtonWidget(),
            const SizedBox(height: 40),
          ],
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
        children: [
          // Image du salon
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

          // Informations du salon
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Salon de coiffure du capitaine',
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
                _buildInfoRow(Icons.email_outlined, 'exemple@mybarbershop.com'),
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

  Widget _buildTrialBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B2B3E), Color(0xFF243441)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B2B3E).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0CD97).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFFF0CD97),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '14 jours restants',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Essai gratuit en équipe',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF0CD97),
              foregroundColor: const Color(0xFF1B2B3E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            icon: const Icon(Icons.shopping_cart_outlined, size: 16),
            label: Text(
              'Mise à niveau',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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