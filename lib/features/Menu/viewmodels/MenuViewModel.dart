import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saloony/core/models/MenuItem.dart';
import 'package:saloony/features/Dashboard/views/SideMenuDialog.dart';

class MenuViewModel extends ChangeNotifier {
  UserProfile _userProfile = UserProfile(
    name: 'Andrew Ainshley',
    planType: 'Plan Pro',
  );

  List<MenuItem> _menuItems = [
    MenuItem(title: 'Tableau de bord', icon: Icons.dashboard, route: '/dashboard'),
    MenuItem(title: 'Rendez-vous', icon: Icons.calendar_today, route: '/appointments'),
    MenuItem(title: 'Demandes', icon: Icons.description, route: '/requests'),
    MenuItem(title: 'Messages', icon: Icons.message, route: '/messages'),
    MenuItem(title: 'Calendrier', icon: Icons.calendar_month, route: '/calendar'),
    MenuItem(title: 'Services', icon: Icons.work, route: '/services'),
    MenuItem(title: 'Clients', icon: Icons.people, route: '/clients'),
    MenuItem(title: 'Équipe', icon: Icons.groups, route: '/team'),
    MenuItem(title: 'Gains', icon: Icons.attach_money, route: '/earnings'),
    MenuItem(title: 'Notes et avis', icon: Icons.star, route: '/reviews'),
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

class DashboardViewModel extends ChangeNotifier {
  BenefitsSummary _benefits = BenefitsSummary(
    total: 7563.99,
    percentageChange: 13,
    period: 'cette semaine',
  );

  List<Appointment> _upcomingAppointments = [
    Appointment(
      id: '1',
      clientName: 'Michael DeMoya',
      clientImage: 'assets/michael.jpg',
      date: "Aujourd'hui",
      time: '11h00',
      servicesCount: 5,
      price: 402.00,
    ),
  ];

  List<Message> _unreadMessages = [
    Message(
      id: '1',
      senderName: 'Luis Marou Elian',
      senderImage: 'assets/luis.jpg',
      content: "Tout est prêt. Merci d'avoir",
      time: '09:34',
      unreadCount: 2,
    ),
    Message(
      id: '2',
      senderName: 'Luis Marou Elian',
      senderImage: 'assets/luis.jpg',
      content: "Tout est prêt. Merci d'avoir",
      time: '09:34',
      unreadCount: 2,
    ),
  ];

  List<PendingRequest> _pendingRequests = [
    PendingRequest(
      id: '1',
      clientName: 'Michael DeMoya',
      clientImage: 'assets/michael.jpg',
      price: 402.00,
      servicesCount: 5,
      date: "Aujourd'hui",
      time: '11h00',
      timeUntil: 'Il y a 5 minutes',
    ),
    PendingRequest(
      id: '2',
      clientName: 'Michael DeMoya',
      clientImage: 'assets/michael.jpg',
      price: 492.00,
      servicesCount: 5,
      date: "Aujourd'hui",
      time: '11h00',
      timeUntil: 'Il y a 5 minutes',
    ),
  ];

  int _upcomingAppointmentsCount = 8;
  String _nextAppointmentTime = '17prochain';
  double _lastWeekPercentage = 8.67;
  int _daysRemaining = 14;

  BenefitsSummary get benefits => _benefits;
  List<Appointment> get upcomingAppointments => _upcomingAppointments;
  List<Message> get unreadMessages => _unreadMessages;
  List<PendingRequest> get pendingRequests => _pendingRequests;
  int get upcomingAppointmentsCount => _upcomingAppointmentsCount;
  String get nextAppointmentTime => _nextAppointmentTime;
  double get lastWeekPercentage => _lastWeekPercentage;
  int get daysRemaining => _daysRemaining;

  void acceptRequest(String requestId) {
    // Logique pour accepter une demande
    notifyListeners();
  }

  void rejectRequest(String requestId) {
    // Logique pour rejeter une demande
    notifyListeners();
  }

  void markAsRead(String messageId) {
    // Logique pour marquer un message comme lu
    notifyListeners();
  }
}