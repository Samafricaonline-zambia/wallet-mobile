import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/international_payments.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/features/international_payments/models/payment_request_model.dart';
import 'package:sampay_wallet/features/international_payments/services/international_payments_service.dart';
import 'package:sampay_wallet/features/international_payments/widgets/countries_list.dart';
import 'package:sampay_wallet/features/transfer_payment/services/wallet_transfer_service.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/services/wallet_service.dart';
import 'package:watch_it/watch_it.dart';

class InternationalPaymentsPage extends StatelessWidget with WatchItMixin {
  final WalletService walletService = getIt<WalletService>();
  final AppStateService appState = getIt<AppStateService>();
  final InternationalPaymentsService internationalPaymentsService =
      getIt<InternationalPaymentsService>();
  final WalletTransferService transferService = getIt<WalletTransferService>();
  InternationalPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    void handleOptionClick(int optionIndex) {
      final newRequest = InternationalPaymentsRequestModel.empty();

      switch (InternationalPaymentsConstants.countries[optionIndex].badgeText) {
        case "Mobile Wallet":
          internationalPaymentsService.updateCurrentPaymentRequest(
            newRequest.copyWith(
              debtoraccount: appState.phoneNumber,
              spid: InternationalPaymentsConstants.southAfrica.id,
              receivercountry:
                  InternationalPaymentsConstants.southAfrica.subTitle,
            ),
          );
          context.push(AppRoutes.internationalMobileWalletPayments);
          break;

        default:
          internationalPaymentsService.updateCurrentPaymentRequest(
            newRequest.copyWith(
              accountType: "bank",
              debtoraccount: appState.phoneNumber,
              spid: InternationalPaymentsConstants.southAfrica.id,
              receivercountry:
                  InternationalPaymentsConstants.southAfrica.subTitle,
            ),
          );
          context.push(AppRoutes.internationalBankPayments);
          break;
      }
    }

    return OptionsLayout(
      title: "International Payments",
      child: CountriesList(onClick: handleOptionClick),
    );
  }
}
