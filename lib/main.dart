import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:rhythm_master/providers/home_provider.dart';
import 'package:rhythm_master/providers/metro_provider.dart';
import 'package:rhythm_master/providers/setting_provider.dart';
import 'package:rhythm_master/providers/speed_provider.dart';
import 'package:rhythm_master/providers/tap_temp_provider.dart';
import 'package:rhythm_master/views/screens/home_screen.dart';

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
  PackageInfo packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
    buildSignature: '',
    installerStore: '',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    packageInfo = info;
    print('packageInfo.version ${packageInfo.version}');
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
        title: 'JHG Rhythm Master',
        theme: JHGTheme.themeData,
        // ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        //   scaffoldBackgroundColor: JHGColors.secondryBlack,
        // ),
        home: HomeScreen(),
        // SplashScreen(
        //   yearlySubscriptionId: yearlySubscription(),
        //   monthlySubscriptionId: monthlySubscription(),
        //   appName: AppConstant.appName,
        //   appVersion: packageInfo.version,
        //   nextPage: () => const HomeScreen(),
        // ),
      ),
    );
  }
}
