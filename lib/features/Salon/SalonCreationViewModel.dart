import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/enum/SalonCategory.dart';
import 'package:saloony/core/enum/SalonGenderType.dart';
import 'package:saloony/core/enum/additional_service.dart';
import 'package:saloony/core/models/DayAvailability.dart';
import 'package:saloony/core/models/TeamMember.dart';
import 'package:saloony/core/models/Treatment.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/models/User.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saloony/core/services/SalonService.dart';
import 'package:saloony/features/Salon/location_result.dart';

enum AccountType { solo, team }

// Modèle pour les créneaux horaires
class TimeSlot {
  final String time;
  bool isAvailable;
  
  TimeSlot({required this.time, this.isAvailable = true});
}

// Modèle pour l'availability par jour
class DayAvailabilityWithSlots {
  final String day;
  bool isAvailable;
  TimeRange? timeRange;
  
  DayAvailabilityWithSlots({
    required this.day,
    this.isAvailable = false,
    this.timeRange,
  });
}

class TimeRange {
  TimeOfDay startTime;
  TimeOfDay endTime;
  
  TimeRange({required this.startTime, required this.endTime});
}

// Modèle pour un service personnalisé
class CustomService {
  String id;
  String name;
  String description;
  double price;
  String? photoPath;
  String? specificGender; // 'Man', 'Woman', ou null pour mixte
  String category;
  
  CustomService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.photoPath,
    this.specificGender,
    required this.category,
  });
}

class SalonCreationViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SalonService _salonService = SalonService();
  final ImagePicker _picker = ImagePicker();
  
  // Contrôleurs de texte
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController additionalAddressController = TextEditingController();

  // Données utilisateur
  User? _currentUser;
  bool _isLoadingUser = true;
  bool _isCreatingSalon = false;
  int _currentStep = 0;

  // Informations du salon
  SalonCategory? selectedCategory;
  String? _businessImagePath;
  LocationResult? _location;
  SalonGenderType? _selectedGenderType;
  List<AdditionalService> selectedAdditionalServices = [];
  
  // Traitements et services
  List<Treatment> _availableTreatments = [];
  List<String> _selectedTreatmentIds = [];
  List<CustomService> _customServices = [];
  
  // Équipe
  List<TeamMember> _teamMembers = [];
  AccountType? _accountType;

  // Disponibilité - CORRECTION COMPLÈTE
  final Map<String, DayAvailabilityWithSlots> _weeklyAvailability = {};

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoadingUser => _isLoadingUser;
  bool get isCreatingSalon => _isCreatingSalon;
  int get currentStep => _currentStep;
  AccountType? get accountType => _accountType;
  String? get businessImagePath => _businessImagePath;
  LocationResult? get location => _location;
  Map<String, DayAvailabilityWithSlots> get weeklyAvailability => _weeklyAvailability;
  List<TeamMember> get teamMembers => _teamMembers;
  List<Treatment> get availableTreatments => _availableTreatments;
  List<String> get selectedTreatmentIds => _selectedTreatmentIds;
  List<CustomService> get customServices => _customServices;
  SalonGenderType? get selectedGenderType => _selectedGenderType;

  List<AdditionalService> get availableAdditionalServices => AdditionalService.values;
  List<SalonGenderType> get availableGenderTypes => SalonGenderType.values;

  double get progress => (_currentStep + 1) / 7;

  String? get selectedGenderTypeForUI {
    if (_selectedGenderType == null) return null;
    switch (_selectedGenderType!) {
      case SalonGenderType.man:
        return 'Man';
      case SalonGenderType.woman:
        return 'Woman';
      case SalonGenderType.mixed:
        return 'Mixed';
    }
  }

  List<Map<String, dynamic>> get availableGenderTypesForUI {
    return [
      {'value': SalonGenderType.man, 'label': 'Man'},
      {'value': SalonGenderType.woman, 'label': 'Woman'},
      {'value': SalonGenderType.mixed, 'label': 'Mixed'},
    ];
  }

  String? get selectedGenderTypeString => _selectedGenderType?.name;
  List<String> get availableGenderTypesStrings => 
      SalonGenderType.values.map((e) => e.name).toList();

  List<DayAvailabilityWithSlots> get availability {
    return _weeklyAvailability.values.toList();
  }

