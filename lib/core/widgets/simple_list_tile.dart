import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';

class SimpleListTile extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final String? image;
  final double imageSize;
  final double iconSize;
  final VoidCallback? onClick;
  final EdgeInsets? padding;
  final bool isShowTrailingIcon;

  const SimpleListTile({
    super.key,
    this.description,
    this.icon,
    this.image,
    required this.title,
    this.onClick,
    this.padding,
    this.iconSize = 50,
    this.imageSize = 50,
    this.isShowTrailingIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget? createLeadingChild() {
      if (icon != null) {
        return Icon(icon);
      }

      if (image != null) {
        return SimpleImageCard(
          image: image,
          height: imageSize,
          width: imageSize,
        );
      }

      return null;
    }

    return Card(
      child: ListTile(
        contentPadding:
            padding ??
            EdgeInsets.only(
              left: AppConstants.STANDARD_PAGE_PADDING,
              right: AppConstants.STANDARD_PAGE_PADDING / 2,
            ),
        onTap: () {
          onClick?.call();
        },

        title: SimpleAppText(title),
        subtitle: description != null
            ? SimpleAppText.small(AppUtils().valueOrDefault(description))
            : null,
        leading: createLeadingChild(),
        trailing: isShowTrailingIcon ? Icon(AppIcons.next) : null,
      ),
    );
  }
}
