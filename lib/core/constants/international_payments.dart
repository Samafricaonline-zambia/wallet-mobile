import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/models/dialog_option_model.dart';
import 'package:sampay_wallet/core/utils/string_utils.dart';

class InternationalPaymentsConstants {
  static DialogOptionModel southAfrica = DialogOptionModel(
    id: "212006",
    image: AppAssets.southAfrica,
    title: "South Africa",
    subTitle: "ZA",
    description: "Send money to South Africa via mobile money or bank transfer",
    badgeText: "Mobile Wallet",
  );
  static DialogOptionModel zimbabwe = DialogOptionModel(
    id: "290001",
    image: AppAssets.zimbabwe,
    title: "Zimbabwe",
    subTitle: "ZW",
    description: "Send money to Zimbabwe via mobile money or bank transfer",
    badgeText: "Bank Account",
  );
  static List<DialogOptionModel> countries = [southAfrica, zimbabwe];

  static final List<InternationalTransferPurpose> transferPurposes = [
    InternationalTransferPurpose(
      '10001',
      'Adjustments / Reversals / Refunds applicable to merchandise',
    ),
    InternationalTransferPurpose(
      '10101',
      'Export advance payment (excluding certain goods)',
    ),
    InternationalTransferPurpose('20001', 'Adjustments, reversals and refunds'),
    InternationalTransferPurpose(
      '25001',
      'Travel services for non-residents – business',
    ),
    InternationalTransferPurpose(
      '25101',
      'Travel services for non-residents – holiday',
    ),
    InternationalTransferPurpose(
      '25501',
      'Travel services for residents – business',
    ),
    InternationalTransferPurpose(
      '25601',
      'Travel services for residents – holiday',
    ),
    InternationalTransferPurpose('28501', 'Tuition fees'),
    InternationalTransferPurpose(
      '29301',
      'Payments for medical and dental services',
    ),
    InternationalTransferPurpose('30001', 'Adjustments, reversals and refunds'),
    InternationalTransferPurpose(
      '30301',
      'Compensation paid to resident employee abroad',
    ),
    InternationalTransferPurpose(
      '30401',
      'Compensation paid to non-resident employee',
    ),
    InternationalTransferPurpose(
      '30501',
      'Compensation paid to migrant worker',
    ),
    InternationalTransferPurpose(
      '30601',
      'Compensation paid to foreign national contract worker',
    ),
    InternationalTransferPurpose('30701', 'Commission or brokerage'),
    InternationalTransferPurpose('40001', 'Adjustments, reversals and refunds'),
    InternationalTransferPurpose('40101', 'Gifts'),
    InternationalTransferPurpose('41001', 'Alimony'),
    InternationalTransferPurpose(
      '41601',
      'Migrant worker remittances (excluding compensation)',
    ),
    InternationalTransferPurpose(
      '41701',
      'Foreign national contract worker remittances (excluding compensation)',
    ),
  ];

  static final List<String> transferReasonDescriptions = transferPurposes
      .map((item) => item.reason)
      .toList();
  static final List<String> transferReasonCodes = transferPurposes
      .map((item) => item.code)
      .toList();

  static InternationalTransferPurpose getPurposeByIndex(int index) =>
      transferPurposes[index];

  static InternationalTransferPurpose getPurposeByCode(String code) =>
      transferPurposes.firstWhere(
        (item) => StringUtils.areEqual(item.code, code),
        orElse: () => InternationalTransferPurpose("", ""),
      );
}

class InternationalTransferPurpose {
  final String code;
  final String reason;

  InternationalTransferPurpose(this.code, this.reason);
}
