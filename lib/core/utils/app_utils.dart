import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/models/institutions.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/string_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/v4.dart';

class AppUtils {
  /// Returns the screen width divided by the specified divisor
  ///
  /// Parameters:
  /// - [context]: Build context to access MediaQuery
  /// - [division]: Number to divide the width by (default 1)
  ///
  /// Returns the calculated screen width
  double getScreenWidth(BuildContext context, {int division = 1}) =>
      MediaQuery.of(context).size.width / division;

  /// Returns the screen height divided by the specified divisor
  ///
  /// Parameters:
  /// - [context]: Build context to access MediaQuery
  /// - [division]: Number to divide the height by (default 1)
  ///
  /// Returns the calculated screen height
  double getScreenHeight(BuildContext context, {int division = 1}) =>
      MediaQuery.of(context).size.height / division;

  bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Hides the keyboard by removing focus from the current focus node
  ///
  /// Parameters:
  /// - [context]: Build context to access the current focus scope
  void hideKeyboard(BuildContext context) => FocusScope.of(context).unfocus();

  /// Executes a callback function after a specified delay
  ///
  /// Parameters:
  /// - [fnCallback]: The function to execute after the delay
  /// - [duration]: The delay duration (default 5 seconds)
  void executeDelayed(
    VoidCallback fnCallback, {
    Duration duration = const Duration(seconds: 5),
  }) async {
    Future.delayed(duration, fnCallback);
  }

  /// Formats a phone number by normalizing to a standard format with prefix
  ///
  /// Parameters:
  /// - [phone]: The phone number string to format
  /// - [prefixWith]: The prefix to add to the formatted number (default "+260")
  ///
  /// Returns the formatted phone number with the specified prefix
  /// Examples: +260977123456 -> 0977123456, 0977123456 -> +260977123456
  String formatPhoneNumber(String phone, {String prefixWith = "+260"}) {
    if (phone.isEmpty) return phone;

    // Remove all whitespace
    String cleaned = phone.trim().replaceAll(' ', '');
    String returnValue = cleaned;

    // Check if +260 is already present
    if (cleaned.startsWith('+260')) {
      //return cleaned;
      returnValue = cleaned.replaceAll("+260", "");
    }

    // Check if 260 is present without plus
    if (cleaned.startsWith('260')) {
      //return '+$cleaned';
      returnValue = cleaned.replaceAll("260", "");
    }

    // Check if starts with 0 (local format with leading zero)
    if (cleaned.startsWith('0')) {
      //return '+260${cleaned.substring(1)}';
      returnValue = cleaned.substring(1);
    }

    // Default: prepend +260
    return '$prefixWith$returnValue';
  }

  /// Formats an NRC (National Registration Card) number by adding slashes at appropriate positions
  ///
  /// Format: XXX/XXX/XX-X (10 digits with slashes after 6th and 8th characters)
  ///
  /// Parameters:
  /// - [currentValue]: The raw NRC number string to format
  ///
  /// Returns the formatted NRC number with slashes
  String formatNrc(String currentValue) {
    String formattedText = '';
    final unformattedText = currentValue.replaceAll(
      '/',
      '',
    ); // Remove existing slashes

    if (unformattedText.length <= 10) {
      for (int i = 0; i < unformattedText.length; i++) {
        formattedText += unformattedText[i];
        // Add slash after 6th and 8th characters (indices 5 and 7)
        if (i == 5 || i == 7) {
          formattedText += '/';
        }
      }
      return formattedText;
    }

    // If length exceeds 10, return the current value with proper formatting
    // Handle NRC format: XXX/XXX/XX-X (10 characters without slashes)
    if (unformattedText.length > 10) {
      // Truncate to maximum allowed length (10 digits)
      final truncated = unformattedText.substring(0, 10);
      for (int i = 0; i < truncated.length; i++) {
        formattedText += truncated[i];
        if (i == 5 || i == 7) {
          formattedText += '/';
        }
      }
      return formattedText;
    }

    return currentValue;
  }

  /// Extracts and returns the initials from a user's full name
  ///
  /// Parameters:
  /// - [userName]: The full name string
  ///
  /// Returns uppercase initials (first letter of first name and last name)
  /// If only one name is provided, returns the first letter of that name
  String getNameInitials(String userName) {
    if (userName.isEmpty) return "";

    final names = userName.trim().split(' ');
    if (names.length == 1) {
      return names[0][0].toUpperCase();
    }
    return '${names[0][0]}${names[1][0]}'.toUpperCase();
  }

