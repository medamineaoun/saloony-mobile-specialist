// salon_creation_viewmodel.dart - VERSION CORRIGÉE
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
import 'package:saloony/core/services/TreatmentService.dart';
import 'package:saloony/features/Salon/location_result.dart';
import 'package:saloony/core/services/ToastService.dart'; // ✅ AJOUT IMPORT

enum AccountType { solo, team }

class TimeRange {
  TimeOfDay startTime;
  TimeOfDay endTime;
  
  TimeRange({required this.startTime, required this.endTime});
}

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

class CustomService {
  String id;
  final double? duration; // en minutes
  String name;
  String description;
  double price;
  String? photoPath;
  String? specificGender;
  String category;
  
  CustomService({
    required this.id,
    required this.name,
    required this.duration,
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
  final TreatmentService _treatmentService = TreatmentService();
  String? _currentUserId;
  String? get currentUserId => _currentUserId;
  final ImagePicker _picker = ImagePicker();
  
  // Controllers
  final TextEditingController salonNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController additionalAddressController = TextEditingController();

  // User data
  User? _currentUser;
  bool _isLoadingUser = true;
  bool _isCreatingSalon = false;
  int _currentStep = 0;

  // Salon information
  SalonCategory? selectedCategory = SalonCategory.hairSalon;

  String? _salonImagePath;
  LocationResult? _location;
  SalonGenderType? _selectedGenderType;
  List<AdditionalService> selectedAdditionalServices = [];
  
  // Treatments and services
  List<Treatment> _availableTreatments = [];
  List<String> _selectedTreatmentIds = [];
  List<CustomService> _customServices = [];
  
  // Team
  List<TeamMember> _teamMembers = [];
  AccountType? _accountType;

  // Availability
  final Map<String, DayAvailabilityWithSlots> _weeklyAvailability = {};

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoadingUser => _isLoadingUser;
  bool get isCreatingSalon => _isCreatingSalon;
  int get currentStep => _currentStep;
  AccountType? get accountType => _accountType;
  String? get salonImagePath => _salonImagePath;
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
        return salonNameController.text.trim().isNotEmpty &&
               selectedCategory != null;
      case 1: 
        return descriptionController.text.trim().isNotEmpty &&
               _location != null &&
               _salonImagePath != null &&
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
    _initializeAvailability();
  }

  void _setupControllerListeners() {
    salonNameController.addListener(notifyListeners);
    descriptionController.addListener(notifyListeners);
    additionalAddressController.addListener(notifyListeners);
  }

  // ✅ FIXED: Add UUID validation helper
  bool _isValidUUID(String? str) {
    if (str == null) return false;
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegex.hasMatch(str);
  }

  void setGenderTypeFromString(String typeString) {
    try {
      _selectedGenderType = SalonGenderType.fromString(typeString);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erreur conversion gender type: $e');
      _showToastError(null, 'Erreur de conversion du type de clientèle');
    }
  }

  void updateCustomService(CustomService service) {
    final index = _customServices.indexWhere((s) => s.id == service.id);
    if (index != -1) {
      _customServices[index] = service;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> verifySpecialistByEmail(String email) async {
    try {
      final result = await _salonService.verifySpecialistEmail(email);
      return result;
    } catch (e) {
      debugPrint('❌ Erreur vérification email: $e');
      return {'success': false, 'message': 'Erreur de vérification'};
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

  void setAdditionalServices(List<AdditionalService> services) {
    selectedAdditionalServices = services;
    notifyListeners();
  }

  void setAccountType(AccountType type) {
    _accountType = type;
    notifyListeners();
  }

  // Step navigation
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

  // salon methods
  void setCategory(SalonCategory category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setGenderType(SalonGenderType type) {
    _selectedGenderType = type;
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
        _salonImagePath = image.path;
        notifyListeners();
        _showToastSuccess(null, 'Image sélectionnée avec succès');
      }
    } catch (e) {
      debugPrint('❌ Erreur sélection image: $e');
      _showToastError(null, 'Erreur lors de la sélection de l\'image');
    }
  }

  // Team management
  void addTeamMember(TeamMember member) {
    _teamMembers.add(member);
    notifyListeners();
    _showToastSuccess(null, 'Membre ajouté avec succès');
  }

  void removeTeamMember(String memberId) {
    _teamMembers.removeWhere((m) => m.id == memberId);
    notifyListeners();
    _showToastInfo(null, 'Membre retiré de l\'équipe');
  }

  // Services management
  void toggleTreatmentSelection(String treatmentId) {
    if (_selectedTreatmentIds.contains(treatmentId)) {
      _selectedTreatmentIds.remove(treatmentId);
    } else {
      _selectedTreatmentIds.add(treatmentId);
    }
    notifyListeners();
  }

  void addCustomService(CustomService service) {
    _customServices.add(service);
    notifyListeners();
    _showToastSuccess(null, 'Service personnalisé ajouté');
  }

  void removeCustomService(String serviceId) {
    _customServices.removeWhere((s) => s.id == serviceId);
    notifyListeners();
    _showToastInfo(null, 'Service personnalisé supprimé');
  }

  // ✅ FIXED: Validate time range when setting
  void setDayTimeRange(String day, TimeOfDay startTime, TimeOfDay endTime) {
    if (_weeklyAvailability.containsKey(day)) {
      // Validate the time range
      if (!_isValidTimeRange(startTime, endTime)) {
        debugPrint('⚠️ Invalid time range for $day: ${startTime.format} - ${endTime.format}');
        _showToastWarning(null, 'Plage horaire invalide pour $day');
        return; // Don't set invalid time ranges
      }
      
      _weeklyAvailability[day]!.timeRange = TimeRange(
        startTime: startTime,
        endTime: endTime,
      );
      _weeklyAvailability[day]!.isAvailable = true;
      notifyListeners();
      _showToastSuccess(null, 'Horaire mis à jour pour $day');
    }
  }

  void toggleDayAvailability(int index) {
    if (index >= 0 && index < _weeklyAvailability.values.length) {
      final dayKey = _weeklyAvailability.keys.elementAt(index);
      final day = _weeklyAvailability[dayKey];
      if (day != null) {
        day.isAvailable = !day.isAvailable;
        
        if (day.isAvailable && day.timeRange == null) {
          day.timeRange = TimeRange(
            startTime: const TimeOfDay(hour: 9, minute: 0),
            endTime: const TimeOfDay(hour: 18, minute: 0),
          );
        }
        
        // Validate time range if available
        if (day.isAvailable && day.timeRange != null) {
          if (!_isValidTimeRange(day.timeRange!.startTime, day.timeRange!.endTime)) {
            debugPrint('⚠️ Invalid time range for $dayKey, resetting to defaults');
            day.timeRange = TimeRange(
              startTime: const TimeOfDay(hour: 9, minute: 0),
              endTime: const TimeOfDay(hour: 18, minute: 0),
            );
          }
        }
        
        notifyListeners();
        final status = day.isAvailable ? 'activé' : 'désactivé';
        _showToastInfo(null, '$dayKey $status');
      }
    }
  }

  // Data loading
  Future<void> _loadCurrentUser() async {
    _isLoadingUser = true;
    notifyListeners();

    try {
      final result = await _authService.getCurrentUser();
      if (result['success'] == true && result['user'] != null) {
        _currentUser = User.fromJson(result['user']);
      }
    } catch (e) {
      debugPrint('❌ Erreur chargement utilisateur: $e');
      _showToastError(null, 'Erreur lors du chargement du profil');
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
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Erreur chargement traitements: $e');
      _showToastError(null, 'Erreur lors du chargement des traitements');
    }
  }

  Future<void> _finishCreation(BuildContext context) async {
    if (_isCreatingSalon) return;

    _isCreatingSalon = true;
    notifyListeners();

    final BuildContext? savedContext = context;

    try {
      // Validation de base
      if (_location == null) {
        _showError(savedContext, 'Veuillez sélectionner un emplacement');
        return;
      }

      // ✅ FIXED: Vérifier qu'au moins un traitement OU service personnalisé est sélectionné
      if (_selectedTreatmentIds.isEmpty && _customServices.isEmpty) {
        _showError(savedContext, 'Veuillez sélectionner au moins un traitement ou service personnalisé');
        return;
      }

      if (selectedCategory == null) {
        _showError(savedContext, 'Veuillez sélectionner une catégorie');
        return;
      }

      if (_selectedGenderType == null) {
        _showError(savedContext, 'Veuillez sélectionner le type de clientèle');
        return;
      }

      if (selectedAdditionalServices.isEmpty) {
        _showError(savedContext, 'Veuillez sélectionner au moins un service additionnel');
        return;
      }

      final availableDays = _weeklyAvailability.values
          .where((day) => day.isAvailable && 
                         day.timeRange != null && 
                         _isValidTimeRange(day.timeRange!.startTime, day.timeRange!.endTime))
          .length;

      if (availableDays == 0) {
        _showError(savedContext, 'Veuillez définir au moins un jour de disponibilité avec des horaires valides');
        return;
      }

      if (_weeklyAvailability.length != 7) {
        _showError(savedContext, 'Veuillez définir la disponibilité pour tous les jours de la semaine');
        return;
      }

      List<String> specialistIds = [];
      if (_currentUser != null) {
        specialistIds = [_currentUser!.userId!];
      }
      
      for (final member in _teamMembers) {
        if (!_isValidUUID(member.id)) {
          _showError(savedContext, 'ID invalide pour ${member.fullName}. Veuillez contacter le support.');
          return;
        }
        specialistIds.add(member.id);
      }

      if (specialistIds.isEmpty) {
        _showError(savedContext, 'Erreur: utilisateur non identifié');
        return;
      }

      final List<String> additionalServicesStrings = additionalServicesForApi;

      debugPrint('📤 Création du salon...');
      debugPrint('Nom: ${salonNameController.text}');
      debugPrint('Catégorie (API): $salonCategoryForApi');
      debugPrint('Gender Type (API): $genderTypeForApi');
      debugPrint('Services additionnels: $additionalServicesStrings');
      debugPrint('Traitements: ${_selectedTreatmentIds.length}');
      debugPrint('Services personnalisés: ${_customServices.length}');
      debugPrint('Spécialistes: ${specialistIds.length}');
      debugPrint('Spécialistes IDs: $specialistIds');
      debugPrint('Jours disponibles: $availableDays/7');

      List<String> finalTreatmentIds = List.from(_selectedTreatmentIds);
      
      if (_customServices.isNotEmpty) {
        debugPrint('📝 Création des ${_customServices.length} services personnalisés...');
        
        for (final customService in _customServices) {
          try {
            final backendCategory = _mapTreatmentCategoryToBackend(customService.category);
            
            debugPrint('  🎯 Catégorie mapping: ${customService.category} -> $backendCategory');
            
            final treatmentResult = await _treatmentService.addTreatment(
              name: customService.name,
              description: customService.description,
              price: customService.price,
              duration: customService.duration != null ? customService.duration! / 60 : 1.0,
              category: backendCategory, 
              photoPath: customService.photoPath,
            );
            
            if (treatmentResult['success'] && treatmentResult['treatment'] != null) {
              final treatmentId = treatmentResult['treatment']['treatmentId'] ?? treatmentResult['treatment']['id'];
              if (treatmentId != null) {
                finalTreatmentIds.add(treatmentId);
                debugPrint('  ✅ Service "${customService.name}" créé avec ID: $treatmentId');
              } else {
                debugPrint('  ⚠️ ID manquant pour service "${customService.name}"');
              }
            } else {
              debugPrint('  ⚠️ Échec création service "${customService.name}": ${treatmentResult['message']}');
            }
          } catch (e) {
            debugPrint('  ❌ Erreur création service "${customService.name}": $e');
          }
        }
      }

      if (finalTreatmentIds.isEmpty) {
        _showError(savedContext, 'Impossible de créer les services. Veuillez réessayer.');
        return;
      }

      debugPrint('📋 Total traitements finaux: ${finalTreatmentIds.length}');

      final availabilityForApi = _prepareAvailabilityForApi();

      final createResult = await _salonService.createSalon(
        salonName: salonNameController.text.trim(),
        salonDescription: descriptionController.text.trim(),
        salonCategory: salonCategoryForApi,
        additionalServices: additionalServicesStrings,
        genderType: genderTypeForApi,
        latitude: _location!.latitude,
        longitude: _location!.longitude,
        treatmentIds: finalTreatmentIds, 
        specialistIds: specialistIds,
        availability: availabilityForApi,
      );

      if (!createResult['success']) {
        final errorMessage = createResult['message'] ?? 'Erreur lors de la création';
        debugPrint('❌ Erreur création: $errorMessage');
        _showError(savedContext, errorMessage);
        return;
      }

      final salonId = createResult['salon']?['salonId'];
      if (salonId == null) {
        debugPrint('❌ ID salon manquant dans la réponse');
        _showError(savedContext, 'Erreur: ID du salon non reçu');
        return;
      }

      debugPrint('✅ Salon créé: $salonId');

      if (_salonImagePath != null) {
        debugPrint('📷 Upload de la photo...');
        final photoResult = await _salonService.addSalonPhoto(
          salonId: salonId,
          imagePath: _salonImagePath!,
        );
        
        if (photoResult['success']) {
          debugPrint('✅ Photo uploadée');
          _showToastSuccess(savedContext, 'Photo du salon uploadée avec succès');
        } else {
          debugPrint('⚠️ Photo non uploadée: ${photoResult['message']}');
          _showToastWarning(savedContext, 'Photo non uploadée: ${photoResult['message']}');
        }
      }

      if (savedContext != null && savedContext.mounted) {
        _showToastSuccess(savedContext, '✅ Salon créé avec succès !');
        
        // Navigation après un délai pour voir le toast
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(savedContext).popUntil((route) => route.isFirst);
        });
      }
    } catch (e) {
      debugPrint('❌ Erreur création salon: $e');
      _showError(savedContext, 'Erreur: ${e.toString()}');
    } finally {
      _isCreatingSalon = false;
      notifyListeners();
    }
  }

  void _showError(BuildContext? context, String message) {
    _showToastError(context, message);
  }

  // ✅ NOUVELLES MÉTHODES POUR LES TOASTS
  void _showToastSuccess(BuildContext? context, String message) {
    if (context != null && context.mounted) {
      ToastService.showSuccess(context, message);
    }
  }

  void _showToastError(BuildContext? context, String message) {
    if (context != null && context.mounted) {
      ToastService.showError(context, message);
    }
  }

  void _showToastInfo(BuildContext? context, String message) {
    if (context != null && context.mounted) {
      ToastService.showInfo(context, message);
    }
  }

  void _showToastWarning(BuildContext? context, String message) {
    if (context != null && context.mounted) {
      ToastService.showWarning(context, message);
    }
  }

  // ✅ FIXED: Only include valid availabilities
  Map<String, dynamic> _prepareAvailabilityForApi() {
    final Map<String, dynamic> availabilityMap = {};
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    debugPrint('🗓️ Préparation des disponibilités:');
    
    for (final day in days) {
      final dayData = _weeklyAvailability[day];
      if (dayData != null) {
        final dayEntry = <String, dynamic>{
          'dayOfWeek': _mapDayToBackend(day),
          'available': dayData.isAvailable,
        };
        
        if (dayData.isAvailable && dayData.timeRange != null) {
          final startTime = dayData.timeRange!.startTime;
          final endTime = dayData.timeRange!.endTime;
          
          // Validation: s'assurer que l'heure de fin est après l'heure de début
          if (_isValidTimeRange(startTime, endTime)) {
            dayEntry['fromHour'] = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
            dayEntry['toHour'] = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
            
            debugPrint('  ✅ $day: ${dayEntry['fromHour']} - ${dayEntry['toHour']}');
          } else {
            debugPrint('  ⚠️ $day: Plage horaire invalide - marqué comme non disponible');
            dayEntry['available'] = false;
            dayEntry['fromHour'] = null;
            dayEntry['toHour'] = null;
          }
        } else {
          dayEntry['fromHour'] = null;
          dayEntry['toHour'] = null;
          debugPrint('  ❌ $day: Non disponible');
        }
        
        availabilityMap[day] = dayEntry;
      } else {
        debugPrint('  ⚠️ $day: Données manquantes');
      }
    }
    
    return availabilityMap;
  }

  bool _isValidTimeRange(TimeOfDay start, TimeOfDay end) {
    final startInMinutes = start.hour * 60 + start.minute;
    final endInMinutes = end.hour * 60 + end.minute;
    return endInMinutes > startInMinutes;
  }

  String _mapDayToBackend(String day) {
    switch (day) {
      case 'Monday': return 'MONDAY';
      case 'Tuesday': return 'TUESDAY';
      case 'Wednesday': return 'WEDNESDAY';
      case 'Thursday': return 'THURSDAY';
      case 'Friday': return 'FRIDAY';
      case 'Saturday': return 'SATURDAY';
      case 'Sunday': return 'SUNDAY';
      default: return day.toUpperCase();
    }
  }

  List<String> get additionalServicesForApi {
    return selectedAdditionalServices.map((service) {
      switch (service) {
        case AdditionalService.wifi:
          return 'WIFI';
        case AdditionalService.tv:
          return 'TV';
        case AdditionalService.backgroundMusic:
          return 'BACKGROUND_MUSIC';
        case AdditionalService.airConditioning:
          return 'AIR_CONDITIONING';
        case AdditionalService.heating:
          return 'HEATING';
        case AdditionalService.coffeeTea:
          return 'COFFEE_TEA';
        case AdditionalService.drinksSnacks:
          return 'DRINKS_SNACKS';
        case AdditionalService.freeParking:
          return 'FREE_PARKING';
        case AdditionalService.paidParking:
          return 'PAID_PARKING';
        case AdditionalService.publicTransportAccess:
          return 'PUBLIC_TRANSPORT_ACCESS';
        case AdditionalService.wheelchairAccessible:
          return 'WHEELCHAIR_ACCESSIBLE';
        case AdditionalService.childFriendly:
          return 'CHILD_FRIENDLY';
        case AdditionalService.shower:
          return 'SHOWER';
        case AdditionalService.lockers:
          return 'LOCKERS';
        case AdditionalService.creditCardAccepted:
          return 'CREDIT_CARD_ACCEPTED';
        case AdditionalService.mobilePayment:
          return 'MOBILE_PAYMENT';
        case AdditionalService.securityCameras:
          return 'SECURITY_CAMERAS';
        case AdditionalService.petFriendly:
          return 'PET_FRIENDLY';
        case AdditionalService.noPets:
          return 'NO_PETS';
        case AdditionalService.smokingAllowed:
          return 'SMOKING_ALLOWED';
        case AdditionalService.nonSmoking:
          return 'NON_SMOKING';
        default:
          return service.toString().split('.').last.toUpperCase();
      }
    }).toList();
  }

  void _initializeAvailability() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    for (final day in days) {
      _weeklyAvailability[day] = DayAvailabilityWithSlots(
        day: day,
        isAvailable: false,
        timeRange: TimeRange(
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 18, minute: 0),
        ),
      );
    }
    
    debugPrint('✅ Disponibilités initialisées: ${_weeklyAvailability.length} jours');
    notifyListeners();
  }

