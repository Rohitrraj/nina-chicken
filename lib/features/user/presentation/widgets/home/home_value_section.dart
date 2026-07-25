import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/card/cards.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class HomeValueSection extends StatelessWidget {
  const HomeValueSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const values = [
      _HomeValue(
        icon: Icons.restaurant_menu_rounded,
        title: 'Informasi Menu Jelas',
        description:
            'Nama, kategori, harga, dan deskripsi menu '
            'ditampilkan dalam satu tempat.',
      ),
      _HomeValue(
        icon: Icons.favorite_outline_rounded,
        title: 'Cita Rasa Rumahan',
        description:
            'Pilihan menu dengan karakter rasa yang '
            'akrab untuk menemani waktu makan.',
      ),
      _HomeValue(
        icon: Icons.devices_rounded,
        title: 'Mudah Dijelajahi',
        description:
            'Tampilan responsif untuk membantu pelanggan '
            'melihat menu melalui ponsel maupun desktop.',
      ),
    ];

    return AppSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mengapa Kedai Ayam Nina?',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Pengalaman sederhana untuk mengenal menu '
            'dan informasi Kedai Ayam Nina.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppResponsiveBuilder(
            builder: (context, screenSize, constraints) {
              final columns = switch (screenSize) {
                AppScreenSize.mobile => 1,
                AppScreenSize.tablet => 2,
                AppScreenSize.desktop => 3,
                AppScreenSize.wideDesktop => 3,
              };

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: values.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: AppSpacing.lg,
                  crossAxisSpacing: AppSpacing.lg,
                  mainAxisExtent: 210,
                ),
                itemBuilder: (context, index) {
                  return _HomeValueCard(value: values[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HomeValueCard extends StatelessWidget {
  const _HomeValueCard({required this.value});

  final _HomeValue value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      premium: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: AppRadius.sm,
            ),
            child: Icon(
              value.icon,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            value.title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Expanded(
            child: Text(
              value.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeValue {
  const _HomeValue({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
