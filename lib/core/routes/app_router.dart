import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/routes/transition_helper.dart';
import 'package:sampay_wallet/features/about_us/page.dart';
import 'package:sampay_wallet/features/bills/bill_payment.dart';
import 'package:sampay_wallet/features/bills/page.dart';
import 'package:sampay_wallet/features/bills/view_electricity_tokens.dart';
import 'package:sampay_wallet/features/dashboard/page.dart';
import 'package:sampay_wallet/features/ecommerce/page.dart';
import 'package:sampay_wallet/features/external_links/web_view.dart';
import 'package:sampay_wallet/features/faq/page.dart';
import 'package:sampay_wallet/features/favourites/favourites_detail.dart';
import 'package:sampay_wallet/features/favourites/page.dart';
import 'package:sampay_wallet/features/forgot_password/page.dart';
import 'package:sampay_wallet/features/international_payments/bank_payment.dart';
import 'package:sampay_wallet/features/international_payments/mobile_wallet_payment.dart';
import 'package:sampay_wallet/features/international_payments/page.dart';
import 'package:sampay_wallet/features/load_wallet/bank_details_pop.dart';
import 'package:sampay_wallet/features/load_wallet/card_payment_view.dart';
import 'package:sampay_wallet/features/load_wallet/list_banks.dart';
import 'package:sampay_wallet/features/load_wallet/mobile_money_payment.dart';
import 'package:sampay_wallet/features/load_wallet/page.dart';
import 'package:sampay_wallet/features/login/page.dart';
import 'package:sampay_wallet/features/pay_merchant/page.dart';
import 'package:sampay_wallet/features/profile/page.dart';
import 'package:sampay_wallet/features/registration/page.dart';
import 'package:sampay_wallet/features/reports/page.dart';
import 'package:sampay_wallet/features/reports/transaction_details.dart';
import 'package:sampay_wallet/features/scan-qr/generate_qr.dart';
import 'package:sampay_wallet/features/scan-qr/page.dart';
import 'package:sampay_wallet/features/scan-qr/scan_qr.dart';
import 'package:sampay_wallet/features/splash/page.dart';
import 'package:sampay_wallet/features/support/page.dart';
import 'package:newrelic_mobile/newrelic_navigation_observer.dart';
import 'package:sampay_wallet/features/transfer_payment/list_institutions.dart';
import 'package:sampay_wallet/features/transfer_payment/page.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const registration = '/registration';
  static const forgotPassword = '/forgotPassword';
  static const dashboard = '/dashboard';
  static const bills = '/bills';
  static const billPayment = '/billPayment';
  static const reports = '/reports';
  static const transaction = '/transactionDetails';
  static const ecommerce = '/ecommerce';
  static const webview = '/webview';
  static const profile = '/profile';
  static const favourites = '/favourites';
  static const favouritesDetail = '/favouritesDetail';
  static const loadWallet = '/loadWallet';
  static const mobileMoneyPayment = '/mobileMoneyPayment';
  static const cardPaymentView = '/cardPaymentView';
  static const aboutUs = '/aboutUs';
  static const faq = '/faq';
  static const support = '/support';
  static const electricityTokens = '/electricityTokens';
  static const payMerchant = '/payMerchant';
  static const qrCode = '/qrCode';
  static const generateQR = '/generateQR';
  static const scanQR = '/scanQR';
  static const transferPayment = '/transferPayment';
  static const listInstitutions = '/listInstitutions';
  static const listBanks = '/listBanks';
  static const bankDetails = '/bankDetails';
  static const internationalPayments = '/internationalPayments';
  static const internationalBankPayments = '/internationalBankPayments';
  static const internationalMobileWalletPayments =
      '/internationalMobileWalletPayments';

  static final GoRouter appRouter = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: handleRedirection,
    observers: [NewRelicNavigationObserver()],
    routes: [
      // Public routes (no shell)
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(const LoginPage()),
      ),
      GoRoute(
        path: AppRoutes.registration,
        name: AppRoutes.registration,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(RegistrationPage()),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: AppRoutes.forgotPassword,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(ForgotPasswordPage()),
      ),
      GoRoute(
        path: AppRoutes.webview,
        name: AppRoutes.webview,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(const ExternalWebView()),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: AppRoutes.dashboard,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(DashboardPage()),
      ),
      GoRoute(
        path: AppRoutes.bills,
        name: AppRoutes.bills,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(BillsPage()),
      ),
      GoRoute(
        path: AppRoutes.reports,
        name: AppRoutes.reports,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(ReportsPage()),
      ),
      GoRoute(
        path: AppRoutes.ecommerce,
        name: AppRoutes.ecommerce,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(const EcommercePage()),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profile,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(const ProfilePage()),
      ),
      GoRoute(
        path: AppRoutes.favourites,
        name: AppRoutes.favourites,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(FavouritesPage()),
      ),
      GoRoute(
        path: AppRoutes.favouritesDetail,
        name: AppRoutes.favouritesDetail,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(FavouritesDetailPage()),
      ),
      GoRoute(
        path: AppRoutes.transaction,
        name: AppRoutes.transaction,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(const TransactionDetailsPage()),
      ),
      GoRoute(
        path: AppRoutes.billPayment,
        name: AppRoutes.billPayment,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(BillPaymentPage()),
      ),
      GoRoute(
        path: AppRoutes.loadWallet,
        name: AppRoutes.loadWallet,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(LoadWalletPage()),
      ),
      GoRoute(
        path: AppRoutes.mobileMoneyPayment,
        name: AppRoutes.mobileMoneyPayment,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(MobileMoneyPaymentPage()),
      ),
      GoRoute(
        path: AppRoutes.cardPaymentView,
        name: AppRoutes.cardPaymentView,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(CardPaymentVeiew()),
      ),
      GoRoute(
        path: AppRoutes.aboutUs,
        name: AppRoutes.aboutUs,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(AboutUsPage()),
      ),
      GoRoute(
        path: AppRoutes.faq,
        name: AppRoutes.faq,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(FAQPage()),
      ),
      GoRoute(
        path: AppRoutes.support,
        name: AppRoutes.support,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(SupportPage()),
      ),
      GoRoute(
        path: AppRoutes.electricityTokens,
        name: AppRoutes.electricityTokens,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(ViewElectricityTokensPage()),
      ),
      GoRoute(
        path: AppRoutes.payMerchant,
        name: AppRoutes.payMerchant,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(PayMerchantPage()),
      ),
      GoRoute(
        path: AppRoutes.qrCode,
        name: AppRoutes.qrCode,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(QRPage()),
      ),
      GoRoute(
        path: AppRoutes.generateQR,
        name: AppRoutes.generateQR,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(GenerateQRCode()),
      ),
      GoRoute(
        path: AppRoutes.scanQR,
        name: AppRoutes.scanQR,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(ScanQRCode()),
      ),
      GoRoute(
        path: AppRoutes.transferPayment,
        name: AppRoutes.transferPayment,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(TransferPaymentPage()),
      ),
      GoRoute(
        path: AppRoutes.listInstitutions,
        name: AppRoutes.listInstitutions,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(ListInstitutionsPage()),
      ),
      GoRoute(
        path: AppRoutes.listBanks,
        name: AppRoutes.listBanks,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(LoadWalletFromBankPage()),
      ),
      GoRoute(
        path: AppRoutes.bankDetails,
        name: AppRoutes.bankDetails,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(BankDetailsAndPopPage()),
      ),
      GoRoute(
        path: AppRoutes.internationalPayments,
        name: AppRoutes.internationalPayments,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(InternationalPaymentsPage()),
      ),
      GoRoute(
        path: AppRoutes.internationalBankPayments,
        name: AppRoutes.internationalBankPayments,
        builder: (context, state) =>
            TransitionHelper.slideInFromRight(InternationalBankPaymentsPage()),
      ),
      GoRoute(
        path: AppRoutes.internationalMobileWalletPayments,
        name: AppRoutes.internationalMobileWalletPayments,
        builder: (context, state) => TransitionHelper.slideInFromRight(
          InternationalMobileWalletPaymentsPage(),
        ),
      ),

      // Shell route for protected pages (with DashboardLayout)
      //   ShellRoute(
      //     builder: (context, state, child) {
      //       return DashboardLayout(selectedTabBarIndex: 0, child: child);
      //     },
      //     routes: [
      //       // GoRoute(
      //       //   path: AppRoutes.dashboard,
      //       //   name: AppRoutes.dashboard,
      //       //   builder: (context, state) =>
      //       //       TransitionHelper.fadeIn(const DashboardPage()),
      //       // ),
      //       // GoRoute(
      //       //   path: AppRoutes.bills,
      //       //   name: AppRoutes.bills,
      //       //   builder: (context, state) =>
      //       //       TransitionHelper.fadeIn(const BillsPage()),
      //       // ),
      //       // GoRoute(
      //       //   path: AppRoutes.reports,
      //       //   name: AppRoutes.reports,
      //       //   builder: (context, state) =>
      //       //       TransitionHelper.fadeIn(const ReportsPage()),
      //       // ),
      //       // GoRoute(
      //       //   path: AppRoutes.ecommerce,
      //       //   name: AppRoutes.ecommerce,
      //       //   builder: (context, state) =>
      //       //       TransitionHelper.fadeIn(const EcommercePage()),
      //       // ),
      //     ],
      //   ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );

  static FutureOr<String?> handleRedirection(
    BuildContext context,
    GoRouterState state,
  ) {
    return state.matchedLocation;
  }
}
