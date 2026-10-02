import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sampay_wallet/core/constants/api_endpoints.dart';
import 'package:sampay_wallet/core/extensions/general_extensions.dart';
import 'package:sampay_wallet/core/models/institution_lookup_model.dart';
import 'package:sampay_wallet/core/models/institutions.dart';
import 'package:sampay_wallet/core/models/kyc_and_charges_model.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/card.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/momo.dart';
import 'package:sampay_wallet/core/models/payment_request_model.dart';
import 'package:sampay_wallet/core/models/spend_distribution_model.dart';
import 'package:sampay_wallet/core/models/wallet_balance_model.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';
import 'package:sampay_wallet/core/services/loader_service.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/features/bills/models/bill_item_model.dart';
import 'package:sampay_wallet/features/load_wallet/models/bank_deposit_model.dart';
import 'package:sampay_wallet/features/scan-qr/models/qr_model.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/services/network_service.dart';

class WalletService {
  late NetworkService networkService = getIt<NetworkService>();
  late AppStateService appState = getIt<AppStateService>();
  late AppLoaderService appLoaderService = getIt<AppLoaderService>();
  //late String accessToken;

  WalletService() {
    //accessToken = "";
    //checkAccessToken();
  }

  // void checkAccessToken() {
  //   if (accessToken.isEmpty) {
  //     accessToken = appState.loggedInUser.value != null
  //         ? appState.loggedInUser.value!.accessToken
  //         : "";
  //   }
  // }

  Future<void> init() async {
    await fetchWalletBalance();
    fetchInstitutions();
  }

