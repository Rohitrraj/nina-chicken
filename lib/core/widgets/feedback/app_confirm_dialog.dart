import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';

class AppConfirmDialog {
  const AppConfirmDialog._();

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String cancelLabel = 'Batal',
    String confirmLabel = 'Konfirmasi',
    bool destructive = false,
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final emphasisColor = destructive
            ? theme.colorScheme.error
            : theme.colorScheme.primary;

        return AlertDialog(
          icon: Icon(
            destructive
                ? Icons.warning_amber_rounded
                : Icons.help_outline_rounded,
            color: emphasisColor,
            size: 32,
          ),
          title: Text(title, textAlign: TextAlign.center),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          actions: [
            AppButton(
              label: cancelLabel,
              size: AppButtonSize.small,
              variant: AppButtonVariant.text,
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            AppButton(
              label: confirmLabel,
              size: AppButtonSize.small,
              variant: destructive
                  ? AppButtonVariant.danger
                  : AppButtonVariant.primary,
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
