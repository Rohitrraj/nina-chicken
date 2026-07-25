import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/catalog/catalog.dart';

void main() {
  testWidgets('CatalogToolbar reports search and category changes', (
    tester,
  ) async {
    final controller = TextEditingController();
    String? searchValue;
    String? selectedCategory;

    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: CatalogToolbar(
              searchController: controller,
              categories: const ['Semua', 'Food', 'Beverage'],
              selectedCategory: 'Semua',
              resultCount: 3,
              totalCount: 3,
              onSearchChanged: (value) {
                searchValue = value;
              },
              onCategorySelected: (category) {
                selectedCategory = category;
              },
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'penyet');

    expect(searchValue, 'penyet');

    await tester.tap(
      find.byKey(const ValueKey<String>('catalog-category-Food')),
    );

    await tester.pump();

    expect(selectedCategory, 'Food');
  });
}
