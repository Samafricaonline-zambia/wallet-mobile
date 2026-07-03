import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/models/dialog_option_model.dart';
import 'package:sampay_wallet/core/models/institutions.dart';
import 'package:sampay_wallet/core/models/kyc_and_charges_model.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/momo.dart';
import 'package:sampay_wallet/core/models/payment_request_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/bottom_sheet_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/transfer_payment/services/wallet_transfer_service.dart';
import 'package:sampay_wallet/features/transfer_payment/widgets/bank_transfer_form.dart';
import 'package:sampay_wallet/features/transfer_payment/widgets/list_institutions.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/services/wallet_service.dart';
import 'package:watch_it/watch_it.dart';

class ListInstitutionsPage extends StatelessWidget with WatchItMixin {
  final WalletService walletService = getIt<WalletService>();
  final WalletTransferService transferService = getIt<WalletTransferService>();
  final AppStateService appState = getIt<AppStateService>();

  final Function(PaymentRequestModel request)? onSubmit;

  ListInstitutionsPage({super.key, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final List<InstitutionModel> allInstitutions = watchValue(
      (ValueNotifier<List<InstitutionModel>> m) => m,
      instanceName: "allInstitutions",
    );

    final InstitutionType selectedInstitutionType = watchValue(
      (ValueNotifier<InstitutionType> m) => m,
      instanceName: "selectedInstitutionType",
    );

    List<InstitutionModel> data = [];

    switch (selectedInstitutionType) {
      case InstitutionType.psp:
        data = appState.psps.value;
        break;

      case InstitutionType.mno:
        data = appState.mnos.value;
        break;

      default:
        data = appState.banks.value;
        break;
    }

    void handleTransferSubmit(
      LoadWalletWithMOMO value,
      InstitutionModel selectedInstitution,
    ) async {
      debugPrint(value.toString());
      PaymentRequestModel request = PaymentRequestModel(
        institutionId: selectedInstitution.nfsId,
        account: AppUtils().valueOrDefault(value.account),
        amount: AppUtils().valueOrDefault<double>(value.amount),
        service: selectedInstitution.participantName,
      );
      final response = await walletService.submitPaymentRequest(request);

      if (context.mounted) {
        if (response.isSuccess) {
          SimpleToast.showSuccessToast(
            response.displayMessage,
            context,
            onCompleted: () {
              context.pop();
            },
          );
        } else {
          SimpleToast.showErrorToast(response.displayMessage, context);
        }
      }
    }

    void handleInstitutionClick(InstitutionModel value) {
      final foundInstitution = AppUtils().getInstitutionByName(
        allInstitutions,
        value.participantName,
      );

      transferService.updateTransferRequest(
        LoadWalletWithMOMO(account: "", amount: 1.0),
      );
      BottomSheetUtils(context).open(
        BankTransferForm(
          option: DialogOptionModel(
            title: foundInstitution.participantName,
            description: foundInstitution.switchChannel,
            image: foundInstitution.logo,
            badgeText: foundInstitution.nfsId,
          ),
          onSubmit: (value) => handleTransferSubmit(value, foundInstitution),
        ),
      );
    }

    String buildTitle() {
      switch (transferService.selectedInstitutionType.value) {
        case InstitutionType.bank:
          return "Select a bank";

        default:
          return "Select a provider";
      }
    }

    return OptionsLayout(
      title: buildTitle(),
      child: ListInstitutions(data: data, onClick: handleInstitutionClick),
    );
  }
}