  Future<NetworkResponse> fetchInstitutions() async {
    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      final NetworkResponse response = await networkService.get(
        ApiEndpoints.institutions,
        bearerToken: appState.accessToken,
      );

      if (response.isSuccess) {
        appState.updateAllInstitutions(
          InstitutionsModel.fromJson(response.body),
        );
      }

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<AccountLookupModel> fetchKYCAndCharges(
    KYCAndChargesModel request,
  ) async {
    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      final payload = {
        "account": request.account,
        "amount": request.amount,
        "institution_id": request.institutionId,
        "request": "account_lookup",
      };

      final NetworkResponse response = await networkService.post(
        ApiEndpoints.walletWithdrawBank,
        bearerToken: appState.accessToken,
        jsonBody: payload.toJson,
      );

      if (response.isSuccess) {
        return AccountLookupModel.fromMap(response.data);
      }

      return AccountLookupModel.empty().copyWith(
        message: response.displayMessage,
      );
    } catch (e) {
      return AccountLookupModel.empty().copyWith(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<NetworkResponse> submitPaymentRequest(
    PaymentRequestModel request,
  ) async {
    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      final payload = request
          .copyWith(
            request: "payment_request",
            reference: AppUtils().generateReference(prefix: "REF"),
          )
          .toJson();

      final NetworkResponse response = await networkService.post(
        ApiEndpoints.walletWithdrawBank,
        bearerToken: appState.accessToken,
        jsonBody: payload,
      );

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<NetworkResponse> fetchWalletBalance() async {
    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();
      final NetworkResponse response = await networkService.get(
        ApiEndpoints.walletBalance,
        bearerToken: appState.accessToken,
      );

      if (response.isSuccess) {
        //walletBalance.value = WalletBalanceModel.fromJson(response.data);
        appState.updateWalletBalance(WalletBalanceModel.fromMap(response.data));
      } else {
        //walletBalance.value = null;
        appState.updateWalletBalance(null);
      }

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<NetworkResponse> fetchWalletTransactions() async {
    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();
      final NetworkResponse response = await networkService.get(
        ApiEndpoints.walletTransactionHistory,
        bearerToken: appState.accessToken,
      );

      if (response.isSuccess) {
        //walletBalance.value = WalletBalanceModel.fromJson(response.data);
        appState.updateWalletTransactions(
          WalletTransactionsModel.fromMap(response.data),
        );
      } else {
        //walletBalance.value = null;
        appState.updateWalletTransactions(null);
      }

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<NetworkResponse> fetchSpendDistribution(
    String? period,
    String? from,
    String? to,
  ) async {
    try {
      appLoaderService.updateIsLoading(true);

      Map<String, String> queryParams = {};

      if (period != null) {
        queryParams.putIfAbsent("period", () => period);
      }

      if (from != null) {
        queryParams.putIfAbsent("from", () => from);
      }

      if (to != null) {
        queryParams.putIfAbsent("to", () => to);
      }

      final NetworkResponse response = await networkService.get(
        ApiEndpoints.walletSpendDistribution,
        bearerToken: appState.accessToken,
        queryParameters: queryParams,
      );

      if (response.isSuccess) {
        //walletBalance.value = WalletBalanceModel.fromJson(response.data);
        appState.updateSpendAnalysisTransactions(
          SpendDistributionModel.fromMap(response.data),
        );
      } else {
        //walletBalance.value = null;
        appState.updateWalletTransactions(null);
      }

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<NetworkResponse> fundWalletMOMO(
    LoadWalletWithMOMO loadWalletRequestMOMO,
  ) async {
    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      final NetworkResponse response = await networkService.post(
        ApiEndpoints.walletFundMomo,
        body: loadWalletRequestMOMO
            .copyWith(reference: AppUtils().generateReference())
            .toMap(),
        bearerToken: appState.accessToken,
      );

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<NetworkResponse> fundWalletCard(
    LoadWalletWithCard loadWalletRequestCard,
  ) async {
    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();
      final NetworkResponse response = await networkService.post(
        ApiEndpoints.walletFundMomo,
        body: loadWalletRequestCard.toMap(),
        bearerToken: appState.accessToken,
      );

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<NetworkResponse> transferMOMO(
    LoadWalletWithMOMO transferRequest,
  ) async {
    final payload = {
      "account": transferRequest.account,
      "amount": transferRequest.amount,
      "reference": AppUtils().generateReference(prefix: "MOBILEMONEY"),
      "service": transferRequest.service,
    };

    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      final NetworkResponse response = await networkService.post(
        ApiEndpoints.walletWithdrawMomo,
        body: payload,
        bearerToken: appState.accessToken,
      );

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<NetworkResponse> transferSampay(
    LoadWalletWithMOMO transferRequest,
  ) async {
    final payload = {
      "phone_number": transferRequest.account,
      "amount": transferRequest.amount,
      "reference": AppUtils().generateReference(prefix: "SAMPAY"),
      "accounttype": "personal",
    };

    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      final NetworkResponse response = await networkService.post(
        ApiEndpoints.walletQRPayment,
        body: payload,
        bearerToken: appState.accessToken,
      );

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<NetworkResponse> makeVasPayment({
    required String service,
    required String account,
    required double amount,
    required String transactionType,
    required String serviceType,
    String referencePrefix = "",
  }) async {
    final paymentReference =
        '${referencePrefix.isNotEmpty ? referencePrefix : 'VAS'}${DateTime.now().millisecondsSinceEpoch}';

    final payload = {
      "service": service,
      "account": account,
      "amount": amount,
      "reference": paymentReference,
      "transactiontype": transactionType,
      "servicetype": serviceType,
    };

    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();
      final NetworkResponse response = await networkService.post(
        ApiEndpoints.vasPayment,
        bearerToken: appState.accessToken,
        body: payload,
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      return NetworkResponse.error(message: e.toString());
    } finally {
      await fetchWalletBalance();
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<NetworkResponse> makeMerchantPayment(BillItemModel request) async {
    final payload = {
      "merchantcode": request.accountNumber,
      "narration": request.tag,
      "amount": request.value,
      "reference": AppUtils().generateReference(prefix: "MERCHANT"),
    };

    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      final NetworkResponse response = await networkService.post(
        ApiEndpoints.walletPayMerchant,
        body: payload,
        bearerToken: appState.accessToken,
      );

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<NetworkResponse> makeQRPayment({required QRModel qrCode}) async {
    final payload = {
      'phone_number': qrCode.phone, // Use the formatted username
      'amount': qrCode.amount!.toStringAsFixed(2),
      'accounttype': qrCode.wallet!
          .toLowerCase(), // Convert to lowercase to match example
    };

    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();
      final NetworkResponse response = await networkService.post(
        ApiEndpoints.walletQRPayment,
        bearerToken: appState.accessToken,
        body: payload,
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      return NetworkResponse.error(message: e.toString());
    } finally {
      await fetchWalletBalance();
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<String> getCardPaymentUrl(double amount) async {
    final payload = {"amount": amount.toStringAsFixed(2)};

    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      final NetworkResponse response = await networkService.post(
        ApiEndpoints.walletFundCard,
        body: payload,
        bearerToken: appState.accessToken,
      );

      if (response.isSuccess) {
        return response.data["checkout_url"];
      }

      debugPrint(response.displayMessage);
      return "";
    } catch (e) {
      debugPrint(e.toString());
      return "";
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<String> uploadBankDepositProof(BankDepositModel request) async {
    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      final response = await networkService.postFormData(
        ApiEndpoints.walletUploadDepositProof,
        bearerToken: appState.accessToken,
        fields: request.toMap(),
        files: [await request.toMultipartFile()],
      );

      if (!response.isSuccess) {
        return response.displayMessage;
      }

      debugPrint(response.displayMessage);
      return "";
    } catch (e) {
      debugPrint(e.toString());
      return "";
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }
}
