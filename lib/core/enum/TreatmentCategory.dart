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
