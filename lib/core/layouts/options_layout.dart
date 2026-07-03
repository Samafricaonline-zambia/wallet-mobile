import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_modal_progress.dart';
import 'package:watch_it/watch_it.dart';

class OptionsLayout extends StatelessWidget with WatchItMixin {
  final bool isCenterTile;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String title;
  final String pageTitle;
  final String pageDescription;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final Widget? child;
  final bool isLoading;
  final bool isPadding;
  final bool isScrolling;
  final VoidCallback? onClick;
  final Widget? floatingActionButton;

  const OptionsLayout({
    super.key,
    this.scaffoldKey,
    this.isCenterTile = false,
    this.title = "",
    this.pageTitle = "",
    this.pageDescription = "",
    this.bottom,
    this.actions,
    this.child,
    this.isLoading = false,
    this.isPadding = true,
    this.isScrolling = true,
    this.onClick,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    final double screenWidth = AppUtils().getScreenWidth(context);
    final double screenHeight = AppUtils().getScreenHeight(context);

    final bool isAppLoading = watchValue(
      (ValueNotifier<bool> m) => m,
      instanceName: "isAppLoading",
    );

    Widget? createPageTitle() {
      if (pageTitle.isEmpty) return child;

      return Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        children: [
          Container(
            padding: EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
            width: screenWidth,
            //height: screenHeight,
            decoration: BoxDecoration(color: appTheme.light),
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .start,
              children: [
                SimpleAppText.title(
                  pageTitle,
                  fontWeight: FontWeight.w900,
                  //color: appTheme.onPrimary,
                ),
                EmptySpace.small(),
                SimpleAppText.small(pageDescription, color: appTheme.grey),
              ],
            ),
          ),
          Expanded(
            child: isScrolling
                ? SingleChildScrollView(
                    padding: EdgeInsets.all(
                      isPadding ? AppConstants.STANDARD_PAGE_PADDING : 0,
                    ),
                    child: child,
                  )
                : isPadding
                ? Padding(
                    padding: EdgeInsetsGeometry.all(
                      AppConstants.STANDARD_PAGE_PADDING,
                    ),
                    child: child,
                  )
                : child ?? EmptySpace(),
          ),
        ],
      );
    }

    Widget createChild() {
      if (pageTitle.isEmpty) {
        return Container(
          width: screenWidth,
          height: screenHeight,
          padding: EdgeInsets.all(
            isPadding ? AppConstants.STANDARD_PAGE_PADDING : 0,
          ),
          child: isScrolling ? SingleChildScrollView(child: child) : child,
        ).onTap(() => AppUtils().hideKeyboard(context));
      }

      return Container(
        width: screenWidth,
        height: screenHeight,
        padding: EdgeInsets.all(0),
        child: createPageTitle(),
      ).onTap(() {
        AppUtils().hideKeyboard(context);
        onClick?.call();
      });
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        centerTitle: isCenterTile,
        title: SimpleAppText(
          title,
          color: appTheme.white,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
        iconTheme: IconThemeData(color: appTheme.white),
        actions: actions,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.splashBackground),
              fit: .cover,
            ),
          ),
        ),
        bottom: bottom,
      ),
      //bottomSheet: SizedBox(height: 100, child: Placeholder()),
      body: SimpleModalProgress(
        createChild(),
        isLoading: isLoading || isAppLoading,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
