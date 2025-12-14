import 'package:flutter/material.dart';
import '../constants/SaloonyColors.dart';
import '../constants/SaloonyTextStyles.dart';

/// Card Widget with shadow and consistent styling
class SaloonyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double elevation;
  final VoidCallback? onTap;
  final bool isClickable;

  const SaloonyCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 12,
    this.elevation = 2,
    this.onTap,
    this.isClickable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      color: backgroundColor ?? Colors.white,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderColor != null
            ? BorderSide(color: borderColor!)
            : BorderSide.none,
      ),
      margin: margin,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );

    if (isClickable || onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }

    return card;
  }
}

/// Container with gradient background
class SaloonyGradientContainer extends StatelessWidget {
  final List<Color> colors;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const SaloonyGradientContainer({
    Key? key,
    required this.colors,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 12,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

/// Chip/Badge Widget
class SaloonyChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final double? elevation;

  const SaloonyChip({
    Key? key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.onTap,
    this.onDelete,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: SaloonyTextStyles.labelMedium.copyWith(
          color: textColor ?? SaloonyColors.textPrimary,
        ),
      ),
      avatar: icon != null ? Icon(icon, size: 18) : null,
      backgroundColor: backgroundColor ?? SaloonyColors.tertiaryLight,
      onDeleted: onDelete,
      deleteIcon: onDelete != null ? const Icon(Icons.close, size: 18) : null,
      side: BorderSide.none,
    );
  }
}

/// Divider with text
class SaloonyDividerWithText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? dividerColor;

  const SaloonyDividerWithText({
    Key? key,
    required this.text,
    this.textColor,
    this.dividerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor ?? SaloonyColors.borderLight,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: SaloonyTextStyles.labelMedium.copyWith(
              color: textColor ?? SaloonyColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor ?? SaloonyColors.borderLight,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

/// Empty State Widget
class SaloonyEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color? iconColor;
  final Widget? actionWidget;

  const SaloonyEmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    this.iconColor,
    this.actionWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: iconColor ?? SaloonyColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: SaloonyTextStyles.heading3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              description,
              style: SaloonyTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          if (actionWidget != null) ...[
            const SizedBox(height: 24),
            actionWidget!,
          ],
        ],
      ),
    );
  }
}

/// Loading Indicator
class SaloonyLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;
  final String? label;

  const SaloonyLoadingIndicator({
    Key? key,
    this.color,
    this.size = 48,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: size,
          width: size,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? SaloonyColors.secondary,
            ),
            strokeWidth: 4,
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 16),
          Text(
            label!,
            style: SaloonyTextStyles.bodyMedium.copyWith(
              color: SaloonyColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Alert Dialog with custom styling
class SaloonyAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final VoidCallback? onPositive;
  final VoidCallback? onNegative;
  final IconData? icon;

  const SaloonyAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    this.positiveButtonText = 'OK',
    this.negativeButtonText,
    this.onPositive,
    this.onNegative,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      icon: icon != null
          ? Icon(
              icon,
              color: SaloonyColors.secondary,
              size: 48,
            )
          : null,
      title: Text(
        title,
        style: SaloonyTextStyles.heading3,
        textAlign: TextAlign.center,
      ),
      content: Text(
        message,
        style: SaloonyTextStyles.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        if (negativeButtonText != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onNegative?.call();
            },
            child: Text(
              negativeButtonText!,
              style: SaloonyTextStyles.buttonMedium.copyWith(
                color: SaloonyColors.textSecondary,
              ),
            ),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onPositive?.call();
          },
          child: Text(
            positiveButtonText ?? 'OK',
            style: SaloonyTextStyles.buttonMedium.copyWith(
              color: SaloonyColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Snackbar with custom styling
class SaloonySnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final Color bgColor;
    final IconData icon;
    final Color textColor;

    switch (type) {
      case SnackBarType.success:
        bgColor = SaloonyColors.success;
        icon = Icons.check_circle_outline;
        textColor = Colors.white;
        break;
      case SnackBarType.error:
        bgColor = SaloonyColors.error;
        icon = Icons.error_outline;
        textColor = Colors.white;
        break;
      case SnackBarType.warning:
        bgColor = SaloonyColors.warning;
        icon = Icons.warning_outlined;
        textColor = Colors.white;
        break;
      case SnackBarType.info:
        bgColor = SaloonyColors.info;
        icon = Icons.info_outline;
        textColor = Colors.white;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: SaloonyTextStyles.bodyMedium.copyWith(
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

enum SnackBarType { success, error, warning, info }

// ------------------------- Shared Buttons & Inputs -------------------------

/// Primary Button Widget
class SaloonyPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
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
    this.onPressed,
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
              color: (backgroundColor ?? SaloonyColors.primary).withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
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
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? SaloonyColors.secondary,
                    ),
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: textColor ?? SaloonyColors.secondary, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(label, style: SaloonyTextStyles.buttonLarge.copyWith(color: textColor ?? SaloonyColors.secondary)),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Secondary (outlined) button
class SaloonySecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double height;
  final IconData? icon;
  final bool isFullWidth;

  const SaloonySecondaryButton({
    Key? key,
    required this.label,
    this.onPressed,
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
          side: BorderSide(color: borderColor ?? SaloonyColors.primary, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor ?? SaloonyColors.primary, size: 18),
              const SizedBox(width: 8),
            ],
            Text(label, style: SaloonyTextStyles.buttonLarge.copyWith(color: textColor ?? SaloonyColors.primary)),
          ],
        ),
      ),
    );
  }
}

