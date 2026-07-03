import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/momo.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/services/wallet_service.dart';

class WalletTransferService extends ChangeNotifier {
  ValueNotifier<LoadWalletWithMOMO> transferRequest =
      ValueNotifier<LoadWalletWithMOMO>(LoadWalletWithMOMO(amount: 1));
  ValueNotifier<int> selectedServiceIndex = ValueNotifier<int>(0);
  ValueNotifier<int> selectedWalletIndex = ValueNotifier<int>(0);
  ValueNotifier<InstitutionType> selectedInstitutionType =
      ValueNotifier<InstitutionType>(.bank);

  final WalletService walletService = getIt<WalletService>();
  final AppStateService appState = getIt<AppStateService>();

  WalletTransferService() {
    // Needs to be removed as default value should be empty
    selectedServiceIndex.value = 0;
    selectedWalletIndex.value = 0;

    if (appState.loggedInUser.value != null) {
      transferRequest.value = transferRequest.value.copyWith(
        account: AppUtils().formatPhoneNumber(
          appState.loggedInUser.value!.user.phone,
        ),
        service: AppConstants.AIRTIME_MERCHANTS[selectedServiceIndex.value],
      );
    }

    notifyListeners();
  }

  void updateSelectedServiceIndex(int value) {
    selectedServiceIndex.value = value;
    notifyListeners();
  }

  void updateSelectedWalletIndex(int value) {
    selectedWalletIndex.value = value;
    notifyListeners();
  }

  void updateTransferRequest(LoadWalletWithMOMO value) {
    transferRequest.value = value;
    notifyListeners();
  }

  void updateSelectedInstitutionType(InstitutionType value) {
    selectedInstitutionType.value = value;
    notifyListeners();
  }
}
