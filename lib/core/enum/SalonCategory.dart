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
