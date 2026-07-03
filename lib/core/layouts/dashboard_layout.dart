//import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
//import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/models/wallet_balance_model.dart';
import 'package:sampay_wallet/core/models/wallet_model.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/services/authentication_service.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/services/wallet_service.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/dashboard_header.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_bottom_bar.dart';
import 'package:sampay_wallet/core/widgets/simple_floating_action_button.dart';
import 'package:sampay_wallet/core/widgets/simple_modal_progress.dart';
import 'package:sampay_wallet/core/widgets/simple_side_menu.dart';
import 'package:watch_it/watch_it.dart';

class DashboardLayout extends WatchingWidget {
  final Widget? child;
  final Widget? footer;
  final bool isLoading;
  final bool isNoPadding;
  final bool isNoScroll;
  final bool isShowBackButton;
  final int selectedTabBarIndex;
  final Function(int index)? onTabIndexChange;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DashboardLayout({
    super.key,
    this.child,
    this.isLoading = false,
    //this.scaffoldKey,
    this.isNoPadding = false,
    this.isNoScroll = false,
    this.isShowBackButton = false,
    this.selectedTabBarIndex = -1,
    this.footer,
    this.onTabIndexChange,
  });

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authService = getIt<AuthenticationService>();
    final WalletService walletService = getIt<WalletService>();
    final AppStateService appState = getIt<AppStateService>();

    final WalletBalanceModel? walletBalance = watchValue(
      (ValueNotifier<WalletBalanceModel?> m) => m,
      instanceName: "walletBalance",
    );

    final bool isAppLoading = watchValue(
      (ValueNotifier<bool> m) => m,
      instanceName: "isAppLoading",
    );

    final double totalHeight = AppUtils().getScreenHeight(context);
    final double totalWidth = AppUtils().getScreenWidth(context);
    final double topMargin = 80;
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    if (walletBalance == null) {
      () async {
        await walletService.fetchWalletBalance();
      };
    }

    void handleTabChange(int index) {
      switch (index) {
        case 1:
          context.push(AppRoutes.bills);
          return;

        case 2:
          context.push(AppRoutes.reports);
          return;

        case 3:
          context.push(AppRoutes.ecommerce);
          return;

        default:
          context.push(AppRoutes.dashboard);
          return;
      }
    }

    final WalletModel localWallet = WalletModel(
      title: "Local Wallet",
      currency: walletBalance != null
          ? walletBalance.balances!.local!.currency ?? "ZMW"
          : "ZMW",
      balance: walletBalance != null
          ? AppUtils().parseAmount(walletBalance.balances!.local!.amount)
          : 0.0,
      isActive: walletBalance != null
          ? walletBalance.balances!.local!.accountStatus == "active"
          : false,
    );
    final WalletModel internationalWallet = WalletModel(
      title: "International Wallet",
      currency: "ZMW",
      balance: walletBalance != null
          ? AppUtils().parseAmount(
              walletBalance.balances!.international!.amount,
            )
          : 0.0,
      isActive: walletBalance != null
          ? walletBalance.balances!.international!.accountStatus == "active"
          : false,
    );

    EdgeInsetsGeometry createChildPadding() {
      return isNoPadding
          ? EdgeInsets.zero
          : EdgeInsets.only(
              left: AppConstants.STANDARD_PAGE_PADDING,
              right: AppConstants.STANDARD_PAGE_PADDING,
              bottom: AppConstants.STANDARD_PAGE_PADDING,
              top: topMargin,
            );
    }

    Widget createChild() {
      if (isNoScroll && child != null) {
        return child ?? EmptySpace();
      }

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: createChildPadding(),
        child: child,
      ).onTap(() => AppUtils().hideKeyboard(context));
    }

    Widget normalState() {
      return SimpleModalProgress(
        isLoading: isLoading || isAppLoading,
        Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Container(
                  width: totalWidth,
                  height: totalHeight * 0.32,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        AppAssets.splashBackground,
                      ), // Local asset
                      fit: BoxFit.cover,
                      alignment: AlignmentGeometry
                          .centerRight, // or BoxFit.contain, BoxFit.fill, etc.
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        AppConstants.STANDARD_UPPER_BORDER_RADIUS,
                      ),
                      bottomRight: Radius.circular(
                        AppConstants.STANDARD_UPPER_BORDER_RADIUS,
                      ),
                    ),
                  ),
                  child: EmptySpace(),
                ).onTap(() => AppUtils().hideKeyboard(context)),

                // Main content - Takes remaining space
                Expanded(
                  child: Container(
                    width: totalWidth,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: createChild(),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              top: totalHeight * 0.10,
              //height: totalHeight * 0.35,
              child: DashboardHeader(
                localWallet: localWallet,
                internationalWallet: internationalWallet,
                onLoadWalletClick: () async {
                  context.push(AppRoutes.loadWallet);
                },
                onRefreshWalletClick: () {
                  walletService.fetchWalletBalance();
                },
                onSendMoneyClick: () {
                  context.push(AppRoutes.transferPayment);
                  // DialogUtils().openModalDialog(
                  //   title: "Money Transfer",
                  //   context,
                  //   LocalMoneyTransferOptions(),
                  // );
                },
              ),
            ),
            Positioned(
              top: 40, // Adjust as needed
              left: 16, // Adjust as needed
              child: SimpleFloatingActionButton(
                icon: AppIcons.menu,
                onClick: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      //draggableBody: false,
      //dismissOnClick: true,
      key: scaffoldKey,
      body: normalState(),
      //bottomSheet: DefaultBottomSheet(child: Placeholder()),
      drawer: SimpleSideMenu(
        userName: appState.loggedInUser.value?.user.name ?? "",
      ),
      bottomNavigationBar: SimpleFloatingBottomBar(
        selectedTabIndex: selectedTabBarIndex,
        onTap: (int index) {
          if (onTabIndexChange != null) {
            onTabIndexChange!(index);
          }
          handleTabChange(index);
        },
      ),
      // bottomNavigationBar: SimpleBottomBar(
      //   selectedTabIndex: selectedTabBarIndex,
      //   onTap: (int index) {
      //     if (index != selectedTabBarIndex) {
      //       onTabIndexChange?.call(index);
      //       handleTabChange(index);
      //     }
      //   },
      // ),
    );
  }
}
