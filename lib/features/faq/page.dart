import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/models/simple_item_model.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_collapsible_tile.dart';
import 'package:sampay_wallet/core/widgets/simple_list.dart';

class FAQPage extends StatelessWidget {
  static final List<SimpleItemModel> faqItems = [
    SimpleItemModel(
      title: 'How To Send Money',
      description:
          'On the app dashboard, select the send icon that is on the group of buttons just below.',
      icon: AppIcons.send,
    ),
    SimpleItemModel(
      title: 'How to Pay For TV',
      description:
          'On the app home screen, select the tv option that is on the group of icons under services.',
      icon: AppIcons.mac,
    ),
    SimpleItemModel(
      title: 'How To Add Money',
      description:
          'On the app dashboard, select the load icon that is on the group of buttons just below.',
      icon: AppIcons.wallet,
    ),
    SimpleItemModel(
      title: 'How to Buy Airtime',
      description:
          'On the app home screen, select the airtime option under services.',
      icon: AppIcons.phone,
    ),
    SimpleItemModel(
      title: 'How to Buy Electricity',
      description:
          'On the app home screen, select the electricity option under services.',
      icon: AppIcons.flashLight,
    ),
  ];
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionsLayout(
      isScrolling: false,
      title: "FAQ",
      child: Column(
        children: [
          Expanded(
            child: SimpleList(
              separator: EmptySpace.small(),
              itemCount: faqItems.length,
              itemBuilder: (bContext, index) {
                return SimpleCollapsibleTile(
                  icon: faqItems[index].icon,
                  title: faqItems[index].title,
                  description: AppUtils().valueOrDefault(
                    faqItems[index].description,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
