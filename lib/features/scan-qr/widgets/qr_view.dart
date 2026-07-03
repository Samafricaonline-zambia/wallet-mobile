import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/features/scan-qr/models/qr_model.dart';
import 'package:watch_it/watch_it.dart';

class QRView extends StatelessWidget with WatchItMixin {
  const QRView({super.key});

  @override
  Widget build(BuildContext context) {
    final QRModel qrCode = watchValue(
      (ValueNotifier<QRModel> m) => m,
      instanceName: "qrCode",
    );

    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.all(AppConstants.STANDARD_PAGE_PADDING),
          child: PrettyQrView.data(data: qrCode.toString()),
        ),
        EmptySpace.small(),
      ],
    );
  }
}
