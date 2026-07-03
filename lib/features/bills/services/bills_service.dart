import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/api_endpoints.dart';
import 'package:sampay_wallet/core/models/bill_merchant_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/services/loader_service.dart';
import 'package:sampay_wallet/core/services/network_service.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/features/bills/models/bill_item_model.dart';
import 'package:sampay_wallet/features/bills/models/electricity_token_model.dart';
import 'package:sampay_wallet/services/app_state_service.dart';

class BillsService extends ChangeNotifier {
  late NetworkService networkService = getIt<NetworkService>();
  //late String accessToken
  late AppStateService appState = getIt<AppStateService>();
  late AppLoaderService appLoaderService = getIt<AppLoaderService>();

  ValueNotifier<BillMerchantModel?> selectedBillMerchant =
      ValueNotifier<BillMerchantModel?>(null);
  ValueNotifier<BillItemModel> currentBillingItem =
      ValueNotifier<BillItemModel>(BillItemModel());
  ValueNotifier<ElectricityTokensModel> electricityTokens =
      ValueNotifier<ElectricityTokensModel>(
        ElectricityTokensModel(status: false, tokens: []),
      );

  BillsService() {
    //networkService = getIt<NetworkService>();
    //appState = getIt<AppStateService>();
    // accessToken = appState.loggedInUser.value != null
    //     ? AppUtils().valueOrDefault(appState.loggedInUser.value!.accessToken)
    //     : "";
    //appLoaderService = getIt<AppLoaderService>();
  }

  void setSelectedBillMerchant(BillMerchantModel value) {
    selectedBillMerchant.value = value;

    notifyListeners();
  }

  void updateCurrentBillingItem(BillItemModel value) {
    currentBillingItem.value = value;

    notifyListeners();
  }

  Future<ElectricityTokensModel> fetchZescoTokens() async {
    try {
      appLoaderService.updateIsLoading(true);
      final NetworkResponse response = await networkService.get(
        ApiEndpoints.vasZescoTokens,
        bearerToken: appState.accessToken,
      );

      if (response.isSuccess) {
        //walletBalance.value = WalletBalanceModel.fromJson(response.data);
        electricityTokens.value = ElectricityTokensModel.fromMap(response.data);
        return ElectricityTokensModel.fromMap(response.data);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
    }

    return ElectricityTokensModel(status: false, tokens: []);
  }
}
