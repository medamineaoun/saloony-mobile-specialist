import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/constants/app_routes.dart';
import 'package:saloony/features/Menu/views/SideMenuDialog.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/SalonService.dart';
import 'package:saloony/features/profile/views/LogoutButton.dart';

bool notificationsEnabled = true;

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthService _authService = AuthService();
  final SalonService _salonService = SalonService();
  
  bool _isLoading = true;
  Map<String, dynamic>? _userSalon;
  Map<String, dynamic>? _currentUser;
  String _userRole = 'CUSTOMER';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    
    try {
      final userResult = await _authService.getCurrentUser();
      
      if (userResult['success'] == true && userResult['user'] != null) {
        _currentUser = userResult['user'];
        _userRole = _currentUser!['appRole'] ?? 'CUSTOMER';
        
        if (_userRole == 'SPECIALIST') {
          final userId = _currentUser!['userId'];
          final salonResult = await _salonService.getSpecialistSalon(userId);
          
          if (salonResult['success'] == true && salonResult['salon'] != null) {
            _userSalon = salonResult['salon'];
          }
        }
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement des données: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getSalonImageUrl(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) {
      return '';
    }
    
    if (photoPath.startsWith('http://') || photoPath.startsWith('https://')) {
      return photoPath;
    }
    
    final cleanPath = photoPath.startsWith('/') 
        ? photoPath.substring(1) 
        : photoPath;
    
    final uri = Uri.parse(_salonService.baseUrl);
    final baseUrlWithoutPath = '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
    
    return '$baseUrlWithoutPath/$cleanPath';
  }

  void _showSideMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const SideMenuDialog(),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
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

    if (shouldLogout == true && mounted) {
      await _authService.signOut();
      
      if (mounted) {
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
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
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
                    const Icon(
                      Icons.settings_outlined,
                      color: Color(0xFF1B2B3E),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Paramètres du Salon',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B2B3E),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    _buildSalonSettingsMenuItem(
                      context,
                      icon: Icons.calendar_today_outlined,
                      title: 'Rendez-vous',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    _buildSalonSettingsMenuItem(
                      context,
                      icon: Icons.edit_outlined,
                      title: 'Modifier le Salon',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    _buildSalonSettingsMenuItem(
                      context,
                      icon: Icons.room_service_outlined,
                      title: 'Services',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    _buildSalonSettingsMenuItem(
                      context,
                      icon: Icons.people_outlined,
                      title: 'Clients',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    _buildSalonSettingsMenuItem(
                      context,
                      icon: Icons.group_outlined,
                      title: 'Équipe',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    _buildSalonSettingsMenuItem(
                      context,
                      icon: Icons.attach_money_outlined,
                      title: 'Tarifs',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
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
                    'Fermer',
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
          'Profil',
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1B2B3E),
              ),
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadUserData,
                color: const Color(0xFF1B2B3E),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      
                      if (_userRole == 'SPECIALIST')
                        _userSalon != null
                            ? _buildSalonCard()
                            : _buildCreateSalonCard(),
                      
                      if (_userRole == 'SPECIALIST')
                        const SizedBox(height: 24),
                      
                      _buildSection(
                        title: 'Application',
                        items: [
                          _MenuItem(
                            icon: Icons.person_outline_rounded,
                            title: 'Modifier le Profil',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.editProfile);
                            },
                          ),
                          _MenuItem(
                            icon: Icons.lock_outline_rounded,
                            title: 'Changer le Mot de Passe',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.ResetPasswordP);
                            },
                          ),
                          _MenuItem(
                            icon: Icons.email_outlined,
                            title: 'Changer l\'Email',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.ChangeEmail);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      if (_userRole == 'SPECIALIST' && _userSalon != null)
                        _buildSection(
                          title: 'Paramètres du Salon',
                          items: [
                            _MenuItem(
                              icon: Icons.settings_outlined,
                              title: 'Gérer le Salon',
                              onTap: () {
                                _showSalonSettingsMenu(context);
                              },
                            ),
                            _MenuItem(
                              icon: Icons.calendar_today_outlined,
                              title: 'Rendez-vous',
                              onTap: () {},
                            ),
                            _MenuItem(
                              icon: Icons.room_service_outlined,
                              title: 'Services & Tarifs',
                              onTap: () {},
                            ),
                            _MenuItem(
                              icon: Icons.group_outlined,
                              title: 'Équipe',
                              onTap: () {},
                            ),
                          ],
                        ),
                      
                      if (_userRole == 'SPECIALIST' && _userSalon != null)
                        const SizedBox(height: 24),
                      
                      _buildSection(
                        title: 'À Propos',
                        items: [
                          _MenuItem(
                            icon: Icons.description_outlined,
                            title: 'Conditions d\'Utilisation',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.HelpCenterScreen);
                            },
                          ),
                          _MenuItem(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Politique de Confidentialité',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.PrivacyPolicy);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      _buildSection(
                        title: 'Autres',
                        items: [
                          _MenuItem(
                            icon: Icons.dark_mode_outlined,
                            title: 'Thème de l\'App',
                            trailing: 'Clair',
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.language_outlined,
                            title: 'Langue',
                            trailing: 'Français',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: LogoutButtonWidget(),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSalonCard() {
    final salonImageUrl = _getSalonImageUrl(_userSalon?['salonPhotoPath']);
    
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                salonImageUrl.isNotEmpty
                    ? Image.network(
                        salonImageUrl,
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
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: const Color(0xFF1B2B3E),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.store, size: 60, color: Colors.grey),
                      ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to edit salon
                    },
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
                ),
              ],
            ),
          ),

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
                        _userSalon?['salonName'] ?? 'Mon Salon',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1B2B3E),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F9FA),
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
                const SizedBox(height: 12),
                if (_userSalon?['salonDescription'] != null && 
                    _userSalon!['salonDescription'].toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _userSalon!['salonDescription'],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF1B2B3E).withOpacity(0.7),
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (_userSalon?['address'] != null && 
                    _userSalon!['address'].toString().isNotEmpty)
                  _buildInfoRow(Icons.location_on_outlined, _userSalon!['address']),
                if (_userSalon?['latitude'] != null && _userSalon?['longitude'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _buildInfoRow(
                      Icons.map_outlined,
                      'GPS: ${_userSalon!['latitude'].toStringAsFixed(4)}, ${_userSalon!['longitude'].toStringAsFixed(4)}',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateSalonCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1B2B3E),
            const Color(0xFF1B2B3E).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B2B3E).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.store_outlined,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Créer Votre Salon',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Commencez à gérer votre salon professionnel et vos rendez-vous',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.createsalon);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1B2B3E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_circle_outline),
                  const SizedBox(width: 8),
                  Text(
                    'Créer Mon Salon',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF1B2B3E).withOpacity(0.6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
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