// lib/core/constants/ecommerce_constants.dart
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/models/ecommerce_model.dart';

class EcommerceConstants {
  // Private constructor to prevent instantiation
  EcommerceConstants._();

  static final EcommerceModel sampayBusiness = EcommerceModel(
    image: AppAssets.sampayBusiness,
    link: AppAssets.sampayBusinessUrl,
    title: "Sampay Business",
  );

  // Static list of all ecommerce options
  static final List<EcommerceModel> ecommerceOptions = [
    EcommerceModel(
      image: AppAssets.sambeziLogo,
      link: AppAssets.sambeziUrl,
      title: "Sambezi",
    ),
    EcommerceModel(
      image: AppAssets.samrentLogo,
      link: AppAssets.samrentUrl,
      title: "Samrent",
    ),
    EcommerceModel(
      image: AppAssets.samshopLogo,
      link: AppAssets.samshopUrl,
      title: "Samshop",
    ),
    EcommerceModel(
      image: AppAssets.sammembershipLogo,
      link: AppAssets.sammembershipUrl,
      title: "Sammembership",
    ),
    EcommerceModel(
      image: AppAssets.samchilimbaLogo,
      link: AppAssets.samchilimbaUrl,
      title: "Samchilimba",
    ),
    EcommerceModel(
      image: AppAssets.ieczLogo,
      link: AppAssets.ieczUrl,
      title: "IECZ",
    ),
    EcommerceModel(
      image: AppAssets.sameatsLogo,
      link: AppAssets.sameatsUrl,
      title: "Sameats",
    ),
    EcommerceModel(
      image: AppAssets.samticketsLogo,
      link: AppAssets.samticketsUrl,
      title: "Samtickets",
    ),
    EcommerceModel(
      image: AppAssets.samgamingLogo,
      link: AppAssets.samgamingUrl,
      title: "Samgaming",
    ),
    EcommerceModel(
      image: AppAssets.lionZoneLogo,
      link: AppAssets.lionZoneUrl,
      title: "LionZone",
    ),
    EcommerceModel(
      image: AppAssets.samfinLogo,
      link: AppAssets.samfinUrl,
      title: "Samfin",
    ),
  ];
}
