import 'package:flutter/foundation.dart';
import 'package:sampay_wallet/core/constants/api_endpoints.dart';
import 'package:sampay_wallet/core/constants/international_payments.dart';
import 'package:sampay_wallet/core/extensions/general_extensions.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/services/loader_service.dart';
import 'package:sampay_wallet/core/services/network_service.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/string_utils.dart';
import 'package:sampay_wallet/features/international_payments/models/payment_request_model.dart';
import 'package:sampay_wallet/services/app_state_service.dart';

class InternationalPaymentsService extends ChangeNotifier {
  late NetworkService networkService;
  late AppStateService appState;
  late AppLoaderService appLoaderService;
  //late String accessToken;
  final String uatAddress = "https://sampay.dev/uat/";
  final String prodAddress = "https://sampay.dev/api/tcib";

  ValueNotifier<InternationalPaymentsRequestModel> currentPaymentRequest =
      ValueNotifier<InternationalPaymentsRequestModel>(
        InternationalPaymentsRequestModel.empty(),
      );

  InternationalPaymentsService() {
    networkService = getIt<NetworkService>();
    appState = getIt<AppStateService>();
    appLoaderService = getIt<AppLoaderService>();
  }

  void updateCurrentPaymentRequest(InternationalPaymentsRequestModel value) {
    currentPaymentRequest.value = value;

    notifyListeners();
  }

  Future<bool> isServiceActive() async {
    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      final NetworkResponse response = await networkService.get(
        InternationalPaymentsEndpoints.healthCheck,
        baseAddress: kDebugMode ? uatAddress : prodAddress,
        bearerToken: appState.accessToken,
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<String> verifyTpin() async {
    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      final NetworkResponse response = await networkService.post(
        InternationalPaymentsEndpoints.verifyTpin,
        baseAddress: kDebugMode ? uatAddress : prodAddress,
        bearerToken: appState.accessToken,
        body: {},
      );

      return response.displayMessage;
    } catch (e) {
      return e.toString();
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<bool> verifyReceiver(InternationalPaymentsRequestModel request) async {
    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      String creditAccountPrefix = "";

      if (request.accountType.isNotEmpty) {
        creditAccountPrefix =
            StringUtils.areEqual(
              request.receivercountry,
              InternationalPaymentsConstants.southAfrica.subTitle,
            )
            ? "+27-"
            : "+263-";
      }

      final payload = {
        "spid": request.spid,
        //"receiveraccount": request.creditaccount,
        "receivername": request.receiverfullname,
        "debtoraccount": AppUtils().formatPhoneNumber(
          request.debtoraccount,
          prefixWith: "+260-",
        ),
        "creditaccount": AppUtils().formatPhoneNumber(
          request.creditaccount,
          prefixWith: creditAccountPrefix,
        ),
        "receiveraccount": AppUtils().formatPhoneNumber(
          request.creditaccount,
          prefixWith: creditAccountPrefix,
        ),
      };

      if (request.accountType.isNotEmpty) {
        payload["account_type"] = request.accountType;
        payload["creditaccount"] = request.creditaccount;
        payload["receiveraccount"] = request.creditaccount;
      }

      final NetworkResponse response = await networkService.post(
        InternationalPaymentsEndpoints.verifyAccount,
        baseAddress: kDebugMode ? uatAddress : prodAddress,
        bearerToken: appState.accessToken,
        jsonBody: payload.toJson,
      );

      return !StringUtils.areEqual(response.displayMessage, "none");
    } catch (e) {
      return false;
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }

  Future<String> sendPayment(InternationalPaymentsRequestModel request) async {
    try {
      appLoaderService.updateIsLoading(true);
      //checkAccessToken();

      String creditAccountPrefix = "";

      if (request.accountType.isEmpty) {
        creditAccountPrefix =
            StringUtils.areEqual(
              request.receivercountry,
              InternationalPaymentsConstants.southAfrica.subTitle,
            )
            ? "+27-"
            : "+263-";
      }

      final payload = {
        "spid": request.spid,
        "amount": request.amount,
        "receiverfullname": request.receiverfullname,
        "senderfullname": request.senderfullname,
        "senderreportcode": request.senderreportcode,
        "senderreason": request.senderreason,

        "debtoraccount": AppUtils().formatPhoneNumber(
          request.debtoraccount,
          prefixWith: "+260-",
        ),
        "creditaccount": AppUtils().formatPhoneNumber(
          request.creditaccount,
          prefixWith: creditAccountPrefix,
        ),
        "receiveraccount": AppUtils().formatPhoneNumber(
          request.creditaccount,
          prefixWith: creditAccountPrefix,
        ),
      };

      if (StringUtils.areEqual(request.accountType, "bank")) {
        payload["receiveraddress"] = request.receiveraddress;
        payload["receiverpostcode"] = request.receiverpostcode;
        payload["receivertown"] = request.receivertown;
        payload["receivercountry"] = request.receivercountry;

        payload["creditaccount"] = request.creditaccount;
        payload["receiveraccount"] = request.creditaccount;
      }

      debugPrint(payload.toJson);

      final NetworkResponse response = await networkService.post(
        InternationalPaymentsEndpoints.paymentRequest,
        baseAddress: kDebugMode ? uatAddress : prodAddress,
        bearerToken: appState.accessToken,
        jsonBody: payload.toJson,
      );

      return response.displayMessage;
    } catch (e) {
      return e.toString();
    } finally {
      appLoaderService.updateIsLoading(false);
    }
  }
}
