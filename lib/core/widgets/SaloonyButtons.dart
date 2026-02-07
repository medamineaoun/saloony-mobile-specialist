import 'package:flutter/material.dart';
import '../constants/SaloonyColors.dart';
import '../constants/SaloonyTextStyles.dart';

/// Primary Button Widget
/// Large button with gradient background for primary actions
class SaloonyPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isFullWidth;

  const SaloonyPrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 56,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isFullWidth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundColor ?? SaloonyColors.primary,
              backgroundColor ?? SaloonyColors.navy,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? SaloonyColors.primary).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? SaloonyColors.secondary,
                    ),
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: textColor ?? SaloonyColors.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: SaloonyTextStyles.buttonLarge.copyWith(
                        color: textColor ?? SaloonyColors.secondary,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Secondary Button Widget
/// Outlined button for secondary actions
class SaloonySecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double height;
  final IconData? icon;
  final bool isFullWidth;

  const SaloonySecondaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.borderColor,
    this.textColor,
    this.width,
    this.height = 56,
    this.icon,
    this.isFullWidth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? SaloonyColors.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: textColor ?? SaloonyColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: SaloonyTextStyles.buttonLarge.copyWith(
                color: textColor ?? SaloonyColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Text Button Widget
/// Minimal button with text only
class SaloonyTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? textColor;
  final TextStyle? style;

  const SaloonyTextButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.textColor,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: style ??
            SaloonyTextStyles.buttonMedium.copyWith(
              color: textColor ?? SaloonyColors.secondary,
            ),
      ),
    );
  }
}

/// Small/Mini Button Widget
/// For compact buttons like "Cancel", "Delete", etc.
class SaloonySmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final IconData? icon;

  const SaloonySmallButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 40,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? SaloonyColors.tertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: textColor ?? SaloonyColors.textPrimary,
                size: 16,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: SaloonyTextStyles.buttonSmall.copyWith(
                color: textColor ?? SaloonyColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
