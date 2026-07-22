import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/constant/enum.dart';
import 'package:kedai_ayam_nina/core/widgets/snackbarr/custom_snackbar.dart';
import 'package:kedai_ayam_nina/features/auth/presentations/bloc/auth_bloc.dart';
import 'package:kedai_ayam_nina/features/auth/presentations/pages/component/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 32,
      children: [
        Image.asset(Assets.logoC1),
        Text(
          "Kedai Ayam Nina",
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar(
                  message: "Login Berhasil",
                  state: SnackBarState.success,
                ),
              );
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar(
                  message: state.message,
                  state: SnackBarState.error,
                ),
              );
            }
          },
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: state is AuthInProgress
                  ? const Center(
                      key: ValueKey('loading'),
                      child: CircularProgressIndicator(),
                    )
                  : LoginForm(
                      key: ValueKey('form'),
                      email: _emailController,
                      password: _passwordController,
                      isLoading: false,
                      formKey: GlobalKey<FormState>(),
                      onLogin: () {
                        context.read<AuthBloc>().add(
                          AuthLogin(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ],
    );
  }
}
