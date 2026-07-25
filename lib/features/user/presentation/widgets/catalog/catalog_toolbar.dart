import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/forms/forms.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class CatalogToolbar extends StatelessWidget {
  const CatalogToolbar({
    super.key,
    required this.searchController,
    required this.categories,
    required this.selectedCategory,
    required this.resultCount,
    required this.totalCount,
    required this.onSearchChanged,
    required this.onCategorySelected,
  });

  final TextEditingController searchController;
  final List<String> categories;
  final String selectedCategory;
  final int resultCount;
  final int totalCount;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppResponsiveBuilder(
          builder: (context, screenSize, constraints) {
            final useHorizontalLayout =
                screenSize == AppScreenSize.desktop ||
                screenSize == AppScreenSize.wideDesktop;

            final searchField = ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: AppSearchField(
                controller: searchController,
                hintText: 'Cari menu...',
                semanticLabel: 'Cari menu Kedai Ayam Nina',
                onChanged: onSearchChanged,
              ),
            );

            final resultSummary = Text(
              'Menampilkan $resultCount dari $totalCount menu',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            );

            if (useHorizontalLayout) {
              return Row(
                children: [
                  Expanded(child: searchField),
                  const SizedBox(width: AppSpacing.lg),
                  resultSummary,
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                searchField,
                const SizedBox(height: AppSpacing.sm),
                resultSummary,
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: categories.map((category) {
            return _CatalogCategoryChip(
              category: category,
              selected:
                  category.toLowerCase() == selectedCategory.toLowerCase(),
              onTap: () {
                onCategorySelected(category);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CatalogCategoryChip extends StatelessWidget {
  const _CatalogCategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final String category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      selected: selected,
      label: 'Kategori $category',
      child: Material(
        color: selected ? theme.colorScheme.primary : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.pill,
          side: BorderSide(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: InkWell(
          key: ValueKey<String>('catalog-category-$category'),
          onTap: onTap,
          borderRadius: AppRadius.pill,
          mouseCursor: SystemMouseCursors.click,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              category,
              style: theme.textTheme.labelLarge?.copyWith(
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
