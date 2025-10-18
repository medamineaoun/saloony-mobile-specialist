import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/models/User.dart';

class MenuViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  bool _isLoading = true;
  String _selectedRoute = '/dashboard';

  List<MenuItem> _menuItems = [
    MenuItem(title: 'Dashboard', icon: Icons.dashboard_rounded, route: '/dashboard'),
        MenuItem(title: 'Create Salon', icon: Icons.store_rounded, route: '/createsalon'),
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

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  List<MenuItem> get menuItems => _menuItems;
  String get selectedRoute => _selectedRoute;
  
  String get userName => _currentUser?.fullName ?? 'Utilisateur';
  String get userRole => _formatRole(_currentUser?.appRole ?? 'USER');

  MenuViewModel() {
    loadCurrentUser();
  }

  /// Charge les informations de l'utilisateur connecté
  Future<void> loadCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.getCurrentUser();
      
      if (result['success'] == true && result['user'] != null) {
        _currentUser = User.fromJson(result['user']);
      } else {
        _currentUser = null;
      }
    } catch (e) {
      print('Erreur lors du chargement de l\'utilisateur: $e');
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Formate le rôle pour l'affichage
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

  /// Rafraîchir les données utilisateur
  Future<void> refreshUser() async {
    await loadCurrentUser();
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