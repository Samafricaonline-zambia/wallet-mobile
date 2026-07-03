import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/international_payments.dart';
import 'package:sampay_wallet/core/themes/app_theme.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_option_tile.dart';

class CountriesList extends StatelessWidget {
  final Function(int optionIndex)? onClick;
  const CountriesList({super.key, this.onClick});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return SimpleOptionTile(
          image: InternationalPaymentsConstants.countries[index].image,
          title: InternationalPaymentsConstants.countries[index].title,
          description:
              InternationalPaymentsConstants.countries[index].description,
          badgeText: InternationalPaymentsConstants.countries[index].badgeText,
          backgroundColor: index % 2 == 0
              ? AppTheme.currentTheme.colorScheme.light
              : null,
          onClick: () => onClick?.call(index),
        );
      },
      separatorBuilder: (context, index) => EmptySpace.small(),
      itemCount: InternationalPaymentsConstants.countries.length,
    );
    ;
  }
}
