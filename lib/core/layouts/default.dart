import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_floating_action_button.dart';
import 'package:sampay_wallet/core/widgets/simple_modal_progress.dart';

class DefaultLayout extends StatelessWidget {
  final Widget? headerWidget;
  final Widget? child;
  final Widget? footer;
  final bool isShowLoadingState;
  final bool isLoading;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool isNoPadding;
  final bool isShowBackButton;

  const DefaultLayout({
    super.key,
    this.headerWidget,
    this.child,
    this.isShowLoadingState = false,
    this.isLoading = false,
    this.scaffoldKey,
    this.isNoPadding = false,
    this.isShowBackButton = false,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final double totalHeight = AppUtils().getScreenHeight(context);
    final double totalWidth = AppUtils().getScreenWidth(context);

    Widget loadingState() {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.splashBackground,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ).onTap(() => AppUtils().hideKeyboard(context)),

          Column(
            children: [
              SizedBox(
                height: totalHeight * 0.7, // 70% of screen height
                child: Center(
                  child: Image.asset(
                    AppAssets.logoWhite,
                    fit: BoxFit.cover,
                    width: 300,
                    //height: 100,
                  ),
                ),
              ),
              SizedBox(
                height:
                    totalHeight *
                    (footer == null ? 0.3 : 0.25), // 30% of screen height
                child: Center(
                  child:
                      child ??
                      SpinKitSpinningLines(
                        color: AppConstants.AppTheme(context).light,
                        size: 50.0,
                      ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget normalState() {
      return SimpleModalProgress(
        isLoading: isLoading,
        Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.splashBackground,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ).onTap(() => AppUtils().hideKeyboard(context)),

            Column(
              children: [
                // Logo section - Dynamic height based on screen size
                LayoutBuilder(
                  builder: (context, constraints) {
                    double logoHeight = constraints.maxHeight * 0.20;
                    // Cap the logo height
                    if (logoHeight > 200) logoHeight = 200;
                    if (logoHeight < 100) logoHeight = 100;

                    return Container(
                      width: totalWidth,
                      height: logoHeight,
                      alignment: headerWidget == null
                          ? Alignment.bottomCenter
                          : Alignment.center,
                      child:
                          headerWidget ??
                          Image.asset(
                            AppAssets.logoWhite,
                            fit: BoxFit.contain,
                            width: logoHeight * 0.8,
                          ),
                    );
                  },
                ),

                // Main content - Takes remaining space
                Expanded(
                  child: Container(
                    width: totalWidth,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          AppConstants.STANDARD_BORDER_RADIUS,
                        ),
                        topRight: Radius.circular(
                          AppConstants.STANDARD_BORDER_RADIUS,
                        ),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: isNoPadding
                                ? EdgeInsets.zero
                                : const EdgeInsets.all(
                                    AppConstants.STANDARD_PAGE_PADDING,
                                  ),
                            child: child,
                          ).onTap(() => AppUtils().hideKeyboard(context)),
                        ),
                        if (footer != null)
                          Container(
                            height: 50, // Fixed height instead of percentage
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: footer,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            if (Navigator.canPop(context) && isShowBackButton)
              Positioned(
                top: 40, // Adjust as needed
                left: 16, // Adjust as needed
                child: SimpleFloatingActionButton(),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      body: isShowLoadingState ? loadingState() : normalState(),
    );
  }
}
