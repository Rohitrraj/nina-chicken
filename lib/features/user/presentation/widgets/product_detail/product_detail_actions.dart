import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';

class ProductDetailActions extends StatelessWidget {
  const ProductDetailActions({super.key, required this.onViewMenu});

  final VoidCallback onViewMenu;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        label: 'Lihat Menu Lain',
        variant: AppButtonVariant.primary,
        size: AppButtonSize.medium,
        leadingIcon: Icons.restaurant_menu_rounded,
        onPressed: onViewMenu,
      ),
    );
  }
}
