// ignore_for_file: non_constant_identifier_names

import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/models/bank_details_model.dart';
import 'package:sampay_wallet/core/utils/string_utils.dart';

class Banks {
  static final List<BankDetailsModel> DATA = [
    BankDetailsModel(
      name: 'Zanaco Bank',
      accountNumber: '5763022500191',
      branchName: 'Ndola Business Centre',
      branchCode: '042',
      sortCode: '010142',
      swiftCode: 'ZNCOZMLU',
      logo: AppAssets.zanacoLogo,
      description:
          "Deposit money into any of our bank accounts and submit your POP. No additional charges apply.",
    ),
    BankDetailsModel(
      name: 'Atlasmara Bank',
      accountNumber: '0035933683019',
      branchName: 'Kitwe Branch',
      branchCode: '003',
      sortCode: '',
      swiftCode: 'FMBZZMLX',
      logo: AppAssets.atlasMaraLogo,
      description:
          "Deposit money into any of our bank accounts and submit your POP. No additional charges apply.",
    ),
    BankDetailsModel(
      name: 'UBA Bank',
      accountNumber: '9050030000829',
      branchName: 'Ndola Branch',
      branchCode: '370001',
      sortCode: '',
      swiftCode: 'UNAFZMLU',
      logo: AppAssets.ubaLogo,
      description:
          "Deposit money into any of our bank accounts and submit your POP. No additional charges apply.",
    ),
    BankDetailsModel(
      name: 'FNB',
      accountNumber: '62868203185',
      branchName: 'COMMERCIAL',
      branchCode: '260035',
      sortCode: '',
      swiftCode: 'ZIRNZMLX',
      logo: AppAssets.fnbLogo,
      description:
          "Deposit money into any of our bank accounts and submit your POP. No additional charges apply.",
    ),
    BankDetailsModel(
      name: 'Absa Bank',
      accountNumber: '1068917',
      branchName: 'Barclays Business Centre Industrial',
      branchCode: '020125',
      sortCode: '',
      swiftCode: 'BARCZMLX',
      logo: AppAssets.absaLogo,
      description:
          "Deposit money into any of our bank accounts and submit your POP. No additional charges apply.",
    ),
  ];
  BankDetailsModel getBankDetails(String bankName) => DATA.firstWhere(
    (bank) => StringUtils.isIn(bankName, bank.name),
    orElse: () => BankDetailsModel.empty(),
  );
}
