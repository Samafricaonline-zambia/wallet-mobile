import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/features/scan-qr/models/qr_model.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/services/wallet_service.dart';

class QrService extends ChangeNotifier {
  late AppStateService appState = getIt<AppStateService>();
  late WalletService walletService = getIt<WalletService>();

  final List<String> wallets = ["Personal", "Business"];
  ValueNotifier<int> selectedWalletIndex = ValueNotifier<int>(0);
  ValueNotifier<QRModel> qrCode = ValueNotifier<QRModel>(QRModel());

  QrService() {
    resetQRCode();
  }

  void resetQRCode() {
    selectedWalletIndex.value = 0;

    qrCode.value = QRModel().copyWith(
      id: AppUtils().getUniqueId(),
      phone: appState.loggedInUser.value != null
          ? AppUtils().formatPhoneNumber(
              appState.phoneNumber,
              prefixWith: "260",
            )
          : "",
      name: appState.loggedInUser.value != null
          ? appState.loggedInUser.value!.user.name
          : "",
      wallet: wallets[selectedWalletIndex.value],
    );

    notifyListeners();
  }

  void setSelectedWalletIndex(int value) {
    selectedWalletIndex.value = value;

    generateQR(value: qrCode.value.copyWith(wallet: wallets[value]));

    notifyListeners();
  }

  String generateQR({QRModel? value}) {
    if (value != null) {
      qrCode.value = value;

      notifyListeners();
    }

    return qrCode.value.toString();
  }

  QRModel scanQR(String value) {
    final scannedQRCode = QRModel.fromString(value);

    walletService.makeQRPayment(qrCode: scannedQRCode);

    return scannedQRCode;
  }
}
