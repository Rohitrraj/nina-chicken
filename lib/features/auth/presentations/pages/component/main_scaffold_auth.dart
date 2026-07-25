import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/router/router.dart';

class MainScaffoldAuth extends StatelessWidget {
  const MainScaffoldAuth({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;

    final horizontalPadding = AppBreakpoints.horizontalPadding(viewportWidth);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: horizontalPadding,
        title: Semantics(
          button: true,
          label: 'Kembali ke Beranda',
          child: TextButton.icon(
            onPressed: () {
              context.go(MyRoute.home.path);
            },
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Kembali ke Beranda'),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight > 72
                ? constraints.maxHeight - 72
                : 0.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.lg,
                horizontalPadding,
                AppSpacing.xxl,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: availableHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1060),
                    child: navigationShell,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
