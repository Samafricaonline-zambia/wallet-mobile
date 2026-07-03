import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    return OptionsLayout(
      title: "Support",
      isPadding: false,
      isScrolling: false,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFc0030e), // Sampay red primary
              Color(0xFF8b0000), // Deeper red for depth
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 100.0,
                floating: true,
                pinned: true,
                backgroundColor: appTheme.primary,
                automaticallyImplyLeading: false, // Remove the back arrow
                titleSpacing:
                    16.0, // Add horizontal padding for the title to avoid sticking to the wall
                flexibleSpace: FlexibleSpaceBar(
                  title: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                    ), // Additional left padding for the title
                    child: const Text(
                      'Get Help',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Section with FadeIn
                      FadeInHeroSection(),
                      const SizedBox(height: 32),
                      // Lusaka Hub
                      _buildSupportCard(
                        title: "Support",
                        phone1: '+260978788923',
                        email: 'support@samafricaonline.com',
                        icon: Icons.location_city,
                        delay: 200,
                        appTheme: appTheme,
                        context: context,
                      ),
                      // const SizedBox(height: 24),
                      // // Ndola Hub
                      // _buildSupportCard(
                      //   title: "Ndola Online Business Hub",
                      //   phone1: '+260978788923',
                      //   phone2: '+260978788923',
                      //   email: 'support@samafricaonline.com',
                      //   location:
                      //       '13 Ulengo Road, Light Industrial Area, Ndola.',
                      //   icon: Icons.location_city,
                      //   delay: 400,
                      //   appTheme: appTheme,
                      //   context: context,
                      // ),
                      // const SizedBox(height: 24),
                      // // Samchat Support
                      // _buildSupportCard(
                      //   title: "Samchat Support",
                      //   phone1: '+260978788923',
                      //   phone2: '+260978788923',
                      //   email: 'support@samafricaonline.com',
                      //   location: '18 United Nations, Long Acres, Lusaka.',
                      //   icon: Icons.chat_bubble_outline,
                      //   delay: 600,
                      //   appTheme: appTheme,
                      //   context: context,
                      // ),
                      // const SizedBox(height: 48),
                      // Footer CTA
                      // _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard({
    required String title,
    required String phone1,
    required String email,
    //required String? location,
    required IconData icon,
    required ColorScheme appTheme,
    required BuildContext context,
    required int delay,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + delay),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(230),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.white.withAlpha(128), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: appTheme.primary.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: appTheme.primary, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildContactItem(
              icon: Icons.phone,
              label: 'Call',
              child: Text(phone1, style: const TextStyle(fontSize: 16)),
              onTap: () async {
                //ExternalLinks.call(phone1);
                final isCallPlaced = await AppUtils().makePhoneCall(
                  "tel:$phone1",
                );

                if (!isCallPlaced && AppUtils().isContextValid(context)) {
                  SimpleToast.showErrorToast(
                    "Unable to place a call to $phone1",
                    context,
                  );
                }
              },
              appTheme: appTheme,
            ),
            _buildContactItem(
              icon: Icons.email_outlined,
              label: 'Email',
              child: Text(email, style: const TextStyle(fontSize: 16)),
              onTap: () async {
                //ExternalLinks.call(email);
                final isEmailSent = await AppUtils().launchEmail(
                  "mailto:$email",
                );

                if (!isEmailSent && AppUtils().isContextValid(context)) {
                  SimpleToast.showErrorToast(
                    "Unable to launch the email app",
                    context,
                  );
                }
              },
              appTheme: appTheme,
            ),
            //const SizedBox(height: 12),
            // Row(
            //   children: [
            //     Icon(
            //       Icons.location_on_outlined,
            //       size: 24,
            //       color: appTheme.primary,
            //     ),
            //     const SizedBox(width: 12),
            //     Expanded(
            //       child: SimpleAppText(
            //         location,
            //         // style: const TextStyle(
            //         //   fontFamily: 'Inter',
            //         //   fontSize: 15,
            //         //   height: 1.6,
            //         //   color: Colors.black54,
            //         // ),
            //       ).onTap(() => AppUtils().openMapWithAddress(location)),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required Widget child,
    required VoidCallback onTap,
    required ColorScheme appTheme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: appTheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  child,
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      builder: (context, double value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text(
            'Back to Home',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: appTheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

// Custom widget for hero image with fade-in
class FadeInHeroSection extends StatelessWidget {
  const FadeInHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage(AppAssets.support),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                Icons.support_agent,
                size: 80,
                color: Color.fromRGBO(255, 255, 255, 0.8),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 30,
              ),
            ),
            const Positioned(
              bottom: 16,
              right: 16,
              child: Text(
                'We\'re Here to Help',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
