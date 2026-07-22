import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/router/router.dart';

class MainScaffoldAuth extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainScaffoldAuth({super.key, required this.navigationShell});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: InkWell(
          onTap: () {
            context.go(MyRoute.home.path);
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                "Kembali ke Beranda",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                color: Theme.of(context).colorScheme.onPrimary,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: navigationShell,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
