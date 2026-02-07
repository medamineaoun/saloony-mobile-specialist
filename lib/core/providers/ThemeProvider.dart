import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/SaloonyColors.dart';
import '../constants/SaloonyTextStyles.dart';

/// Theme Provider pour gérer l'état du thème
class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'app_theme';
  static const String _lightTheme = 'light';
  static const String _darkTheme = 'dark';
  static const String _systemTheme = 'system';

  String _currentTheme = _lightTheme;
  late SharedPreferences _prefs;
  bool _initialized = false;

  ThemeProvider() {
    _initPreferences();
  }

  String get currentTheme => _currentTheme;
  bool get isDarkMode => _currentTheme == _darkTheme;
  bool get isSystemDefault => _currentTheme == _systemTheme;
  bool get isInitialized => _initialized;

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _currentTheme = _prefs.getString(_themeKey) ?? _lightTheme;
    _initialized = true;
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      await _prefs.setString(_themeKey, theme);
      notifyListeners();
    }
  }

  /// Obtenir le ThemeData basé sur le thème sélectionné
  ThemeData getThemeData(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark = _currentTheme == _darkTheme ||
        (_currentTheme == _systemTheme && brightness == Brightness.dark);

    if (isDark) {
      return _buildDarkTheme();
    } else {
      return _buildLightTheme();
    }
  }

  /// Construire le thème clair
  static ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: SaloonyColors.primary,
      scaffoldBackgroundColor: SaloonyColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: SaloonyColors.background,
        foregroundColor: SaloonyColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: SaloonyColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SaloonyColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SaloonyColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SaloonyColors.primary, width: 2),
        ),
        hintStyle: const TextStyle(color: SaloonyColors.textHint),
        labelStyle: const TextStyle(color: SaloonyColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SaloonyColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SaloonyColors.primary,
          side: const BorderSide(color: SaloonyColors.primary, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SaloonyColors.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: SaloonyColors.tertiaryLight,
        disabledColor: SaloonyColors.tertiaryLight,
        selectedColor: SaloonyColors.primary,
        labelStyle: const TextStyle(color: SaloonyColors.textPrimary),
        brightness: Brightness.light,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: SaloonyColors.secondary,
        foregroundColor: SaloonyColors.primary,
      ),
      colorScheme: const ColorScheme.light(
        primary: SaloonyColors.primary,
        secondary: SaloonyColors.secondary,
        surface: SaloonyColors.background,
        error: SaloonyColors.error,
      ),
    );
  }

  /// Construire le thème sombre
  static ThemeData _buildDarkTheme() {
    const darkBgColor = Color(0xFF0F1620);
    const darkCardColor = Color(0xFF1B2B3E);
    const lightText = Color(0xFFF0F0F0);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: SaloonyColors.secondary,
      scaffoldBackgroundColor: darkBgColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkCardColor,
        foregroundColor: lightText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: lightText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A3F54)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A3F54)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SaloonyColors.secondary, width: 2),
        ),
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        labelStyle: const TextStyle(color: lightText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SaloonyColors.secondary,
          foregroundColor: SaloonyColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SaloonyColors.secondary,
          side: const BorderSide(color: SaloonyColors.secondary, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SaloonyColors.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      cardTheme: CardThemeData(
        color: darkCardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Color(0xFF2A3F54),
        disabledColor: Color(0xFF2A3F54),
        selectedColor: SaloonyColors.secondary,
        labelStyle: const TextStyle(color: lightText),
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: SaloonyColors.secondary,
        foregroundColor: SaloonyColors.primary,
      ),
      colorScheme: const ColorScheme.dark(
        primary: SaloonyColors.secondary,
        secondary: SaloonyColors.gold,
        surface: darkCardColor,
        error: Color(0xFFEF5350),
      ),
    );
  }

  /// Expose explicit light theme data
  ThemeData get lightTheme => _buildLightTheme();

  /// Expose explicit dark theme data
  ThemeData get darkTheme => _buildDarkTheme();
}
