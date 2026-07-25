import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/contact/contact.dart';

void main() {
  const address =
      '5 Jalan Anyar Raya No. 46B, RT.7/RW.10, '
      'Wijaya Kusuma, Kec. Grogol Petamburan, '
      'Kota Jakarta Barat, Daerah Khusus Ibukota '
      'Jakarta 11460';

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
                  location: address,
                  operatingHours: 'Setiap hari, 10.00 - 22.00',
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

  testWidgets('Contact displays Maps address and operating hours', (
    tester,
  ) async {
    await pumpContactSections(tester, viewportSize: const Size(1440, 1600));

    expect(find.text('Contact Us'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Jam Operasional'), findsOneWidget);
    expect(find.text('+62 895-3832-05337'), findsOneWidget);
    expect(find.text(address), findsOneWidget);
    expect(find.text('Setiap hari, 10.00 - 22.00'), findsOneWidget);

    expect(find.text('Siapkan Pesan'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Contact copy actions execute callbacks', (tester) async {
    var phoneCopied = false;
    var locationCopied = false;

    await pumpContactSections(
      tester,
      viewportSize: const Size(390, 900),
      onCopyPhone: () {
        phoneCopied = true;
      },
      onCopyLocation: () {
        locationCopied = true;
      },
    );

    final scrollable = find.byType(Scrollable).first;

    final phoneButton = find.widgetWithText(OutlinedButton, 'Salin Nomor');

    await tester.scrollUntilVisible(phoneButton, 300, scrollable: scrollable);
    await tester.pumpAndSettle();
    await tester.tap(phoneButton);
    await tester.pump();

    final locationButton = find.widgetWithText(OutlinedButton, 'Salin Lokasi');

    await tester.scrollUntilVisible(
      locationButton,
      300,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
    await tester.tap(locationButton);
    await tester.pump();

    expect(phoneCopied, isTrue);
    expect(locationCopied, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Contact renders without overflow on mobile', (tester) async {
    await pumpContactSections(tester, viewportSize: const Size(390, 2400));

    expect(find.text('Salin Nomor'), findsOneWidget);
    expect(find.text('Salin Lokasi'), findsOneWidget);
    expect(find.text('Jam Operasional'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
