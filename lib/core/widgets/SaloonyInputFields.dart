import 'package:flutter/material.dart';
import '../constants/SaloonyColors.dart';
import '../constants/SaloonyTextStyles.dart';

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

  const SaloonyInputField({
    Key? key,
    this.controller,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines = 1,
    this.readOnly = false,
    this.onSuffixIconTap,
    this.fillColor,
    this.labelTextColor,
    this.borderColor,
    this.focusedBorderColor,
  }) : super(key: key);

  @override
  State<SaloonyInputField> createState() => _SaloonyInputFieldState();
}

class _SaloonyInputFieldState extends State<SaloonyInputField> {
  late FocusNode _focusNode;
  late bool _isFocused;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: SaloonyTextStyles.labelLarge.copyWith(
            color: widget.labelTextColor ?? SaloonyColors.textPrimary,
          ),
        ),
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
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: SaloonyColors.textSecondary,
                    size: 22,
                  )
                : null,
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      widget.suffixIcon,
                      color: SaloonyColors.textSecondary,
                      size: 22,
                    ),
                    onPressed: widget.onSuffixIconTap,
                  )
                : null,
            filled: true,
            fillColor: widget.fillColor ?? Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.borderColor ?? SaloonyColors.borderLight,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.borderColor ?? SaloonyColors.borderLight,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.focusedBorderColor ?? SaloonyColors.primary,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }
}

/// Simple text field without label (for inline fields)
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

  const SaloonySimpleTextField({
    Key? key,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.onSuffixIconTap,
    this.fillColor,
  }) : super(key: key);

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
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: SaloonyColors.textSecondary,
                size: 22,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(
                  suffixIcon,
                  color: SaloonyColors.textSecondary,
                  size: 22,
                ),
                onPressed: onSuffixIconTap,
              )
            : null,
        filled: true,
        fillColor: fillColor ?? Colors.white,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
    );
  }
}

class SaloonySearchField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;

  const SaloonySearchField({
    Key? key,
    this.controller,
    this.onChanged,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: SaloonyTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: SaloonyTextStyles.hintText,
        prefixIcon: const Icon(
          Icons.search_outlined,
          color: SaloonyColors.textSecondary,
          size: 22,
        ),
        suffixIcon: controller?.text.isNotEmpty ?? false
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: SaloonyColors.textTertiary,
                  size: 20,
                ),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
