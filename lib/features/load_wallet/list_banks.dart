import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/features/load_wallet/services/load_wallet_service.dart';
import 'package:sampay_wallet/features/load_wallet/widgets/list_banks.dart';
import 'package:watch_it/watch_it.dart';

class LoadWalletFromBankPage extends StatelessWidget with WatchItMixin {
  final LoadWalletService loadWalletService = getIt<LoadWalletService>();
  LoadWalletFromBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionsLayout(
      title: "Banks",
      pageTitle: "Select Bank",
      pageDescription:
          "Deposit money into any of our bank accounts and submit your POP. No additional charges apply.",
      child: ListBanks(
        onClick: (value) {
          debugPrint(value.toString());
          loadWalletService.updateSelectedBank(value);
          context.push(AppRoutes.bankDetails);
        },
      ),
    );
  }
}
