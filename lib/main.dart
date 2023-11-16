import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:rhythm_master/providers/metro_provider.dart';
import 'package:rhythm_master/providers/setting_provider.dart';
import 'package:rhythm_master/providers/speed_provider.dart';
import 'package:rhythm_master/providers/tap_temp_provider.dart';
import 'package:rhythm_master/screens/home_screen.dart';
import 'package:rhythm_master/utils/app_constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      ],
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'JHG Rhythm ',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(
          yearlySubscriptionId: AppConstant.yearlySubscriptionId,
          monthlySubscriptionId: AppConstant.monthlySubscriptionId,
          appName: AppConstant.appName,
          appVersion: AppConstant.appVersion,
          nextPage: () => const HomeScreen(),
        ),
      ),
    );
  }
}
