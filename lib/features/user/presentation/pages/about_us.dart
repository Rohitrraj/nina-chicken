import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/animated_scroll_item.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_navbar.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_footer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_drawer.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktopWidth(screenWidth);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF0),
      drawer: isDesktop ? null : const UserDrawer(),
      bottomNavigationBar: UserFooter(isDesktop: isDesktop),
      body: CustomScrollView(
        slivers: [
          UserNavBar(isDesktop: isDesktop),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64.0 : 24.0,
                vertical: 48.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedScrollItem(
                    id: 'about_title',
                    child: const Text(
                      "About Us",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedScrollItem(
                    id: 'about_desc',
                    child: const Text(
                      "Kedai Ayam Nina adalah rumah bagi pencinta ayam goreng sejati. Didirikan di jantung Jakarta Barat pada tahun 2023, kami berkomitmen menghadirkan pengalaman kuliner yang tak terlupakan. Nama Ayam Nina sendiri kami abadikan dari nama putri tercinta, sebagai simbol kasih sayang dan ketulusan yang kami tuangkan dalam setiap masakan.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Placeholder for team or history
                  AnimatedScrollItem(
                    id: 'about_image',
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://images.unsplash.com/photo-1549488344-1f9b8d2bd1f3?q=80&w=1000&auto=format&fit=crop",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
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
