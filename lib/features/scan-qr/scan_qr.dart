import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/bottom_sheet_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_buttons.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/core/widgets/simple_switch.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/scan-qr/models/qr_model.dart';
import 'package:sampay_wallet/features/scan-qr/services/qr_service.dart';
import 'package:sampay_wallet/features/scan-qr/widgets/qr_payment.dart';
import 'package:sampay_wallet/services/wallet_service.dart';

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({super.key});

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  late final MobileScannerController controller;
  final QrService qrService = getIt<QrService>();
  final WalletService walletService = getIt<WalletService>();

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(autoStart: false, autoZoom: true);
    controller.start();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = AppUtils().getScreenWidth(context);
    final double screenHeight = AppUtils().getScreenHeight(context);
    final BottomSheetUtils paymentSheet = BottomSheetUtils(context);

    void startScanner() {
      setState(() {
        controller.start();
      });
    }

    void stopScanner() {
      setState(() {
        controller.stop();
      });
    }

    void closeBottomSheet() {
      startScanner();
    }

    void showPaymentStatus(
      bool isSuccess, {
      String errorMessage = "Error processing payment",
    }) {
      qrService.resetQRCode();
      AppUtils().hideKeyboard(context);
      if (isSuccess) {
        SimpleToast.showSuccessToast(
          "Payment successful",
          context,
          onCompleted: closeBottomSheet,
        );
      } else {
        SimpleToast.showErrorToast(errorMessage, context);
      }
    }

    void handleMakePayment(QRModel value) async {
      walletService.makeQRPayment(qrCode: value).then((response) {
        showPaymentStatus(
          response.isSuccess,
          errorMessage: response.displayMessage,
        );
      });
    }

    void handleCodeDetection(
      BarcodeCapture? result, {
      bool isGalleryImage = false,
    }) {
      if (result != null && result.barcodes.isNotEmpty) {
        if (result.barcodes.first.rawValue?.endsWith("sampay") ?? false) {
          stopScanner();

          final String scannedCode = AppUtils().valueOrDefault(
            result.barcodes.first.rawValue,
          );

          final QRModel scannedQRCode = QRModel.fromString(scannedCode);

          qrService.generateQR(value: scannedQRCode);

          paymentSheet.open(
            QRPaymentForm(onSubmit: () => handleMakePayment(scannedQRCode)),
            onClose: closeBottomSheet,
          );
        }
      } else if (isGalleryImage) {
        SimpleToast("Please select different image", context);
      }
    }

    void handleOpenGallery() async {
      final picker = ImagePicker();
      // Pick an image.
      picker.pickImage(source: ImageSource.gallery).then((image) {
        setState(() {
          if (image != null) {
            controller
                .analyzeImage(image.path)
                .then(
                  (value) => handleCodeDetection(value, isGalleryImage: true),
                );
          }
        });
      });
    }

    return OptionsLayout(
      title: "QR Code",
      pageTitle: "Scan QR Code",
      pageDescription:
          "Scan QR code to make a payment. Only Sampay QRCodes will work with this scanner.",
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.5,
            child: MobileScanner(
              controller: controller,
              onDetect: handleCodeDetection,
            ),
          ),
          EmptySpace(),
          SimpleFlex(
            children: [
              SimpleSwitch<bool>(
                title: "Torch",
                yesValue: true,
                noValue: false,
                onChange: (value) {
                  setState(() {
                    controller.toggleTorch();
                  });
                },
              ),
              SimpleSwitch<bool>(
                title: "Switch Camera",
                yesValue: true,
                noValue: false,
                onChange: (value) {
                  setState(() {
                    controller.switchCamera();
                  });
                },
              ),
            ],
          ),
          EmptySpace.small(),
          SimpleButtons("Gallery", onClick: handleOpenGallery),
        ],
      ),
    );
  }
}
