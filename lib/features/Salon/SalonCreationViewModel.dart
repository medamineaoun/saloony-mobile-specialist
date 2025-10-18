import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/models/User.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saloony/core/services/SalonService.dart';

enum AccountType { solo, team }

class SalonCreationViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SalonService _salonService = SalonService();
  final ImagePicker _picker = ImagePicker();
  
  // Données utilisateur
  User? _currentUser;
  bool _isLoadingUser = true;
  bool _isCreatingSalon = false;
  
  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // État
  int _currentStep = 0;
  AccountType? _accountType;
  String? _businessImagePath;
  LocationResult? _location;
  
  // Nouveaux champs pour les traitements et services
  List<Treatment> _availableTreatments = [];
  List<String> _selectedTreatmentIds = [];
  String? _selectedSalonCategory;
  List<String> _selectedAdditionalServices = [];
  String? _selectedGenderType;
  
  List<DayAvailability> _availability = [
    DayAvailability(day: 'Monday', isAvailable: true),
    DayAvailability(day: 'Tuesday', isAvailable: true),
    DayAvailability(day: 'Wednesday', isAvailable: true),
    DayAvailability(day: 'Thursday', isAvailable: true),
    DayAvailability(day: 'Friday', isAvailable: true),
    DayAvailability(day: 'Saturday', isAvailable: false),
    DayAvailability(day: 'Sunday', isAvailable: false),
  ];

  List<Service> _services = [];
  List<TeamMember> _teamMembers = [];

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoadingUser => _isLoadingUser;
  bool get isCreatingSalon => _isCreatingSalon;
  int get currentStep => _currentStep;
  AccountType? get accountType => _accountType;
  String? get businessImagePath => _businessImagePath;
  LocationResult? get location => _location;
  List<DayAvailability> get availability => _availability;
  List<Service> get services => _services;
  List<TeamMember> get teamMembers => _teamMembers;
  List<Treatment> get availableTreatments => _availableTreatments;
  List<String> get selectedTreatmentIds => _selectedTreatmentIds;
  String? get selectedSalonCategory => _selectedSalonCategory;
  List<String> get selectedAdditionalServices => _selectedAdditionalServices;
  String? get selectedGenderType => _selectedGenderType;

  double get progress => (_currentStep + 1) / 7;

  bool get canContinue {
    switch (_currentStep) {
      case 0:
        // Account Type
        return _accountType != null;
      case 1:
        // Account Information
        return firstNameController.text.trim().isNotEmpty &&
               lastNameController.text.trim().isNotEmpty &&
               businessNameController.text.trim().isNotEmpty &&
               emailController.text.trim().isNotEmpty &&
               phoneController.text.trim().isNotEmpty &&
               _isValidEmail(emailController.text.trim());
      case 2:
        // Business Details
        return addressController.text.trim().isNotEmpty &&
               descriptionController.text.trim().isNotEmpty &&
               _location != null &&
               _selectedSalonCategory != null &&
               _selectedGenderType != null;
      case 3:
        // Availability
        return _availability.any((day) => day.isAvailable);
      case 4:
        // Treatments
        return _selectedTreatmentIds.isNotEmpty;
      case 5:
        // Team
        return _accountType == AccountType.solo || _teamMembers.isNotEmpty;
      case 6:
        // Confirmation
        return true;
      default:
        return false;
    }
  }

  SalonCreationViewModel() {
    _loadCurrentUser();
    _loadAvailableTreatments();
    _setupControllerListeners();
  }

  /// 🔔 Configurer les listeners des controllers
  void _setupControllerListeners() {
    firstNameController.addListener(notifyListeners);
    lastNameController.addListener(notifyListeners);
    businessNameController.addListener(notifyListeners);
    emailController.addListener(notifyListeners);
    phoneController.addListener(notifyListeners);
    addressController.addListener(notifyListeners);
    descriptionController.addListener(notifyListeners);
  }

  /// ✉️ Valider le format email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  /// 📥 Charger les informations de l'utilisateur connecté
  Future<void> _loadCurrentUser() async {
    _isLoadingUser = true;
    notifyListeners();

    try {
      final result = await _authService.getCurrentUser();

      if (result['success'] == true && result['user'] != null) {
        _currentUser = User.fromJson(result['user']);
        _prefillUserData();
      }
    } catch (e) {
      debugPrint('❌ Erreur lors du chargement de l\'utilisateur: $e');
    } finally {
      _isLoadingUser = false;
      notifyListeners();
    }
  }

  /// 📋 Charger les traitements disponibles
  Future<void> _loadAvailableTreatments() async {
    try {
      final result = await _salonService.getAllTreatments();
      
      if (result['success'] == true && result['treatments'] != null) {
        _availableTreatments = (result['treatments'] as List)
            .map((json) => Treatment.fromJson(json))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Erreur lors du chargement des traitements: $e');
    }
  }

  /// ✏️ Pré-remplir les champs avec les données utilisateur
  void _prefillUserData() {
    if (_currentUser == null) return;

    firstNameController.text = _currentUser!.userFirstName ?? '';
    lastNameController.text = _currentUser!.userLastName ?? '';
    emailController.text = _currentUser!.userEmail ?? '';
    phoneController.text = _currentUser!.userPhoneNumber ?? '';

    debugPrint('✅ Données utilisateur pré-remplies');
    notifyListeners();
  }

  // Setters
  void setAccountType(AccountType type) {
    _accountType = type;
    notifyListeners();
  }

  void setSalonCategory(String category) {
    _selectedSalonCategory = category;
    notifyListeners();
  }

  void toggleAdditionalService(String service) {
    if (_selectedAdditionalServices.contains(service)) {
      _selectedAdditionalServices.remove(service);
    } else {
      _selectedAdditionalServices.add(service);
    }
    notifyListeners();
  }

  void setGenderType(String type) {
    _selectedGenderType = type;
    notifyListeners();
  }

  void toggleTreatmentSelection(String treatmentId) {
    if (_selectedTreatmentIds.contains(treatmentId)) {
      _selectedTreatmentIds.remove(treatmentId);
    } else {
      _selectedTreatmentIds.add(treatmentId);
    }
    notifyListeners();
  }

  void setLocation(LocationResult location) {
    _location = location;
    addressController.text = location.address;
    notifyListeners();
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        _businessImagePath = image.path;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de la sélection d\'image: $e');
    }
  }

  void toggleDayAvailability(int index) {
    _availability[index].isAvailable = !_availability[index].isAvailable;
    notifyListeners();
  }

  void addService(Service service) {
    _services.add(service);
    notifyListeners();
  }

  void removeService(String serviceId) {
    _services.removeWhere((s) => s.id == serviceId);
    notifyListeners();
  }

  void addTeamMember(TeamMember member) {
    _teamMembers.add(member);
    notifyListeners();
  }

  void removeTeamMember(String memberId) {
    _teamMembers.removeWhere((m) => m.id == memberId);
    notifyListeners();
  }

  void nextStep(BuildContext context) {
    if (_currentStep < 6) {
      _currentStep++;
      notifyListeners();
    } else {
      _finishCreation(context);
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  Future<void> _finishCreation(BuildContext context) async {
    if (_isCreatingSalon) return;

    _isCreatingSalon = true;
    notifyListeners();

    try {
      // Validation finale
      if (_location == null) {
        _showError(context, 'Please select a location on the map');
        return;
      }

      if (_selectedTreatmentIds.isEmpty) {
        _showError(context, 'Please select at least one treatment');
        return;
      }

      // Obtenir les IDs des spécialistes
      List<String> specialistIds = [];
      if (_accountType == AccountType.solo && _currentUser != null) {
        specialistIds = [_currentUser!.userId!];
      } else {
        specialistIds = _teamMembers.map((m) => m.id).toList();
      }

      if (specialistIds.isEmpty) {
        _showError(context, 'Please add at least one team member');
        return;
      }

      // Étape 1: Créer le salon
      final createResult = await _salonService.createSalon(
        salonName: businessNameController.text,
        salonDescription: descriptionController.text,
        salonCategory: _selectedSalonCategory!,
        additionalServices: _selectedAdditionalServices,
        genderType: _selectedGenderType!,
        latitude: _location!.latitude,
        longitude: _location!.longitude,
        treatmentIds: _selectedTreatmentIds,
        specialistIds: specialistIds,
      );

      if (!createResult['success']) {
        _showError(context, createResult['message']);
        return;
      }

      final salonId = createResult['salon']['salonId'];

      // Étape 2: Ajouter la photo si disponible
      if (_businessImagePath != null) {
        await _salonService.addSalonPhoto(
          salonId: salonId,
          imagePath: _businessImagePath!,
        );
      }

      // Succès
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Salon créé avec succès !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de la création du salon: $e');
      if (context.mounted) {
        _showError(context, 'Une erreur est survenue: $e');
      }
    } finally {
      _isCreatingSalon = false;
      notifyListeners();
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showAddServiceDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Service Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                addService(Service(
                  id: DateTime.now().toString(),
                  name: nameController.text,
                  description: descController.text,
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void showAddTeamMemberDialog(BuildContext context) {
    final nameController = TextEditingController();
    final specialtyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Team Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: specialtyController,
              decoration: const InputDecoration(labelText: 'Specialty'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                addTeamMember(TeamMember(
                  id: DateTime.now().toString(),
                  fullName: nameController.text,
                  specialty: specialtyController.text,
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    businessNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

// Models
class DayAvailability {
  final String day;
  bool isAvailable;

  DayAvailability({required this.day, required this.isAvailable});
}

class Service {
  final String id;
  final String name;
  final String description;

  Service({required this.id, required this.name, required this.description});
}

class TeamMember {
  final String id;
  final String fullName;
  final String specialty;

  TeamMember({required this.id, required this.fullName, required this.specialty});
}

class LocationResult {
  final double latitude;
  final double longitude;
  final String address;

  LocationResult({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class Treatment {
  final String treatmentId;
  final String treatmentName;
  final String treatmentDescription;
  final String treatmentCategory;

  Treatment({
    required this.treatmentId,
    required this.treatmentName,
    required this.treatmentDescription,
    required this.treatmentCategory,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      treatmentId: json['treatmentId'],
      treatmentName: json['treatmentName'],
      treatmentDescription: json['treatmentDescription'] ?? '',
      treatmentCategory: json['treatmentCategory'],
    );
  }
}