// lib/core/constants/dialog_options.dart
import '../models/dialog_option_model.dart';

class AppDialogOptions {
  // Load Wallet Options
  static const DialogOptionModel loadMobileMoney = DialogOptionModel(
    image: "assets/icons/phone.png",
    title: "Mobile Money",
    description:
        "Load your wallet from an Airtel, MTN or Zamtel mobile money account. Additional charges apply.",
    badgeText: "",
    hasAdditionalCharge: true,
  );

  static const DialogOptionModel loadVisaMastercard = DialogOptionModel(
    image: "assets/icons/visamastercard.png",
    title: "Visa/MasterCard",
    description:
        "Load your wallet from a VISA or Mastercard connected account. Additional charges apply.",
    badgeText: "Coming soon",
    hasAdditionalCharge: true,
  );

  static const DialogOptionModel loadZamtelCashPoint = DialogOptionModel(
    image: "assets/icons/zamtel.png",
    title: "Zamtel Cash Point",
    description:
        "Load your wallet from any nearest Zamtel Agent outlet. Additional charges apply.",
    badgeText: "",
    hasAdditionalCharge: true,
  );

  static const DialogOptionModel loadBankDeposit = DialogOptionModel(
    image: "assets/icons/bank.png",
    title: "Bank Deposit",
    description:
        "Deposit money into any of our bank accounts and submit your POP. No additional charges apply.",
    badgeText: "",
    hasAdditionalCharge: false,
  );

  static const DialogOptionModel loadSampayAgent = DialogOptionModel(
    image: "assets/icons/bank-agent.png",
    title: "Sampay Agent",
    description:
        "Deposit money with any of our agent outlets. No additional charges apply.",
    badgeText: "",
    hasAdditionalCharge: false,
  );

  // Money Transfer Options
  static const DialogOptionModel localTransfer = DialogOptionModel(
    image: "assets/icons/local-transfer-icons.png",
    title: "Local Transfer",
    description:
        "Transfer Money from your Sampay wallet to Mobile Money, Fintech or Banks in Zambia",
    badgeText: "",
    hasAdditionalCharge: true,
  );

  static const DialogOptionModel internationalTransfer = DialogOptionModel(
    image: "assets/icons/international-transfer-icons.png",
    title: "International Transfer",
    description:
        "Transfer Money from your Sampay wallet to Mobile Money, Fintech or Banks across the SADC region",
    badgeText: "",
    hasAdditionalCharge: true,
  );

  static const DialogOptionModel transferMobileMoney = DialogOptionModel(
    image: "assets/icons/phone.png",
    title: "Mobile Money",
    description:
        "Send money from your wallet to an Airtel, MTN or Zamtel mobile money account. Additional charges apply.",
    badgeText: "",
    hasAdditionalCharge: true,
  );

  static const DialogOptionModel transferSampay = DialogOptionModel(
    image: "assets/logos/sampay LOGOS/sampayRED.png",
    title: "Sampay",
    description: "Send money from your wallet to another Sampay Account.",
    badgeText: "",
    hasAdditionalCharge: true,
  );

  static const DialogOptionModel transferETumba = DialogOptionModel(
    image: "assets/icons/eTUMBA.png",
    title: "eTumba",
    description:
        "Send money to an eTumba account of your choice. Additional charges apply.",
    badgeText: "Coming soon",
    hasAdditionalCharge: true,
  );

  static const DialogOptionModel transferBank = DialogOptionModel(
    image: "assets/icons/bank.png",
    title: "Send To Bank",
    description:
        "Send Money directly to all available bank accounts. Additional charges apply.",
    badgeText: "",
    hasAdditionalCharge: false,
  );

  static const DialogOptionModel transferZCode = DialogOptionModel(
    image: "assets/icons/kazang.png",
    title: "Get a Z-Code",
    description:
        "Generate a Z-Code and withdraw from any Kazang or Zoona Outlet. Additional charges apply.",
    badgeText: "",
    hasAdditionalCharge: false,
  );

  // Get collections
  static List<DialogOptionModel> get loadWalletOptions => [
    loadMobileMoney,
    loadVisaMastercard,
    loadZamtelCashPoint,
    loadBankDeposit,
    loadSampayAgent,
  ];

  static List<DialogOptionModel> get walletTransferOptions => [
    transferMobileMoney,
    transferSampay,
    transferETumba,
    transferBank,
    transferZCode,
  ];
}
