import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/models/bottom_bar_item_model.dart';

class FavouriteCategoryModel {
  final IconItemModel item;
  final BillMerchantType merchantType;

  FavouriteCategoryModel({required this.item, required this.merchantType});

  FavouriteCategoryModel copyWith({
    IconItemModel? item,
    BillMerchantType? merchantType,
  }) {
    return FavouriteCategoryModel(
      item: item ?? this.item,
      merchantType: merchantType ?? this.merchantType,
    );
  }

  @override
  String toString() =>
      'FavouriteCategoryModel(item: $item, merchantType: $merchantType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FavouriteCategoryModel &&
        other.item == item &&
        other.merchantType == merchantType;
  }

  @override
  int get hashCode => item.hashCode ^ merchantType.hashCode;
}
