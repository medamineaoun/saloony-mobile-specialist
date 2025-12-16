import 'package:flutter/material.dart';
import 'package:SaloonySpecialist/core/models/User.dart';
import 'package:SaloonySpecialist/core/services/AuthService.dart';
import 'package:SaloonySpecialist/core/services/UserService.dart';
import 'package:SaloonySpecialist/core/Config/ProviderSetup.dart';

class MenuViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  User? _currentUser;
  bool _isLoading = true;
  bool _hasSalon = false;
  String _selectedRoute = '/dashboard';

  final List<MenuItem> _menuItems = [
    MenuItem(
      title: 'Create Salon',
      icon: Icons.store_rounded,
      route: '/createsalon',
    ),
    MenuItem(
      title: 'Appointments',
      icon: Icons.calendar_today_rounded,
      route: '/appointments',
    ),
    
  ];

  // === GETTERS ===
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get hasSalon => _hasSalon;
  List<MenuItem> get menuItems => _menuItems;
  String get selectedRoute => _selectedRoute;

  String get userName => _currentUser?.fullName ?? 'User';
  String get userRole => _formatRole(_currentUser?.appRole ?? 'USER');

  /// ✅ GETTER pour l'URL de l'image de profil (Web & Mobile compatible)
  String? get profileImageUrl {
    final photoPath = _currentUser?.profilePhotoPath;
    
    if (photoPath == null || photoPath.isEmpty) {
      return null;
    }

    // Si c'est déjà une URL complète
    if (photoPath.startsWith('http://') || photoPath.startsWith('https://')) {
      return photoPath;
    }

    // Construire l'URL complète à partir du chemin relatif
    final baseUrl = Config.userBaseUrl;
    final cleanPath = photoPath.startsWith('/') 
        ? photoPath.substring(1) 
        : photoPath;
    
    final uri = Uri.parse(baseUrl);
    final baseUrlWithoutPath = '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
    
    return '$baseUrlWithoutPath/$cleanPath';
  }

  MenuViewModel() {
    loadCurrentUser();
  }

  /// Charger les infos utilisateur + vérifier s'il a un salon
  Future<void> loadCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.getCurrentUser();

      if (result['success'] == true && result['user'] != null) {
        _currentUser = User.fromJson(result['user']);

        debugPrint('✅ User loaded: ${_currentUser?.fullName}');
        debugPrint('📸 Profile photo path: ${_currentUser?.profilePhotoPath}');
        debugPrint('📸 Profile image URL: $profileImageUrl');

        // Vérifier s'il a un salon
        final salonCheck = await _userService.checkIfSpecialistHasSalon(
          _currentUser!.userId,
        );
        
        if (salonCheck['success'] == true) {
          _hasSalon = salonCheck['hasSalon'];
          debugPrint('✅ Has salon: $_hasSalon');
        } else {
          _hasSalon = false;
          debugPrint('⚠️ Could not check salon status');
        }
      } else {
        _currentUser = null;
        _hasSalon = false;
        debugPrint('❌ Failed to load user');
      }
    } catch (e) {
      debugPrint('❌ Error loading user: $e');
      _currentUser = null;
      _hasSalon = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _formatRole(String role) {
    switch (role.toUpperCase()) {
      case 'CUSTOMER':
        return 'Client';
      case 'SPECIALIST':
        return 'Specialist';
      case 'ADMIN':
        return 'Administrator';
      default:
        return 'User';
    }
  }

  void selectMenuItem(String route) {
    _selectedRoute = route;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await loadCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final String? route;
  final bool requiresSalon;

  MenuItem({
    required this.title,
    required this.icon,
    this.route,
    this.requiresSalon = false,
  });
}