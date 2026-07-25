import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/product_detail/product_detail.dart';

void main() {
  testWidgets('ProductDetailActions executes view menu callback', (
    tester,
  ) async {
    var menuPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: ProductDetailActions(
            onViewMenu: () {
              menuPressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Lihat Menu Lain'), findsOneWidget);

    expect(find.text('Hubungi Kami'), findsNothing);

    await tester.tap(find.text('Lihat Menu Lain'));
    await tester.pump();

    expect(menuPressed, isTrue);
  });
}
