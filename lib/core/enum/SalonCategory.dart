enum SalonCategory {
  barbershop('BARBERSHOP', 'Barbershop', '💈'),
  hairSalon('HAIR_SALON', 'Hair Salon', '✂️'),
  beautyInstitute('BEAUTY_INSTITUTE', 'Beauty Institute', '💅'),
  nailSalon('NAIL_SALON', 'Nail Salon', '💅'),
  spaMassagesCenter('SPA_MASSAGES_CENTER', 'Spa & Massages Center', '🧖');

  final String value;
  final String displayName;
  final String emoji;

  const SalonCategory(this.value, this.displayName, this.emoji);

  static SalonCategory fromString(String value) {
    return SalonCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SalonCategory.barbershop,
    );
  }
}
