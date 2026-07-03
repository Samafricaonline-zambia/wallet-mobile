import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    return OptionsLayout(
      title: "About Us",
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
                      'About Sampay',
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
                      // Hero Image or Icon with FadeIn animation
                      FadeInImageSection(),
                      const SizedBox(height: 24),
                      // Introduction Section
                      _buildSection(
                        title: "Sampay at a Glance",
                        description:
                            'Sampay is a financial product by Samafrica Online Zambia Limited. With Sampay, you have the power of E-money at your fingertips.',
                        icon: Icons.currency_exchange,
                        delay: 200,
                        appTheme: appTheme,
                      ),
                      const SizedBox(height: 32),
                      // The Dream Section
                      _buildSection(
                        title: "The Dream",
                        description:
                            'The dream was to create a digital product that would allow a simple fisherman from a village in Samfya to buy a pair of Nikes from London and get it delivered to his doorstep.\n\nNow the dream has become so much more. Our services are now centered on ensuring that we attain financial inclusion for every Zambian with access to financial and commercial products and services at the most affordable cost.',
                        icon: Icons.draw,
                        delay: 400,
                        isExpanded: true,
                        appTheme: appTheme,
                      ),
                      const SizedBox(height: 32),
                      // Who We Are Section
                      _buildSection(
                        title: "Who We Are",
                        description:
                            'Samafrica Online Zambia Limited is a Technology Platform and Digital Payments Company that offers web and mobile payments on behalf of merchants and consumers. The company was designated as a Payment Systems Business by the Central Bank of Zambia in January, 2019 and is fully licensed to issue e-money through its payment application called Sampay.\n\nThe company\'s payment solutions include Samchilimba, a Village Banking product that enable consumers to manage a community based fund and operate an internal lending and savings group.\n\nThrough our Sampay Application, we facilitate the processing of payments throughout Zambia for the purchase and payments of goods and services, as well as the transfer and withdraw of funds through our network of agents and other third-party partners such as banks and mobile money operators.',
                        icon: Icons.business,
                        delay: 600,
                        isExpanded: true,
                        appTheme: appTheme,
                      ),
                      const SizedBox(height: 32),
                      // Our Vision Section
                      _buildSection(
                        title: "Our Vision",
                        description:
                            'Our vision is to simplify internet payments to suit every person in Africa. To allow the simplest person in a typical African Village to purchase any good or service from the largest providers in the world and get it delivered to their front door. An all-encompassing payment and communication software built by Africans for Africans.',
                        icon: Icons.visibility,
                        delay: 800,
                        isExpanded: true,
                        appTheme: appTheme,
                      ),
                      // const SizedBox(height: 48),
                      // // Call to Action or Footer
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

  Widget _buildSection({
    required String title,
    required String description,
    required IconData icon,
    required int delay,
    required ColorScheme appTheme,
    bool isExpanded = false,
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
          color: Colors.white.withAlpha(220),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
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
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                height: 1.6,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
              textAlign: isExpanded ? TextAlign.justify : TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    return Center(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1000),
        builder: (context, double value, child) {
          return Transform.scale(scale: value, child: child);
        },
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
            shadowColor: Colors.black.withAlpha(100),
          ),
        ),
      ),
    );
  }
}

// Custom widget for hero image with fade-in
class FadeInImageSection extends StatelessWidget {
  const FadeInImageSection({super.key});

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
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage(AppAssets.logo), // Reuse app asset
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
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
                'Empowering Financial Inclusion',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
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
