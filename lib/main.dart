import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sampay_wallet/core/constants/new_relic_config.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/themes/app_theme.dart';
import 'package:sampay_wallet/services/app_state_service.dart';

void main() async {
  // 1. Ensure Flutter binding is initialized FIRST
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // 2. Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 3. Initialize dependencies
  await configureDependencies();

  // 4. Initialize ScreenUtil
  await ScreenUtil.ensureScreenSize();

  // 5. Initialize New Relic (don't await - let it run in background)
  NewRelicConfig().init();

  // 6. Run app immediately (NOT inside New Relic callback)
  runApp(const SampayWalletApp());
}

class SampayWalletApp extends StatelessWidget {
  const SampayWalletApp({super.key});

  void registerCriticalServices() {
    getIt<AppStateService>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    registerCriticalServices();

    return ScreenUtilInit(
      designSize: const Size(375, 812), // Your design size (e.g., iPhone X)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Sampay Wallet',
          theme: AppTheme.lightTheme, // Light mode theme
          darkTheme: AppTheme.darkTheme, // Dark mode theme
          themeMode: ThemeMode.system, // Follows system setting
          //home: const SplashScreen(),
          routerConfig: AppRoutes.appRouter,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
