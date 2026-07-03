import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/features/scan-qr/widgets/generate_qr_form.dart';

class GenerateQRCode extends StatelessWidget {
  const GenerateQRCode({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionsLayout(
      title: "QR Code",
      pageTitle: "Generate QR Code",
      pageDescription:
          "Configure the details to generate a QR Code. You can receive a payment using the generated QR Code.",
      child: Column(children: [GenerateQRForm()]),
    );
  }
}