  // ✅ SIMPLE FIX: Map frontend categories to backend categories
  String _mapTreatmentCategoryToBackend(String frontendCategory) {
    // Si la catégorie est déjà une valeur backend valide, la retourner telle quelle
    const backendCategories = [
      'BARBER', 'HAIRDRESSING', 'NAILS', 
      'FACE_AND_BODY_TREATMENTS', 'MAKEUP_AND_EYELASHES', 'SPA_AND_MASSAGES'
    ];
    
    if (backendCategories.contains(frontendCategory)) {
      return frontendCategory;
    }
    
    // Mapping simple des catégories frontend vers backend
    switch (frontendCategory.toUpperCase()) {
      case 'HAIRCUT':
      case 'HAIR_STYLING':
      case 'HAIR_COLOR':
      case 'HAIR_TREATMENT':
        return 'HAIRDRESSING';
      case 'MANICURE':
      case 'PEDICURE':
      case 'NAIL_ART':
        return 'NAILS';
      case 'MASSAGE':
      case 'FACIAL':
      case 'BODY_TREATMENT':
      case 'SPA_TREATMENTS':
        return 'SPA_AND_MASSAGES';
      case 'BEARD_TRIM':
      case 'SHAVING':
      case 'BARBER_SERVICES':
        return 'BARBER';
      case 'MAKEUP':
      case 'EYELASH_EXTENSIONS':
      case 'EYEBROWS':
        return 'MAKEUP_AND_EYELASHES';
      case 'SKIN_CARE':
      case 'WAXING':
      case 'BODY_CARE':
        return 'FACE_AND_BODY_TREATMENTS';
      default:
        return 'HAIRDRESSING'; // Default fallback
    }
  }

