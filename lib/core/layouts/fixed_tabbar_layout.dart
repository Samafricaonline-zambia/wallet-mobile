import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/services/authentication_service.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/widgets/simple_bottom_bar.dart';
import 'package:sampay_wallet/core/widgets/simple_floating_action_button.dart';
import 'package:sampay_wallet/core/widgets/simple_modal_progress.dart';
import 'package:sampay_wallet/core/widgets/simple_side_menu.dart';

class FixedTabbarLayout extends StatelessWidget {
  final List<Widget>? children;
  final int selectedTabBarIndex;
  final bool isLoading;
  final Function(int index)? onTabIndexChange;

  const FixedTabbarLayout({
    super.key,
    this.children,
    this.selectedTabBarIndex = -1,
    this.isLoading = false,
    this.onTabIndexChange,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final AppStateService appState = getIt<AppStateService>();

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

    return Scaffold(
      key: scaffoldKey,
      body: SimpleModalProgress(
        isLoading: isLoading,
        Stack(
          fit: StackFit.expand,
          children: [
            if (children != null) ...children!,
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
      ),
      drawer: SimpleSideMenu(userName: appState.loggedInUser.value!.user.name),
      bottomNavigationBar: SimpleFloatingBottomBar(
        selectedTabIndex: selectedTabBarIndex,
        onTap: (int index) {
          print('click index=$index');
          if (onTabIndexChange != null) {
            onTabIndexChange!(index);
          }
          handleTabChange(index);
        },
      ),
    );
  }
}
