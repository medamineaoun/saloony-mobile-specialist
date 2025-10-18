
import 'package:saloony/core/constants/SalonConstants.dart';

/// Modèle Salon
class Salon {
  final String? salonId;
  final String salonName;
  final String? salonDescription;
  final DateTime? salonRegistrationDate;
  final SalonStatus salonStatus;
  final SalonCategory salonCategory;
  final List<AdditionalService> additionalServices;
  final SalonGenderType type;
  final List<String>? salonPhotosPaths;
  final double? salonLongitude;
  final double? salonLatitude;
  final List<String>? salonTreatmentsIds;
  final List<String>? salonSpecialistsIds;
  final String? ownerId;

  Salon({
    this.salonId,
    required this.salonName,
    this.salonDescription,
    this.salonRegistrationDate,
    this.salonStatus = SalonStatus.PENDING,
    required this.salonCategory,
    required this.additionalServices,
    required this.type,
    this.salonPhotosPaths,
    this.salonLongitude,
    this.salonLatitude,
    this.salonTreatmentsIds,
    this.salonSpecialistsIds,
    this.ownerId,
  });

  /// Créer depuis JSON
  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      salonId: json['salonId'],
      salonName: json['salonName'] ?? '',
      salonDescription: json['salonDescription'],
      salonRegistrationDate: json['salonRegistrationDate'] != null
          ? DateTime.parse(json['salonRegistrationDate'])
          : null,
      salonStatus: SalonStatus.fromString(json['salonStatus'] ?? 'PENDING'),
      salonCategory: SalonCategory.fromString(json['salonCategory'] ?? 'BARBERSHOP'),
      additionalServices: (json['additionalService'] as List<dynamic>?)
              ?.map((e) => AdditionalService.fromString(e.toString()))
              .toList() ??
          [],
      type: SalonGenderType.fromString(json['type'] ?? 'UNISEX'),
      salonPhotosPaths: (json['salonPhotosPaths'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      salonLongitude: json['salonLongitude']?.toDouble(),
      salonLatitude: json['salonLatitude']?.toDouble(),
      salonTreatmentsIds: (json['salonTreatmentsIds'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      salonSpecialistsIds: (json['salonSpecialistsIds'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      ownerId: json['ownerId'],
    );
  }

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      if (salonId != null) 'salonId': salonId,
      'salonName': salonName,
      if (salonDescription != null) 'salonDescription': salonDescription,
      if (salonRegistrationDate != null)
        'salonRegistrationDate': salonRegistrationDate!.toIso8601String(),
      'salonStatus': salonStatus.value,
      'salonCategory': salonCategory.value,
      'additionalService': additionalServices.map((e) => e.value).toList(),
      'type': type.value,
      if (salonPhotosPaths != null) 'salonPhotosPaths': salonPhotosPaths,
      if (salonLongitude != null) 'salonLongitude': salonLongitude,
      if (salonLatitude != null) 'salonLatitude': salonLatitude,
      if (salonTreatmentsIds != null) 'salonTreatmentsIds': salonTreatmentsIds,
      if (salonSpecialistsIds != null) 'salonSpecialistsIds': salonSpecialistsIds,
      if (ownerId != null) 'ownerId': ownerId,
    };
  }

  /// Copie avec modifications
  Salon copyWith({
    String? salonId,
    String? salonName,
    String? salonDescription,
    DateTime? salonRegistrationDate,
    SalonStatus? salonStatus,
    SalonCategory? salonCategory,
    List<AdditionalService>? additionalServices,
    SalonGenderType? type,
    List<String>? salonPhotosPaths,
    double? salonLongitude,
    double? salonLatitude,
    List<String>? salonTreatmentsIds,
    List<String>? salonSpecialistsIds,
    String? ownerId,
  }) {
    return Salon(
      salonId: salonId ?? this.salonId,
      salonName: salonName ?? this.salonName,
      salonDescription: salonDescription ?? this.salonDescription,
      salonRegistrationDate: salonRegistrationDate ?? this.salonRegistrationDate,
      salonStatus: salonStatus ?? this.salonStatus,
      salonCategory: salonCategory ?? this.salonCategory,
      additionalServices: additionalServices ?? this.additionalServices,
      type: type ?? this.type,
      salonPhotosPaths: salonPhotosPaths ?? this.salonPhotosPaths,
      salonLongitude: salonLongitude ?? this.salonLongitude,
      salonLatitude: salonLatitude ?? this.salonLatitude,
      salonTreatmentsIds: salonTreatmentsIds ?? this.salonTreatmentsIds,
      salonSpecialistsIds: salonSpecialistsIds ?? this.salonSpecialistsIds,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  /// Validation
  bool get isValid {
    return salonName.isNotEmpty &&
        salonName.length >= SalonConstants.minSalonNameLength &&
        salonName.length <= SalonConstants.maxSalonNameLength &&
        additionalServices.isNotEmpty &&
        (salonTreatmentsIds != null && salonTreatmentsIds!.isNotEmpty) &&
        (salonSpecialistsIds != null && salonSpecialistsIds!.isNotEmpty);
  }

  /// Vérifier si le salon a une localisation
  bool get hasLocation {
    return salonLatitude != null && salonLongitude != null;
  }

  /// Vérifier si le salon a des photos
  bool get hasPhotos {
    return salonPhotosPaths != null && salonPhotosPaths!.isNotEmpty;
  }

  /// Obtenir le nombre de services
  int get servicesCount {
    return salonTreatmentsIds?.length ?? 0;
  }

  /// Obtenir le nombre de spécialistes
  int get specialistsCount {
    return salonSpecialistsIds?.length ?? 0;
  }

  @override
  String toString() {
    return 'Salon(id: $salonId, name: $salonName, status: ${salonStatus.displayName})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Salon && other.salonId == salonId;
  }

  @override
  int get hashCode => salonId.hashCode;
}

/// Modèle de réponse de création de salon
class SalonCreationResponse {
  final bool success;
  final String? message;
  final Salon? salon;

  SalonCreationResponse({
    required this.success,
    this.message,
    this.salon,
  });

  factory SalonCreationResponse.fromJson(Map<String, dynamic> json) {
    return SalonCreationResponse(
      success: json['success'] ?? false,
      message: json['message'],
      salon: json['salon'] != null ? Salon.fromJson(json['salon']) : null,
    );
  }
}

/// Modèle de validation de salon
class SalonValidation {
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Salon name is required';
    }
    if (name.length < SalonConstants.minSalonNameLength) {
      return 'Name must be at least ${SalonConstants.minSalonNameLength} characters';
    }
    if (name.length > SalonConstants.maxSalonNameLength) {
      return 'Name must not exceed ${SalonConstants.maxSalonNameLength} characters';
    }
    return null;
  }

  static String? validateDescription(String? description) {
    if (description != null && description.length > SalonConstants.maxDescriptionLength) {
      return 'Description must not exceed ${SalonConstants.maxDescriptionLength} characters';
    }
    return null;
  }

  static String? validateLatitude(double? latitude) {
    if (latitude == null) return null;
    if (latitude < SalonConstants.minLatitude || latitude > SalonConstants.maxLatitude) {
      return 'Invalid latitude';
    }
    return null;
  }

  static String? validateLongitude(double? longitude) {
    if (longitude == null) return null;
    if (longitude < SalonConstants.minLongitude || longitude > SalonConstants.maxLongitude) {
      return 'Invalid longitude';
    }
    return null;
  }
}