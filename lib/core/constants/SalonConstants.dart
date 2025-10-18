/// Constantes pour la configuration du salon
class SalonConstants {
  // URL de base de l'API - À MODIFIER selon votre environnement
  static const String baseUrl = 'http://localhost:8080'; // ou votre URL de production
  
  // Endpoints
  static const String createSalonEndpoint = '/api/salon/add-salon';
  static const String updateSalonEndpoint = '/api/salon/modify-salon';
  static const String getSalonEndpoint = '/api/salon/retrieve-salon';
  static const String deleteSalonEndpoint = '/api/salon/remove-salon';
  static const String addPhotoEndpoint = '/api/salon/{id}/photos';
  static const String updateLocationEndpoint = '/api/salon/{id}/update-location';
  static const String activateSalonEndpoint = '/api/salon/{id}/activate';
  static const String blockSalonEndpoint = '/api/salon/{id}/block';
  
  // Traitements
  static const String getTreatmentsEndpoint = '/api/treatment/retrieve-all-treatments';
  
  // Limites de validation
  static const int minSalonNameLength = 2;
  static const int maxSalonNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const double minLatitude = -90.0;
  static const double maxLatitude = 90.0;
  static const double minLongitude = -180.0;
  static const double maxLongitude = 180.0;
  
  // Messages d'erreur
  static const String networkError = 'Network error. Please check your connection.';
  static const String authError = 'Authentication required. Please login.';
  static const String serverError = 'Server error. Please try again later.';
  static const String validationError = 'Please fill all required fields.';
}

/// Catégories de salon
enum SalonCategory {
  BARBERSHOP('BARBERSHOP', 'Barbershop', '💈'),
  BEAUTY_SALON('BEAUTY_SALON', 'Beauty Salon', '💅'),
  SPA('SPA', 'Spa', '🧖'),
  NAIL_SALON('NAIL_SALON', 'Nail Salon', '💅');

  final String value;
  final String displayName;
  final String emoji;

  const SalonCategory(this.value, this.displayName, this.emoji);

  static SalonCategory fromString(String value) {
    return SalonCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SalonCategory.BARBERSHOP,
    );
  }
}

/// Types de genre pour les clients
enum SalonGenderType {
  MALE('MALE', 'Male', '👨'),
  FEMALE('FEMALE', 'Female', '👩'),
  UNISEX('UNISEX', 'Unisex', '👥');

  final String value;
  final String displayName;
  final String emoji;

  const SalonGenderType(this.value, this.displayName, this.emoji);

  static SalonGenderType fromString(String value) {
    return SalonGenderType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SalonGenderType.UNISEX,
    );
  }
}

/// Services additionnels
enum AdditionalService {
  WIFI('WIFI', 'WiFi', '📶'),
  PARKING('PARKING', 'Parking', '🅿️'),
  AIR_CONDITIONING('AIR_CONDITIONING', 'Air Conditioning', '❄️'),
  COFFEE('COFFEE', 'Coffee', '☕'),
  TV('TV', 'TV Entertainment', '📺'),
  MAGAZINES('MAGAZINES', 'Magazines', '📰'),
  WHEELCHAIR_ACCESS('WHEELCHAIR_ACCESS', 'Wheelchair Access', '♿'),
  CARD_PAYMENT('CARD_PAYMENT', 'Card Payment', '💳');

  final String value;
  final String displayName;
  final String emoji;

  const AdditionalService(this.value, this.displayName, this.emoji);

  static AdditionalService fromString(String value) {
    return AdditionalService.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AdditionalService.WIFI,
    );
  }
}

/// Statut du salon
enum SalonStatus {
  PENDING('PENDING', 'Pending Approval', '⏳'),
  ACTIVE('ACTIVE', 'Active', '✅'),
  BLOCKED('BLOCKED', 'Blocked', '🚫');

  final String value;
  final String displayName;
  final String emoji;

  const SalonStatus(this.value, this.displayName, this.emoji);

  static SalonStatus fromString(String value) {
    return SalonStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SalonStatus.PENDING,
    );
  }
}

/// Catégories de traitement
enum TreatmentCategory {
  HAIRCUT('HAIRCUT', 'Haircut', '✂️'),
  COLORING('COLORING', 'Coloring', '🎨'),
  BEARD('BEARD', 'Beard', '🧔'),
  FACIAL('FACIAL', 'Facial', '🧖'),
  MASSAGE('MASSAGE', 'Massage', '💆'),
  NAILS('NAILS', 'Nails', '💅'),
  WAXING('WAXING', 'Waxing', '🕯️'),
  MAKEUP('MAKEUP', 'Makeup', '💄');

  final String value;
  final String displayName;
  final String emoji;

  const TreatmentCategory(this.value, this.displayName, this.emoji);

  static TreatmentCategory fromString(String value) {
    return TreatmentCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TreatmentCategory.HAIRCUT,
    );
  }
}

/// Extension pour obtenir les listes
extension SalonEnumExtensions on Object {
  static List<String> get salonCategoryValues =>
      SalonCategory.values.map((e) => e.value).toList();

  static List<String> get genderTypeValues =>
      SalonGenderType.values.map((e) => e.value).toList();

  static List<String> get additionalServiceValues =>
      AdditionalService.values.map((e) => e.value).toList();

  static List<String> get treatmentCategoryValues =>
      TreatmentCategory.values.map((e) => e.value).toList();
}