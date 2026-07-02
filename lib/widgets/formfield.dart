import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';

/// Shared label + input field style used across the app (auth, business,
/// payment, document and product forms) so every field looks the same:
/// a label above a rounded cream-coloured box with a soft tan border.
class LabeledTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final VoidCallback? onTap;
  final Widget? prefix;
  final Widget? suffixIcon;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.onTap,
    this.prefix,
    this.suffixIcon,
  });

  static TextStyle get labelStyle => avenirNextCyr.copyWith(
    color: ColorResources.textDark,
    fontSize: Dimensions.spacingSize12,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get inputStyle => avenirNextCyr.copyWith(
    color: ColorResources.textDark,
    fontSize: Dimensions.fontSizeDefault,
  );

  static InputDecoration fieldDecoration(
    String hint, {
    Widget? prefix,
    Widget? suffixIcon,
  }) {
    final radius = BorderRadius.circular(Dimensions.radiusSizeDefault);

    return InputDecoration(
      hintText: hint,
      counterText: "",
      filled: true,
      fillColor: ColorResources.cardBg,
      prefixIcon: prefix,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: avenirNextCyr.copyWith(
        color: ColorResources.textLight,
        fontSize: Dimensions.spacingSize12,
      ),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: ColorResources.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: ColorResources.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: ColorResources.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
      errorStyle: avenirNextCyr.copyWith(color: Colors.redAccent, fontSize: 11),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: labelStyle),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          readOnly: readOnly,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          onTap: onTap,
          style: inputStyle,
          decoration: fieldDecoration(hint, prefix: prefix, suffixIcon: suffixIcon),
        ),
      ],
    );
  }
}

/// Dropdown counterpart of [LabeledTextField] so selects share the same
/// label + cream field look.
class LabeledDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const LabeledDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: LabeledTextField.labelStyle),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          style: LabeledTextField.inputStyle,
          decoration: LabeledTextField.fieldDecoration(hint),
        ),
      ],
    );
  }
}

/// Kept for backwards compatibility with any existing call sites; delegates
/// to [LabeledTextField] with an empty label so styling stays in one place.
class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: LabeledTextField.inputStyle,
      decoration: LabeledTextField.fieldDecoration(hint, suffixIcon: suffixIcon),
    );
  }
}
