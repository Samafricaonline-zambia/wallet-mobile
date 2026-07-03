import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/models/input_field_model.dart';

class BillsData {
  // Better structure: Map instead of List
  static final Map<String, InputFieldModel> inputLabels = {
    "BoxOffice": InputFieldModel(
      label: "Smartcard Number",
      prefix: "",
      keyboardType: TextInputType.number,
    ),
    "DSTV": InputFieldModel(
      label: "Account Number",
      prefix: "",
      keyboardType: TextInputType.number,
    ),
    "GOTV": InputFieldModel(
      label: "Account Number",
      prefix: "",
      keyboardType: TextInputType.number,
    ),
    "TopStar": InputFieldModel(
      label: "Account Number",
      prefix: "",
      keyboardType: TextInputType.number,
    ),
  };

  // Much simpler lookup
  static InputFieldModel getInputFieldModel(String merchantName) {
    return inputLabels[merchantName] ?? InputFieldModel.empty();
  }

  // Get all available merchants
  static List<String> getMerchants() => inputLabels.keys.toList();
}
