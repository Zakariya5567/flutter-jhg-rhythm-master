
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:tempo_bpm/providers/metro_provider.dart';
import 'package:tempo_bpm/providers/speed_provider.dart';
import 'package:tempo_bpm/providers/tap_temp_provider.dart';
import 'package:tempo_bpm/screens/bpm_screen.dart';
import 'package:tempo_bpm/screens/home_screen.dart';
import 'package:tempo_bpm/utils/app_constant.dart';


Future<void> main() async{
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
        ChangeNotifierProvider<TapTempoProvider>(create: (context)=> TapTempoProvider()),
        ChangeNotifierProvider<SpeedProvider>(create: (context)=> SpeedProvider()),
        ChangeNotifierProvider<MetroProvider>(create: (context)=> MetroProvider()),
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
        home:  SplashScreen(
          yearlySubscriptionId: AppConstant.yearlySubscriptionId,
          monthlySubscriptionId: AppConstant.monthlySubscriptionId,
          nextPage: ()=> const HomeScreen(),),
      ),
    );
  }
}


