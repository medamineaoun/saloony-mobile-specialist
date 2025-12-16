import 'package:SaloonySpecialist/core/constants/SaloonyTextStyles.dart';
import 'package:SaloonySpecialist/core/constants/SaloonyColors.dart';
import '../../../core/constants/SaloonyColors.dart' hide SaloonyColors;

import 'package:flutter/material.dart';
import 'package:SaloonySpecialist/core/Config/ProviderSetup.dart' as AppConfig;
import 'package:SaloonySpecialist/core/constants/app_routes.dart';
import 'package:SaloonySpecialist/features/Menu/views/SideMenuDialog.dart';
import 'package:SaloonySpecialist/core/services/AuthService.dart';
import 'package:SaloonySpecialist/core/services/SalonService.dart';
import 'package:SaloonySpecialist/core/services/UserService.dart';
import 'package:SaloonySpecialist/core/services/ToastService.dart';
import 'package:SaloonySpecialist/features/Salon/views/AppThemeScreen.dart';
import 'package:SaloonySpecialist/features/Salon/views/AppointmentsScreen.dart' hide SaloonyColors;
import 'package:SaloonySpecialist/features/Salon/views/ClientsScreen.dart' hide SaloonyColors;
import 'package:SaloonySpecialist/features/Salon/views/EditSalonScreen.dart';
import 'package:SaloonySpecialist/features/Salon/views/ServicesManagementScreen.dart' hide SaloonyColors;
import 'package:SaloonySpecialist/features/Salon/views/TeamMembersScreen.dart' hide SaloonyColors;
import 'package:SaloonySpecialist/features/profile/views/ChangePhoneWidget.dart';
import 'package:SaloonySpecialist/features/profile/views/LanguageScreen.dart';
import 'package:SaloonySpecialist/features/profile/views/LogoutButton.dart';
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
  final UserService _userService = UserService();
  
  bool _isLoading = true;
  Map<String, dynamic>? _userSalon;
  Map<String, dynamic>? _currentUser;
  String _userRole = 'CUSTOMER';
  bool _isSalonOwner = false;

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
        SnackBar(
          content: Text("Cannot open WhatsApp.", style: SaloonyTextStyles.bodyMedium.copyWith(color: Colors.white)),
          backgroundColor: SaloonyColors.error,
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
        _isSalonOwner = _currentUser!['isSalonOwner'] == true;
        
        debugPrint('👤 User role: $_userRole');
        debugPrint('👑 Is salon owner: $_isSalonOwner');
        
        if (_userRole == 'SPECIALIST') {
          final userId = _currentUser!['userId'];
          final salonResult = await _salonService.getSpecialistSalon(userId);
          
          if (salonResult['success'] == true && salonResult['salon'] != null) {
            _userSalon = salonResult['salon'];
            final salonOwnerId = _userSalon!['salonOwnerId'];
            _isSalonOwner = (salonOwnerId != null && salonOwnerId == userId);
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: SaloonyColors.background,
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: SaloonyColors.warning, size: 28),
              const SizedBox(width: 12),
              Text('Deactivate Account', style: SaloonyTextStyles.heading3),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to deactivate your account?',
                style: SaloonyTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SaloonyColors.errorLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: SaloonyColors.error.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('This action will:', style: SaloonyTextStyles.labelLarge.copyWith(color: SaloonyColors.errorDark)),
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
              child: Text('Cancel', style: SaloonyTextStyles.buttonMedium.copyWith(color: SaloonyColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () => _confirmDeactivation(),
              style: ElevatedButton.styleFrom(
                backgroundColor: SaloonyColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('Deactivate', style: SaloonyTextStyles.buttonMedium.copyWith(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeactivation() async {
    Navigator.of(context).pop();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: SaloonyColors.background,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: SaloonyColors.primary),
              const SizedBox(height: 20),
              Text('Deactivating account...', style: SaloonyTextStyles.bodyMedium),
            ],
          ),
        ),
      ),
    );

    try {
      final result = await _userService.deactivateAccount();
      
      if (mounted) Navigator.of(context).pop();
      
      if (result['success'] == true) {
        ToastService.showSuccess(context, 'Account deactivated successfully');
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          await _authService.signOut();
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
        }
      } else {
        ToastService.showError(context, result['message'] ?? 'Failed to deactivate account');
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ToastService.showError(context, 'Error deactivating account: $e');
      }
    }
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: SaloonyTextStyles.bodySmall.copyWith(color: SaloonyColors.errorDark)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SaloonyColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: SaloonyColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: SaloonyColors.primary),
          onPressed: () => _showSideMenu(context),
        ),
        title: Text('Profile', style: SaloonyTextStyles.heading3),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: SaloonyColors.primary),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: SaloonyColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: SaloonyColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: SaloonyColors.primary))
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadUserData,
                color: SaloonyColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      if (_userRole == 'SPECIALIST')
                        _userSalon != null ? _buildSalonCard() : _buildCreateSalonCard(),
                      if (_userRole == 'SPECIALIST') const SizedBox(height: 24),
                      _buildSection(
                        title: 'Application',
                        items: [
                          _MenuItem(
                            icon: Icons.person_outline_rounded,
                            title: 'Edit Profile',
                            onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
                          ),
                          _MenuItem(
                            icon: Icons.lock_outline_rounded,
                            title: 'Change Password',
                            onTap: () => Navigator.pushNamed(context, AppRoutes.ResetPasswordP),
                          ),
                          _MenuItem(
                            icon: Icons.email_outlined,
                            title: 'Change Email',
                            onTap: () => Navigator.pushNamed(context, AppRoutes.ChangeEmail),
                          ),
                          _MenuItem(
                            icon: Icons.phone_android_outlined,
                            title: 'Change Phone',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePhoneWidget())),
                          ),
                          _MenuItem(
                            icon: Icons.cancel_presentation_outlined,
                            title: 'Deactivate Account',
                            onTap: _showDeactivateDialog,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
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
                            onTap: () => Navigator.pushNamed(context, AppRoutes.HelpCenterScreen),
                          ),
                          _MenuItem(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Privacy Policy',
                            onTap: () => Navigator.pushNamed(context, AppRoutes.PrivacyPolicy),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'Help & Support',
                        items: [
                          _MenuItem(
                            icon: Icons.help_outline_rounded,
                            title: 'Help center',
                            onTap: () => Navigator.pushNamed(context, AppRoutes.HelpCenterScreen),
                          ),
                          _MenuItem(
                            icon: Icons.headset_mic_outlined,
                            title: 'Customer Support',
                            onTap: _openWhatsApp,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'Preferences',
                        items: [
                          _MenuItem(
                            icon: Icons.palette_outlined,
                            title: 'App Theme',
                            trailing: 'Light',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppThemeScreen())),
                          ),
                          _MenuItem(
                            icon: Icons.language_outlined,
                            title: 'Language',
                            trailing: 'English',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageScreen())),
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
        color: SaloonyColors.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: SaloonyColors.primary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: SaloonyColors.secondaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.settings_outlined, color: SaloonyColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Salon Settings', style: SaloonyTextStyles.heading4),
              ],
            ),
          ),
          _buildSalonSettingsMenuItem(
            icon: Icons.edit_outlined,
            title: 'Edit Salon',
            onTap: () async {
              final updated = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(builder: (context) => EditSalonScreen(salonData: _userSalon!)),
              );
              if (updated != null && mounted) {
                setState(() {
                  _userSalon = Map<String, dynamic>.from(updated);
                });
              }
            },
          ),
          _buildSalonSettingsMenuItem(
            icon: Icons.calendar_today_outlined,
            title: 'Appointments',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentsScreen())),
          ),
          _buildSalonSettingsMenuItem(
            icon: Icons.content_cut_outlined,
            title: 'Services',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TreatmentsManagementScreen())),
          ),
          _buildSalonSettingsMenuItem(
            icon: Icons.people_outline_rounded,
            title: 'Clients',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ClientsScreen())),
          ),
          _buildSalonSettingsMenuItem(
            icon: Icons.group_outlined,
            title: 'Team',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamMembersScreen())),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSalonSettingsMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(24)) : BorderRadius.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: SaloonyColors.backgroundTertiary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 20, color: SaloonyColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: SaloonyTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500))),
                Icon(Icons.chevron_right_rounded, color: SaloonyColors.textTertiary, size: 22),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Divider(height: 1, thickness: 1, color: SaloonyColors.borderLight),
          ),
      ],
    );
  }

  String _getSalonImageUrl(dynamic photoData) {
    if (photoData == null) return '';

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
    
    return 'Address not available';
  }

  Widget _buildSalonCard() {
    final salonImageUrl = _getSalonImageUrl(_userSalon?['salonPhotosPaths']);
    final salonAddress = _getSalonAddress(_userSalon);
    final String? salonStatus = _userSalon?['salonStatus']?.toString().toUpperCase();
    final Color verifiedIconColor = (salonStatus == 'ACTIVE')
      ? SaloonyColors.success
      : (salonStatus == 'PENDING')
        ? SaloonyColors.gold
        : (salonStatus == 'BLOCKED')
          ? SaloonyColors.error
          : SaloonyColors.gold;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: SaloonyColors.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: SaloonyColors.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Stack(
              children: [
                if (salonImageUrl.isNotEmpty)
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.network(
                      salonImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          color: SaloonyColors.backgroundTertiary,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                              color: SaloonyColors.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  _buildPlaceholderImage(),
                
                if (_isSalonOwner)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: InkWell(
                          onTap: () async {
                            final updated = await Navigator.push<Map<String, dynamic>>(
                              context,
                              MaterialPageRoute(builder: (context) => EditSalonScreen(salonData: _userSalon!)),
                            );
                            if (updated != null && mounted) {
                              setState(() {
                                _userSalon = Map<String, dynamic>.from(updated);
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: SaloonyColors.background,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.edit_outlined, size: 20, color: SaloonyColors.primary),
                          ),
                        ),
                      ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _userSalon?['salonName'] ?? 'Salon name not available',
                        style: SaloonyTextStyles.heading2,
                      ),
                    ),
                    // Status badge
                    if (salonStatus != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: (salonStatus == 'ACTIVE')
                                ? SaloonyColors.successLight
                                : (salonStatus == 'PENDING')
                                    ? SaloonyColors.warningLight
                                    : SaloonyColors.tertiaryLight,
                            borderRadius: BorderRadius.circular(16),
                           
                          ),
                       
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (salonStatus == 'ACTIVE')
                            ? SaloonyColors.success.withOpacity(0.12)
                            : SaloonyColors.secondaryLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: (salonStatus == 'ACTIVE') ? SaloonyColors.success : Colors.transparent,
                          width: 1.2,
                        ),
                      ),
                      child: Icon(Icons.verified, size: 20, color: verifiedIconColor),
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
                      style: SaloonyTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                
                if (salonAddress.isNotEmpty && salonAddress != 'Address not available')
                  _buildInfoRow(Icons.location_on_outlined, salonAddress),
                
                if (_userSalon?['salonCategory'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _buildInfoRow(Icons.category_outlined, _userSalon!['salonCategory'].toString()),
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SaloonyColors.backgroundTertiary,
            SaloonyColors.backgroundSecondary,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store_outlined, size: 60, color: SaloonyColors.textTertiary),
          const SizedBox(height: 8),
          Text('No image', style: SaloonyTextStyles.caption),
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
            SaloonyColors.primary,
            SaloonyColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: SaloonyColors.primary.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.store_outlined, size: 50, color: SaloonyColors.gold),
            ),
            const SizedBox(height: 24),
            Text(
              'Create Your Salon',
              style: SaloonyTextStyles.heading2.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'Start managing your professional salon and appointments',
              textAlign: TextAlign.center,
              style: SaloonyTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.9)),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.createsalon),
              style: ElevatedButton.styleFrom(
                backgroundColor: SaloonyColors.gold,
                foregroundColor: SaloonyColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                minimumSize: const Size(double.infinity, 56),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_circle_outline),
                  const SizedBox(width: 12),
                  Text('Create My Salon', style: SaloonyTextStyles.buttonLarge),
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
        Icon(icon, size: 18, color: SaloonyColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: SaloonyTextStyles.bodySmall),
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
        color: SaloonyColors.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: SaloonyColors.primary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Text(title, style: SaloonyTextStyles.labelLarge.copyWith(color: SaloonyColors.textSecondary)),
          ),
          ...List.generate(items.length, (index) {
            final item = items[index];
            final isLast = index == items.length - 1;
            return Column(
              children: [
                InkWell(
                  onTap: item.onTap,
                  borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(24)) : BorderRadius.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: SaloonyColors.backgroundTertiary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(item.icon, size: 20, color: SaloonyColors.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(item.title, style: SaloonyTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
                        ),
                        if (item.trailing != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(item.trailing!, style: SaloonyTextStyles.bodySmall),
                          ),
                        Icon(Icons.chevron_right_rounded, color: SaloonyColors.textTertiary, size: 22),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: Divider(height: 1, thickness: 1, color: SaloonyColors.borderLight),
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