  String get salonCategoryForApi {
    if (selectedCategory == null) return '';
    
    switch (selectedCategory!) {
      case SalonCategory.hairSalon:
        return 'HAIR_SALON';
      case SalonCategory.spaMassagesCenter:
        return 'SPA_MASSAGES_CENTER';
      case SalonCategory.barbershop:
        return 'BARBERSHOP';
      case SalonCategory.nailSalon:
        return 'NAIL_SALON';
      case SalonCategory.beautyInstitute:
        return 'BEAUTY_INSTITUTE';
    }
  }

  String get genderTypeForApi {
    if (_selectedGenderType == null) return '';
    
    switch (_selectedGenderType!) {
      case SalonGenderType.man:
        return 'MEN';
      case SalonGenderType.woman:
        return 'WOMEN';
      case SalonGenderType.mixed:
        return 'MIXED';
    }
  }

  // ✅ FIXED: Validate UUID when adding team members
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
                  _showToastWarning(context, 'Veuillez remplir tous les champs');
                  return;
                }

                // Verify if the email belongs to a registered specialist
                final verificationResult = await verifySpecialistByEmail(email);
                
                if (verificationResult['success'] == true && 
                    verificationResult['user'] != null) {
                  final userData = verificationResult['user'];
                  final userId = userData['userId'];
                  
                  // ✅ FIXED: Validate UUID format
                  if (!_isValidUUID(userId)) {
                    _showToastError(context, 'Format d\'ID utilisateur invalide. Ce compte spécialiste peut être corrompu. Veuillez contacter le support.');
                    return;
                  }
                  
                  final teamMember = TeamMember(
                    id: userId,
                    fullName: name,
                    email: email,
                  );

                  addTeamMember(teamMember);
                  Navigator.pop(context);
                  
                } else {
                  _showToastError(context, verificationResult['message'] ?? 'Utilisateur non trouvé. Assurez-vous que le spécialiste est enregistré dans l\'application.');
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
    salonNameController.dispose();
    descriptionController.dispose();
    additionalAddressController.dispose();
    super.dispose();
  }
}