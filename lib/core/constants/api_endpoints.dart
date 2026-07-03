// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl =
      "https://samafricaonline.com/sam_pay/public/api/v1";
  static const String paymentsBaseUrl = "https://payments.sampay.dev/api/v1";

  // Auth endpoints
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String sendOtp = '/verify-user';
  static const String verifyOtp = '/verify-otp';
  static const String register = '/register';

  // Wallet endpoints
  static const String walletBalance = '/wallet/balance';
  static const String walletGetNrc = '/wallet/nrc';
  static const String walletVerify = '/verify';
  static const String walletTransactionHistory = '/wallet/transactionHistory';
  static const String walletTransferHistory = '/wallet/transfer-history';
  static const String walletFundMomo = '/wallet/fund/momo';
  static const String walletFundCard = '/wallet/fund/card';
  static const String walletUploadDepositProof = '/wallet/uploadDepositProof';
  static const String walletWithdrawBank = '/wallet/withdraw/bank';
  static const String walletWithdrawMomo = '/wallet/withdraw/momo';
  static const String walletTransferBalances = '/wallet/transfer-balances';
  static const String walletQRPayment = '/wallet/sendhome';
  static const String walletPayMerchant = '/wallet/merchant';
  static const String walletScanAndPay = '/wallet/scan';
  static const String wallerUploadBankDeposit = '/wallet/uploadDepositProof';
  static const String walletDeductInternational = '/wallet/deduct_int_balance';

  // KYC endpoints
  static const String kycPersonal = '/kyc/personal';
  static const String kycStatus = '/kyc/status';

  // VAS endpoints
  static const String vasPayment = '/vas/payment';
  static const String vasZescoTokens = '/vas/zesco-tokens';
  static const String vasSavedAccounts = '/vas/saved-accounts';

  // Institutions
  static const String institutions = "/nfs/institutions";
}

// International Payments
class InternationalPaymentsEndpoints {
  static const String healthCheck = "/health_check";
  static const String verifyAccount = "/verification";
  static const String paymentRequest = "/payment";
  static const String returnPayment = "/payment_return";
}
