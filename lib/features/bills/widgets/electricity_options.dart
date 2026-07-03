import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_list_tile.dart';
import 'package:sampay_wallet/core/constants/bills/electricity_options_data.dart';

class ElectricityOptions extends StatelessWidget {
  final Function(int index)? onOptionClick;
  const ElectricityOptions({super.key, this.onOptionClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 300,
      child: Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
            child: SimpleAppText(
              "What do you want to do?",
              fontWeight: FontWeight.w900,
            ),
          ),
          EmptySpace.small(),
          ...List.generate(
            ElectricityOptionsData.items.length,
            (index) => SimpleListTile(
              title: ElectricityOptionsData.items[index].title,
              description: ElectricityOptionsData.items[index].description,
              //image: ElectricityOptionsData.items[index].image,
              icon: ElectricityOptionsData.items[index].icon,
              onClick: () => onOptionClick?.call(index),
            ),
          ),
        ],
      ),
    );
  }
}
