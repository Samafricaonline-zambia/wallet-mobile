import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_buttons.dart';
import 'package:sampay_wallet/core/widgets/simple_divider.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';
import 'package:sampay_wallet/core/widgets/simple_pill.dart';
import 'package:watch_it/watch_it.dart';

class TransactionDetailsPage extends StatelessWidget with WatchItMixin {
  const TransactionDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    final double screenWidth = AppUtils().getScreenWidth(context);
    final double maxRightChildWidth = screenWidth * 0.5;
    final TransactionsModel? transaction = watchValue(
      (ValueNotifier<TransactionsModel?> m) => m,
      instanceName: "selectedTransaction",
    );

    if (transaction != null) {
      final bool isCreditTransaction = AppUtils().isCreditTransaction(
        transaction.transactionType ?? "",
      );
      return OptionsLayout(
        title: AppUtils().valueOrDefault(transaction.vendor),
        child: Column(
          children: [
            SimpleImageCard(
              image: AppUtils().getMerchantAssetImage(transaction.vendor ?? ""),
              height: 100,
              width: 100,
            ),
            EmptySpace.large(),
            SimpleFlex(
              leftChild: SimpleAppText("Description"),
              rightChild: SimpleAppText(
                transaction.description ?? "",
                align: .end,
              ).maxWidth(maxRightChildWidth),
              isWithDivider: true,
            ),
            SimpleFlex(
              leftChild: SimpleAppText(
                isCreditTransaction ? "Received from" : "Sent to",
              ),
              rightChild: SimpleAppText(
                AppUtils().valueOrDefault(
                  isCreditTransaction
                      ? transaction.sender
                      : transaction.receiver,
                ),
                align: .end,
              ).maxWidth(maxRightChildWidth),
              isWithDivider: true,
            ),
            SimpleFlex(
              leftChild: SimpleAppText("Transaction Type"),
              rightChild: SimpleAppText(
                isCreditTransaction ? "Credit" : "Debit",
              ),
              isWithDivider: true,
            ),
            SimpleFlex(
              leftChild: SimpleAppText("Amount"),
              rightChild: SimplePill(
                AppUtils().formatCurrency(transaction.amount),
                bgColor: AppUtils().getCreditDebitBGColor(
                  AppUtils().valueOrDefault(transaction.transactionType),
                  appTheme,
                ),
                color: AppUtils().getCreditDebitTextColor(
                  AppUtils().valueOrDefault(transaction.transactionType),
                  appTheme,
                ),
                fontSize: 14,
              ),
              isWithDivider: true,
            ),
            SimpleFlex(
              leftChild: SimpleAppText("Reference"),
              rightChild: SimpleAppText(
                AppUtils().valueOrDefault(transaction.referenceId),
                align: .end,
              ).maxWidth(maxRightChildWidth),
              isWithDivider: true,
            ),
            SimpleFlex(
              leftChild: SimpleAppText(
                isCreditTransaction ? "Received on" : "Sent on",
              ),
              rightChild: SimpleAppText(
                AppUtils().valueOrDefault(
                  AppUtils().formatTimestamp(transaction.timestamp),
                ),
              ),
              isWithDivider: true,
            ),
            SimpleFlex(
              leftChild: SimpleAppText("Notes"),
              rightChild: SimpleAppText(
                AppUtils().valueOrDefault(transaction.rawDetail),
              ),
              isWithDivider: true,
            ),
            EmptySpace(),
            SimpleButtons.fullWidth(
              "Close",
              onClick: () {
                context.pop();
              },
            ),
          ],
        ),
      );
    }

    return SimpleAppText("No transaction details found. Please try again.");
  }
}
