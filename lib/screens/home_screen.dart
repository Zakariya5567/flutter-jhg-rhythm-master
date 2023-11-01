import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:tempo_bpm/screens/bpm_view.dart';
import 'package:tempo_bpm/screens/speed_view.dart';

import '../providers/metro_provider.dart';
import '../utils/app_ colors.dart';
import '../utils/app_constant.dart';
import 'metro_view.dart';
class HomeScreen  extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {



  // List on buttons , Tap tempo | Metronome | Speed Trainer
  List<String> buttonList = [AppConstant.tapTempo,AppConstant.metronome,AppConstant.speedTrainer];


  // Identify selected button
  // Base on this value we will show the screen
  // 0 for tap tempo | 1 for Metronome | 2 for Speed trainer
  int selectedButton = 0;

  // Set button value base on selection
  setSelectedButton(int value){
    setState(() {
      selectedButton = value;
    });
  }



  // Set expiry date when user login to the app
  // we will expire user login after 14 days
  setExpiryDate()async{
    DateTime currentDate = DateTime.now();
    DateTime endDate = currentDate.add(const Duration(days: 14));
    await LocalDB.storeEndDate(endDate.toString());
  }

  @override
    void initState() {
    setExpiryDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
          height: height,
          width: width,
          color: AppColors.blackPrimary,
          child: Padding(
            padding:  EdgeInsets.only(
                top:height*0.05 ,
                bottom: 0,
                left:width*0.06 ,
                right:width*0.06 ,
                 ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // SPACER
                SizedBox(height: height*0.07,),

                //BUTTON SELECTION SECTION
                SizedBox(
                  height: height*0.05,
                  child: ListView.builder(
                    itemCount:buttonList.length,
                   shrinkWrap: true,
                   scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: ()async{
                         setSelectedButton(index);
                        },
                        child:Padding(
                          padding:  EdgeInsets.symmetric(horizontal: width*0.02),
                          child: Container(
                            height: height*0.05,
                            width: width*0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:selectedButton == index ? AppColors.greySecondary : AppColors.greyPrimary,
                              border: Border.all(color: AppColors.greySecondary)
                            ),
                            child: Center(
                              child: Text(
                                buttonList[index],
                                style:  TextStyle(
                                  fontFamily: AppConstant.sansFont,
                                  color: AppColors.whitePrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ),


                // ScreenView base on button selection
                selectedButton == 0 ?
                const BpmView() :
                selectedButton == 1 ?
                const MetroView():
                const SpeedView()

              ],
            ),
          ),
        )
    );
  }
}
