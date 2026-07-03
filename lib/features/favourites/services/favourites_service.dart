import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sampay_wallet/core/constants/storage_keys.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/services/storage_service.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/features/favourites/models/favourite_item_model.dart';

class FavouritesService extends ChangeNotifier {
  late StorageService storageService;
  ValueNotifier<int> selectedCategoryIndex = ValueNotifier<int>(-1);
  ValueNotifier<FavouriteItemModel> newFavourite =
      ValueNotifier<FavouriteItemModel>(FavouriteItemModel());
  ValueNotifier<List<FavouriteItemModel>> favourites =
      ValueNotifier<List<FavouriteItemModel>>([]);

  FavouritesService() {
    storageService = getIt<StorageService>();
    fetchStoredFavourites();
  }

  void fetchStoredFavourites() {
    try {
      final storedFavourites = storageService.read(AppStorageKeys.favourites);

      // Check if stored data is null or empty
      if (storedFavourites.isEmpty) {
        favourites.value = [];
        notifyListeners();
        return;
      }

      // Parse JSON safely
      final decoded = json.decode(storedFavourites);

      // Check if decoded is a List
      if (decoded is! List) {
        favourites.value = [];
        notifyListeners();
        return;
      }

      // Convert to FavouriteItemModel using map instead of forEach
      final favouritesFromStorage = decoded
          .map((element) => FavouriteItemModel.fromJson(element))
          .toList();

      favourites.value = favouritesFromStorage;
    } catch (e) {
      // Handle any parsing errors
      print('Error fetching stored favourites: $e');
      favourites.value = [];
    }

    notifyListeners();
  }

  void storeFavourites() {
    storageService.save(
      AppStorageKeys.favourites,
      json.encode(favourites.value),
    );
  }

  void setSelectedCategoryIndex(int value) {
    selectedCategoryIndex.value = value;

    notifyListeners();
  }

  void updateNewFavourite(FavouriteItemModel value) {
    newFavourite.value = value;

    notifyListeners();
  }

  void addToFavourites(FavouriteItemModel value) {
    final List<FavouriteItemModel> updatedFavourites = [
      ...favourites.value,
      value,
    ];

    updatedFavourites.sort(
      (a, b) => AppUtils()
          .valueOrDefault(a.tag)
          .compareTo(AppUtils().valueOrDefault(b.tag)),
    );

    favourites.value = updatedFavourites;

    storeFavourites();
    notifyListeners();
  }

  void updateFavourites(
    FavouriteItemModel oldValue,
    FavouriteItemModel newValue,
  ) {
    final List<FavouriteItemModel> updatedFavourites = favourites.value
        .where((item) => item != oldValue)
        .toList();

    updatedFavourites.add(newValue);
    updatedFavourites.sort(
      (a, b) => AppUtils()
          .valueOrDefault(a.tag)
          .compareTo(AppUtils().valueOrDefault(b.tag)),
    );

    favourites.value = updatedFavourites;

    storeFavourites();
    notifyListeners();
  }
}
