import 'package:flutter/material.dart';

class ProfileEditViewModel extends ChangeNotifier {
  // Détails du compte
  String _fullName = 'Jean Dupont';
  String _speciality = 'Maquilleur';
  String _platformRole = 'Sélectionnez le rôle';
  String _email = 'exemple@domaine.com';
  String _phoneNumber = '+123 456 789 000';
  
  // Détails de l'entreprise
  String _businessName = 'Salon de coiffure XYZ';
  String _aboutBusiness = 'Brève description';
  String _businessEmail = 'exemple@domaine.com';
  String _businessPhone = '+123 456 789 000';
  String _website = 'www.mybarbershop.com';
  
  // Onglet actif (0 = Détails du compte, 1 = Détails de l'entreprise)
  int _activeTab = 0;
  
  // Image de profil
  String? _profileImagePath;
  
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get fullName => _fullName;
  String get speciality => _speciality;
  String get platformRole => _platformRole;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get businessName => _businessName;
  String get aboutBusiness => _aboutBusiness;
  String get businessEmail => _businessEmail;
  String get businessPhone => _businessPhone;
  String get website => _website;
  int get activeTab => _activeTab;
  String? get profileImagePath => _profileImagePath;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Setters
  void setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void setSpeciality(String value) {
    _speciality = value;
    notifyListeners();
  }

  void setPlatformRole(String value) {
    _platformRole = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void setBusinessName(String value) {
    _businessName = value;
    notifyListeners();
  }

  void setAboutBusiness(String value) {
    _aboutBusiness = value;
    notifyListeners();
  }

  void setBusinessEmail(String value) {
    _businessEmail = value;
    notifyListeners();
  }

  void setBusinessPhone(String value) {
    _businessPhone = value;
    notifyListeners();
  }

  void setWebsite(String value) {
    _website = value;
    notifyListeners();
  }

  void setActiveTab(int index) {
    _activeTab = index;
    notifyListeners();
  }

  void setProfileImage(String? path) {
    _profileImagePath = path;
    notifyListeners();
  }

  // Validation
  bool validateAccountDetails() {
    if (_fullName.isEmpty) {
      _errorMessage = 'Le nom est requis';
      notifyListeners();
      return false;
    }
    if (_email.isEmpty || !_email.contains('@')) {
      _errorMessage = 'Email invalide';
      notifyListeners();
      return false;
    }
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  bool validateBusinessDetails() {
    if (_businessName.isEmpty) {
      _errorMessage = 'Le nom de l\'entreprise est requis';
      notifyListeners();
      return false;
    }
    if (_businessEmail.isEmpty || !_businessEmail.contains('@')) {
      _errorMessage = 'Email invalide';
      notifyListeners();
      return false;
    }
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  // Sauvegarder les modifications
  Future<void> saveChanges() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulation d'un appel API
      await Future.delayed(const Duration(seconds: 2));
      
      // Validation selon l'onglet actif
      bool isValid = _activeTab == 0 
          ? validateAccountDetails() 
          : validateBusinessDetails();
      
      if (!isValid) {
        _isLoading = false;
        return;
      }

      // Ici, vous feriez l'appel API réel
      // await _apiService.updateProfile(...);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erreur lors de la sauvegarde: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Liste des rôles disponibles
  List<String> get availableRoles => [
    'Sélectionnez le rôle',
    'Coiffeur',
    'Barbier',
    'Esthéticien',
    'Maquilleur',
    'Styliste',
    'Masseur',
  ];
}