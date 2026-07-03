import 'package:flutter/material.dart';
import 'package:sampay_wallet/features/bills/models/bill_item_model.dart';

class PayMerchantService extends ChangeNotifier {
  ValueNotifier<BillItemModel> payMerchantRequest =
      ValueNotifier<BillItemModel>(BillItemModel());

  void setPayMerchantRequest(BillItemModel value) {
    payMerchantRequest.value = value;

    notifyListeners();
  }
}