bool get canContinue {
  switch (_currentStep) {
    case 0: 
      return businessNameController.text.trim().isNotEmpty &&
             selectedCategory != null;
             
    case 1: 
      return descriptionController.text.trim().isNotEmpty &&
             _location != null &&
             _businessImagePath != null &&
             _selectedGenderType != null;
    
    case 2: 
      return true;
             
    case 3:
      return _weeklyAvailability.values.any((day) => day.isAvailable);
      
    case 4:
      return _selectedTreatmentIds.isNotEmpty || _customServices.isNotEmpty;
      
    case 5: 
      return true;
      
    case 6:
      return true;
      
    default:
      return false;
  }
}

  SalonCreationViewModel() {
    _loadCurrentUser();
    _loadAvailableTreatments();
    _setupControllerListeners();
    _initializeAvailability(); // ← INITIALISATION AJOUTÉE
  }

  void _setupControllerListeners() {
    businessNameController.addListener(notifyListeners);
    descriptionController.addListener(notifyListeners);
    additionalAddressController.addListener(notifyListeners);
  }

  // CORRECTION: Initialisation de la disponibilité
  void _initializeAvailability() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    for (final day in days) {
      _weeklyAvailability[day] = DayAvailabilityWithSlots(
        day: day,
        isAvailable: false, // Par défaut non disponible
        timeRange: TimeRange(
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 18, minute: 0),
        ),
      );
    }
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    _isLoadingUser = true;
    notifyListeners();

    try {
      final result = await _authService.getCurrentUser();

      if (result['success'] == true && result['user'] != null) {
        _currentUser = User.fromJson(result['user']);
        debugPrint('✅ Utilisateur chargé: ${_currentUser?.userFirstName}');
      }
    } catch (e) {
      debugPrint('❌ Erreur chargement utilisateur: $e');
    } finally {
      _isLoadingUser = false;
      notifyListeners();
    }
  }

  Future<void> _loadAvailableTreatments() async {
    try {
      final result = await _salonService.getAllTreatments();
      
      if (result['success'] == true && result['treatments'] != null) {
        _availableTreatments = (result['treatments'] as List)
            .map((json) => Treatment.fromJson(json))
            .toList();
        debugPrint('✅ ${_availableTreatments.length} traitements chargés');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Erreur chargement traitements: $e');
    }
  }

  // Setters
  void setAccountType(AccountType type) {
    _accountType = type;
    notifyListeners();
  }

  void setGenderType(SalonGenderType type) {
    _selectedGenderType = type;
    notifyListeners();
  }

  void setGenderTypeFromString(String typeString) {
    try {
      _selectedGenderType = SalonGenderType.fromString(typeString);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erreur conversion gender type: $e');
    }
  }

  void toggleAdditionalService(AdditionalService service) {
    if (selectedAdditionalServices.contains(service)) {
      selectedAdditionalServices.remove(service);
    } else {
      selectedAdditionalServices.add(service);
    }
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
        debugPrint('✅ Image sélectionnée: $_businessImagePath');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Erreur sélection image: $e');
    }
  }

  // CORRECTION: Méthode pour mettre à jour les horaires d'un jour
  void setDayTimeRange(String day, TimeOfDay startTime, TimeOfDay endTime) {
    if (_weeklyAvailability.containsKey(day)) {
      _weeklyAvailability[day]!.timeRange = TimeRange(
        startTime: startTime,
        endTime: endTime,
      );
      // Marquer automatiquement le jour comme disponible quand on définit des horaires
      _weeklyAvailability[day]!.isAvailable = true;
      notifyListeners();
    }
  }

  // CORRECTION: Méthode pour basculer la disponibilité d'un jour
  void toggleDayAvailability(int index) {
    if (index >= 0 && index < _weeklyAvailability.values.length) {
      final dayKey = _weeklyAvailability.keys.elementAt(index);
      final day = _weeklyAvailability[dayKey];
      if (day != null) {
        day.isAvailable = !day.isAvailable;
        notifyListeners();
      }
    }
  }

  // Gestion des services personnalisés
  void addCustomService(CustomService service) {
    _customServices.add(service);
    notifyListeners();
  }

  void removeCustomService(String serviceId) {
    _customServices.removeWhere((s) => s.id == serviceId);
    notifyListeners();
  }

  void updateCustomService(CustomService service) {
    final index = _customServices.indexWhere((s) => s.id == service.id);
    if (index != -1) {
      _customServices[index] = service;
      notifyListeners();
    }
  }

  // Gestion de l'équipe
  void addTeamMember(TeamMember member) {
    _teamMembers.add(member);
    notifyListeners();
  }

  void removeTeamMember(String memberId) {
    _teamMembers.removeWhere((m) => m.id == memberId);
    notifyListeners();
  }

  // Vérifier si un spécialiste existe par email
  Future<Map<String, dynamic>> verifySpecialistByEmail(String email) async {
    try {
      final result = await _salonService.verifySpecialistEmail(email);
      return result;
    } catch (e) {
      debugPrint('❌ Erreur vérification email: $e');
      return {'success': false, 'message': 'Erreur de vérification'};
    }
  }

  void nextStep(BuildContext context) {
    if (_currentStep < 5) {
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

  void setCategory(SalonCategory category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setAdditionalServices(List<AdditionalService> services) {
    selectedAdditionalServices = services;
    notifyListeners();
  }

  Future<void> _finishCreation(BuildContext context) async {
    if (_isCreatingSalon) return;

    _isCreatingSalon = true;
    notifyListeners();

    try {
      if (_location == null) {
        _showError(context, 'Veuillez sélectionner un emplacement');
        return;
      }

      if (_selectedTreatmentIds.isEmpty && _customServices.isEmpty) {
        _showError(context, 'Veuillez sélectionner au moins un traitement');
        return;
      }

      if (selectedCategory == null) {
        _showError(context, 'Veuillez sélectionner une catégorie');
        return;
      }

      if (_selectedGenderType == null) {
        _showError(context, 'Veuillez sélectionner le type de clientèle');
        return;
      }

      // Vérifier qu'au moins un jour est disponible
      if (!_weeklyAvailability.values.any((day) => day.isAvailable)) {
        _showError(context, 'Veuillez définir au moins un jour de disponibilité');
        return;
      }

      List<String> specialistIds = [];
      if (_currentUser != null) {
        specialistIds = [_currentUser!.userId!];
      }
      
      specialistIds.addAll(_teamMembers.map((m) => m.id));

      if (specialistIds.isEmpty) {
        _showError(context, 'Erreur: utilisateur non identifié');
        return;
      }

      final List<String> additionalServicesStrings = selectedAdditionalServices
          .map((service) => service.toJson())
          .toList();

      debugPrint('📤 Création du salon...');
      debugPrint('Nom: ${businessNameController.text}');
      debugPrint('Catégorie: ${selectedCategory!.name}');
      debugPrint('Gender Type: ${_selectedGenderType!.name}');
      debugPrint('Services additionnels: $additionalServicesStrings');
      debugPrint('Traitements: ${_selectedTreatmentIds.length}');
      debugPrint('Services personnalisés: ${_customServices.length}');
      debugPrint('Spécialistes: ${specialistIds.length}');
      debugPrint('Jours disponibles: ${_weeklyAvailability.values.where((d) => d.isAvailable).length}');

      final createResult = await _salonService.createSalon(
        context: context, 
        salonName: businessNameController.text.trim(),
        salonDescription: descriptionController.text.trim(),
        salonCategory: selectedCategory!.name,
        additionalServices: additionalServicesStrings,
        genderType: _selectedGenderType!.toJson(),
        latitude: _location!.latitude,
        longitude: _location!.longitude,
        treatmentIds: _selectedTreatmentIds,
        specialistIds: specialistIds,
        customServices: _customServices,
        availability: _weeklyAvailability,
      );

      if (!createResult['success']) {
        _showError(context, createResult['message'] ?? 'Erreur lors de la création');
        return;
      }

      final salonId = createResult['salon']?['salonId'];
      if (salonId == null) {
        _showError(context, 'Erreur: ID du salon non reçu');
        return;
      }

      debugPrint('✅ Salon créé: $salonId');

      if (_businessImagePath != null) {
        debugPrint('📷 Upload de la photo...');
        final photoResult = await _salonService.addSalonPhoto(
          salonId: salonId,
          imagePath: _businessImagePath!,
        );
        
        if (photoResult['success']) {
          debugPrint('✅ Photo uploadée');
        } else {
          debugPrint('⚠️ Photo non uploadée: ${photoResult['message']}');
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Salon créé avec succès !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      debugPrint('❌ Erreur création salon: $e');
      if (context.mounted) {
        _showError(context, 'Erreur: ${e.toString()}');
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

  // CORRECTION: Méthode pour afficher le dialog d'ajout d'équipe
  void showAddTeamMemberDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final specialtyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1B2B3E).withOpacity(0.1),
                    const Color(0xFFF0CD97).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_add_alt_1_outlined,
              color: Color(0xFF1B2B3E),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Add Team Member',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1B2B3E),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            _buildTeamMemberTextField(
              controller: nameController,
              label: 'Full Name',
              hint: 'Enter full name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTeamMemberTextField(
              controller: emailController,
              label: 'Email',
              hint: 'Enter email address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTeamMemberTextField(
              controller: specialtyController,
              label: 'Specialty',
              hint: 'e.g., Hair Stylist, Barber, Nail Technician',
              icon: Icons.work_outline,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B2B3E), Color(0xFF2A3F54)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final email = emailController.text.trim();
              final specialty = specialtyController.text.trim();

              if (name.isEmpty || email.isEmpty || specialty.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Please fill all fields',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              // Verify if the email belongs to a registered specialist
              final verificationResult = await verifySpecialistByEmail(email);
              
              if (verificationResult['success'] == true && 
                  verificationResult['user'] != null) {
                final userData = verificationResult['user'];
                
                final teamMember = TeamMember(
                  id: userData['userId'],
                  fullName: name,
                  email: email,
                  specialty: specialty,
                );

                addTeamMember(teamMember);
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Team member added successfully!',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      verificationResult['message'] ?? 'User not found. Please make sure the specialist is registered in the app.',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Add Member',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  // Helper method for text fields in the dialog
  Widget _buildTeamMemberTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1B2B3E),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFFF0CD97),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    businessNameController.dispose();
    descriptionController.dispose();
    additionalAddressController.dispose();
    super.dispose();
  }
}