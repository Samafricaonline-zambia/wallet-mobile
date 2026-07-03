import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/models/simple_item_model.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_avatar.dart';
import 'package:sampay_wallet/core/widgets/simple_card.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';
import 'package:sampay_wallet/core/widgets/simple_ripple_wrapper.dart';

class SimpleTile extends StatelessWidget {
  final SimpleItemModel item;
  final bool isShowAvatar;
  final Widget? action;
  final VoidCallback? onClick;
  final double? padding;

  const SimpleTile({
    super.key,
    required this.item,
    this.onClick,
    this.isShowAvatar = false,
    this.action,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildLeading({bool isDefault = true}) {
      if (isShowAvatar) {
        return SimpleCard(
          child: SimpleAppText(AppUtils().getNameInitials(item.title)),
        );
      }

      return SimpleImageCard(image: item.image, icon: item.icon);

      // if (AppUtils().valueOrDefault(item.image).isNotEmpty) {
      //   return Image(
      //     image: AssetImage(item.image!),
      //     height: !isDefault ? 50 : null,
      //     width: !isDefault ? 50 : null,
      //     fit: .fill,
      //   );
      // }

      // return Icon(item.icon);
    }

    Widget buildTitle() {
      if (AppUtils().valueOrDefault(item.subTitle).isNotEmpty) {
        return SimpleAppText.small(item.title);
      }

      return SimpleAppText.title(
        item.title,
        fontWeight: FontWeight.w900,
        shouldWrap: false,
      );
    }

    EdgeInsetsGeometry? getContentPadding() {
      if (padding != null) {
        return EdgeInsets.only(left: padding!, right: padding!);
      }

      if (AppUtils().valueOrDefault(item.description).isEmpty) {
        return EdgeInsets.all(8.0);
      }

      return null;
    }

    Widget? buildSubTitle() {
      if (AppUtils().valueOrDefault(item.subTitle).isNotEmpty) {
        return SimpleAppText(item.subTitle ?? "", fontWeight: FontWeight.w900);
      }

      if (AppUtils().valueOrDefault(item.description).isNotEmpty) {
        return SimpleAppText(item.description ?? "");
      }

      return null;
    }

    return Card(
      child: ListTile(
        contentPadding: getContentPadding(),
        title: buildTitle(),
        subtitle: buildSubTitle(),
        leading: buildLeading(),
        trailing: action,
        isThreeLine:
            AppUtils().valueOrDefault(item.subTitle).isNotEmpty ||
            AppUtils().valueOrDefault(item.description).isNotEmpty,
        onTap: onClick,
      ),
    );
  }
}
