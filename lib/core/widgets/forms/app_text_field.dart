import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.inputFormatters,
    this.autofillHints,
    this.helperText,
    this.errorText,
    this.semanticLabel,
  });

  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int maxLines;
  final int? minLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final String? helperText;
  final String? errorText;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final field = TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : minLines,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      inputFormatters: inputFormatters,
      autofillHints: autofillHints,
      style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, semanticLabel: label),
        suffixIcon: suffixIcon,
      ),
    );

    return Semantics(
      textField: true,
      label: semanticLabel ?? label ?? hintText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          field,
        ],
      ),
    );
  }
}
