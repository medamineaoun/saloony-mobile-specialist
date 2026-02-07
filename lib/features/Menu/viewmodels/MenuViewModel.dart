import 'package:flutter/material.dart';
import 'package:saloony/core/models/User.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/UserService.dart';

class MenuViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  User? _currentUser;
  bool _isLoading = true;
  bool _hasSalon = false;
  String _selectedRoute = '/dashboard';

  List<MenuItem> _menuItems = [
    MenuItem(title: 'Create Salon', icon: Icons.store_rounded, route: '/createsalon'),
    MenuItem(title: 'Appointments', icon: Icons.calendar_today_rounded, route: '/appointments'),
    //MenuItem(title: 'Requests', icon: Icons.description_outlined, route: '/requests'),
   
 
  ];

  // === GETTERS ===
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get hasSalon => _hasSalon;
  List<MenuItem> get menuItems => _menuItems;
  String get selectedRoute => _selectedRoute;

  String get userName => _currentUser?.fullName ?? 'Utilisateur';
  String get userRole => _formatRole(_currentUser?.appRole ?? 'USER');

  MenuViewModel() {
    loadCurrentUser();
  }

  /// Charger les infos utilisateur + vérifier s’il a un salon
  Future<void> loadCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.getCurrentUser();

      if (result['success'] == true && result['user'] != null) {
        _currentUser = User.fromJson(result['user']);

        // Vérifier s’il a un salon
        final salonCheck = await _userService.checkIfSpecialistHasSalon(_currentUser!.userId);
        if (salonCheck['success'] == true) {
          _hasSalon = salonCheck['hasSalon'];
        } else {
          _hasSalon = false;
        }
      } else {
        _currentUser = null;
        _hasSalon = false;
      }
    } catch (e) {
      print('Erreur lors du chargement de l’utilisateur: $e');
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
        return 'Spécialiste';
      case 'ADMIN':
        return 'Administrateur';
      default:
        return 'Utilisateur';
    }
  }

  void selectMenuItem(String route) {
    _selectedRoute = route;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await loadCurrentUser();
  }
}

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
