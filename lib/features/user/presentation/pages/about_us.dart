import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/animated_scroll_item.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/about/about.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_drawer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_footer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_navbar.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktopWidth(viewportWidth);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? AppColors.publicBackground
          : theme.scaffoldBackgroundColor,
      drawer: isDesktop ? null : const UserDrawer(),
      body: CustomScrollView(
        slivers: [
          UserNavBar(isDesktop: isDesktop),
          const SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'about_intro',
              child: AboutIntroSection(),
            ),
          ),
          const SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'about_highlights',
              child: AboutHighlightStrip(),
            ),
          ),
          const SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'about_values',
              child: AboutValuesSection(),
            ),
          ),
          const SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'about_family_story',
              child: AboutFamilyStorySection(),
            ),
          ),
          const SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'about_process',
              child: AboutProcessSection(),
            ),
          ),
          const SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'about_testimonials',
              child: AboutTestimonialsSection(),
            ),
          ),
          SliverToBoxAdapter(child: UserFooter(isDesktop: isDesktop)),
        ],
      ),
    );
  }
}
