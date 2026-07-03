import 'package:sampay_wallet/core/constants/constants.dart';

class TransferConfirmationMessages {
  static String bankMessage =
      'Your account named "#account" will be charged #value ZMW for this transfer. Do you want to proceed?';

  static List<Map<String, String>> messages = [
    {"transferType": TransferType.bank.name, "message": bankMessage},
    {
      "transferType": TransferType.internationalBank.name,
      "message":
          "You are tranfering #value to #account. Do you want to proceed",
    },
    {
      "transferType": TransferType.internationalWallet.name,
      "message":
          "You are tranfering #value to #account. Do you want to proceed",
    },
  ];

  static String getTransferConfirmationMessage({
    required TransferType transferType,
    required String accountHolderName,
    required String value,
  }) {
    final messageMap = messages.firstWhere(
      (item) => item["transferType"] == transferType.name,
      orElse: () => {},
    );
    final String returnValue = messageMap["message"] ?? bankMessage;

    return returnValue
        .replaceAll("#value", value)
        .replaceAll("#account", accountHolderName);
  }
}
