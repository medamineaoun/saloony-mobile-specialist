import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SaloonyColors.dart';

/// Saloony Text Styles
class SaloonyTextStyles {
  SaloonyTextStyles._();

  /// Display Large - 48px, Bold
  /// Used for app title and major page headers
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
    color: SaloonyColors.textPrimary,
    height: 1.2,
  );

  /// Display Medium - 40px, Bold
  /// Used for section headers
  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.3,
    color: SaloonyColors.textPrimary,
    height: 1.2,
  );

  /// Display Small - 32px, Bold
  /// Used for sub-headers and dialog titles
  static TextStyle displaySmall = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2,
    color: SaloonyColors.textPrimary,
    height: 1.3,
  );

  /// Heading 1 - 28px, Bold
  /// Used for page titles (like "Welcome Back!")
    static TextStyle heading1 = GoogleFonts.playfairDisplay(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: SaloonyColors.textPrimary,
      height: 1.1,
    );

  /// Heading 2 - 24px, Bold
  /// Used for subsection titles
  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: SaloonyColors.textPrimary,
    height: 1.4,
  );

  /// Heading 3 - 20px, Semi-bold
  /// Used for card titles and smaller headers
  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: SaloonyColors.textPrimary,
    height: 1.4,
  );

  /// Heading 4 - 18px, Semi-bold
  /// Used for list item headers
  static TextStyle heading4 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: SaloonyColors.textPrimary,
    height: 1.4,
  );

 
  /// Body Large - 16px, Regular
  /// Used for main body text
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: SaloonyColors.textPrimary,
    height: 1.5,
  );

  /// Body Medium - 15px, Regular
  /// Used for standard body text
  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: SaloonyColors.textPrimary,
    height: 1.5,
  );

  /// Body Small - 14px, Regular
  /// Used for secondary text and descriptions
  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: SaloonyColors.textSecondary,
    height: 1.5,
  );

  /// Label Large - 14px, Semi-bold
  /// Used for form field labels
  static TextStyle labelLarge = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: SaloonyColors.textPrimary,
    height: 1.4,
  );

  /// Label Medium - 13px, Semi-bold
  /// Used for smaller labels
  static TextStyle labelMedium = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: SaloonyColors.textSecondary,
    height: 1.4,
  );

  /// Label Small - 12px, Semi-bold
  /// Used for tiny labels and badges
  static TextStyle labelSmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: SaloonyColors.textSecondary,
    height: 1.4,
  );

 
  /// Caption - 12px, Regular
  /// Used for captions and small info text
  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: SaloonyColors.textTertiary,
    height: 1.4,
  );

  /// Overline - 11px, Semi-bold, Uppercase
  /// Used for overline text
  static TextStyle overline = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: SaloonyColors.textSecondary,
    letterSpacing: 1.5,
    height: 1.3,
  );

 
  /// Button Large - 16px, Semi-bold
  static TextStyle buttonLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
  );

  /// Button Medium - 15px, Semi-bold
  static TextStyle buttonMedium = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.4,
  );

  /// Button Small - 13px, Semi-bold
  static TextStyle buttonSmall = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.4,
  );

  
  /// Subtitle - 15px, Regular, Secondary color
  /// Used for subtitles under main headers
    static TextStyle subtitle = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: SaloonyColors.textSecondary,
      height: 1.3,
    );

  /// Error Text - 13px, Regular, Error color
  static TextStyle errorText = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: SaloonyColors.error,
    height: 1.4,
  );

  /// Success Text - 13px, Regular, Success color
  static TextStyle successText = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: SaloonyColors.success,
    height: 1.4,
  );

  /// Hint Text - 14px, Regular, Hint color
  static TextStyle hintText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: SaloonyColors.textHint,
    height: 1.5,
  );

  /// Link Text - 14px, Semi-bold, Secondary color
  static TextStyle linkText = GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: SaloonyColors.gold,
      height: 1.4,
    );
}
