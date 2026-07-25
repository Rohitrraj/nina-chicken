import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/animated_scroll_item.dart';
import 'package:kedai_ayam_nina/core/widgets/feedback/feedback.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/contact/contact.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_drawer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_footer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_navbar.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  static const String _phoneNumber = '+62 895-3832-05337';
  static const String _location = 'Jakarta Barat, Indonesia';

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktopWidth(viewportWidth);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: isDesktop ? null : const UserDrawer(),
      body: CustomScrollView(
        slivers: [
          UserNavBar(isDesktop: isDesktop),
          const SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'contact_header',
              child: ContactHeaderSection(),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'contact_information',
              child: ContactInformationPanel(
                phoneNumber: _phoneNumber,
                location: _location,
                onCopyPhone: () {
                  _copyText(
                    context,
                    value: _phoneNumber,
                    successMessage: 'Nomor telepon berhasil disalin',
                  );
                },
                onCopyLocation: () {
                  _copyText(
                    context,
                    value: _location,
                    successMessage: 'Informasi lokasi berhasil disalin',
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(child: UserFooter(isDesktop: isDesktop)),
        ],
      ),
    );
  }

  static Future<void> _copyText(
    BuildContext context, {
    required String value,
    required String successMessage,
  }) async {
    await Clipboard.setData(ClipboardData(text: value));

    if (!context.mounted) {
      return;
    }

    AppSnackbar.show(
      context,
      message: successMessage,
      type: AppSnackbarType.success,
    );
  }
}
