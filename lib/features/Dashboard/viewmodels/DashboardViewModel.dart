import 'package:flutter/foundation.dart';
import 'package:saloony/core/models/Appointment.dart';



class DashboardViewModel extends ChangeNotifier {

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


 int _upcomingAppointmentsCount = 8;
  String _nextAppointmentTime = '17';
  double _lastWeekPercentage = 8.67;
  int _daysRemaining = 14;
  bool _isLoading = false;

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

       
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
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

      await Future.delayed(const Duration(seconds: 2));

      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void changeBenefitsPeriod(String period) {
   
    notifyListeners();
  }

  @override
  void dispose() {
    // Nettoyer les ressources si nécessaire
    super.dispose();
  }
}