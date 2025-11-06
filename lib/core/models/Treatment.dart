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