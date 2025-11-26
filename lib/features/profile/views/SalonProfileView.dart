import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SaloonySpecialist/core/Config/ProviderSetup.dart' as AppConfig;
import 'package:SaloonySpecialist/core/constants/app_routes.dart';
import 'package:SaloonySpecialist/features/Menu/views/SideMenuDialog.dart';
import 'package:SaloonySpecialist/core/services/AuthService.dart';
import 'package:SaloonySpecialist/core/services/SalonService.dart';
import 'package:SaloonySpecialist/features/Salon/views/AppThemeScreen.dart';
import 'package:SaloonySpecialist/features/Salon/views/AppointmentsScreen.dart';
import 'package:SaloonySpecialist/features/Salon/views/ClientsScreen.dart';
import 'package:SaloonySpecialist/features/Salon/views/EditSalonScreen.dart';
import 'package:SaloonySpecialist/features/Salon/views/ServicesManagementScreen.dart';
import 'package:SaloonySpecialist/features/Salon/views/TeamMembersScreen.dart';
import 'package:SaloonySpecialist/features/profile/views/ChangePhoneWidget.dart';
import 'package:SaloonySpecialist/features/profile/views/LanguageScreen.dart';
import 'package:SaloonySpecialist/features/profile/views/LogoutButton.dart';
import 'package:SaloonySpecialist/core/Config/ProviderSetup.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _isSalonOwner = false; // ✅ Nouveau champ

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
void _openWhatsApp() async {
  const phoneNumber = "+21626320130";
  const message = "Hello, I need support please.";

  final url = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Cannot open WhatsApp."),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    
    try {
      final userResult = await _authService.getCurrentUser();
      
      if (userResult['success'] == true && userResult['user'] != null) {
        _currentUser = userResult['user'];
        _userRole = _currentUser!['appRole'] ?? 'CUSTOMER';
        
        // ✅ Récupérer isSalonOwner depuis les données utilisateur
        _isSalonOwner = _currentUser!['isSalonOwner'] == true;
        
        debugPrint('👤 User role: $_userRole');
        debugPrint('👑 Is salon owner from user data: $_isSalonOwner');
        debugPrint('📋 Current user data: $_currentUser');
        
        if (_userRole == 'SPECIALIST') {
          final userId = _currentUser!['userId'];
          final salonResult = await _salonService.getSpecialistSalon(userId);
          
          if (salonResult['success'] == true && salonResult['salon'] != null) {
            _userSalon = salonResult['salon'];
            
            // ✅ SOLUTION: Vérifier si l'utilisateur est le propriétaire en comparant les IDs
            final salonOwnerId = _userSalon!['salonOwnerId'];
            _isSalonOwner = (salonOwnerId != null && salonOwnerId == userId);
            
            debugPrint('🏢 Salon owner ID: $salonOwnerId');
            debugPrint('👤 Current user ID: $userId');
            debugPrint('👑 Is salon owner (calculated): $_isSalonOwner');
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSideMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const SideMenuDialog(),
    );
  }
 void _showDeactivateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange[700],
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Deactivate Account',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to deactivate your account?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF1B2B3E),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This action will:',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildWarningItem('• Deactivate your account'),
                    _buildWarningItem('• Remove access to your profile'),
                    _buildWarningItem('• Require reactivation to use again'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _confirmDeactivation(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Deactivate',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
 Future<void> _confirmDeactivation() async {
    Navigator.of(context).pop(); // Fermer le dialogue
    
    // Afficher un indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF1B2B3E),
              ),
              const SizedBox(height: 16),
              Text(
                'Deactivating account...',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
            ],
          ),
        ),
      ),
    );

 
  }
  Widget _buildWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.red[800],
          height: 1.4,
        ),
      ),
    );
  }
  void _navigateToAppointments() {
    debugPrint('Navigate to Appointments');
  }

  void _navigateToEditSalon() {
    debugPrint('Navigate to Edit Salon');
  }

  void _navigateToServices() {
    debugPrint('Navigate to Services');
  }

  void _navigateToClients() {
    debugPrint('Navigate to Clients');
  }

  void _navigateToTeam() {
     Navigator.pushNamed(context, AppRoutes.TeamMembersScreen);
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
                            title: 'Edit Profile',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.editProfile);
                            },
                          ),
                          _MenuItem(
                            icon: Icons.lock_outline_rounded,
                            title: 'Change Password',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.ResetPasswordP);
                            },
                          ),
                          _MenuItem(
                            icon: Icons.email_outlined,
                            title: 'Change Email',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.ChangeEmail);
                            },
                          ),
                          _MenuItem(
  icon: Icons.phone_android_outlined,
  title: 'Change Phone',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePhoneWidget(),
      ),
    );
  },
),
_MenuItem(
  icon: Icons.cancel_presentation_outlined,
  title: 'Deactivate Account',
  onTap: _showDeactivateDialog,
),
 ],
                      ),
                      const SizedBox(height: 24),
                      
                      // ✅ Section Salon Settings - Affichée uniquement si isSalonOwner = true
                      if (_userRole == 'SPECIALIST' && _userSalon != null && _isSalonOwner)
                        _buildSalonSettingsSection(),
                      
                      if (_userRole == 'SPECIALIST' && _userSalon != null && _isSalonOwner)
                        const SizedBox(height: 24),
                      
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
                         _buildSection(
                        title: 'Help & Support',
                        items: [
                          _MenuItem(
                            icon: Icons.description_outlined,
                            title: 'Help center',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.HelpCenterScreen);
                            },
                          ),
                          _MenuItem(
  icon: Icons.privacy_tip_outlined,
  title: 'Customer Support',
  onTap: _openWhatsApp,
),

                        ],
                      ),
                                           const SizedBox(height: 24),

                      _buildSection(
                        title: 'Other',
                        items: [
                         _MenuItem(
                            icon: Icons.dark_mode_outlined,
                            title: 'App Theme',
                            trailing: 'Light',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AppThemeScreen()),
                              );
                            },
                          ),
                          _MenuItem(
                            icon: Icons.language_outlined,
                            title: 'Language',
                            trailing: 'English',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LanguageScreen()),
                              );
                            },
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

  Widget _buildSalonSettingsSection() {
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
            child: Row(
              children: [
                const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFF1B2B3E),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Salon Settings',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B2B3E),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          _buildSalonSettingsMenuItem(
            icon: Icons.edit_outlined,
            title: 'Edit Salon',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditSalonScreen(salonData: _userSalon!)
                ),
              );
            },
          ),
          _buildSalonSettingsMenuItem(
            icon: Icons.calendar_today_outlined,
            title: 'Appointments',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppointmentsScreen()),
              );
            },
          ),
          _buildSalonSettingsMenuItem(
            icon: Icons.cut,
            title: 'Services',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TreatmentsManagementScreen()),
              );
            },
          ),
          _buildSalonSettingsMenuItem(
            icon: Icons.people_outlined,
            title: 'Clients',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClientsScreen()),
              );
            },
          ),
          _buildSalonSettingsMenuItem(
            icon: Icons.group_outlined,
            title: 'Team',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeamMembersScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSalonSettingsMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
        ),
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
  }

  String _getSalonImageUrl(dynamic photoData) {
    if (photoData == null) {
      return '';
    }

    if (photoData is List) {
      if (photoData.isEmpty) return '';
      photoData = photoData.first;
    }

    if (photoData is String) {
      if (photoData.isEmpty) return '';
      
      String cleanPath = photoData;
      if (cleanPath.startsWith('file://')) {
        cleanPath = cleanPath.substring(7);
      }
      
      if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
        return cleanPath;
      }

      if (cleanPath.startsWith('/')) {
        cleanPath = cleanPath.substring(1);
      }

      final uri = Uri.parse(AppConfig.Config.baseUrl);
      final baseUrlWithoutPath = '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';

      return '$baseUrlWithoutPath/$cleanPath';
    }

    if (photoData is Map) {
      final url = photoData['url'] ?? photoData['path'] ?? photoData['photoPath'];
      if (url != null && url is String && url.isNotEmpty) {
        String cleanPath = url;
        if (cleanPath.startsWith('file://')) {
          cleanPath = cleanPath.substring(7);
        }
        
        if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
          return cleanPath;
        }
        
        if (cleanPath.startsWith('/')) {
          cleanPath = cleanPath.substring(1);
        }
        
        final uri = Uri.parse(AppConfig.Config.baseUrl);
        final baseUrlWithoutPath = '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
        
        return '$baseUrlWithoutPath/$cleanPath';
      }
    }

    return '';
  }

  String _getSalonAddress(Map<String, dynamic>? salonData) {
    if (salonData == null) return '';
    
    debugPrint('📦 Salon data received: $salonData');
    
    final address = salonData['address'] ?? 
                   salonData['fullAddress'] ?? 
                   salonData['location'] ?? 
                   salonData['salonAddress'];
    
    if (address is String && address.isNotEmpty) {
      return address;
    }
    
    if (address is Map) {
      final street = address['street'] ?? address['addressLine1'];
      final city = address['city'];
      final postalCode = address['postalCode'] ?? address['zipCode'];
      
      final parts = [street, city, postalCode]
          .where((part) => part != null && part.toString().isNotEmpty)
          .toList();
      if (parts.isNotEmpty) {
        return parts.join(', ');
      }
    }
    
    final latitude = salonData['salonLatitude'];
    final longitude = salonData['salonLongitude'];
    
    if (latitude != null && longitude != null) {
      try {
        final lat = latitude is num ? latitude : double.parse(latitude.toString());
        final lng = longitude is num ? longitude : double.parse(longitude.toString());
        return '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
      } catch (e) {
        debugPrint('❌ Coordinate conversion error: $e');
      }
    }
    
    return 'Address not available';
  }

  Widget _buildSalonCard() {
    final salonImageUrl = _getSalonImageUrl(_userSalon?['salonPhotosPaths']);
    final salonAddress = _getSalonAddress(_userSalon);
    
    debugPrint('🖼️ Final image URL: $salonImageUrl');
    debugPrint('📍 Final address: $salonAddress');
    debugPrint('📦 Complete salon data: $_userSalon');
    
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
                if (salonImageUrl.isNotEmpty)
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.network(
                      salonImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('❌ Image loading error: $error');
                        debugPrint('❌ Attempted URL: $salonImageUrl');
                        return _buildPlaceholderImage();
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
                    ),
                  )
                else
                  _buildPlaceholderImage(),
                
                // ✅ Bouton Edit visible uniquement pour le propriétaire
                if (_isSalonOwner)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: InkWell(
                      onTap: _navigateToEditSalon,
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
                        _userSalon?['salonName'] ?? 'Salon name not available',
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
                      _userSalon!['salonDescription'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF1B2B3E).withOpacity(0.7),
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                
                if (salonAddress.isNotEmpty && salonAddress != 'Address not available')
                  _buildInfoRow(Icons.location_on_outlined, salonAddress),
                
                if (_userSalon?['salonLatitude'] != null && _userSalon?['salonLongitude'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _buildInfoRow(
                      Icons.map_outlined,
                      '${_userSalon!['salonLatitude'].toString()}, ${_userSalon!['salonLongitude'].toString()}',
                    ),
                  ),
                
                if (_userSalon?['salonCategory'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _buildInfoRow(
                      Icons.category_outlined,
                      _userSalon!['salonCategory'].toString(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store, size: 60, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'No image',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
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
              'Create Your Salon',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start managing your professional salon and appointments',
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
                    'Create My Salon',
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