import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/international_payments.dart';
import 'package:sampay_wallet/core/widgets/simple_drop_down.dart';

class TransferReasonDropDown extends StatefulWidget {
  final Function(int reasonIndex)? onChange;
  final int initialIndex;
  const TransferReasonDropDown({
    super.key,
    this.onChange,
    this.initialIndex = 0,
  });

  @override
  State<TransferReasonDropDown> createState() => _TransferReasonDropDownState();
}

class _TransferReasonDropDownState extends State<TransferReasonDropDown> {
  late int selectedReasonIndex = widget.initialIndex;

  void updateSelectedIndex(int value) {
    setState(() {
      selectedReasonIndex = value;
    });
    widget.onChange?.call(value);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onChange?.call(selectedReasonIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDropDown(
      initialValue: InternationalPaymentsConstants.getPurposeByIndex(
        selectedReasonIndex,
      ).reason,
      items: InternationalPaymentsConstants.transferReasonDescriptions,
      labelText: "Purpose",
      onIndexChanged: updateSelectedIndex,
    );
  }
}
