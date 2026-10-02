import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sampay_wallet/core/constants/api_endpoints.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/models/authentication_model.dart';
import 'package:sampay_wallet/core/models/bill_merchant_model.dart';
import 'package:sampay_wallet/core/models/institutions.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/card.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/momo.dart';
import 'package:sampay_wallet/core/models/registration_model.dart';
import 'package:sampay_wallet/core/models/spend_distribution_model.dart';
import 'package:sampay_wallet/core/models/wallet_balance_model.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';
import 'package:sampay_wallet/core/services/loader_service.dart';
import 'package:sampay_wallet/core/utils/date_utils.dart';
import 'package:sampay_wallet/features/bills/models/bill_item_model.dart';
import 'package:sampay_wallet/features/bills/models/electricity_token_model.dart';
import 'package:sampay_wallet/features/bills/services/bills_service.dart';
import 'package:sampay_wallet/features/favourites/models/favourite_item_model.dart';
import 'package:sampay_wallet/features/favourites/services/favourites_service.dart';
import 'package:sampay_wallet/features/international_payments/models/payment_request_model.dart';
import 'package:sampay_wallet/features/international_payments/services/international_payments_service.dart';
import 'package:sampay_wallet/features/load_wallet/models/bank_deposit_model.dart';
import 'package:sampay_wallet/features/load_wallet/services/load_wallet_service.dart';
import 'package:sampay_wallet/features/pay_merchant/services/pay_merchant_service.dart';
import 'package:sampay_wallet/features/registration/services/registration_service.dart';
import 'package:sampay_wallet/features/scan-qr/models/qr_model.dart';
import 'package:sampay_wallet/features/scan-qr/services/qr_service.dart';
import 'package:sampay_wallet/features/transfer_payment/services/wallet_transfer_service.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/services/authentication_service.dart';
import 'package:sampay_wallet/core/services/network_service.dart';
import 'package:sampay_wallet/core/services/storage_service.dart';
import 'package:sampay_wallet/services/wallet_service.dart';
import 'package:sampay_wallet/features/reports/services/reports_service.dart';
import 'package:sampay_wallet/features/splash/services/splash_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  /** ========================================== */
  /** Services required throughout App Lifecycle */
  /** ========================================== */
  NetworkService networkService = NetworkService();
  getIt.registerSingleton<NetworkService>(networkService);
  getIt.registerSingleton<ValueNotifier<bool>>(
    networkService.isNetworkConnected,
    instanceName: "isNetworkConnected",
  );

  getIt.registerSingleton<NetworkService>(
    NetworkService(url: ApiEndpoints.paymentsBaseUrl),
    instanceName: "paymentService",
  );

  final StorageService storageService = StorageService();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);

  final AppLoaderService appLoaderService = AppLoaderService();
  getIt.registerSingleton<AppLoaderService>(appLoaderService);
  getIt.registerSingleton<ValueNotifier<bool>>(
    appLoaderService.isLoading,
    instanceName: "isAppLoading",
  );

  /** AppState Service */
  final AppStateService appState = AppStateService();
  await appState.init();
  getIt.registerSingleton<AppStateService>(appState);

  getIt.registerSingleton<ValueNotifier<WalletBalanceModel?>>(
    appState.walletBalance,
    instanceName: "walletBalance",
  );

  getIt.registerSingleton<ValueNotifier<WalletTransactionsModel?>>(
    appState.walletTransactions,
    instanceName: "walletTransactions",
  );

  getIt.registerSingleton<ValueNotifier<SpendDistributionModel?>>(
    appState.spendDistributionTransactions,
    instanceName: "spendDistributionTransactions",
  );

  getIt.registerSingleton<ValueNotifier<List<InstitutionModel>>>(
    appState.allInstitutions,
    instanceName: "allInstitutions",
  );
  /** AppState Service */

  /** Auth Service */
  final AuthenticationService authService = AuthenticationService();
  getIt.registerSingleton<AuthenticationService>(authService);
  getIt.registerSingleton<ValueNotifier<AuthenticationModel>>(
    authService.credentials,
    instanceName: "credentials",
  );
  getIt.registerSingleton<ValueNotifier<bool>>(
    authService.rememberMe,
    instanceName: "rememberMe",
  );
  getIt.registerSingleton<ValueNotifier<ForgotPasswordModel>>(
    authService.forgotPasswordDetails,
    instanceName: "forgotPasswordDetails",
  );
  /** Auth Service */

  /** Wallet Service */
  final WalletService walletService = WalletService();
  await walletService.init();
  getIt.registerSingleton<WalletService>(walletService);
  /** Wallet Service */

  /** ============================================== */
  /** End Services required throughout App Lifecycle */
  /** ============================================== */

  /** Services required only for that feature */
  getIt.registerFactory<SplashService>(() => SplashService());

  final ReportsService reportsService = ReportsService();
  getIt.registerFactory<ReportsService>(() => reportsService);
  getIt.registerSingleton<ValueNotifier<int>>(
    reportsService.selectedTabIndex,
    instanceName: "selectedReportsTabIndex",
  );
  getIt.registerSingleton<ValueNotifier<int>>(
    reportsService.selectedFilterIndex,
    instanceName: "selectedFilterIndex",
  );
  getIt.registerSingleton<ValueNotifier<SimpleDateRange>>(
    reportsService.selectedDateRange,
    instanceName: "selectedDateRange",
  );
  getIt.registerSingleton<ValueNotifier<TransactionsModel?>>(
    reportsService.selectedTransaction,
    instanceName: "selectedTransaction",
  );

  final BillsService billsService = BillsService();
  getIt.registerSingleton<BillsService>(billsService);
  getIt.registerSingleton<ValueNotifier<BillMerchantModel?>>(
    billsService.selectedBillMerchant,
    instanceName: "selectedBillMerchant",
  );
  getIt.registerSingleton<ValueNotifier<BillItemModel>>(
    billsService.currentBillingItem,
    instanceName: "currentBillingItem",
  );
  getIt.registerSingleton<ValueNotifier<ElectricityTokensModel>>(
    billsService.electricityTokens,
    instanceName: "electricityTokens",
  );

  final PayMerchantService payMerchantService = PayMerchantService();
  getIt.registerSingleton<PayMerchantService>(payMerchantService);
  getIt.registerSingleton<ValueNotifier<BillItemModel>>(
    payMerchantService.payMerchantRequest,
    instanceName: "payMerchantRequest",
  );

  final LoadWalletService loadWalletService = LoadWalletService();
  getIt.registerFactory<LoadWalletService>(() => loadWalletService);
  getIt.registerSingleton<ValueNotifier<int>>(
    loadWalletService.selectedWalletTypeIndex,
    instanceName: "selectedWalletTypeIndex",
  );
  getIt.registerSingleton<ValueNotifier<LoadWalletWithMOMO>>(
    loadWalletService.loadWalletRequestMOMO,
    instanceName: "loadWalletRequestMOMO",
  );
  getIt.registerSingleton<ValueNotifier<LoadWalletWithCard>>(
    loadWalletService.loadWalletWithCard,
    instanceName: "loadWalletWithCard",
  );
  getIt.registerSingleton<ValueNotifier<BankDepositModel>>(
    loadWalletService.loadWalletWithBankDeposit,
    instanceName: "loadWalletWithBankDeposit",
  );
  getIt.registerSingleton<ValueNotifier<File>>(
    loadWalletService.selectedPop,
    instanceName: "selectedPop",
  );

  final FavouritesService favouritesService = FavouritesService();
  getIt.registerFactory<FavouritesService>(() => favouritesService);
  getIt.registerSingleton<ValueNotifier<int>>(
    favouritesService.selectedCategoryIndex,
    instanceName: "selectedFavouritesCategoryIndex",
  );
  getIt.registerSingleton<ValueNotifier<FavouriteItemModel>>(
    favouritesService.newFavourite,
    instanceName: "newFavourite",
  );
  getIt.registerSingleton<ValueNotifier<List<FavouriteItemModel>>>(
    favouritesService.favourites,
    instanceName: "favourites",
  );

  QrService qrService = QrService();
  getIt.registerFactory<QrService>(() => qrService);
  getIt.registerSingleton<ValueNotifier<int>>(
    qrService.selectedWalletIndex,
    instanceName: "selectedQRWalletIndex",
  );
  getIt.registerSingleton<ValueNotifier<QRModel>>(
    qrService.qrCode,
    instanceName: "qrCode",
  );

  WalletTransferService transferService = WalletTransferService();
  getIt.registerFactory<WalletTransferService>(() => transferService);
  getIt.registerSingleton<ValueNotifier<int>>(
    transferService.selectedServiceIndex,
    instanceName: "selectedServiceIndex",
  );
  getIt.registerSingleton<ValueNotifier<int>>(
    transferService.selectedWalletIndex,
    instanceName: "selectedTransferWalletIndex",
  );
  getIt.registerSingleton<ValueNotifier<LoadWalletWithMOMO>>(
    transferService.transferRequest,
    instanceName: "transferRequest",
  );
  getIt.registerSingleton<ValueNotifier<InstitutionType>>(
    transferService.selectedInstitutionType,
    instanceName: "selectedInstitutionType",
  );

  InternationalPaymentsService internationalPaymentsService =
      InternationalPaymentsService();
  getIt.registerFactory<InternationalPaymentsService>(
    () => internationalPaymentsService,
  );
  getIt.registerSingleton<ValueNotifier<InternationalPaymentsRequestModel>>(
    internationalPaymentsService.currentPaymentRequest,
    instanceName: "currentInternaltionalPaymentRequest",
  );

  RegistrationService registrationService = RegistrationService();
  getIt.registerFactory<RegistrationService>(() => registrationService);
  getIt.registerSingleton<ValueNotifier<RegistrationModel>>(
    registrationService.newUser,
    instanceName: "newUser",
  );
}
