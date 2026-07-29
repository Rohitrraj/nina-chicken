import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/auth/presentations/pages/component/login_form.dart';

Future<void> pumpLoginForm(
  WidgetTester tester, {
  required VoidCallback onLogin,
  bool isLoading = false,
}) async {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  addTearDown(emailController.dispose);
  addTearDown(passwordController.dispose);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightTheme(),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 420,
            child: LoginForm(
              emailController: emailController,
              passwordController: passwordController,
              formKey: GlobalKey<FormState>(),
              isLoading: isLoading,
              onLogin: onLogin,
            ),
          ),
        ),
      ),
    ),
  );
}

Finder passwordEditableText() {
  return find.descendant(
    of: find.byKey(const Key('login-password-field')),
    matching: find.byType(EditableText),
  );
}

void main() {
  testWidgets('renders email, password, and submit button', (tester) async {
    await pumpLoginForm(tester, onLogin: () {});

    expect(find.byKey(const Key('login-email-field')), findsOneWidget);

    expect(find.byKey(const Key('login-password-field')), findsOneWidget);

    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Kata sandi'), findsOneWidget);
  });

  testWidgets('rejects empty email and password', (tester) async {
    await pumpLoginForm(tester, onLogin: () {});

    await tester.tap(find.byKey(const Key('login-submit-button')));

    await tester.pump();

    expect(find.text('Email wajib diisi.'), findsOneWidget);

    expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);
  });

  testWidgets('rejects invalid email format', (tester) async {
    await pumpLoginForm(tester, onLogin: () {});

    await tester.enterText(
      find.byKey(const Key('login-email-field')),
      'email-tidak-valid',
    );

    await tester.enterText(
      find.byKey(const Key('login-password-field')),
      'password',
    );

    await tester.tap(find.byKey(const Key('login-submit-button')));

    await tester.pump();

    expect(find.text('Masukkan alamat email yang valid.'), findsOneWidget);
  });

  testWidgets('password is hidden and can be revealed', (tester) async {
    await pumpLoginForm(tester, onLogin: () {});

    var editableText = tester.widget<EditableText>(passwordEditableText());

    expect(editableText.obscureText, isTrue);

    await tester.tap(find.byKey(const Key('login-password-toggle')));

    await tester.pump();

    editableText = tester.widget<EditableText>(passwordEditableText());

    expect(editableText.obscureText, isFalse);

    expect(find.byTooltip('Sembunyikan kata sandi'), findsOneWidget);
  });

  testWidgets('valid form invokes login once', (tester) async {
    var loginCount = 0;

    await pumpLoginForm(
      tester,
      onLogin: () {
        loginCount += 1;
      },
    );

    await tester.enterText(
      find.byKey(const Key('login-email-field')),
      'admin@example.com',
    );

    await tester.enterText(
      find.byKey(const Key('login-password-field')),
      'password',
    );

    await tester.tap(find.byKey(const Key('login-submit-button')));

    await tester.pump();

    expect(loginCount, 1);
  });

  testWidgets('loading state prevents another submit', (tester) async {
    var loginCount = 0;

    await pumpLoginForm(
      tester,
      isLoading: true,
      onLogin: () {
        loginCount += 1;
      },
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('login-submit-button')),
      warnIfMissed: false,
    );

    await tester.pump();

    expect(loginCount, 0);
  });
}
