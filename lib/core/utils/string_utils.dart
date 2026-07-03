import 'package:sampay_wallet/core/utils/app_utils.dart';

class StringUtils {
  static bool areEqual(
    String? str1,
    String? str2, {
    bool isCaseSensitive = false,
  }) {
    if (isCaseSensitive) {
      return str1 == str2;
    }

    return AppUtils().valueOrDefault(str1).toLowerCase() ==
        AppUtils().valueOrDefault(str2).toLowerCase();
  }

  static bool isIn(String? str1, String? str2, {bool isCaseSensitive = false}) {
    if (isCaseSensitive) {
      return AppUtils()
          .valueOrDefault(str2)
          .contains(AppUtils().valueOrDefault(str1));
    }

    return AppUtils()
        .valueOrDefault(str2)
        .toLowerCase()
        .contains(AppUtils().valueOrDefault(str1).toLowerCase());
  }
}
