class Treatment {
  final String treatmentId;
  final String treatmentName;
  final String treatmentDescription;
  final String treatmentCategory;
  final double? treatmentTime; 
  final double? duration;
  final double? treatmentPrice;
  final List<String>? treatmentPhotosPaths;

  Treatment({
    required this.treatmentId,
    required this.treatmentName,
    required this.treatmentDescription,
    required this.treatmentCategory,
    this.treatmentTime,
    this.duration,
    this.treatmentPrice,
    this.treatmentPhotosPaths,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    final treatmentTime = _parseDouble(json['treatmentTime']);

    // Accept plusieurs formes d'ID retournées par l'API
    String id = '';
    if (json['treatmentId'] != null) {
      id = json['treatmentId'].toString();
    } else if (json['treatment_id'] != null) {
      id = json['treatment_id'].toString();
    } else if (json['_id'] != null) {
      id = json['_id'].toString();
    } else if (json['id'] != null) {
      id = json['id'].toString();
    }

    final name = json['treatmentName'] ?? json['name'] ?? '';
    final description = json['treatmentDescription'] ?? json['description'] ?? '';
    final category = json['treatmentCategory'] ?? json['category'] ?? '';

    return Treatment(
      treatmentId: id,
      treatmentName: name,
      treatmentDescription: description,
      treatmentCategory: category,
      treatmentTime: treatmentTime,
      duration: treatmentTime != null ? treatmentTime * 60 : null, // convertit en minutes
      treatmentPrice: _parseDouble(json['treatmentPrice'] ?? json['price']),
      treatmentPhotosPaths: json['treatmentPhotosPaths'] != null
          ? List<String>.from(json['treatmentPhotosPaths'])
          : (json['photos'] != null ? List<String>.from(json['photos']) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatmentId': treatmentId,
      'treatmentName': treatmentName,
      'treatmentDescription': treatmentDescription,
      'treatmentCategory': treatmentCategory,
      'treatmentTime': treatmentTime,
      'duration': duration,
      'treatmentPrice': treatmentPrice,
      'treatmentPhotosPaths': treatmentPhotosPaths,
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Treatment copyWith({
    String? treatmentId,
    String? treatmentName,
    String? treatmentDescription,
    String? treatmentCategory,
    double? treatmentTime,
    double? duration,
    double? treatmentPrice,
    List<String>? treatmentPhotosPaths,
  }) {
    return Treatment(
      treatmentId: treatmentId ?? this.treatmentId,
      treatmentName: treatmentName ?? this.treatmentName,
      treatmentDescription: treatmentDescription ?? this.treatmentDescription,
      treatmentCategory: treatmentCategory ?? this.treatmentCategory,
      treatmentTime: treatmentTime ?? this.treatmentTime,
      duration: duration ?? this.duration,
      treatmentPrice: treatmentPrice ?? this.treatmentPrice,
      treatmentPhotosPaths: treatmentPhotosPaths ?? this.treatmentPhotosPaths,
    );
  }

  @override
  String toString() {
    return 'Treatment(id: $treatmentId, name: $treatmentName, time: $treatmentTime h, duration: $duration min, price: $treatmentPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Treatment && other.treatmentId == treatmentId;
  }

  @override
  int get hashCode => treatmentId.hashCode;
}
