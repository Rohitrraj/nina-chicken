import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/feedback/feedback.dart';
import 'package:kedai_ayam_nina/features/auth/presentations/bloc/auth_bloc.dart';
import 'package:kedai_ayam_nina/features/auth/presentations/pages/component/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _submitLogin() {
    context.read<AuthBloc>().add(
      AuthLogin(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return current is AuthFailure;
      },
      listener: (context, state) {
        if (state is AuthFailure) {
          AppSnackbar.show(
            context,
            type: AppSnackbarType.error,
            message: _presentAuthError(state.message),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthInProgress;

        return LayoutBuilder(
          builder: (context, constraints) {
            final useDesktopLayout =
                constraints.maxWidth >= AppBreakpoints.tablet;

            final card = DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.lg,
                border: Border.all(color: AppColors.border),
                boxShadow: AppShadows.lg,
              ),
              child: ClipRRect(
                borderRadius: AppRadius.lg,
                child: useDesktopLayout
                    ? IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Expanded(flex: 10, child: _AdminBrandPanel()),
                            Expanded(
                              flex: 9,
                              child: _LoginPanel(
                                formKey: _formKey,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                isLoading: isLoading,
                                onLogin: _submitLogin,
                                showMobileBrand: false,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _LoginPanel(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        isLoading: isLoading,
                        onLogin: _submitLogin,
                        showMobileBrand: true,
                      ),
              ),
            );

            return SizedBox(width: constraints.maxWidth, child: card);
          },
        );
      },
    );
  }

  String _presentAuthError(String rawMessage) {
    final message = rawMessage.toLowerCase();

    if (message.contains('invalid-credential') ||
        message.contains('invalid credential') ||
        message.contains('credential is incorrect') ||
        message.contains('wrong-password') ||
        message.contains('wrong password') ||
        message.contains('user-not-found') ||
        message.contains('no user found')) {
      return 'Email atau kata sandi tidak sesuai.';
    }

    if (message.contains('invalid-email') ||
        message.contains('email address is not valid')) {
      return 'Format email tidak valid.';
    }

    if (message.contains('too-many-requests') ||
        message.contains('too many requests')) {
      return 'Terlalu banyak percobaan login. '
          'Tunggu beberapa saat lalu coba lagi.';
    }

    if (message.contains('network-request-failed') ||
        message.contains('network') ||
        message.contains('connection')) {
      return 'Tidak dapat terhubung ke layanan login. '
          'Periksa koneksi internet lalu coba lagi.';
    }

    if (message.contains('user-disabled')) {
      return 'Akun ini tidak dapat digunakan. '
          'Hubungi pengelola sistem.';
    }

    return 'Login gagal. Periksa email dan kata sandi, '
        'lalu coba kembali.';
  }
}

class _LoginPanel extends StatelessWidget {
  const _LoginPanel({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    required this.showMobileBrand,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;
  final bool showMobileBrand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.all(showMobileBrand ? AppSpacing.lg : AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showMobileBrand) ...[
            Center(
              child: Image.asset(
                Assets.logoC1,
                width: 112,
                height: 84,
                fit: BoxFit.contain,
                semanticLabel: 'Logo Kedai Ayam Nina',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary50,
              borderRadius: AppRadius.pill,
            ),
            child: Text('AREA ADMIN', style: AppTypography.sectionEyebrow),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Masuk ke Dashboard',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Gunakan akun administrator untuk '
            'mengelola produk, transaksi, dan '
            'analitik usaha.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          LoginForm(
            emailController: emailController,
            passwordController: passwordController,
            formKey: formKey,
            isLoading: isLoading,
            onLogin: onLogin,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Akses hanya tersedia untuk '
                  'administrator Kedai Ayam Nina.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminBrandPanel extends StatelessWidget {
  const _AdminBrandPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      container: true,
      label: 'Panel pengelolaan Kedai Ayam Nina',
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary700, AppColors.tertiary800],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -70,
              child: _DecorativeCircle(size: 230, opacity: 0.09),
            ),
            Positioned(
              left: -65,
              bottom: -80,
              child: _DecorativeCircle(size: 210, opacity: 0.07),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140,
                    height: 112,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.96),
                      borderRadius: AppRadius.lg,
                    ),
                    child: Image.asset(
                      Assets.logoC1,
                      fit: BoxFit.contain,
                      semanticLabel: 'Logo Kedai Ayam Nina',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Panel Pengelola\nKedai Ayam Nina',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: AppColors.textOnDark,
                      fontWeight: FontWeight.w800,
                      height: 1.18,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Kelola informasi usaha melalui '
                    'satu dashboard yang terintegrasi.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textOnDark.withValues(alpha: 0.82),
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _AdminFeatureItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Pengelolaan produk',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _AdminFeatureItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'Pencatatan transaksi',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _AdminFeatureItem(
                    icon: Icons.insights_outlined,
                    label: 'Analitik keuangan',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminFeatureItem extends StatelessWidget {
  const _AdminFeatureItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.textOnPrimary.withValues(alpha: 0.12),
            borderRadius: AppRadius.sm,
          ),
          child: Icon(icon, color: AppColors.textOnDark, size: 20),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
