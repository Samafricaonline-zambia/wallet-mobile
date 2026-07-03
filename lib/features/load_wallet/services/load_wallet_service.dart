import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/models/bank_details_model.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/card.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/momo.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/services/network_service.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/features/load_wallet/models/bank_deposit_model.dart';
import 'package:sampay_wallet/services/app_state_service.dart';

class LoadWalletService extends ChangeNotifier {
  ValueNotifier<int> selectedWalletTypeIndex = ValueNotifier<int>(0);
  ValueNotifier<LoadWalletWithMOMO> loadWalletRequestMOMO =
      ValueNotifier<LoadWalletWithMOMO>(LoadWalletWithMOMO(amount: 1));
  ValueNotifier<LoadWalletWithCard> loadWalletWithCard =
      ValueNotifier<LoadWalletWithCard>(LoadWalletWithCard(amount: 1));
  ValueNotifier<BankDetailsModel> selectedBank =
      ValueNotifier<BankDetailsModel>(BankDetailsModel.empty());
  ValueNotifier<File> selectedPop = ValueNotifier<File>(File(""));
  ValueNotifier<BankDepositModel> loadWalletWithBankDeposit =
      ValueNotifier<BankDepositModel>(BankDepositModel.empty());

  final AppStateService appState = getIt<AppStateService>();

  LoadWalletService() {
    selectedWalletTypeIndex.value = 0;

    if (appState.loggedInUser.value != null) {
      loadWalletRequestMOMO.value = loadWalletRequestMOMO.value.copyWith(
        account: AppUtils().formatPhoneNumber(appState.phoneNumber),
        wallet: AppConstants.WALLET_OPTIONS[selectedWalletTypeIndex.value],
        reference: AppUtils().generateReference(),
      );

      loadWalletWithCard.value = loadWalletWithCard.value.copyWith(
        reference: AppUtils().generateReference(prefix: "CARD"),
      );
    }

    notifyListeners();
  }

  void setSelectedWalletType(int value) {
    selectedWalletTypeIndex.value = value;
    loadWalletRequestMOMO.value = loadWalletRequestMOMO.value.copyWith(
      wallet: AppConstants.WALLET_OPTIONS[value],
    );
    notifyListeners();
  }

  void updateLoadWalletRequestMOMO(LoadWalletWithMOMO value) {
    loadWalletRequestMOMO.value = value;
    notifyListeners();
  }

  void updateLoadWalletRequestCard(LoadWalletWithCard value) {
    loadWalletWithCard.value = value;
    notifyListeners();
  }

  void updateSelectedBank(BankDetailsModel value) {
    selectedBank.value = value;
    notifyListeners();
  }

  void updateSelectedPop(File value) {
    selectedPop.value = value;

    notifyListeners();
  }

  void updateLoadWalletWithBankDeposit(BankDepositModel value) {
    loadWalletWithBankDeposit.value = value;

    notifyListeners();
  }
}
