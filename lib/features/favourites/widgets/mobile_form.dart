import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/app_labels.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_card.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/features/favourites/models/favourite_item_model.dart';
import 'package:sampay_wallet/features/favourites/services/favourites_service.dart';
import 'package:watch_it/watch_it.dart';

class MobileFavouritesForm extends StatelessWidget with WatchItMixin {
  final FavouritesService favouritesService = getIt<FavouritesService>();
  final Function(FavouriteItemModel newItem)? onSubmit;
  final bool isNewEntry;
  MobileFavouritesForm({super.key, this.onSubmit, this.isNewEntry = true});

  @override
  Widget build(BuildContext context) {
    final FavouriteItemModel newFavourite = watchValue(
      (ValueNotifier<FavouriteItemModel> m) => m,
      instanceName: "newFavourite",
    );

    return SimpleCard(
      child: SimpleForm(
        onSubmit: () => onSubmit?.call(newFavourite),
        isFullWidth: true,
        actionTitle: isNewEntry
            ? AppLabels.ADD_FAVOURITES_ACTION_LABLE
            : AppLabels.UPDATE_FAVOURITES_ACTION_LABLE,
        children: [
          SimpleTextField(
            labelText: "Mobile number",
            icon: AppIcons.phone,
            initialValue: newFavourite.accountNumber,
            prefixText: "+260",
            keyboardType: .number,
            onValueChanged: (value) => favouritesService.updateNewFavourite(
              newFavourite.copyWith(accountNumber: value),
            ),
            validator: (v) => AppValidations.validatePhoneNumber(v),
          ),
          EmptySpace(),
          SimpleTextField(
            labelText: "Tag",
            icon: AppIcons.tag,
            initialValue: newFavourite.tag,
            onValueChanged: (value) => favouritesService.updateNewFavourite(
              newFavourite.copyWith(tag: value),
            ),
            validator: (v) => AppValidations.validateNotNone(
              v,
              message: "Enter tag for the favourite",
            ),
          ),
        ],
      ),
    );
  }
}
