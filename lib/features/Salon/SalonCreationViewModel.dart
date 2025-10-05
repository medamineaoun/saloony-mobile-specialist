import 'package:flutter/material.dart';
import 'dart:io';

class SalonCreationViewModel extends ChangeNotifier {
  // État actuel de la création
  int _currentStep = 0;
  final int _totalSteps = 7;
  
  // Données du salon
  AccountType _accountType = AccountType.solo;
  AccountInfo? _accountInfo;
  BusinessDetails? _businessDetails;
  final List<DayAvailability> _availability = _getDefaultAvailability();
  final List<SalonService> _services = [];
  final List<TeamMember> _teamMembers = [];

  // État de chargement
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  int get currentStep => _currentStep;
  int get totalSteps => _totalSteps;
  double get progress => (_currentStep + 1) / _totalSteps;
  AccountType get accountType => _accountType;
  AccountInfo? get accountInfo => _accountInfo;
  BusinessDetails? get businessDetails => _businessDetails;
  List<DayAvailability> get availability => _availability;
  List<SalonService> get services => _services;
  List<TeamMember> get teamMembers => _teamMembers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get canContinue => _validateCurrentStep();

  // Étape 1: Type de compte
  void setAccountType(AccountType type) {
    _accountType = type;
    notifyListeners();
  }

  // Étape 2: Informations du compte
  void setAccountInfo({
    required String firstName,
    required String lastName,
    required String businessName,
    required String email,
    required String phoneNumber,
  }) {
    _accountInfo = AccountInfo(
      firstName: firstName,
      lastName: lastName,
      businessName: businessName,
      email: email,
      phoneNumber: phoneNumber,
    );
    notifyListeners();
  }

  // Étape 3: Détails de l'entreprise
  void setBusinessDetails({
    String? logoPath,
    required String description,
    required String address,
  }) {
    _businessDetails = BusinessDetails(
      logoPath: logoPath,
      description: description,
      address: address,
    );
    notifyListeners();
  }

  // Étape 4: Disponibilité
  void toggleDayAvailability(int index) {
    _availability[index].isAvailable = !_availability[index].isAvailable;
    if (!_availability[index].isAvailable) {
      _availability[index].startTime = null;
      _availability[index].endTime = null;
    }
    notifyListeners();
  }

  void setDayTimes(int index, TimeOfDay? start, TimeOfDay? end) {
    _availability[index].startTime = start;
    _availability[index].endTime = end;
    notifyListeners();
  }

  // Étape 5: Services
  void addService(SalonService service) {
    _services.add(service);
    notifyListeners();
  }

  void updateService(int index, SalonService service) {
    _services[index] = service;
    notifyListeners();
  }

  void removeService(int index) {
    _services.removeAt(index);
    notifyListeners();
  }

  // Étape 6: Membres de l'équipe (uniquement pour salon)
  void addTeamMember(TeamMember member) {
    _teamMembers.add(member);
    notifyListeners();
  }

  void updateTeamMember(int index, TeamMember member) {
    _teamMembers[index] = member;
    notifyListeners();
  }

  void removeTeamMember(int index) {
    _teamMembers.removeAt(index);
    notifyListeners();
  }

  // Navigation
  void nextStep() {
    if (_currentStep < _totalSteps - 1 && _validateCurrentStep()) {
      _currentStep++;
      _errorMessage = null;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      _errorMessage = null;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < _totalSteps) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Validation
  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Type de compte
        return true;
      case 1: // Informations du compte
        return _accountInfo != null &&
            _accountInfo!.firstName.isNotEmpty &&
            _accountInfo!.lastName.isNotEmpty &&
            _accountInfo!.businessName.isNotEmpty &&
            _accountInfo!.email.isNotEmpty &&
            _accountInfo!.phoneNumber.isNotEmpty;
      case 2: // Détails entreprise
        return _businessDetails != null &&
            _businessDetails!.description.isNotEmpty &&
            _businessDetails!.address.isNotEmpty;
      case 3: // Disponibilité
        return _availability.any((day) => day.isAvailable);
      case 4: // Services
        return _services.isNotEmpty;
      case 5: // Membres (optionnel pour solo)
        return _accountType == AccountType.solo || _teamMembers.isNotEmpty;
      case 6: // Confirmation
        return true;
      default:
        return false;
    }
  }

  // Soumission finale
  Future<bool> submitSalonCreation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Implémenter l'appel API
      // final result = await salonService.createSalon(...)
      
      await Future.delayed(const Duration(seconds: 2)); // Simulation
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erreur lors de la création du salon: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Réinitialisation
  void reset() {
    _currentStep = 0;
    _accountType = AccountType.solo;
    _accountInfo = null;
    _businessDetails = null;
    _availability.clear();
    _availability.addAll(_getDefaultAvailability());
    _services.clear();
    _teamMembers.clear();
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Helper pour la disponibilité par défaut
  static List<DayAvailability> _getDefaultAvailability() {
    return [
      DayAvailability(day: 'Lundi'),
      DayAvailability(day: 'Mardi'),
      DayAvailability(day: 'Mercredi'),
      DayAvailability(day: 'Jeudi'),
      DayAvailability(day: 'Vendredi'),
      DayAvailability(day: 'Samedi'),
      DayAvailability(day: 'Dimanche'),
    ];
  }
}

// Import des modèles (à créer séparément)
class AccountType {
  static const solo = AccountType._('solo');
  static const team = AccountType._('team');
  
  final String value;
  const AccountType._(this.value);
}

class AccountInfo {
  final String firstName;
  final String lastName;
  final String businessName;
  final String email;
  final String phoneNumber;

  AccountInfo({
    required this.firstName,
    required this.lastName,
    required this.businessName,
    required this.email,
    required this.phoneNumber,
  });
}

class BusinessDetails {
  final String? logoPath;
  final String description;
  final String address;

  BusinessDetails({
    this.logoPath,
    required this.description,
    required this.address,
  });
}

class DayAvailability {
  final String day;
  bool isAvailable;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  DayAvailability({
    required this.day,
    this.isAvailable = false,
    this.startTime,
    this.endTime,
  });
}

class SalonService {
  final String id;
  final String? imagePath;
  final String name;
  final String description;

  SalonService({
    required this.id,
    this.imagePath,
    required this.name,
    required this.description,
  });
}

class TeamMember {
  final String id;
  final String? imagePath;
  final String fullName;
  final String specialty;
  final String email;

  TeamMember({
    required this.id,
    this.imagePath,
    required this.fullName,
    required this.specialty,
    required this.email,
  });
}