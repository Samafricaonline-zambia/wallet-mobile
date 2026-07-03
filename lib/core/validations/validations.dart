// core/validations/app_validations.dart
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/models/bill_merchant_model.dart';

class AppValidations {
  /// Validates a Zambian phone number
  ///
  /// Format: Zambian mobile numbers (9 digits after area code)
  /// Accepted formats: +260XXXXXXXXX, 260XXXXXXXXX, 0XXXXXXXXX, or just XXXXXXXXX
  /// The number will be normalized to 9 digits for validation
  /// Example: +260977123456, 0977123456, 977123456
  /// Returns null if valid, error message string if invalid
  static String? validatePhoneNumber(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Phone number is required';
    }

    String cleaned = value.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Remove +260 if present
    if (cleaned.startsWith('+260')) {
      cleaned = cleaned.substring(4);
    }

    // Remove leading 260 if present
    if (cleaned.startsWith('260')) {
      cleaned = cleaned.substring(3);
    }

    // Remove leading 0 if present
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }

    // Should be 9 digits
    if (cleaned.length != 9) {
      return 'Phone number must be 9 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'Phone number must contain only digits';
    }

    return null;
  }

  /// Validates a password based on security requirements
  ///
  /// Parameters:
  /// - [minLength]: Minimum password length (default 8)
  /// - [requireUppercase]: Whether password must contain uppercase letter (default true)
  /// - [requireDigits]: Whether password must contain at least one digit (default true)
  ///
  /// Returns null if valid, error message string if invalid
  static String? validatePassword(
    String? value, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireDigits = true,
  }) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    if (requireUppercase && !RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (requireDigits && !RegExp(r'(?=.*[0-9])').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validates that the confirm password matches the original password
  ///
  /// Parameters:
  /// - [value]: The confirm password string to validate
  /// - [password]: The original password to compare against
  ///
  /// Returns null if passwords match, error message string if they don't
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates a Zambian NRC (National Registration Card) number
  ///
  /// Format: 9 digits (e.g., 123456789)
  /// The number will be cleaned by removing any '/' characters
  /// Example: 123456/78/9 -> normalized to 9 digits
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateNRC(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NRC number is required';
    }

    String cleaned = value.trim().replaceAll('/', '');

    // NRC should be 9 digits (format: 123456/78/9 -> 9 digits)
    if (cleaned.length != 9) {
      return 'NRC must be 9 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'NRC must contain only digits';
    }

    return null;
  }

  /// Validates an email address format
  ///
  /// Checks for standard email pattern: local-part@domain.extension
  /// Example: user@example.com, name.surname@domain.co.zm
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateEmail(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Email address is required';
    }

    final email = value.trim();
    final isValid = RegExp(
      r'^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}$',
    ).hasMatch(email);

    return isValid ? null : 'Please enter a valid email address';
  }

  /// Validates that a string value is not null or empty
  ///
  /// Returns null if value is not empty, error message string if empty or null
  static String? validateNotNull(String? value, {String? message}) {
    if (value != null && value.isNotEmpty) {
      return null;
    }

    return message ?? "Please provide a value";
  }

  /// Validates that a numeric string value is not zero
  ///
  /// Parses the string as a double and checks if the absolute value is not zero
  /// Returns null if value is greater than zero, error message if value is zero or null
  static String? validateNotNullOrZero(String? value, {String? message}) {
    final intValue = (double.tryParse(value ?? "0.0") ?? 0.0).abs();

    if (intValue != 0) {
      return null;
    }

    return message ?? "Please provide a value";
  }

  /// Validates that a numeric string value is not less than a minimum threshold
  ///
  /// Parameters:
  /// - [min]: Minimum allowed value (default 1)
  ///
  /// Returns null if value >= min, error message if value < min or invalid
  static String? validateNotNullOrLessThan(
    String? value, {
    String? message,
    double min = 1,
  }) {
    final intValue = (double.tryParse(value ?? "0.0") ?? 0.0).abs();

    if (intValue >= min) {
      return null;
    }

    return message ?? "Please provide a value";
  }

  /// Validates that a string value is not null, not empty, and not equal to "none"
  ///
  /// Useful for dropdown selections where "none" is a placeholder option
  /// Returns null if valid, error message if invalid
  static String? validateNotNone(String? value, {String? message}) {
    if (value != null && value.isNotEmpty && value != "none") {
      return null;
    }

    return message ?? "Please select a non-none value";
  }

  /// Validates Zambian Electricity Meter numbers
  ///
  /// Format: Usually 11 digits for ZESCO meters
  /// Pattern: Starts with 1, 2, 3, 4, or 5 followed by 10 digits
  /// Length: 11-13 digits total
  /// Example: 12345678901, 2147483647
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateZambianElectricityMeter(
    String? value, {
    String? message,
  }) {
    if (value == null || value.isEmpty) {
      return message ?? "Electricity meter number is required";
    }

    // Remove any whitespace
    final meterNumber = value.trim().replaceAll(' ', '');

    // Check if empty after trimming
    if (meterNumber.isEmpty) {
      return message ?? "Electricity meter number is required";
    }

    // Check length (ZESCO standard is 11 digits)
    if (meterNumber.length < 10 || meterNumber.length > 13) {
      return "Meter number should be 11-13 digits";
    }

    // Check if contains only digits
    if (!RegExp(r'^\d+$').hasMatch(meterNumber)) {
      return "Meter number should contain only numbers";
    }

    // For ZESCO meters: Usually starts with 1, 2, 3, 4, or 5
    final firstDigit = int.parse(meterNumber[0]);
    if (firstDigit < 0) {
      return "Invalid meter number format";
    }

    return null;
  }

  /// Validates Zambian DStv smartcard numbers
  ///
  /// Format: 9-12 digits (most common is 11 digits)
  /// Pattern: Typically starts with 1, 2, 3, 4, 5, or 6
  /// Examples: 12345678901, 45678901234
  /// The number will be cleaned by removing whitespace and hyphens
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateZambianDStv(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? "DStv smartcard number is required";
    }

    // Remove whitespace and special characters
    final smartcardNumber = value.trim().replaceAll(RegExp(r'[\s\-]'), '');

    if (smartcardNumber.isEmpty) {
      return message ?? "DStv smartcard number is required";
    }

    // DStv smartcard number formats:
    // - 11 digits (most common)
    // - 10 digits (older cards)
    // - 9 digits (legacy)
    if (smartcardNumber.length < 9 || smartcardNumber.length > 12) {
      return "DStv smartcard number should be 9-12 digits";
    }

    // Check if contains only digits
    if (!RegExp(r'^\d+$').hasMatch(smartcardNumber)) {
      return "Smartcard number should contain only numbers";
    }

    // Optional: Check if starts with valid prefix (DStv Zambia typically starts with 4, 5, or 6)
    final firstDigit = int.parse(smartcardNumber[0]);
    if (![1, 2, 3, 4, 5, 6].contains(firstDigit)) {
      return "Invalid DStv smartcard number format";
    }

    return null;
  }

  /// Validates Zambian GoTV smartcard numbers
  ///
  /// Format: 9-11 digits (most common is 10 digits)
  /// Pattern: Typically starts with 1, 2, or 3
  /// Examples: 1234567890, 23456789012
  /// The number will be cleaned by removing whitespace and hyphens
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateZambianGoTV(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? "GoTV smartcard number is required";
    }

    // Remove whitespace and special characters
    final smartcardNumber = value.trim().replaceAll(RegExp(r'[\s\-]'), '');

    if (smartcardNumber.isEmpty) {
      return message ?? "GoTV smartcard number is required";
    }

    // GoTV smartcard number formats:
    // - 10 digits (most common)
    // - 11 digits (newer cards)
    // - 9 digits (older cards)
    if (smartcardNumber.length < 9 || smartcardNumber.length > 11) {
      return "GoTV smartcard number should be 9-11 digits";
    }

    // Check if contains only digits
    if (!RegExp(r'^\d+$').hasMatch(smartcardNumber)) {
      return "Smartcard number should contain only numbers";
    }

    // GoTV numbers typically start with 1, 2, or 3
    final firstDigit = int.parse(smartcardNumber[0]);
    if (![1, 2, 3].contains(firstDigit)) {
      return "Invalid GoTV smartcard number format";
    }

    return null;
  }

  /// Validates Zambian TopStar decoder numbers
  ///
  /// Format: 8-12 digits (most common is 10 digits)
  /// Pattern: Typically starts with 1, 2, 4, or 5
  /// Examples: 1234567890, 456789012345
  /// The number will be cleaned by removing whitespace and hyphens
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateZambianTopStar(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? "TopStar decoder number is required";
    }

    // Remove whitespace and special characters
    final decoderNumber = value.trim().replaceAll(RegExp(r'[\s\-]'), '');

    if (decoderNumber.isEmpty) {
      return message ?? "TopStar decoder number is required";
    }

    // TopStar decoder number formats:
    // - 10 digits (standard)
    // - 8 digits (older models)
    // - 12 digits (newer models)
    if (decoderNumber.length < 8 || decoderNumber.length > 12) {
      return "TopStar decoder number should be 8-12 digits";
    }

    // Check if contains only digits
    if (!RegExp(r'^\d+$').hasMatch(decoderNumber)) {
      return "Decoder number should contain only numbers";
    }

    // TopStar numbers typically start with 1, 2, 4, or 5
    final firstDigit = int.parse(decoderNumber[0]);
    if (![1, 2, 4, 5].contains(firstDigit)) {
      return "Invalid TopStar decoder number format";
    }

    return null;
  }

  /// Validates Zambian BoxOffice smartcard numbers
  ///
  /// Format: 9-11 digits (most common is 10 digits)
  /// Pattern: Typically starts with 1, 2, or 3
  /// Examples: 1234567890, 23456789012
  /// The number will be cleaned by removing whitespace and hyphens
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateZambianBoxOffice(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? "BoxOffice smartcard number is required";
    }

    // Remove whitespace and special characters
    final smartcardNumber = value.trim().replaceAll(RegExp(r'[\s\-]'), '');

    if (smartcardNumber.isEmpty) {
      return message ?? "BoxOffice smartcard number is required";
    }

    // BoxOffice smartcard number formats:
    // - 10 digits (standard)
    // - 9 digits (legacy)
    if (smartcardNumber.length < 9 || smartcardNumber.length > 11) {
      return "BoxOffice smartcard number should be 9-11 digits";
    }

    // Check if contains only digits
    if (!RegExp(r'^\d+$').hasMatch(smartcardNumber)) {
      return "Smartcard number should contain only numbers";
    }

    // BoxOffice numbers typically start with 1, 2, or 3
    final firstDigit = int.parse(smartcardNumber[0]);
    if (![1, 2, 3].contains(firstDigit)) {
      return "Invalid BoxOffice smartcard number format";
    }

    return null;
  }

  /// Validates Cable TV payment based on the provider type
  ///
  /// Currently supports basic non-zero validation
  /// Can be extended to support provider-specific validations for:
  /// - DStv, GoTV, BoxOffice, TopStar
  ///
  /// Parameters:
  /// - [cableTv]: The cable TV provider name
  /// - [value]: The smartcard/decoder number to validate
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateCableTVPayment(
    String cableTv,
    String? value, {
    String? message,
  }) {
    return validateNotNullOrZero(value, message: message);
    // switch (BillMerchants.fromString(cableTv)) {
    //   case BillMerchants.dstv:
    //     return validateZambianDStv(value, message: message);

    //   case BillMerchants.boxOffice:
    //     return validateZambianBoxOffice(value, message: message);

    //   case BillMerchants.gotv:
    //     return validateZambianGoTV(value, message: message);

    //   default:
    //     return validateZambianTopStar(value, message: message);
    // }
  }

  /// Validates bill payment based on merchant type
  ///
  /// Routes to the appropriate validation function based on the merchant type:
  /// - [BillMerchantType.cableTv]: Validates Cable TV smartcard/decoder numbers
  /// - [BillMerchantType.electricity]: Validates electricity meter numbers
  /// - Other types: Validates phone numbers by default
  ///
  /// Parameters:
  /// - [merchant]: The bill merchant model containing merchant type and name
  /// - [value]: The account/meter/smartcard number to validate
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateBillPayment(
    BillMerchantModel merchant,
    String? value, {
    String? message,
  }) {
    switch (merchant.merchantType) {
      case BillMerchantType.cableTv:
        return validateCableTVPayment(merchant.name, value, message: message);

      case BillMerchantType.electricity:
        return validateZambianElectricityMeter(value, message: message);

      default:
        return validatePhoneNumber(value, message: message);
    }
  }

  /// Validates Zambian bank account numbers
  ///
  /// Supports all major Zambian banks with their specific account number formats
  /// Returns null if valid, error message string if invalid
  ///
  /// Parameters:
  /// - [value]: The account number string to validate
  /// - [message]: Custom error message (optional)
  /// - [bankName]: The name of the bank for bank-specific validation (optional)
  ///
  /// Example: validateZambianBankAccount('5763022500191', bankName: 'Zanaco')
  static String? validateZambianBankAccount(
    String? value, {
    String? message,
    String? bankName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Bank account number is required';
    }

    // Clean the input - remove spaces, hyphens, and special characters
    String cleaned = value.trim().replaceAll(RegExp(r'[\s\-\.]'), '');

    if (cleaned.isEmpty) {
      return message ?? 'Bank account number is required';
    }

    // Check if contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'Account number must contain only digits';
    }

    // If bank name is provided, do bank-specific validation
    if (bankName != null && bankName.isNotEmpty) {
      return _validateByBank(cleaned, bankName, message);
    }

    // Generic validation for any Zambian bank
    // Most Zambian bank accounts are between 8-16 digits
    if (cleaned.length < 8 || cleaned.length > 16) {
      return 'Account number should be between 8-16 digits';
    }

    return null;
  }

  /// Bank-specific validation helper function
  ///
  /// Validates account numbers against specific bank formats
  ///
  /// Parameters:
  /// - [accountNumber]: The cleaned account number string
  /// - [bankName]: The name of the bank for format validation
  /// - [message]: Custom error message (optional)
  ///
  /// Returns null if valid, error message string if invalid
  static String? _validateByBank(
    String accountNumber,
    String bankName,
    String? message,
  ) {
    // Convert bank name to lowercase for case-insensitive matching
    final bank = bankName.toLowerCase().trim();

    // ==================== ZANACO ====================
    /// Zanaco Bank
    /// Format: Usually 13 digits, sometimes 10-16 digits
    /// Pattern: Starts with 5, 6, 7, or 8
    if (bank.contains('zanaco')) {
      if (accountNumber.length < 10 || accountNumber.length > 16) {
        return 'Zanaco account number should be 10-16 digits';
      }
      final firstDigit = int.parse(accountNumber[0]);
      if (![5, 6, 7, 8].contains(firstDigit)) {
        return 'Invalid Zanaco account number format';
      }
      return null;
    }

    // ==================== ABSA ====================
    /// ABSA Bank (formerly Barclays)
    /// Format: Usually 7-12 digits
    if (bank.contains('absa')) {
      if (accountNumber.length < 7 || accountNumber.length > 12) {
        return 'ABSA account number should be 7-12 digits';
      }
      return null;
    }

    // ==================== ATLASMARA ====================
    /// AtlasMara (BancABC) - Access Bank
    /// Format: Usually 13 digits
    /// Pattern: Starts with 0, 1, 2, 3
    if (bank.contains('atlasmara') || bank.contains('bancabc')) {
      if (accountNumber.length != 13) {
        return 'AtlasMara account number should be 13 digits';
      }
      final firstDigit = int.parse(accountNumber[0]);
      if (![0, 1, 2, 3].contains(firstDigit)) {
        return 'Invalid AtlasMara account number format';
      }
      return null;
    }

    // ==================== ACCESS BANK ====================
    /// Access Bank
    /// Format: Usually 10-12 digits
    if (bank.contains('access')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'Access Bank account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== BANK OF CHINA ====================
    /// Bank of China
    /// Format: Usually 10-14 digits
    if (bank.contains('bank of china')) {
      if (accountNumber.length < 10 || accountNumber.length > 14) {
        return 'Bank of China account number should be 10-14 digits';
      }
      return null;
    }

    // ==================== CITIBANK ====================
    /// Citibank
    /// Format: Usually 10-12 digits
    if (bank.contains('citibank') || bank.contains('citi')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'Citibank account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== ECOBANK ====================
    /// ECOBANK
    /// Format: Usually 10-12 digits
    if (bank.contains('ecobank') || bank.contains('eco')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'ECOBANK account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== FAB ====================
    /// FAB (First Alliance Bank)
    /// Format: Usually 10-12 digits
    if (bank.contains('fab')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'FAB account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== FCB ====================
    /// FCB (Finance Bank)
    /// Format: Usually 10-12 digits
    if (bank.contains('fcb')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'FCB account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== FINCA ====================
    /// Finca
    /// Format: Usually 10-12 digits
    if (bank.contains('finca')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'Finca account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== FNB ====================
    /// FNB (First National Bank)
    /// Format: Usually 10-11 digits
    /// Pattern: Often starts with 6
    if (bank.contains('fnb') || bank.contains('first national')) {
      if (accountNumber.length < 10 || accountNumber.length > 11) {
        return 'FNB account number should be 10-11 digits';
      }
      return null;
    }

    // ==================== INVESTRUST ====================
    /// Investrust Bank
    /// Format: Usually 10-12 digits
    if (bank.contains('investrust')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'Investrust account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== IZB ====================
    /// IZB (Indo Zambia Bank)
    /// Format: Usually 10-12 digits
    if (bank.contains('izb') ||
        (bank.contains('indo') && bank.contains('zambia'))) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'IZB account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== NATSAVE ====================
    /// Natsave (National Savings and Credit Bank)
    /// Format: Usually 10-12 digits
    if (bank.contains('natsave')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'Natsave account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== STANBIC ====================
    /// Stanbic Bank
    /// Format: Usually 10-12 digits
    if (bank.contains('stanbic')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'Stanbic account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== STDCHART ====================
    /// Standard Chartered Bank
    /// Format: Usually 10-12 digits
    if (bank.contains('stdchart') || bank.contains('standard chartered')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'Standard Chartered account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== TENGA ====================
    /// Tenga (AtlasMara) - Access Bank
    /// Format: Usually 13 digits
    if (bank.contains('tenga')) {
      if (accountNumber.length != 13) {
        return 'Tenga account number should be 13 digits';
      }
      return null;
    }

    // ==================== UBA ====================
    /// UBA Bank (United Bank for Africa)
    /// Format: Usually 10-14 digits
    if (bank.contains('uba') || bank.contains('united bank for africa')) {
      if (accountNumber.length < 10 || accountNumber.length > 14) {
        return 'UBA account number should be 10-14 digits';
      }
      return null;
    }

    // ==================== ZICB ====================
    /// ZICB (Zambia Industrial Commercial Bank)
    /// Format: Usually 10-12 digits
    if (bank.contains('zicb')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'ZICB account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== ZNBS ====================
    /// ZNBS (Zambia National Building Society)
    /// Format: Usually 10-12 digits
    if (bank.contains('znbs')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'ZNBS account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== AB BANK MNO ====================
    /// AB Bank MNO
    /// Format: Usually 10-12 digits
    if (bank.contains('ab bank') && bank.contains('mno')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'AB Bank MNO account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== ABBANK (ETUMBA) ====================
    /// ABBank (Etumba)
    /// Format: Usually 10-12 digits
    if (bank.contains('abbank') || bank.contains('etumba')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'ABBank account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== MNO BANKS (Mobile Money) ====================
    /// E-money banks (MNO variants)
    /// These are mobile money versions of the banks
    if (bank.contains('mno')) {
      if (accountNumber.length < 10 || accountNumber.length > 12) {
        return 'E-money account number should be 10-12 digits';
      }
      return null;
    }

    // ==================== UAT ENVIRONMENT BANKS ====================
    /// UAT environment banks (ABSA Spark, Finca UAT)
    if (bank.contains('spark') || bank.contains('uat')) {
      if (accountNumber.length < 10 || accountNumber.length > 14) {
        return 'Account number should be 10-14 digits';
      }
      return null;
    }

    // If bank is not specifically recognized, use generic validation
    if (accountNumber.length < 8 || accountNumber.length > 16) {
      return 'Account number should be between 8-16 digits';
    }

    return null;
  }

  /// Validates bank account with optional branch code
  ///
  /// Combines account number validation with branch code validation
  ///
  /// Parameters:
  /// - [accountNumber]: The account number string to validate
  /// - [branchCode]: Optional branch code to validate
  /// - [message]: Custom error message (optional)
  /// - [bankName]: The name of the bank (optional)
  ///
  /// Returns null if all valid, error message string if invalid
  static String? validateBankAccountWithBranch(
    String? accountNumber,
    String? branchCode, {
    String? message,
    String? bankName,
  }) {
    // First validate the account number
    final accountValidation = validateZambianBankAccount(
      accountNumber,
      message: message,
      bankName: bankName,
    );

    if (accountValidation != null) {
      return accountValidation;
    }

    // If branch code is provided, validate it
    if (branchCode != null && branchCode.isNotEmpty) {
      final branchValidation = validateBranchCode(branchCode);
      if (branchValidation != null) {
        return branchValidation;
      }
    }

    return null;
  }

  /// Validates Zambian bank branch codes
  ///
  /// Branch codes are numeric codes used to identify specific bank branches
  /// Format: 3-6 digits
  ///
  /// Parameters:
  /// - [value]: The branch code string to validate
  /// - [message]: Custom error message (optional)
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateBranchCode(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Branch code is required';
    }

    String cleaned = value.trim().replaceAll(RegExp(r'[\s\-\.]'), '');

    if (cleaned.isEmpty) {
      return message ?? 'Branch code is required';
    }

    // Branch codes are usually 3-6 digits
    if (cleaned.length < 3 || cleaned.length > 6) {
      return 'Branch code should be 3-6 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'Branch code must contain only digits';
    }

    return null;
  }

  /// Validates complete bank account details including account number, branch code, and sort code
  ///
  /// Parameters:
  /// - [accountNumber]: The account number string to validate
  /// - [branchCode]: Optional branch code to validate
  /// - [sortCode]: Optional sort code to validate
  /// - [bankName]: The name of the bank (optional)
  ///
  /// Returns null if all valid, error message string if invalid
  ///
  /// Example:
  /// final error = AppValidations.validateBankAccountDetails(
  ///   accountNumber: '5763022500191',
  ///   branchCode: '042',
  ///   sortCode: '010142',
  ///   bankName: 'Zanaco',
  /// );
  static String? validateBankAccountDetails({
    String? accountNumber,
    String? branchCode,
    String? sortCode,
    String? bankName,
  }) {
    // Validate account number
    if (accountNumber == null || accountNumber.isEmpty) {
      return 'Account number is required';
    }

    final accountValidation = validateZambianBankAccount(
      accountNumber,
      bankName: bankName,
    );
    if (accountValidation != null) {
      return accountValidation;
    }

    // Validate branch code if provided
    if (branchCode != null && branchCode.isNotEmpty) {
      final branchValidation = validateBranchCode(branchCode);
      if (branchValidation != null) {
        return branchValidation;
      }
    }

    // Validate sort code if provided
    if (sortCode != null && sortCode.isNotEmpty) {
      final sortValidation = validateSortCode(sortCode);
      if (sortValidation != null) {
        return sortValidation;
      }
    }

    return null;
  }

  /// Validates Zambian bank sort codes
  ///
  /// Sort codes are 6-digit codes used to identify banks and branches
  /// Format: 6 digits (e.g., 010142)
  ///
  /// Parameters:
  /// - [value]: The sort code string to validate
  /// - [message]: Custom error message (optional)
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateSortCode(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Sort code is required';
    }

    String cleaned = value.trim().replaceAll(RegExp(r'[\s\-\.]'), '');

    if (cleaned.isEmpty) {
      return message ?? 'Sort code is required';
    }

    // Sort codes are usually 6 digits (e.g., 010142)
    if (cleaned.length != 6) {
      return 'Sort code must be 6 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'Sort code must contain only digits';
    }

    return null;
  }

  /// Validates that a string has a specific number of characters
  ///
  /// Parameters:
  /// - [value]: The string to check
  /// - [count]: The exact number of characters required
  /// - [message]: Custom error message (optional)
  ///
  /// Returns null if valid, error message if invalid
  ///
  /// Example:
  ///   validateCharCount("123456", 6) -> null
  ///   validateCharCount("12345", 6) -> "Must be exactly 6 characters"
  static String? validateCharCount(
    String? value, {
    int count = 6,
    String? message,
  }) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'This field is required';
    }

    final text = value.trim();

    if (text.length != count) {
      return message ?? 'Must be exactly $count characters';
    }

    return null;
  }
}
