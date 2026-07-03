// Simple minimal side menu

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/models/bottom_bar_item_model.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/services/storage_service.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/biometric_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_avatar.dart';
import 'package:sampay_wallet/core/widgets/simple_divider.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/core/widgets/simple_floating_action_button.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/services/authentication_service.dart';

class SimpleSideMenu extends StatelessWidget {
  final StorageService storageService = getIt<StorageService>();
  final AuthenticationService authService = getIt<AuthenticationService>();

  final bool isLoading;
  final String userName;
  final String photoPath;

  SimpleSideMenu({
    super.key,
    this.isLoading = false,
    this.photoPath = "",
    this.userName = "",
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    void closeMenu() => context.pop();

    void handleOptionClick(String route) {
      if (route.isEmpty) {
        SimpleToast.showErrorToast(
          "Unable to go to the selected option.",
          context,
        );
        return;
      }

      closeMenu();
      context.push(route);
    }

    void handleLogout() async {
      closeMenu();
      authService.logout(
        onComplete: () {
          if (context.mounted) {
            context.go(AppRoutes.login);
          }
        },
      );
      // storageService.clear();
      // await BiometricUtils.clearSecuredStore();
    }

    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          Container(
            //height: 250,
            padding: EdgeInsets.fromLTRB(
              AppConstants.STANDARD_PAGE_PADDING,
              50,
              AppConstants.STANDARD_PAGE_PADDING,
              0,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.splashBackground),
                fit: .cover,
              ),
            ),
            child: Column(
              children: [
                SimpleFlex(
                  rightChild: SimpleFloatingActionButton(
                    icon: AppIcons.close,
                    onClick: closeMenu,
                  ),
                ),
                EmptySpace(),
                Container(
                  height: 100,
                  padding: EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
                  decoration: BoxDecoration(
                    color: appTheme.white.withAlpha(50),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        AppConstants.STANDARD_BORDER_RADIUS,
                      ),
                      topRight: Radius.circular(
                        AppConstants.STANDARD_BORDER_RADIUS,
                      ),
                    ),
                  ),
                  child: SimpleFlex(
                    alignment: .center,
                    leftChild: SimpleAvatar(userName: userName),
                    rightChild: SimpleAppText(
                      userName,
                      color: appTheme.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppConstants.STANDARD_PAGE_PADDING - 7,
              5,
              AppConstants.STANDARD_PAGE_PADDING - 7,
              5,
            ),
            child: Column(
              children: List.generate(AppConstants.SIDE_MENU_ITEMS.length, (
                index,
              ) {
                return createMenuTile(
                  context,
                  isDisabled: AppUtils()
                      .valueOrDefault(AppConstants.SIDE_MENU_ITEMS[index].route)
                      .isEmpty,
                  AppConstants.SIDE_MENU_ITEMS[index],
                  onClick: () => handleOptionClick(
                    AppConstants.SIDE_MENU_ITEMS[index].route ?? "",
                  ),
                );
              }),
            ),
          ),
          SimpleDivider(
            color: appTheme.borderLight,
            padding: EdgeInsets.all(0),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppConstants.STANDARD_PAGE_PADDING - 7,
              0,
              AppConstants.STANDARD_PAGE_PADDING - 7,
              0,
            ),
            child: createMenuTile(
              context,
              AppConstants.LOGOUT,
              bgColor: Colors.red.shade100,
              color: appTheme.primary,
              iconColor: appTheme.primary,
              isShowTrailing: false,
              fontWeight: FontWeight.w900,
              onClick: handleLogout,
            ),
          ),
        ],
      ),
    );
  }

  Widget createMenuTile(
    BuildContext context,
    IconItemModel item, {
    Color? bgColor,
    Color? color,
    Color? iconColor,
    Color? trailingColor,
    bool isShowTrailing = true,
    FontWeight? fontWeight,
    VoidCallback? onClick,
    bool isDisabled = false,
  }) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    return Card(
      color: bgColor,
      child: ListTile(
        enabled: !isDisabled,
        leading: Icon(
          item.icon,
          color: isDisabled ? appTheme.borderLight : iconColor,
        ),
        title: SimpleAppText(
          item.label ?? "",
          color: isDisabled ? appTheme.borderLight : color,
          fontWeight: fontWeight,
        ),
        trailing: isShowTrailing
            ? Icon(
                AppIcons.next,
                color: isDisabled ? appTheme.borderLight : trailingColor,
              )
            : null,
        onTap: onClick,
      ),
    );
  }
}
