import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';

enum AppSnackbarType { success, error, info, warning }

class AppSnackbar {
  const AppSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    AppSnackbarType type = AppSnackbarType.info,
    Duration duration = const Duration(seconds: 4),
    bool replaceCurrent = true,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    if (replaceCurrent) {
      messenger.hideCurrentSnackBar();
    }

    messenger.showSnackBar(
      build(context, message: message, type: type, duration: duration),
    );
  }

  static SnackBar build(
    BuildContext context, {
    required String message,
    AppSnackbarType type = AppSnackbarType.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    return SnackBar(
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.all(AppSpacing.md),
      dismissDirection: DismissDirection.horizontal,
      content: AppSnackbarContent(message: message, type: type),
    );
  }
}

class AppSnackbarContent extends StatelessWidget {
  const AppSnackbarContent({
    super.key,
    required this.message,
    required this.type,
    this.showCloseIcon = true,
  });

  final String message;
  final AppSnackbarType type;
  final bool showCloseIcon;

  @override
  Widget build(BuildContext context) {
    final presentation = _presentation(context);

    return Semantics(
      liveRegion: true,
      label: message,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: presentation.backgroundColor,
          borderRadius: AppRadius.sm,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(presentation.icon, color: presentation.foregroundColor),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: presentation.foregroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (showCloseIcon) ...[
              const SizedBox(width: AppSpacing.xs),
              IconButton(
                tooltip: 'Tutup pesan',
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: presentation.foregroundColor,
                  size: 20,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _SnackbarPresentation _presentation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case AppSnackbarType.success:
        return const _SnackbarPresentation(
          icon: Icons.check_circle_outline_rounded,
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        );

      case AppSnackbarType.error:
        return _SnackbarPresentation(
          icon: Icons.error_outline_rounded,
          backgroundColor: colorScheme.error,
          foregroundColor: colorScheme.onError,
        );

      case AppSnackbarType.info:
        return _SnackbarPresentation(
          icon: Icons.info_outline_rounded,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        );

      case AppSnackbarType.warning:
        return const _SnackbarPresentation(
          icon: Icons.warning_amber_rounded,
          backgroundColor: Color(0xFFF9A825),
          foregroundColor: Color(0xFF221B00),
        );
    }
  }
}

class _SnackbarPresentation {
  const _SnackbarPresentation({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
}
