// import 'package:flutter/material.dart';
// import 'package:reg_page/reg_page.dart';
//
// import '../utils/app_ colors.dart';
// import '../utils/app_constant.dart';
// class BPMScreen  extends StatefulWidget {
//   const BPMScreen({super.key});
//   @override
//   State<BPMScreen> createState() => _BPMScreenState();
// }
//
// class _BPMScreenState extends State<BPMScreen> {
//
//   double? tapTimestamp;
//
//   List<double> tapIntervals = [];
//
//   double? bpm ;
//
//   void handleTap() {
//     setState(() {
//       animate = true;
//     });
//     Future.delayed(const Duration(milliseconds: 100),(){
//       setState(() {
//         animate = false;
//       });
//
//     });
//
//     final currentTime = DateTime.now().millisecondsSinceEpoch.toDouble();
//
//     if (tapTimestamp != null) {
//       final interval = currentTime - tapTimestamp!;
//       tapIntervals.add(interval);
//
//       // Calculate average BPM
//       final averageInterval = tapIntervals.reduce((a, b) => a + b) / tapIntervals.length;
//       final newBpm = 60000 / averageInterval;
//
//       setState(() {
//         bpm = newBpm;
//       });
//     }
//
//     tapTimestamp = currentTime;
//   }
//
//   bool animate = false;
//
//   void clearBPM() {
//     setState(() {
//       tapTimestamp = null;
//       tapIntervals.clear();
//       bpm = null;
//     });
//   }
//
//
//   setExpiryDate()async{
//     DateTime currentDate = DateTime.now();
//     DateTime endDate = currentDate.add(const Duration(days: 14));
//     await LocalDB.storeEndDate(endDate.toString());
//   }
//
//   @override
//   void initState() {
//     setExpiryDate();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//         body: Container(
//           height: height,
//           width: width,
//           color: AppColors.primaryBlack,
//           child: Padding(
//             padding:  EdgeInsets.symmetric(horizontal:width*0.06,vertical: height*0.05 ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//
//                 // SETTING ICON
//                 Align(alignment: Alignment.topRight,
//                   child: GestureDetector(
//                     onTap: ()async{
//                       Navigator.push(context, MaterialPageRoute(builder: (context){
//                         return  Setting(
//                           yearlySubscriptionId: AppConstant.yearlySubscriptionId,
//                           monthlySubscriptionId: AppConstant.monthlySubscriptionId,
//                           nextPage: ()=> const BPMScreen(),);
//                       }));
//                     },
//                       child:Padding(
//                         padding:  EdgeInsets.only(top: height*0.01,right: width*0.01),
//                         child: Icon(Icons.settings,
//                           color: AppColors.primaryWhite,size: width*0.1,
//                         ),
//                       ),
//                   ),),
//
//                 // SPACER
//                 SizedBox(height: height*0.10,),
//
//                 // BPM VALUE SECTION
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       AppConstant.bpm,
//                       style:  TextStyle(
//                         color: AppColors.primaryBlue,
//                         fontSize: 34,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//
//                     Text(
//                       bpm == null ? AppConstant.bpmNull:
//                       bpm!.toStringAsFixed(1),
//                       style: TextStyle(
//                         color: AppColors.primaryWhite,
//                         fontSize: 34,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 // SPACER
//                 SizedBox(height: height*0.06,),
//
//                 // BLUE BUTTON
//                 AnimatedScale(
//                   alignment: Alignment.center,
//                   duration: const Duration(milliseconds: 500),
//                   curve: Curves.bounceInOut,
//                   scale: animate == true ? 1.2 : 1,
//                   child: Container(
//                       height: height * 0.28,
//                       width: height * 0.28,
//                       decoration:  BoxDecoration(
//                         color: AppColors.primaryBlue,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(height*0.010,),
//                         child:    InkWell(
//                           onTap: (){
//                             handleTap();
//                           },
//                           child: Container(
//                             height: height * 0.28,
//                             width: height * 0.28,
//                             decoration:  BoxDecoration(
//                                 color: AppColors.secondaryBlack,
//                                 shape: BoxShape.circle,
//                                 boxShadow:  [
//                                   BoxShadow(
//                                     color: AppColors.primaryBlue,
//                                     spreadRadius: -100,
//                                     blurRadius: 10,
//                                     // offset: Offset*,4)
//                                   )
//                                 ]
//                             ),
//                           ),
//                         ),
//                       )),
//                 ),
//
//                 // SPACER
//                 SizedBox(height: height*0.18,),
//
//                 // RESET BUTTON
//                 GestureDetector(
//                   onTap: (){
//                     clearBPM();
//                   },
//                   child: Container(
//                     height: height * 0.09,
//                     width: height * 0.09,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: AppColors.secondaryBlack,
//                       shape: BoxShape.circle,
//                     ),
//                     child:Icon(Icons.settings_backup_restore,
//                       color: AppColors.primaryWhite,size: width * 0.1,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//     );
//   }
// }