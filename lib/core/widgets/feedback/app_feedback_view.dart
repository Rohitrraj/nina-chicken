import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';

enum AppFeedbackType { empty, error, info, success }

class AppFeedbackView extends StatelessWidget {
  const AppFeedbackView.empty({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  }) : type = AppFeedbackType.empty;

  const AppFeedbackView.error({
    super.key,
    required this.title,
    this.message,
    this.actionLabel = 'Coba lagi',
    this.onAction,
    this.compact = false,
  }) : type = AppFeedbackType.error;

  const AppFeedbackView.info({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  }) : type = AppFeedbackType.info;

  const AppFeedbackView.success({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  }) : type = AppFeedbackType.success;

  final AppFeedbackType type;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final presentation = _presentation(context);

    return Semantics(
      liveRegion: type == AppFeedbackType.error,
      container: true,
      label: [title, if (message != null) message!].join('. '),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.xxl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: compact ? 48 : 64,
                  height: compact ? 48 : 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: presentation.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    presentation.icon,
                    size: compact ? 26 : 34,
                    color: presentation.color,
                  ),
                ),
                SizedBox(height: compact ? AppSpacing.sm : AppSpacing.lg),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style:
                      (compact
                              ? theme.textTheme.titleMedium
                              : theme.textTheme.titleLarge)
                          ?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                ),
                if (message != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
                if (onAction != null && actionLabel != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: actionLabel!,
                    variant: AppButtonVariant.outlined,
                    size: compact ? AppButtonSize.small : AppButtonSize.medium,
                    onPressed: onAction,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  _FeedbackPresentation _presentation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case AppFeedbackType.empty:
        return _FeedbackPresentation(
          icon: Icons.inventory_2_outlined,
          color: colorScheme.secondary,
        );

      case AppFeedbackType.error:
        return _FeedbackPresentation(
          icon: Icons.error_outline_rounded,
          color: colorScheme.error,
        );

      case AppFeedbackType.info:
        return _FeedbackPresentation(
          icon: Icons.info_outline_rounded,
          color: colorScheme.primary,
        );

      case AppFeedbackType.success:
        return const _FeedbackPresentation(
          icon: Icons.check_circle_outline_rounded,
          color: Color(0xFF2E7D32),
        );
    }
  }
}

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.message, this.compact = false});

  final String? message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      liveRegion: true,
      label: message ?? 'Memuat data',
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator.adaptive(),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackPresentation {
  const _FeedbackPresentation({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}
