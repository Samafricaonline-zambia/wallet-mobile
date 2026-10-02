import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/storage_keys.dart';
import 'package:sampay_wallet/core/models/authentication_model.dart';
import 'package:sampay_wallet/core/models/institutions.dart';
import 'package:sampay_wallet/core/models/spend_distribution_model.dart';
import 'package:sampay_wallet/core/models/wallet_balance_model.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/services/storage_service.dart';
import 'package:sampay_wallet/core/utils/string_utils.dart';

class AppStateService extends ChangeNotifier {
  final StorageService storageService = getIt<StorageService>();
  ValueNotifier<AuthResponse?> loggedInUser = ValueNotifier(null);
  ValueNotifier<bool> isAccessTokenValid = ValueNotifier(false);
  ValueNotifier<int> selectedTabIndex = ValueNotifier(0);
  ValueNotifier<WalletBalanceModel?> walletBalance = ValueNotifier(null);
  ValueNotifier<WalletTransactionsModel?> walletTransactions = ValueNotifier(
    null,
  );
  ValueNotifier<SpendDistributionModel?> spendDistributionTransactions =
      ValueNotifier(null);
  ValueNotifier<List<InstitutionModel>> allInstitutions =
      ValueNotifier<List<InstitutionModel>>([]);

  final _banks = ValueNotifier<List<InstitutionModel>>([]);
  final _psps = ValueNotifier<List<InstitutionModel>>([]);
  final _mnos = ValueNotifier<List<InstitutionModel>>([]);
  ValueNotifier<List<InstitutionModel>> get banks => _banks;
  ValueNotifier<List<InstitutionModel>> get psps => _psps;
  ValueNotifier<List<InstitutionModel>> get mnos => _mnos;

  String get accessToken => loggedInUser.value?.accessToken ?? "";
  String get phoneNumber => loggedInUser.value?.user.phone ?? "";

  AppStateService();

  Future<void> init() async {
    fetchUserDetailsFromStorage();
  }

  bool fetchUserDetailsFromStorage() {
    final savedUserDetails = storageService.read(AppStorageKeys.userDetails);

    if (savedUserDetails.isNotEmpty) {
      updateLoggedInUser(AuthResponse.fromJsonString(savedUserDetails));

      notifyListeners();
      return true;
    }

    updateLoggedInUser(null);
    notifyListeners();
    return false;
  }

  void updateLoggedInUser(AuthResponse? details) {
    loggedInUser.value = details;

    if (details != null) {
      storageService.save(AppStorageKeys.userDetails, details.toString());
    } else {
      storageService.delete(AppStorageKeys.userDetails);
    }

    notifyListeners();
  }

  void deleteLoggedInUser() {
    updateLoggedInUser(null);
  }

  void updateSelectedTabIndex(int value) {
    selectedTabIndex.value = value;

    notifyListeners();
  }

  void updateWalletBalance(WalletBalanceModel? value) {
    walletBalance.value = value;

    notifyListeners();
  }

  void updateWalletTransactions(WalletTransactionsModel? value) {
    walletTransactions.value = value;

    notifyListeners();
  }

  void updateSpendAnalysisTransactions(SpendDistributionModel? value) {
    spendDistributionTransactions.value = value;

    notifyListeners();
  }

  void updateIsAccessTokenValid(bool value) {
    isAccessTokenValid.value = value;

    if (value == false) {
      deleteLoggedInUser();
    }

    notifyListeners();
  }

  void resetAppState() {
    loggedInUser.value = null;
    selectedTabIndex.value = 0;
    walletBalance.value = null;

    notifyListeners();
  }

  void updateAllInstitutions(InstitutionsModel value) {
    allInstitutions.value = value.data;

    _banks.value = allInstitutions.value
        .where(
          (institution) =>
              StringUtils.areEqual(
                institution.institutionType,
                InstitutionType.bank.name,
              ) &&
              StringUtils.areEqual(
                institution.environment,
                EnvironmentType.production.name,
              ) &&
              StringUtils.isIn("e-money", institution.switchChannel),
        )
        .toList();

    _psps.value = allInstitutions.value
        .where(
          (institution) =>
              StringUtils.areEqual(
                institution.institutionType,
                InstitutionType.psp.name,
              ) &&
              StringUtils.areEqual(
                institution.environment,
                EnvironmentType.production.name,
              ),
        )
        .toList();

    _mnos.value = allInstitutions.value
        .where(
          (institution) =>
              StringUtils.areEqual(
                institution.institutionType,
                InstitutionType.mno.name,
              ) &&
              StringUtils.areEqual(
                institution.environment,
                EnvironmentType.production.name,
              ),
        )
        .toList();

    notifyListeners();
  }
}
