import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/decorations.dart';
import 'package:sampay_wallet/core/constants/shadows.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class SimpleFloatingBottomBar extends StatefulWidget {
  final int selectedTabIndex;
  final Function(int index)? onTap;
  const SimpleFloatingBottomBar({
    super.key,
    this.onTap,
    this.selectedTabIndex = -1,
  });

  @override
  State<SimpleFloatingBottomBar> createState() =>
      _SimpleFloatingBottomBarState();
}

class _SimpleFloatingBottomBarState extends State<SimpleFloatingBottomBar> {
  //int selectedTabIndex = 0;
  final NotchBottomBarController notchBottomBarController =
      NotchBottomBarController();

  void handleTabClick(int index) {
    setState(() {
      notchBottomBarController.oldIndex = widget.selectedTabIndex;
      notchBottomBarController.index = index;
      //selectedTabIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    if (widget.selectedTabIndex > -1) {
      setState(() {
        notchBottomBarController.index = widget.selectedTabIndex;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.splashBackground),
          fit: .cover,
        ),
      ),
      child: AnimatedNotchBottomBar(
        showShadow: false,
        itemLabelStyle: TextStyle(color: appTheme.white),
        color: AppColors.white.withAlpha(50),
        //color: Colors.transparent,
        notchBottomBarController: notchBottomBarController,
        bottomBarItems: List.generate(AppConstants.BOTTOM_BAR_ITEMS.length, (
          index,
        ) {
          return BottomBarItem(
            inActiveItem: Icon(
              AppConstants.BOTTOM_BAR_ITEMS[index].icon,
              color: AppColors.white,
            ),
            activeItem: Icon(
              AppConstants.BOTTOM_BAR_ITEMS[index].icon,
              color: appTheme.primary,
            ),
            itemLabel: AppConstants.BOTTOM_BAR_ITEMS[index].label,
          );
        }),
        onTap: (int index) {
          handleTabClick(index);
          if (widget.onTap != null) {
            widget.onTap!(index);
          }
        },
        kIconSize: 18,
        kBottomRadius: 50,
      ),
    );
  }
}

class SimpleBottomBar extends StatefulWidget {
  final int selectedTabIndex;
  final Function(int index)? onTap;
  const SimpleBottomBar({super.key, this.selectedTabIndex = 0, this.onTap});

  @override
  State<SimpleBottomBar> createState() => _SimpleBottomBarState();
}

class _SimpleBottomBarState extends State<SimpleBottomBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedTabIndex;
  }

  void handleClick(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      widget.onTap?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: AppDecorations.white(shadow: AppShadows.large),
      padding: EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          AppConstants.BOTTOM_BAR_ITEMS.length,
          (index) => GestureDetector(
            onTap: () => handleClick(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: index == _selectedIndex
                    ? colorScheme.light
                    : Colors.transparent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      AppConstants.BOTTOM_BAR_ITEMS[index].icon ??
                          AppIcons.info,
                      key: ValueKey(index == _selectedIndex),
                      color: index == _selectedIndex
                          ? colorScheme.primary
                          : colorScheme.black.withAlpha(180),
                      size: 24,
                    ),
                  ),
                  if (index == _selectedIndex) ...[
                    const SizedBox(width: 8),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(-10 * (1 - value), 0),
                            child: child,
                          ),
                        );
                      },
                      child: SimpleAppText(
                        AppConstants.BOTTOM_BAR_ITEMS[index].label ?? "",
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