  /// Generates a random pastel color
  ///
  /// Pastel colors are generated with RGB values between 100-255
  /// resulting in lighter, softer colors suitable for backgrounds
  ///
  /// Returns a Color object with random pastel shade
  Color getRandomPastelColor() {
    final Random random = Random();
    // Pastel colors have higher values (closer to white)
    return Color.fromRGBO(
      100 + random.nextInt(156), // 100-255
      100 + random.nextInt(156), // 100-255
      100 + random.nextInt(156), // 100-255
      1.0,
    );
  }

  /// Converts a text string to a BillMerchants enum value
  ///
  /// Parameters:
  /// - [text]: The text to match against merchant names
  ///
  /// Returns the matching BillMerchants enum, or BillMerchants.none if no match found
  BillMerchants getMerchant(String text) => BillMerchants.values.firstWhere(
    (merchant) => merchant.name.startsWith(text.toLowerCase()),
    orElse: () => BillMerchants.none,
  );

  /// Formats a timestamp string into a human-readable date and time format
  ///
  /// Parameters:
  /// - [timestamp]: ISO timestamp string (if null or empty, uses current time)
  ///
  /// Format examples:
  /// - Current year: "17 Feb at 08:45 PM"
  /// - Different year: "17 Feb 24 at 08:45 PM"
  ///
  /// Returns formatted date and time string
  String formatTimestamp(String? timestamp) {
    if (timestamp == null) {
      return formatTimestamp(DateTime.now().toIso8601String());
    }

    String tmObj = timestamp;
    if (timestamp.isEmpty) {
      tmObj = DateTime.now().toIso8601String();
    }
    DateTime dateTime = DateTime.parse(tmObj.replaceFirst(' ', 'T'));

    final now = DateTime.now();
    final isCurrentYear = dateTime.year == now.year;

    if (isCurrentYear) {
      // Format without year: "17 Feb at 08:45 PM"
      return DateFormat("dd MMM 'at' hh:mm a").format(dateTime);
    } else {
      // Format with year: "17 Feb 24 at 08:45 PM"
      return DateFormat("dd MMM yy 'at' hh:mm a").format(dateTime);
    }
  }

  /// Formats a currency value into ZMW with optional abbreviation
  ///
  /// Parameters:
  /// - [value]: The amount to format (can be String, int, or double)
  /// - [useAbbreviation]: If true, uses K/M/B abbreviations for thousands/millions/billions
  ///
  /// Returns formatted currency string with ZMW suffix
  /// Examples: "1,234.00 ZMW", "1.5K ZMW", "2.3M ZMW"
  String formatCurrency(dynamic value, {bool useAbbreviation = false}) {
    // Parse the value to double
    double amount;
    if (value is String) {
      amount = double.tryParse(value) ?? 0.0;
    } else if (value is int) {
      amount = value.toDouble();
    } else if (value is double) {
      amount = value;
    } else {
      amount = 0.0;
    }

    if (useAbbreviation) {
      // Format with M/B abbreviations
      if (amount >= 1000000000) {
        return "${(amount / 1000000000).toStringAsFixed(1)}B ZMW";
      } else if (amount >= 1000000) {
        return "${(amount / 1000000).toStringAsFixed(1)}M ZMW";
      } else if (amount >= 1000) {
        return "${(amount / 1000).toStringAsFixed(1)}K ZMW";
      } else {
        // Format with thousand separators for small amounts
        final formatter = NumberFormat("#,###.00");
        return "${formatter.format(amount)} ZMW";
      }
    } else {
      // Format with thousand separators only
      final formatter = NumberFormat("#,###.00");
      return "${formatter.format(amount)} ZMW";
    }
  }

  /// Returns the asset image path for a given merchant/vendor name
  ///
  /// Parameters:
  /// - [vendor]: The vendor/merchant name string
  ///
  /// Returns the asset path to the corresponding merchant logo
  /// Returns AppAssets.logo as default if no match found
  String getMerchantAssetImage(String vendor) {
    String assetPath = AppAssets.logo;

    if (vendor.isNotEmpty) {
      List<String> vendorSegments = vendor.split(" ");
      BillMerchants merchant = AppUtils().getMerchant(vendorSegments[0]);

      switch (merchant) {
        case BillMerchants.airtel:
          assetPath = AppAssets.airtel;
          break;

        case BillMerchants.boxOffice:
          assetPath = AppAssets.boxOffice;
          break;

        case BillMerchants.dstv:
          assetPath = AppAssets.dstv;
          break;

        case BillMerchants.gotv:
          assetPath = AppAssets.gotv;
          break;

        case BillMerchants.liquid:
          assetPath = AppAssets.liquid;
          break;

        case BillMerchants.mtn:
          assetPath = AppAssets.mtn;
          break;

        case BillMerchants.topStar:
          assetPath = AppAssets.topStar;
          break;

        case BillMerchants.zamtel:
          assetPath = AppAssets.zamtel;
          break;

        case BillMerchants.zesco:
          assetPath = AppAssets.zesco;
          break;

        default:
          assetPath = AppAssets.logo;
          break;
      }
    }

    return assetPath;
  }

