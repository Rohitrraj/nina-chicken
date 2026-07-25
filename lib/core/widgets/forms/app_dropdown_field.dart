import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';

class AppDropdownItem<T> {
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.items,
    required this.onChanged,
    this.label,
    this.hintText,
    this.value,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
    this.semanticLabel,
  });

  final String? label;
  final String? hintText;
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?> onChanged;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;
  final bool enabled;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
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
          FormField<T>(
            key: ValueKey<T?>(value),
            initialValue: value,
            validator: validator,
            builder: (state) {
              return InputDecorator(
                isEmpty: value == null,
                decoration: InputDecoration(
                  hintText: hintText,
                  errorText: state.errorText,
                  prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    isExpanded: true,
                    isDense: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    hint: hintText == null
                        ? null
                        : Text(
                            hintText!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                    items: items.map((item) {
                      return DropdownMenuItem<T>(
                        value: item.value,
                        enabled: item.enabled,
                        child: Text(
                          item.label,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: enabled
                        ? (newValue) {
                            state.didChange(newValue);
                            onChanged(newValue);
                          }
                        : null,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
