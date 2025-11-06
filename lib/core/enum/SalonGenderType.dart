enum SalonGenderType {
  man,
  woman,
  mixed;

  static SalonGenderType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'man':
        return SalonGenderType.man;
      case 'woman':
        return SalonGenderType.woman;
      case 'mixed':
        return SalonGenderType.mixed;
      default:
        throw ArgumentError('Invalid SalonGenderType: $value');
    }
  }

  /// Pour sérialiser en JSON
  String toJson() => name;
}
