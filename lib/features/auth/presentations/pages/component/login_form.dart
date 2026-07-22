import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/utils/validators.dart';
import 'package:kedai_ayam_nina/core/widgets/custom_button_gradient.dart';
import 'package:kedai_ayam_nina/core/widgets/custom_textfield.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.email,
    required this.password,
    required this.isLoading,
    required this.formKey,
    required this.onLogin,
  });
  final TextEditingController email;
  final TextEditingController password;
  final GlobalKey<FormState> formKey;
  final Function() onLogin;
  final bool isLoading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        spacing: 16,
        children: [
          CustomInputField(
            validator: MyValidators.notNull,
            controller: widget.email,
            prefixIcon: Icons.email,
            label: "Email",
            hintText: "Masukkan email",
          ),
          CustomInputField(
            validator: MyValidators.notNull,
            controller: widget.password,
            prefixIcon: Icons.lock,
            label: "Password",
            hintText: "Masukkan kata sandi",
            suffixIcon: _obscurePassword
                ? Icons.visibility_off
                : Icons.visibility,
            obscureText: _obscurePassword,
            onSuffixTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          CustomGradientButton(
            text: "Masuk",
            onTap: () {
              if (widget.formKey.currentState!.validate()) {
                widget.onLogin.call();
              }
            },
          ),
        ],
      ),
    );
  }
}
