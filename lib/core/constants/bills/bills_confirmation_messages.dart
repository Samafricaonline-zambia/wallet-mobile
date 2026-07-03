import 'package:sampay_wallet/core/constants/constants.dart';

class BillsConfirmationMessages {
  static List<Map<String, String>> messages = [
    {
      "merchantType": BillMerchantType.cableTv.name,
      "message":
          "Are you sure you want to buy cable tv for ZMW #value for this number #accountNumber ?",
    },
    {
      "merchantType": BillMerchantType.airtime.name,
      "message":
          "Are you sure you want to buy Airtime for ZMW #value for this number #accountNumber ?",
    },
    {
      "merchantType": BillMerchantType.data.name,
      "message":
          "Are you sure you want to buy data for ZMW #value for this number #accountNumber ?",
    },
    {
      "merchantType": BillMerchantType.electricity.name,
      "message":
          "Are you sure you want to buy tokens for ZMW #value for this number #accountNumber ?",
    },
  ];

  static String getMerchantConfirmationMessage(
    BillMerchantType merchantType,
    String accountNumber,
    String value,
  ) {
    final merchantName = merchantType.name;
    final messageMap = messages.firstWhere(
      (item) => item["merchantType"] == merchantName,
      orElse: () => {},
    );
    final String returnValue =
        messageMap["message"] ?? "Are you sure you want to proceed?";

    return returnValue
        .replaceAll("#value", value)
        .replaceAll("#accountNumber", accountNumber);
  }
}
