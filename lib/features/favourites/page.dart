import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_icon_tile.dart';
import 'package:sampay_wallet/features/favourites/constants/favourites.dart';
import 'package:sampay_wallet/features/favourites/services/favourites_service.dart';

class FavouritesPage extends StatelessWidget {
  final FavouritesService favouritesService = getIt<FavouritesService>();
  FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    void handleOptionClick(int index) {
      print(index);
      favouritesService.setSelectedCategoryIndex(index);
      context.push(AppRoutes.favouritesDetail);
    }

    return OptionsLayout(
      scaffoldKey: scaffoldKey,
      onClick: () {},
      title: "Favourites",
      pageTitle: "Select Category",
      pageDescription: "Choose your favourite category to manage",
      child: GridView.count(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        crossAxisCount: 2,
        children: List.generate(Favourites.items.length, (index) {
          return Card(
            child: SimpleIconTile(
              icon: Favourites.items[index].item.icon,
              image: AppUtils().valueOrDefault(
                Favourites.items[index].item.image,
              ),
              title: AppUtils().valueOrDefault(
                Favourites.items[index].item.label,
              ),
              isBordered: true,
              onClick: () => handleOptionClick(index),
            ),
          );
        }),
      ),
    );

    // return OptionsLayout(
    //   isPadding: false,
    //   isScrolling: false,
    //   title: "Favourites",
    //   child: Column(
    //     mainAxisAlignment: .start,
    //     crossAxisAlignment: .start,
    //     children: [
    //       Container(
    //         padding: EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
    //         width: screenWidth,
    //         //height: screenHeight,
    //         decoration: BoxDecoration(color: appTheme.light),
    //         child: Column(
    //           mainAxisAlignment: .center,
    //           crossAxisAlignment: .start,
    //           children: [
    //             SimpleAppText.title(
    //               "Select Category",
    //               fontWeight: FontWeight.w900,
    //               //color: appTheme.onPrimary,
    //             ),
    //             EmptySpace.small(),
    //             SimpleAppText.small(
    //               "Choose your favourite category to manage",
    //               color: appTheme.grey,
    //             ),
    //           ],
    //         ),
    //       ),
    //       Expanded(
    //         child: Padding(
    //           padding: const EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
    //           child: GridView.count(
    //             shrinkWrap: true,
    //             physics: BouncingScrollPhysics(),
    //             crossAxisCount: 2,
    //             children: List.generate(AppConstants.FAVOURITES.length, (
    //               index,
    //             ) {
    //               return Card(
    //                 child: SimpleIconTile(
    //                   icon: AppConstants.FAVOURITES[index].icon,
    //                   image: AppUtils().valueOrDefaultString(
    //                     AppConstants.FAVOURITES[index].image,
    //                   ),
    //                   title: AppUtils().valueOrDefaultString(
    //                     AppConstants.FAVOURITES[index].label,
    //                   ),
    //                   isBordered: true,
    //                   onClick: () => handleOptionClick(index),
    //                 ),
    //               );
    //             }),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
