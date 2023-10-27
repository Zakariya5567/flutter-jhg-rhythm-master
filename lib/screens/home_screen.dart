import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:tempo_bpm/screens/bpm_view.dart';
import 'package:tempo_bpm/screens/speed_view.dart';

import '../utils/app_ colors.dart';
import '../utils/app_constant.dart';
import 'metro_view.dart';
class HomeScreen  extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  List<String> buttonList = [AppConstant.tapTempo,AppConstant.metronome,AppConstant.speedTrainer];


  int selectedButton = 0;

  setSelectedButton(int value){
    setState(() {
      selectedButton = value;
    });
  }



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

                // SETTING ICON
                Align(alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: ()async{
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return  Setting(
                          yearlySubscriptionId: AppConstant.yearlySubscriptionId,
                          monthlySubscriptionId: AppConstant.monthlySubscriptionId,
                          nextPage: ()=> const HomeScreen(),);
                      }));
                    },
                    child:Padding(
                      padding:  EdgeInsets.only(top: height*0.01,right: width*0.01),
                      child: Icon(Icons.settings,
                        color: AppColors.whitePrimary, size: width*0.1,
                      ),
                    ),
                  ),),


                // SPACER
                SizedBox(height: height*0.03,),

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


//
//
// void _increaseSpeed() {
//
//    duration = duration+1;
//
//   // duration = Duration(milliseconds: (_controller.duration!.inMilliseconds * 0.8).round());
//   // _controller.repeat(reverse: true);
// }
//
// void _decreaseSpeed() {
//   // _controller.duration = Duration(milliseconds: (_controller.duration!.inMilliseconds * 1.2).round());
//   // _controller.repeat(reverse: true);
// }
//
//
// double bpm = 120;
// double minimumInterval = 40;
// double maximumInterval = 300;
//
//
//
// //Duration duration = const Duration(milliseconds: 500);
// int duration = 500;
// bool isPlay = false;
// double begin = 0;
// final player = AudioPlayer();
// int totalBeat = 4;
// int totalTick = 0;
//
//
//
// int selectedButton = 0;
// setBeats(index){
//
//   if(index == 0 ){
//     totalBeat = 4;
//     selectedButton = index;
//
//   }else if(index == 1 ){
//     totalBeat = 3;
//     selectedButton = index;
//   }else if(index == 2 ){
//     totalBeat = 6;
//     selectedButton = index;
//   }
//
// }
//
// Future playSound()async{
//
//   totalTick = totalTick+1;
//  // final newBpm = 60000 / duration.inMilliseconds.toDouble();
// //  bpm = newBpm;
//   setState(() {});
//
//   if(totalTick == 1){
//     await player.setAudioSource(AudioSource.asset(AppConstant.clickSound));
//     if(player.playing == false){
//       await player.play();
//     }
//   }else{
//     if(totalTick<totalBeat){
//       await player.setAudioSource(AudioSource.asset(AppConstant.tapSound));
//       if(player.playing == false){
//         await player.play();
//       }
//     }else{
//       await player.setAudioSource(AudioSource.asset(AppConstant.tapSound));
//       if(player.playing == false){
//         await player.play();
//       }
//       totalTick = 0;
//     }
//   }
//
// }
//
// Future stopSound()async{
//   if(player.playing){
//     await player.stop();
//   }
//   totalTick = 0;
// }
//
// bool firstTime = true;
//
// onPlay () async {
//   if(isPlay == true){
//     setState(()  {
//       isPlay = false;
//       firstTime = true;
//       begin = 0;
//      // duration =  500;
//       _controller.reset();
//       _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
//     });
//     await stopSound();
//   }else{
//     setState(() {
//       isPlay = true;
//       begin = 0;
//      // duration = 500;
//     });
//
//     _controller = AnimationController(
//       duration:  Duration(milliseconds: duration),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: begin, end: 1).animate(_controller);
//     _controller.repeat(reverse: true);
//     _controller.addStatusListener((status) async {
//       if(status == AnimationStatus.forward){
//         if(begin == -1 && firstTime == false){
//           await playSound();
//         }
//
//       } else if(status == AnimationStatus.reverse){
//         if(begin == 0) {
//           setState(() {
//              duration =  duration * 2;
//             _controller.duration = Duration(milliseconds: duration);
//             begin = -1;
//             _controller.repeat(reverse: true);
//           });
//           _animation = Tween<double>(begin: begin, end: 1).animate(_controller);
//           // await playSound();
//         }else{
//           firstTime = false;
//           await playSound();
//         }
//
//       }
//       else  if(status == AnimationStatus.completed){
//         begin = 0;
//         firstTime = true;
//         await stopSound();
//       }
//       else  if(status == AnimationStatus.dismissed){
//         begin = 0;
//         firstTime = true;
//         await stopSound();
//
//       }
//     });
//   }
//
// }
//
// double topPosition  = 0;
//
//
//
//
// @override
// void dispose() {
//   _controller.dispose();
//   super.dispose();
// }

////-----------------------------------------------------------------

