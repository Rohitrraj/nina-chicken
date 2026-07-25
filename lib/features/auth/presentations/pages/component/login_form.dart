import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.isLoading,
    required this.onLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final VoidCallback onLogin;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  void _submit() {
    if (widget.isLoading) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final isValid = widget.formKey.currentState?.validate() ?? false;

    if (isValid) {
      widget.onLogin();
    }
  }

  String? _validateEmail(String? rawValue) {
    final value = rawValue?.trim() ?? '';

    if (value.isEmpty) {
      return 'Email wajib diisi.';
    }

    final emailPattern = RegExp(
      r'^[A-Za-z0-9.!#$%&'
      r"'*+/=?^_`{|}~-]+@"
      r'[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}'
      r'[A-Za-z0-9])?'
      r'(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}'
      r'[A-Za-z0-9])?)+$',
    );

    if (!emailPattern.hasMatch(value)) {
      return 'Masukkan alamat email yang valid.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi wajib diisi.';
    }

    return null;
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(prefixIcon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.surfaceMuted,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: const OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: BorderSide(color: AppColors.primary600, width: 1.5),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: BorderSide(color: AppColors.neutral300),
      ),
      errorMaxLines: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        key: widget.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const Key('login-email-field'),
              controller: widget.emailController,
              enabled: !widget.isLoading,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              autofillHints: const [
                AutofillHints.username,
                AutofillHints.email,
              ],
              autocorrect: false,
              decoration: _inputDecoration(
                label: 'Email',
                hint: 'nama@email.com',
                prefixIcon: Icons.mail_outline_rounded,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              key: const Key('login-password-field'),
              controller: widget.passwordController,
              enabled: !widget.isLoading,
              validator: _validatePassword,
              obscureText: _obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              autocorrect: false,
              enableSuggestions: false,
              onFieldSubmitted: (_) {
                _submit();
              },
              decoration: _inputDecoration(
                label: 'Kata sandi',
                hint: 'Masukkan kata sandi',
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: IconButton(
                  key: const Key('login-password-toggle'),
                  tooltip: _obscurePassword
                      ? 'Tampilkan kata sandi'
                      : 'Sembunyikan kata sandi',
                  onPressed: widget.isLoading
                      ? null
                      : () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              key: const Key('login-submit-button'),
              label: 'Masuk',
              semanticLabel: widget.isLoading
                  ? 'Sedang masuk ke dashboard'
                  : 'Masuk ke dashboard admin',
              size: AppButtonSize.large,
              fullWidth: true,
              isLoading: widget.isLoading,
              onPressed: widget.isLoading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
