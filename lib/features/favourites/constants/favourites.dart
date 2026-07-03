import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/models/bottom_bar_item_model.dart';
import 'package:sampay_wallet/features/favourites/models/favourite_category_model.dart';

class Favourites {
  static List<FavouriteCategoryModel> items = [
    FavouriteCategoryModel(
      item: IconItemModel(icon: AppIcons.phone, label: 'Phone Numbers'),
      merchantType: .airtime,
    ),
    FavouriteCategoryModel(
      item: IconItemModel(
        //icon: AppIcons.bills,
        image: AppAssets.payMerchant,
        label: 'Merchant Accounts',
      ),
      merchantType: .airtime,
    ),
    FavouriteCategoryModel(
      item: IconItemModel(
        //icon: AppIcons.chart,
        image: AppAssets.zesco,
        label: 'Zesco Accounts',
      ),
      merchantType: .electricity,
    ),
    FavouriteCategoryModel(
      item: IconItemModel(
        //icon: AppIcons.cart,
        image: AppAssets.dstv,
        label: 'DSTV Accounts',
      ),
      merchantType: .cableTv,
    ),
    FavouriteCategoryModel(
      item: IconItemModel(
        //icon: AppIcons.cart,
        image: AppAssets.gotv,
        label: 'GoTV Accounts',
      ),
      merchantType: .cableTv,
    ),
    FavouriteCategoryModel(
      item: IconItemModel(
        //icon: AppIcons.cart,
        image: AppAssets.topStar,
        label: 'TopStar Accounts',
      ),
      merchantType: .cableTv,
    ),
    FavouriteCategoryModel(
      item: IconItemModel(
        //icon: AppIcons.cart,
        image: AppAssets.boxOffice,
        label: 'BoxOffice Accounts',
      ),
      merchantType: .cableTv,
    ),
    FavouriteCategoryModel(
      item: IconItemModel(
        //icon: AppIcons.cart,
        image: AppAssets.liquid,
        label: 'Liquid Accounts',
      ),
      merchantType: .data,
    ),
  ];
}
