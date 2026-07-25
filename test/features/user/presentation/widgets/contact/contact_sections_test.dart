import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/contact/contact.dart';

void main() {
  Future<void> pumpContactSections(
    WidgetTester tester, {
    required Size viewportSize,
    VoidCallback? onCopyPhone,
    VoidCallback? onCopyLocation,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewportSize;

    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const ContactHeaderSection(),
                ContactInformationPanel(
                  phoneNumber: '+62 895-3832-05337',
                  location: 'Jakarta Barat, Indonesia',
                  onCopyPhone: onCopyPhone ?? () {},
                  onCopyLocation: onCopyLocation ?? () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('Contact displays phone and location on desktop', (tester) async {
    await pumpContactSections(tester, viewportSize: const Size(1440, 1600));

    expect(find.text('Hubungi Kedai Ayam Nina'), findsOneWidget);
    expect(find.text('Informasi Kontak'), findsOneWidget);
    expect(find.text('Nomor Telepon'), findsOneWidget);
    expect(find.text('Lokasi'), findsOneWidget);
    expect(find.text('+62 895-3832-05337'), findsOneWidget);
    expect(find.text('Jakarta Barat, Indonesia'), findsOneWidget);

    expect(find.text('Siapkan Pesan'), findsNothing);
    expect(find.text('Salin Pesan'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Contact information actions execute callbacks', (tester) async {
    var phoneCopied = false;
    var locationCopied = false;

    await pumpContactSections(
      tester,
      viewportSize: const Size(390, 800),
      onCopyPhone: () {
        phoneCopied = true;
      },
      onCopyLocation: () {
        locationCopied = true;
      },
    );

    final scrollable = find.byType(Scrollable).first;

    final copyPhoneButton = find.widgetWithText(OutlinedButton, 'Salin Nomor');

    await tester.scrollUntilVisible(
      copyPhoneButton,
      300,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();

    await tester.tap(copyPhoneButton);
    await tester.pump();

    final copyLocationButton = find.widgetWithText(
      OutlinedButton,
      'Salin Lokasi',
    );

    await tester.scrollUntilVisible(
      copyLocationButton,
      300,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();

    await tester.tap(copyLocationButton);
    await tester.pump();

    expect(phoneCopied, isTrue);
    expect(locationCopied, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Contact renders without overflow on mobile', (tester) async {
    await pumpContactSections(tester, viewportSize: const Size(390, 800));

    expect(find.text('Salin Nomor'), findsOneWidget);
    expect(find.text('Salin Lokasi'), findsOneWidget);
    expect(find.text('Siapkan Pesan'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