  /// Returns the current month number (1-12)
  ///
  /// Returns integer representing the current month (January = 1, December = 12)
  int getCurrentMonth() => DateTime.now().month;

  /// Returns the start date (first day) of a specified month
  ///
  /// Parameters:
  /// - [month]: The target month number (1-12). If null, uses current month
  ///
  /// Returns DateTime representing the first day of the target month
  /// Handles month values that cross year boundaries (e.g., month 0 becomes December of previous year)
  DateTime getMonthStartDate({int? month}) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = now.year;

    // Adjust year if month is from previous year
    int year = targetYear;
    int adjustedMonth = targetMonth;

    if (targetMonth < 1) {
      // If month is less than 1, go to previous year
      year = targetYear - 1;
      adjustedMonth = 12 + targetMonth; // targetMonth is negative
    } else if (targetMonth > 12) {
      // If month is greater than 12, go to next year
      year = targetYear + (targetMonth ~/ 12);
      adjustedMonth = targetMonth % 12;
      if (adjustedMonth == 0) adjustedMonth = 12;
    }

    return DateTime(year, adjustedMonth, 1);
  }

  /// Returns the total number of days in a specified month
  ///
  /// Parameters:
  /// - [month]: Optional DateTime representing the target month. If null, uses current month start date
  ///
  /// Returns integer count of days in the month (28-31)
  int getTotalDaysInMonth({DateTime? month}) {
    final DateTime targetMonth = month ?? getMonthStartDate();

    // Get total days in the month
    return DateTime(targetMonth.year, targetMonth.month + 1, 0).day;
  }

  /// Checks if a transaction type is a credit transaction
  ///
  /// Parameters:
  /// - [transactionType]: The transaction type string to check
  ///
  /// Returns true if the transaction type contains "credit" (case-insensitive), false otherwise
  bool isCreditTransaction(String transactionType) =>
      transactionType.toLowerCase().contains("credit");

  /// Returns the appropriate background color for credit/debit transactions
  ///
  /// Parameters:
  /// - [transactionType]: The transaction type string
  /// - [appTheme]: The current ColorScheme for theme colors
  ///
  /// Returns Color with alpha 30 (semi-transparent):
  /// - Debit transactions: error color
  /// - Credit transactions: success color
  Color getCreditDebitBGColor(String transactionType, ColorScheme appTheme) {
    if (transactionType.toLowerCase().startsWith("debit")) {
      return appTheme.error.withAlpha(30);
    }

    return appTheme.success.withAlpha(30);
  }

  /// Returns the appropriate text color for credit/debit transactions
  ///
  /// Parameters:
  /// - [transactionType]: The transaction type string
  /// - [appTheme]: The current ColorScheme for theme colors
  ///
  /// Returns Color:
  /// - Debit transactions: error color
  /// - Credit transactions: success color
  Color getCreditDebitTextColor(String transactionType, ColorScheme appTheme) {
    if (transactionType.toLowerCase().startsWith("debit")) {
      return appTheme.error;
    }

    return appTheme.success;
  }

  /// Generates a unique reference string with an optional prefix
  ///
  /// Parameters:
  /// - [prefix]: Prefix for the reference (default "MOMO")
  ///
  /// Returns reference string combining prefix with current timestamp in milliseconds
  /// Example: "MOMO1734422400000"
  String generateReference({String prefix = "MOMO"}) =>
      "$prefix${DateTime.now().millisecondsSinceEpoch}";

  /// Extracts the wallet type from a wallet string (first word)
  ///
  /// Parameters:
  /// - [value]: The full wallet string (e.g., "MOMO Wallet", "Card Payment")
  ///
  /// Returns the first word of the wallet string
  String getWallet(String value) => value.split(" ")[0];

  /// Safely launches a URL after checking if it can be handled
  ///
  /// Parameters:
  /// - [context]: Build context for showing error messages
  /// - [url]: The URL string to launch
  ///
  /// Shows appropriate error messages if the URL cannot be launched
  Future<void> launchUrlSafe(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    try {
      // Check if the device can handle this type of URL
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        // If the device can't handle it (e.g., no phone app), show an error
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: SimpleAppText('Could not launch the requested action.'),
            ),
          );
        }
      }
    } catch (e) {
      // Handle any unexpected errors
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: SimpleAppText('An error occurred.')),
        );
      }
    }
  }

  Future<bool> makePhoneCall(String phoneNumber) async {
    // Remove any spaces or special characters
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Ensure it has the tel: prefix
    final Uri telUri = Uri(scheme: 'tel', path: cleanedNumber);

    // Check if can launch
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
      return true;
    } else {
      // Fallback: try with plus sign included
      final fallbackUri = Uri.parse('tel:$cleanedNumber');
      if (await canLaunchUrl(fallbackUri)) {
        await launchUrl(fallbackUri);
        return true;
      } else {
        // Show error
        print('Cannot make phone call on this device');
      }
    }

    return false;
  }

  /// Launches the device's default email app with a pre-filled email address
  ///
  /// Parameters:
  /// - [email]: The recipient email address
  /// - [subject]: Optional email subject
  /// - [body]: Optional email body
  /// - [cc]: Optional CC email address
  /// - [bcc]: Optional BCC email address
  ///
  /// Example:
  ///   launchEmail('someone@example.com')
  ///   launchEmail('someone@example.com', subject: 'Hello', body: 'How are you?')
  Future<bool> launchEmail(
    String email, {
    String? subject,
    String? body,
    String? cc,
    String? bcc,
  }) async {
    // Build the mailto URL
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null && subject.isNotEmpty) 'subject': subject,
        if (body != null && body.isNotEmpty) 'body': body,
        if (cc != null && cc.isNotEmpty) 'cc': cc,
        if (bcc != null && bcc.isNotEmpty) 'bcc': bcc,
      },
    );

    // Check if can launch
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
      return true;
    } else {
      // Show error
      print('Cannot launch email on this device');
    }

    return false;
  }

  /// Opens the native maps application with a specified address
  ///
  /// Parameters:
  /// - [address]: The address string to search for in maps
  ///
  /// Uses different URL schemes for Android and iOS:
  /// - Android: geo:0,0?q=address
  /// - iOS: Google Maps web URL
  /// Falls back to web browser if native app fails
  Future<void> openMapWithAddress(String address) async {
    // Encode the address to make it URL-safe (e.g., replacing spaces with %20)
    final encodedAddress = Uri.encodeComponent(address);

    // Different URLs for Android and iOS to ensure the native app opens [citation:3]
    final uri = Platform.isAndroid
        ? Uri.parse('geo:0,0?q=$encodedAddress') // Android uses 'geo:' scheme
        : Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
          ); // iOS uses web URL

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to a standard web browser if the app fails to launch
        final webUri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
        );
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri);
        } else {
          debugPrint('Could not launch map');
        }
      }
    } catch (e) {
      debugPrint('Error launching map: $e');
    }
  }

  /// Returns a value or provides a type-appropriate default if null
  ///
  /// Parameters:
  /// - [value]: The value to check for null
  /// - [defaultValue]: Optional explicit default value
  ///
  /// Returns the original value if not null, otherwise returns defaultValue
  /// or a type-appropriate default (empty string, 0, false, etc.)
  T valueOrDefault<T>(T? value, [T? defaultValue]) {
    if (value != null) return value;
    if (defaultValue != null) return defaultValue;
    return _getTypeDefault<T>();
  }

  /// Returns the original string if not empty, otherwise returns a default value
  ///
  /// Parameters:
  /// - [value]: The string to check for emptiness
  /// - [defaultValue]: The fallback value to return if string is empty (default "")
  ///
  /// Returns the original string if not empty, otherwise returns defaultValue
  String defaultIfEmpty(String value, [String defaultValue = ""]) {
    if (value.isNotEmpty) return value;

    return defaultValue;
  }

  /// Private helper to get type-appropriate defaults for valueOrDefault
  ///
  /// Returns type-appropriate defaults for common types:
  /// - String: ""
  /// - int: 0
  /// - double: 0.0
  /// - num: 0
  /// - bool: false
  /// - List: []
  /// - Map: {}
  /// - Set: <dynamic>{}
  ///
  /// Throws ArgumentError for custom types requiring explicit defaults
  static T _getTypeDefault<T>() {
    final type = T;

    if (type == String) return "" as T;
    if (type == int) return 0 as T;
    if (type == double) return 0.0 as T;
    if (type == num) return 0 as T;
    if (type == bool) return false as T;
    if (type == List) return [] as T;
    if (type == Map) return {} as T;
    if (type == Set) return <dynamic>{} as T;

    // For custom types, return null (but this will throw if T is non-nullable)
    // Better to require explicit default for custom types
    throw ArgumentError(
      'No default value defined for type $T. Please provide a default value.',
    );
  }

  /// Generates a unique identifier using UUID v4
  ///
  /// Returns a randomly generated UUID v4 string
  String getUniqueId() => UuidV4().generate();

  /// Returns a list of merchant names filtered by merchant type
  ///
  /// Parameters:
  /// - [merchant]: The BillMerchantType to filter by
  ///
  /// Returns a List<String> containing merchant labels that match the specified type
  /// Note: Currently filters by .airtime type regardless of input parameter
  List<String> getMerchantNamesByType(BillMerchantType merchant) {
    final merchants = (AppConstants.BILL_MERCHANTS.where(
      (merchant) => merchant.merchantType == .airtime,
    )).toList();

    return merchants.map((item) => valueOrDefault(item.label)).toList();
  }

  /// Prints each item in a list as a string for debugging purposes
  ///
  /// Parameters:
  /// - [value]: The list of items to print
  ///
  /// Calls toString() on each item automatically for formatted output
  void printList<T>(List<T> value) {
    for (var item in value) {
      debugPrint(item.toString());
    }
  }

  /// Retrieves an institution by name from a list of institutions
  ///
  /// Parameters:
  /// - [institutions]: List of InstitutionModel to search through
  /// - [institutionName]: The name of the institution to find
  ///
  /// Returns the matching InstitutionModel, or an empty InstitutionModel if not found
  InstitutionModel getInstitutionByName(
    List<InstitutionModel> institutions,
    String institutionName,
  ) {
    return institutions.firstWhere(
      (institution) =>
          StringUtils.areEqual(institution.participantName, institutionName),
      orElse: () => InstitutionModel.empty(),
    );
  }

  /// Extracts a list of attributes from a list of objects using a getter function
  ///
  /// Parameters:
  /// - [value]: The list of objects to extract attributes from
  /// - [getter]: Function that extracts a String attribute from each object
  ///
  /// Returns a List<String> of extracted attribute values
  List<String> getAttributeList<T, K>(
    List<T> value,
    String Function(T) getter,
  ) {
    return value.map((item) => getter(item)).toList();
  }

  /// Returns the international dialing code (ISD code) for a given country code
  ///
  /// Parameters:
  /// - [countryCode]: The two-letter ISO country code (e.g., "ZM", "ZA", "ZW")
  ///
  /// Returns the ISD dialing code with a plus sign (e.g., "+260", "+27", "+263")
  /// Returns an empty string if the country code is not recognized
  ///
  /// Example:
  ///   getISDCodeFromCountry("ZM") -> "+260" (Zambia)
  ///   getISDCodeFromCountry("ZA") -> "+27"  (South Africa)
  ///   getISDCodeFromCountry("ZW") -> "+263" (Zimbabwe)
  String getISDCodeFromCountry(String countryCode) {
    if (countryCode.isEmpty) return "";

    final code = countryCode.toUpperCase().trim();

    // Map of ISO 3166-1 alpha-2 codes to ISD dialing codes
    const isdMap = {
      "ZM": "+260", // Zambia
      "ZA": "+27", // South Africa
      "ZW": "+263", // Zimbabwe
    };

    return isdMap[code] ?? "";
  }

  bool isContextValid(BuildContext context) {
    if (context.mounted) {
      return true;
    }

    debugPrint("Invalid context found. Details: ${context.toString()}");
    return false;
  }

  double parseAmount(String? value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    // Remove thousands separators
    String cleaned = value.replaceAll(RegExp(r'[,\s]'), '');

    // If the string uses comma as decimal separator (European format)
    // e.g., "14.655,95" -> "14655.95"
    if (cleaned.contains(',')) {
      cleaned = cleaned.replaceAll(',', '.');
    }

    return double.tryParse(cleaned) ?? defaultValue;
  }

  String formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      debugPrint('Error formatting date: $e');
      return isoDate;
    }
  }
}
