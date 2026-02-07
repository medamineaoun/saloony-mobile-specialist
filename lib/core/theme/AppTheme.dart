import 'package:flutter/material.dart';
import '../constants/SaloonyColors.dart';
import '../constants/SaloonyTextStyles.dart';

/// Saloony App Theme Configuration
/// 
/// This class provides the complete ThemeData for the application,
/// ensuring consistent styling across all screens.
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  /// Light theme data for the application
  static ThemeData get lightTheme {
    return ThemeData(
      // Primary colors
      primaryColor: SaloonyColors.primary,
      primaryColorLight: SaloonyColors.primaryLight,
      primaryColorDark: SaloonyColors.primaryDark,
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: SaloonyColors.primary,
        secondary: SaloonyColors.secondary,
        tertiary: SaloonyColors.tertiary,
        surface: SaloonyColors.background,
        background: SaloonyColors.backgroundSecondary,
        error: SaloonyColors.error,
        onPrimary: SaloonyColors.textOnPrimary,
        onSecondary: SaloonyColors.textOnSecondary,
        onSurface: SaloonyColors.textPrimary,
        onBackground: SaloonyColors.textPrimary,
        onError: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: SaloonyColors.background,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: SaloonyColors.primary,
        foregroundColor: SaloonyColors.secondary,
        centerTitle: false,
        titleTextStyle: SaloonyTextStyles.heading2.copyWith(
          color: SaloonyColors.secondary,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: SaloonyTextStyles.displayLarge,
        displayMedium: SaloonyTextStyles.displayMedium,
        displaySmall: SaloonyTextStyles.displaySmall,
        headlineMedium: SaloonyTextStyles.heading1,
        headlineSmall: SaloonyTextStyles.heading2,
        titleLarge: SaloonyTextStyles.heading3,
        titleMedium: SaloonyTextStyles.heading4,
        bodyLarge: SaloonyTextStyles.bodyLarge,
        bodyMedium: SaloonyTextStyles.bodyMedium,
        bodySmall: SaloonyTextStyles.bodySmall,
        labelLarge: SaloonyTextStyles.labelLarge,
        labelMedium: SaloonyTextStyles.labelMedium,
        labelSmall: SaloonyTextStyles.labelSmall,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: SaloonyColors.borderLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: SaloonyColors.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: SaloonyColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: SaloonyColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: SaloonyColors.error,
            width: 2,
          ),
        ),
        hintStyle: SaloonyTextStyles.hintText,
        labelStyle: SaloonyTextStyles.labelLarge,
        prefixIconColor: SaloonyColors.secondary,
        suffixIconColor: SaloonyColors.secondary,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SaloonyColors.primary,
          foregroundColor: SaloonyColors.secondary,
          elevation: 4,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: SaloonyTextStyles.buttonLarge,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SaloonyColors.primary,
          side: const BorderSide(
            color: SaloonyColors.primary,
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: SaloonyTextStyles.buttonLarge,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SaloonyColors.secondary,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          textStyle: SaloonyTextStyles.buttonMedium,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: SaloonyColors.textPrimary,
        size: 24,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: SaloonyColors.background,
        margin: const EdgeInsets.all(0),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: SaloonyColors.background,
        titleTextStyle: SaloonyTextStyles.heading2,
        contentTextStyle: SaloonyTextStyles.bodyMedium,
      ),

      // BottomSheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 8,
        backgroundColor: SaloonyColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        backgroundColor: SaloonyColors.background,
        selectedItemColor: SaloonyColors.secondary,
        unselectedItemColor: SaloonyColors.textTertiary,
        selectedLabelStyle: SaloonyTextStyles.labelSmall,
        unselectedLabelStyle: SaloonyTextStyles.labelSmall,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: SaloonyColors.tertiaryLight,
        selectedColor: SaloonyColors.secondary,
        disabledColor: SaloonyColors.disabled,
        labelStyle: SaloonyTextStyles.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        brightness: Brightness.light,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: SaloonyColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return SaloonyColors.primary;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(
          color: SaloonyColors.borderDefault,
          width: 2,
        ),
      ),

      // Radio Button Theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return SaloonyColors.primary;
          }
          return SaloonyColors.borderDefault;
        }),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return SaloonyColors.secondary;
          }
          return SaloonyColors.textTertiary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return SaloonyColors.primary.withOpacity(0.5);
          }
          return SaloonyColors.borderLight;
        }),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: SaloonyColors.secondary,
        circularTrackColor: SaloonyColors.borderLight,
        linearTrackColor: SaloonyColors.borderLight,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: SaloonyColors.secondary,
        foregroundColor: SaloonyColors.primary,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SaloonyColors.primary,
        contentTextStyle: SaloonyTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: SaloonyColors.secondary,
        unselectedLabelColor: SaloonyColors.textSecondary,
        labelStyle: SaloonyTextStyles.labelLarge,
        unselectedLabelStyle: SaloonyTextStyles.labelMedium,
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(
            color: SaloonyColors.secondary,
            width: 3,
          ),
        ),
      ),

      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: SaloonyColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: SaloonyTextStyles.bodySmall.copyWith(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      ),

      // General Properties
      useMaterial3: false, // Set to true if you want to use Material 3
      brightness: Brightness.light,
    );
  }

  /// Dark theme data for the application (optional)
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: SaloonyColors.primaryDark,
      primaryColorLight: SaloonyColors.primary,
      primaryColorDark: SaloonyColors.primaryDark,
      colorScheme: const ColorScheme.dark(
        primary: SaloonyColors.primary,
        secondary: SaloonyColors.secondary,
        tertiary: SaloonyColors.tertiary,
        surface: Color(0xFF1F1F1F),
        background: Color(0xFF121212),
        error: SaloonyColors.error,
        onPrimary: SaloonyColors.textOnPrimary,
        onSecondary: SaloonyColors.textOnSecondary,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      brightness: Brightness.dark,
    );
  }
}
