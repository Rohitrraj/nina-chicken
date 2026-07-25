import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/about/about.dart';

void main() {
  Future<void> pumpAboutSections(
    WidgetTester tester, {
    required Size viewportSize,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewportSize;

    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                AboutIntroSection(),
                AboutHighlightStrip(),
                AboutValuesSection(),
                AboutFamilyStorySection(),
                AboutProcessSection(),
                AboutTestimonialsSection(),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('About sections render editorial content on desktop', (
    tester,
  ) async {
    await pumpAboutSections(tester, viewportSize: const Size(1440, 5000));

    expect(find.text('Tentang Kedai Ayam Nina'), findsOneWidget);
    expect(find.text('2023'), findsOneWidget);
    expect(find.text('Mengapa Memilih Kami?'), findsOneWidget);
    expect(find.text('Berawal dari Dapur Keluarga'), findsOneWidget);
    expect(find.text('Proses dari Dapur Kami'), findsOneWidget);
    expect(find.text('Kata Pelanggan'), findsOneWidget);
    expect(find.text('5,0'), findsOneWidget);
    expect(find.text('10 ulasan Google'), findsOneWidget);
    expect(find.text('Desy Kristyawati'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('About sections render without overflow on mobile', (
    tester,
  ) async {
    await pumpAboutSections(tester, viewportSize: const Size(390, 6000));

    expect(find.text('Bahan Pilihan'), findsOneWidget);
    expect(find.text('Dimasak Saat Dipesan'), findsOneWidget);
    expect(find.text('Resep Penuh Ketulusan'), findsOneWidget);
    expect(find.text('Memilih bahan'), findsOneWidget);
    expect(find.text('Disajikan hangat'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
