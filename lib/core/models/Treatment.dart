// models/treatment.dart
class Treatment {
  final String treatmentId;
  final String treatmentName;
  final String treatmentDescription;
  final String treatmentCategory;
  final double? treatmentTime; // Durée en heures
  final double? treatmentPrice; // Prix
  final List<String>? treatmentPhotosPaths; // Photos du traitement

  Treatment({
    required this.treatmentId,
    required this.treatmentName,
    required this.treatmentDescription,
    required this.treatmentCategory,
    this.treatmentTime,
    this.treatmentPrice,
    this.treatmentPhotosPaths,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      treatmentId: json['treatmentId']?.toString() ?? '',
      treatmentName: json['treatmentName'] ?? '',
      treatmentDescription: json['treatmentDescription'] ?? '',
      treatmentCategory: json['treatmentCategory'] ?? '',
      treatmentTime: _parseDouble(json['treatmentTime']),
      treatmentPrice: _parseDouble(json['treatmentPrice']),
      treatmentPhotosPaths: json['treatmentPhotosPaths'] != null
          ? List<String>.from(json['treatmentPhotosPaths'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatmentId': treatmentId,
      'treatmentName': treatmentName,
      'treatmentDescription': treatmentDescription,
      'treatmentCategory': treatmentCategory,
      'treatmentTime': treatmentTime,
      'treatmentPrice': treatmentPrice,
      'treatmentPhotosPaths': treatmentPhotosPaths,
    };
  }

  // Helper pour parser les nombres (supporte int, double, String)
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  // Copie avec modification
  Treatment copyWith({
    String? treatmentId,
    String? treatmentName,
    String? treatmentDescription,
    String? treatmentCategory,
    double? treatmentTime,
    double? treatmentPrice,
    List<String>? treatmentPhotosPaths,
  }) {
    return Treatment(
      treatmentId: treatmentId ?? this.treatmentId,
      treatmentName: treatmentName ?? this.treatmentName,
      treatmentDescription: treatmentDescription ?? this.treatmentDescription,
      treatmentCategory: treatmentCategory ?? this.treatmentCategory,
      treatmentTime: treatmentTime ?? this.treatmentTime,
      treatmentPrice: treatmentPrice ?? this.treatmentPrice,
      treatmentPhotosPaths: treatmentPhotosPaths ?? this.treatmentPhotosPaths,
    );
  }

  @override
  String toString() {
    return 'Treatment(id: $treatmentId, name: $treatmentName, price: $treatmentPrice, time: $treatmentTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Treatment && other.treatmentId == treatmentId;
  }

  @override
  int get hashCode => treatmentId.hashCode;
}

// models/custom_service.dart
class CustomService {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? duration; // Durée en minutes
  final String? photoPath;
  final String? specificGender; // 'Man', 'Woman', 'Mixed'
  final String category; // Catégorie du traitement (HAIRCUT, COLORING, etc.)

  CustomService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.duration,
    this.photoPath,
    this.specificGender,
    required this.category,
  });

  // Convertir en Treatment pour l'API
  Treatment toTreatment() {
    return Treatment(
      treatmentId: id,
      treatmentName: name,
      treatmentDescription: description,
      treatmentCategory: category,
      treatmentTime: duration != null ? duration! / 60 : null, // Convertir minutes en heures
      treatmentPrice: price,
      treatmentPhotosPaths: photoPath != null ? [photoPath!] : null,
    );
  }

  factory CustomService.fromJson(Map<String, dynamic> json) {
    return CustomService(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      duration: (json['duration'] as num?)?.toDouble(),
      photoPath: json['photoPath'],
      specificGender: json['specificGender'],
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'photoPath': photoPath,
      'specificGender': specificGender,
      'category': category,
    };
  }

  CustomService copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? duration,
    String? photoPath,
    String? specificGender,
    String? category,
  }) {
    return CustomService(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      photoPath: photoPath ?? this.photoPath,
      specificGender: specificGender ?? this.specificGender,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'CustomService(id: $id, name: $name, category: $category, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomService && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// models/treatment_category.dart
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
      (e) => e.value == value.toUpperCase(),
      orElse: () => TreatmentCategory.HAIRCUT,
    );
  }

  static TreatmentCategory? fromStringOrNull(String? value) {
    if (value == null) return null;
    try {
      return TreatmentCategory.values.firstWhere(
        (e) => e.value == value.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }
}