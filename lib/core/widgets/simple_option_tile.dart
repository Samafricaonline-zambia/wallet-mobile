import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/core/widgets/simple_pill.dart';
import 'package:sampay_wallet/core/widgets/simple_ripple_wrapper.dart';

class SimpleOptionTile extends StatelessWidget {
  final String? image;
  final String? title;
  final String? description;
  final Color? backgroundColor;
  final VoidCallback? onClick;
  final bool isDisabled;
  final String badgeText;

  const SimpleOptionTile({
    super.key,
    this.image,
    this.title = "",
    this.description = "",
    this.backgroundColor,
    this.onClick,
    this.isDisabled = false,
    this.badgeText = "",
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    final bool isItemDisabled = isDisabled || (onClick == null);

    return SimpleRippleWrapper(
      splashColor: isItemDisabled ? Colors.transparent : null,
      padding: EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING / 2),
      backgroundColor: backgroundColor,
      onTap: onClick,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            child: Image.asset(
              opacity: AlwaysStoppedAnimation(isItemDisabled ? 0.2 : 1),
              image ?? "",
              width: 50,
              height: 50,
              fit: BoxFit.scaleDown,
            ),
          ),

          Expanded(
            // This is key - allows text to take remaining space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (badgeText.isEmpty)
                  SimpleAppText(
                    title ?? "",
                    fontWeight: FontWeight.w900,
                    shouldWrap: true,
                    color: appTheme.black.withAlpha(isItemDisabled ? 70 : 255),
                  ),
                if (badgeText.isNotEmpty)
                  SimpleFlex(
                    children: [
                      SimpleAppText(
                        title ?? "",
                        fontWeight: FontWeight.w900,
                        shouldWrap: true,
                        color: appTheme.black.withAlpha(
                          isItemDisabled ? 70 : 255,
                        ),
                      ),
                      SimplePill.warning(badgeText),
                    ],
                  ),
                SimpleAppText.small(
                  description ?? "",
                  shouldWrap: true,
                  color: appTheme.black.withAlpha(isItemDisabled ? 70 : 255),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // return Container(
    //   padding: EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING / 2),
    //   decoration: BoxDecoration(
    //     color: backgroundColor,
    //     borderRadius: BorderRadius.circular(
    //       AppConstants.STANDARD_BORDER_RADIUS,
    //     ),
    //   ),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     mainAxisSize: MainAxisSize.max,
    //     children: [
    //       Card(
    //         child: Image.asset(
    //           image ?? "",
    //           width: 50,
    //           height: 50,
    //           fit: BoxFit.scaleDown,
    //         ),
    //       ),

    //       Expanded(
    //         // This is key - allows text to take remaining space
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             SimpleAppText(
    //               title ?? "",
    //               fontWeight: FontWeight.w900,
    //               shouldWrap: true,
    //             ),
    //             SimpleAppText.small(description ?? "", shouldWrap: true),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
