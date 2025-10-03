import 'package:flutter/foundation.dart';
import 'package:saloony/core/models/MenuItem.dart';


class DashboardViewModel extends ChangeNotifier {
  // Private fields
  BenefitsSummary _benefits = BenefitsSummary(
    total: 7563.99,
    percentageChange: 13,
    period: 'this week',
  );

  List<Appointment> _upcomingAppointments = [
    Appointment(
      id: '1',
      clientName: 'Michael DeMoya',
      clientImage: 'https://via.placeholder.com/50',
      date: 'Today',
      time: '11:00 AM',
      servicesCount: 5,
      price: 402.00,
    ),
    Appointment(
      id: '2',
      clientName: 'Sarah Johnson',
      clientImage: 'https://via.placeholder.com/50',
      date: 'Today',
      time: '2:00 PM',
      servicesCount: 3,
      price: 250.00,
    ),
  ];

  List<Message> _unreadMessages = [
    Message(
      id: '1',
      senderName: 'Luis Marou Elian',
      senderImage: 'https://via.placeholder.com/50',
      content: 'All set. Thanks for having',
      time: '09:34',
      unreadCount: 2,
    ),
    Message(
      id: '2',
      senderName: 'Anna Smith',
      senderImage: 'https://via.placeholder.com/50',
      content: 'Can we reschedule?',
      time: '08:15',
      unreadCount: 1,
    ),
  ];

  List<PendingRequest> _pendingRequests = [
    PendingRequest(
      id: '1',
      clientName: 'Michael DeMoya',
      clientImage: 'https://via.placeholder.com/50',
      price: 402.00,
      servicesCount: 5,
      date: 'Today',
      time: '11:00 AM',
      timeUntil: '5 min ago',
    ),
    PendingRequest(
      id: '2',
      clientName: 'Emma Wilson',
      clientImage: 'https://via.placeholder.com/50',
      price: 492.00,
      servicesCount: 4,
      date: 'Today',
      time: '3:00 PM',
      timeUntil: '12 min ago',
    ),
  ];

  int _upcomingAppointmentsCount = 8;
  String _nextAppointmentTime = '17';
  double _lastWeekPercentage = 8.67;
  int _daysRemaining = 14;
  bool _isLoading = false;

  // Getters
  BenefitsSummary get benefits => _benefits;
  List<Appointment> get upcomingAppointments => _upcomingAppointments;
  List<Message> get unreadMessages => _unreadMessages;
  List<PendingRequest> get pendingRequests => _pendingRequests;
  int get upcomingAppointmentsCount => _upcomingAppointmentsCount;
  String get nextAppointmentTime => _nextAppointmentTime;
  double get lastWeekPercentage => _lastWeekPercentage;
  int get daysRemaining => _daysRemaining;
  bool get isLoading => _isLoading;

  // Methods
  Future<void> acceptRequest(String requestId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simuler un appel API
      await Future.delayed(const Duration(seconds: 1));

      // Retirer la demande de la liste
      _pendingRequests.removeWhere((request) => request.id == requestId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> rejectRequest(String requestId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simuler un appel API
      await Future.delayed(const Duration(seconds: 1));

      // Retirer la demande de la liste
      _pendingRequests.removeWhere((request) => request.id == requestId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> markAsRead(String messageId) async {
    try {
      // Simuler un appel API
      await Future.delayed(const Duration(milliseconds: 500));

      // Trouver et mettre à jour le message
      final messageIndex = _unreadMessages.indexWhere((msg) => msg.id == messageId);
      if (messageIndex != -1) {
        _unreadMessages[messageIndex] = _unreadMessages[messageIndex].copyWith(
          unreadCount: 0,
        );
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAppointmentAsReady(String appointmentId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simuler un appel API
      await Future.delayed(const Duration(seconds: 1));

      // Logique pour marquer comme prêt
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> refreshDashboard() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simuler un appel API pour rafraîchir toutes les données
      await Future.delayed(const Duration(seconds: 2));

      // Recharger les données
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void changeBenefitsPeriod(String period) {
    _benefits = _benefits.copyWith(period: period);
    notifyListeners();
  }

  @override
  void dispose() {
    // Nettoyer les ressources si nécessaire
    super.dispose();
  }
}