/// Text-only button
class SaloonyTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? textColor;
  final TextStyle? style;

  const SaloonyTextButton({Key? key, required this.label, this.onPressed, this.textColor, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(label, style: style ?? SaloonyTextStyles.buttonMedium.copyWith(color: textColor ?? SaloonyColors.secondary)));
  }
}

/// Small compact button
class SaloonySmallButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final IconData? icon;

  const SaloonySmallButton({Key? key, required this.label, this.onPressed, this.backgroundColor, this.textColor, this.width, this.height = 40, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: backgroundColor ?? SaloonyColors.tertiary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12)),
        child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null) ...[Icon(icon, color: textColor ?? SaloonyColors.textPrimary, size: 14), const SizedBox(width: 6)],
          Text(label, style: SaloonyTextStyles.buttonSmall.copyWith(color: textColor ?? SaloonyColors.textPrimary)),
        ]),
      ),
    );
  }
}

/// Input field with label
class SaloonyInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int minLines;
  final bool readOnly;
  final VoidCallback? onSuffixIconTap;
  final Color? fillColor;
  final Color? labelTextColor;
  final Color? borderColor;
  final Color? focusedBorderColor;

  const SaloonyInputField({Key? key, this.controller, required this.label, required this.hintText, this.prefixIcon, this.suffixIcon, this.obscureText = false, this.keyboardType = TextInputType.text, this.validator, this.onChanged, this.maxLines = 1, this.minLines = 1, this.readOnly = false, this.onSuffixIconTap, this.fillColor, this.labelTextColor, this.borderColor, this.focusedBorderColor}) : super(key: key);

  @override
  State<SaloonyInputField> createState() => _SaloonyInputFieldState();
}

class _SaloonyInputFieldState extends State<SaloonyInputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label, style: SaloonyTextStyles.labelLarge.copyWith(color: widget.labelTextColor ?? SaloonyColors.textPrimary)),
      const SizedBox(height: 8),
      TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onChanged: widget.onChanged,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        minLines: widget.minLines,
        readOnly: widget.readOnly,
        style: SaloonyTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: SaloonyTextStyles.hintText,
          prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: SaloonyColors.textSecondary, size: 20) : null,
          suffixIcon: widget.suffixIcon != null ? IconButton(icon: Icon(widget.suffixIcon, color: SaloonyColors.textSecondary, size: 20), onPressed: widget.onSuffixIconTap) : null,
          filled: true,
          fillColor: widget.fillColor ?? Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: widget.borderColor ?? SaloonyColors.borderLight)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: widget.borderColor ?? SaloonyColors.borderLight)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: widget.focusedBorderColor ?? SaloonyColors.primary, width: 2)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      )
    ]);
  }
}

/// Simple inline text field
class SaloonySimpleTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onSuffixIconTap;
  final Color? fillColor;

  const SaloonySimpleTextField({Key? key, this.controller, required this.hintText, this.prefixIcon, this.suffixIcon, this.obscureText = false, this.keyboardType = TextInputType.text, this.validator, this.onChanged, this.onSuffixIconTap, this.fillColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: SaloonyTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: SaloonyTextStyles.hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: SaloonyColors.textSecondary, size: 20) : null,
        suffixIcon: suffixIcon != null ? IconButton(icon: Icon(suffixIcon, color: SaloonyColors.textSecondary, size: 20), onPressed: onSuffixIconTap) : null,
        filled: true,
        fillColor: fillColor ?? Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: SaloonyColors.borderLight)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: SaloonyColors.borderLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: SaloonyColors.primary, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

/// Search field
class SaloonySearchField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;

  const SaloonySearchField({Key? key, this.controller, this.onChanged, this.onClear}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: SaloonyTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: SaloonyTextStyles.hintText,
        prefixIcon: const Icon(Icons.search_outlined, color: SaloonyColors.textSecondary, size: 20),
        suffixIcon: controller?.text.isNotEmpty ?? false ? IconButton(icon: const Icon(Icons.clear, color: SaloonyColors.textTertiary, size: 18), onPressed: onClear) : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: SaloonyColors.borderLight)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: SaloonyColors.borderLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: SaloonyColors.primary, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
