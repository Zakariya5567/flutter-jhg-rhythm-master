import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/app_utils/app_subscription.dart';
import 'package:rhythm_master/providers/home_provider.dart';
import 'package:rhythm_master/providers/metro_provider.dart';
import 'package:rhythm_master/providers/setting_provider.dart';
import 'package:rhythm_master/providers/speed_provider.dart';
import 'package:rhythm_master/providers/tap_temp_provider.dart';
import 'package:rhythm_master/views/screens/home_screen.dart';

import 'app_utils/app_info.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PackageInfo? packageInfo;

  Future<void> initPackageInfo() async {
    packageInfo = await getDeviceInfo();
  }

  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarBrightness: Brightness.dark, // Dark text for status bar
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TapTempoProvider>(
            create: (context) => TapTempoProvider()),
        ChangeNotifierProvider<SpeedProvider>(
            create: (context) => SpeedProvider()),
        ChangeNotifierProvider<MetroProvider>(
            create: (context) => MetroProvider()),
        ChangeNotifierProvider<SettingProvider>(
            create: (context) => SettingProvider()),
        ChangeNotifierProvider<HomeProvider>(
            create: (context) => HomeProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1.0)),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'JHG Rhythm ',
        theme: JHGTheme.themeData.copyWith(
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(JHGColors.whiteGrey),
          ),
        ),
        home: kIsWeb
            ? const HomeScreen()
            : SplashScreen(
                yearlySubscriptionId: yearlySubscription(),
                monthlySubscriptionId: monthlySubscription(),
                appName: AppStrings.appName,
                appVersion: packageInfo?.version ?? "",
                nextPage: () => const HomeScreen(),
                featuresList: getFeaturesList(),
              ),
      ),
    );
  }
}
