
class LocationResult {
  final double latitude;
  final double longitude;
  final String? address;

  LocationResult({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  factory LocationResult.fromMap(Map<String, dynamic> map) {
    return LocationResult(
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      address: map['address'] ?? '',
    );
  }

  LocationResult copyWith({
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return LocationResult(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }

  @override
  String toString() {
    return 'LocationResult(latitude: $latitude, longitude: $longitude, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LocationResult &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.address == address;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ address.hashCode;
}