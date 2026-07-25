import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/animated_scroll_item.dart';
import 'package:kedai_ayam_nina/core/widgets/card/cards.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_drawer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_footer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_navbar.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktopWidth(screenWidth);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: isDesktop ? null : const UserDrawer(),
      bottomNavigationBar: UserFooter(isDesktop: isDesktop),
      body: CustomScrollView(
        slivers: [
          UserNavBar(isDesktop: isDesktop),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 24,
                vertical: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedScrollItem(
                    id: 'contact_title',
                    child: Text(
                      'Contact Us',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedScrollItem(
                    id: 'contact_desc',
                    child: Text(
                      'Punya pertanyaan atau masukan? '
                      'Jangan ragu untuk menghubungi kami.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const AnimatedScrollItem(
                    id: 'contact_card_phone',
                    child: AppInfoCard(
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      content: '+62 895-3832-05337',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const AnimatedScrollItem(
                    id: 'contact_card_loc',
                    child: AppInfoCard(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      content: 'Jakarta Barat, Indonesia',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
