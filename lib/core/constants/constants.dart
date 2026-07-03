// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/models/bill_merchant_model.dart';
import 'package:sampay_wallet/core/models/bottom_bar_item_model.dart';
import 'package:sampay_wallet/core/models/input_field_model.dart';
import 'package:sampay_wallet/core/models/simple_item_model.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';

enum BillMerchantType {
  none,
  airtime,
  cableTv,
  electricity,
  data;

  static BillMerchantType fromString(String value) {
    return BillMerchantType.values.firstWhere(
      (type) => type.name.toLowerCase() == value.toLowerCase(),
      orElse: () => BillMerchantType.none,
    );
  }
}

enum BillMerchants {
  airtel,
  mtn,
  zamtel,
  dstv,
  boxOffice,
  gotv,
  topStar,
  zesco,
  liquid,
  none;

  static BillMerchants fromString(String value) {
    return BillMerchants.values.firstWhere(
      (type) => type.name.toLowerCase() == value.toLowerCase(),
      orElse: () => BillMerchants.none,
    );
  }
}

enum LoadWalletSources { mobileMoney, card, zamtelCashPoint, bankDeposit }

enum InstitutionType { bank, psp, mno }

enum EnvironmentType { production, uat }

enum TransferType { bank, internationalBank, internationalWallet }

class AppConstants {
  static const double STANDARD_BORDER_RADIUS = 16;
  static const double STANDARD_UPPER_BORDER_RADIUS = 40;
  static const double STANDARD_PAGE_PADDING = 18;

  static ColorScheme AppTheme(BuildContext context) =>
      Theme.of(context).colorScheme;

  static List<IconItemModel> BOTTOM_BAR_ITEMS = [
    IconItemModel(icon: AppIcons.home, label: 'Home'),
    IconItemModel(icon: AppIcons.bills, label: 'Sambills'),
    IconItemModel(icon: AppIcons.chart, label: 'Reports'),
    IconItemModel(icon: AppIcons.cart, label: 'Samecommerce'),
  ];

  // Side menu items
  static List<IconItemModel> SIDE_MENU_ITEMS = [
    IconItemModel(
      icon: AppIcons.profile,
      label: 'Profile',
      route: AppRoutes.profile,
    ),
    IconItemModel(
      icon: AppIcons.favorites,
      label: 'Favorites',
      route: AppRoutes.favourites,
    ),
    IconItemModel(icon: AppIcons.faqs, label: 'FAQs', route: AppRoutes.faq),
    IconItemModel(
      icon: AppIcons.support,
      label: 'Support',
      route: AppRoutes.support,
    ),
    IconItemModel(
      icon: AppIcons.aboutUs,
      label: 'About Us',
      route: AppRoutes.aboutUs,
    ),
  ];

  static IconItemModel LOGOUT = IconItemModel(
    icon: AppIcons.logout,
    label: 'Logout',
    route: null,
  );

  static List<SimpleItemModel> REPORT_TABS = [
    SimpleItemModel(
      title: "Transaction \nHistory",
      icon: AppIcons.transactions,
    ),
    SimpleItemModel(title: "Spend \nAnalytics", icon: AppIcons.analytics),
  ];

  static List<String> WALLET_OPTIONS = ["Local Wallet", "International Wallet"];

  static List<BillMerchantModel> BILL_MERCHANTS = [
    BillMerchantModel(
      name: "Airtel",
      label: "Airtel",
      service: "Airtel",
      transactionType: "Direct-Topup",
      merchantType: .airtime,
      icon: AppAssets.airtel,
      inputField: InputFieldModel.airtime(),
    ),
    BillMerchantModel(
      name: "MTN",
      label: "MTN",
      service: "MTN",
      transactionType: "Direct-Topup",
      merchantType: .airtime,
      icon: AppAssets.mtn,
      inputField: InputFieldModel.airtime(),
    ),
    BillMerchantModel(
      name: "Zamtel",
      label: "Zamtel",
      service: "Zamtel",
      transactionType: "Direct-Topup",
      merchantType: .airtime,
      icon: AppAssets.zamtel,
      inputField: InputFieldModel.airtime(),
    ),

    BillMerchantModel(
      name: "DSTV",
      label: "DStv",
      service: "DStv",
      transactionType: "DStv-Topup",
      merchantType: .cableTv,
      icon: AppAssets.dstv,
      inputField: InputFieldModel.cableTv(),
    ),
    BillMerchantModel(
      name: "BoxOffice",
      label: "BoxOffice",
      service: "DStv",
      transactionType: "BoxOffice",
      merchantType: .cableTv,
      icon: AppAssets.boxOffice,
      inputField: InputFieldModel.cableTv().copyWith(
        label: "Smartcard Number",
        icon: AppIcons.smartCard,
      ),
    ),
    BillMerchantModel(
      name: "GOTV",
      label: "GOtv",
      service: "GOtv",
      transactionType: "GOtv-Topup",
      merchantType: .cableTv,
      icon: AppAssets.gotv,
      inputField: InputFieldModel.cableTv(),
    ),
    BillMerchantModel(
      name: "TopStar",
      label: "Topstar",
      service: "Topstar",
      transactionType: "Topstar-Topup",
      merchantType: .cableTv,
      icon: AppAssets.topStar,
      inputField: InputFieldModel.cableTv(),
    ),

    BillMerchantModel(
      name: "Zesco",
      label: "Zesco",
      service: "Zesco",
      transactionType: "Token",
      merchantType: .electricity,
      icon: AppAssets.zesco,
      inputField: InputFieldModel.electricity(),
    ),

    BillMerchantModel(
      name: "Liquid",
      label: "Liquid",
      service: "Liquid",
      transactionType: "Liquid",
      merchantType: .data,
      icon: AppAssets.liquid,
      inputField: InputFieldModel.data(),
    ),
  ];

  static List<String> get AIRTIME_MERCHANTS =>
      AppUtils().getMerchantNamesByType(.airtime);

  static List<String?> get CABLE_TV_MERCHANTS =>
      AppUtils().getMerchantNamesByType(.cableTv);

  static List<String?> get DATA_MERCHANTS =>
      AppUtils().getMerchantNamesByType(.data);

  static List<String?> get ELECTRICITY_MERCHANTS =>
      AppUtils().getMerchantNamesByType(.electricity);
}
