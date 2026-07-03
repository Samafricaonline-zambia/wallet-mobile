import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/models/bottom_bar_item_model.dart';
import 'package:sampay_wallet/core/models/simple_item_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/bottom_sheet_utils.dart';
import 'package:sampay_wallet/core/utils/string_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_list.dart';
import 'package:sampay_wallet/core/widgets/simple_tile.dart';
import 'package:sampay_wallet/features/favourites/constants/favourites.dart';
import 'package:sampay_wallet/features/favourites/models/favourite_category_model.dart';
import 'package:sampay_wallet/features/favourites/models/favourite_item_model.dart';
import 'package:sampay_wallet/features/favourites/services/favourites_service.dart';
import 'package:sampay_wallet/features/favourites/widgets/mobile_form.dart';
import 'package:watch_it/watch_it.dart';

class FavouritesDetailPage extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const FavouritesDetailPage({super.key});

  @override
  State<FavouritesDetailPage> createState() => _FavouritesDetailPageState();
}

class _FavouritesDetailPageState extends State<FavouritesDetailPage> {
  final FavouritesService favouritesService = getIt<FavouritesService>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    BottomSheetUtils bottomSheet = BottomSheetUtils(context);

    final int selectedCategoryIndex = watchValue(
      (ValueNotifier<int> m) => m,
      instanceName: "selectedFavouritesCategoryIndex",
    );
    final List<FavouriteItemModel> favourites = watchValue(
      (ValueNotifier<List<FavouriteItemModel>> m) => m,
      instanceName: "favourites",
    );

    final String categoryName = selectedCategoryIndex > -1
        ? AppUtils().valueOrDefault(
            Favourites.items[selectedCategoryIndex].item.label,
          )
        : "";

    final List<FavouriteItemModel> filteredFavourites = favourites
        .where(
          (element) => StringUtils.areEqual(
            element.category?.toLowerCase(),
            Favourites.items[selectedCategoryIndex].item.label?.toLowerCase(),
          ),
        )
        .toList();

    void closeBottomSheet() {
      if (context.mounted) {
        context.pop();
      }
    }

    void handleNewFavouriteItem(
      FavouriteItemModel value, {
      FavouriteItemModel? oldValue,
    }) {
      if (oldValue == null) {
        favouritesService.addToFavourites(value);
      } else {
        favouritesService.updateFavourites(oldValue, value);
      }

      closeBottomSheet();
    }

    void showAddUpdateFavourites({FavouriteItemModel? value}) {
      favouritesService.updateNewFavourite(value ?? FavouriteItemModel());
      if (Favourites.items[selectedCategoryIndex].merchantType ==
          .electricity) {
        bottomSheet.open(Placeholder());
      }

      bottomSheet.open(
        MobileFavouritesForm(
          isNewEntry: value == null,
          onSubmit: (newItem) => handleNewFavouriteItem(
            newItem.copyWith(
              category: Favourites.items[selectedCategoryIndex].item.label,
            ),
            oldValue: value,
          ),
        ),
      );
    }

    return OptionsLayout(
      scaffoldKey: scaffoldKey,
      title: "Favourites",
      pageTitle: categoryName,
      isPadding: false,
      pageDescription: "Manage favourites for $categoryName",
      floatingActionButton: FloatingActionButton(
        backgroundColor: appTheme.primary,
        onPressed: showAddUpdateFavourites,
        shape: CircleBorder(),
        //child: Icon(AppIcons.plus, color: appTheme.white),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return RotationTransition(
              turns: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: Icon(AppIcons.plus, color: appTheme.white),
        ),
      ),
      child: Expanded(
        child: SimpleList(
          itemCount: filteredFavourites.length,
          itemBuilder: (BuildContext context, int index) {
            return SimpleTile(
              onClick: () {
                showAddUpdateFavourites(value: filteredFavourites[index]);
              },
              padding: 5,
              isShowAvatar: true,
              item: SimpleItemModel(
                title: AppUtils().valueOrDefault(filteredFavourites[index].tag),
                subTitle: AppUtils().formatPhoneNumber(
                  AppUtils().valueOrDefault(
                    filteredFavourites[index].accountNumber,
                  ),
                ),
              ),
              action: Icon(AppIcons.edit),
            );
          },
        ),
      ),
    );
  }
}
