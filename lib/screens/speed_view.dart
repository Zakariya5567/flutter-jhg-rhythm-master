import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempo_bpm/providers/speed_provider.dart';
import '../utils/app_ colors.dart';
import '../utils/app_constant.dart';
import '../utils/images.dart';


class SpeedView extends StatefulWidget {
   const SpeedView({super.key});

  @override
  State<SpeedView> createState() => _SpeedViewState();
}
class _SpeedViewState extends State<SpeedView> with TickerProviderStateMixin {

  @override
  void initState() {
      final speedProvider = Provider.of<SpeedProvider>(context,listen: false);
      super.initState();
  }

  SpeedProvider? speedProvider;

  @override
  void didChangeDependencies() {
    speedProvider = Provider.of<SpeedProvider>(context,listen: false);
    super.didChangeDependencies();
  }


 @override
  void dispose() {
     speedProvider!.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<SpeedProvider>(builder: (context, controller, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal:0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // SPACER
            SizedBox(height: height * 0.05),
            // STARTING TEMPO
            Heading(title: AppConstant.startingTempo, numbers: controller.startTempo.toStringAsFixed(0)),
            // SPACER
            SizedBox(height: height * 0.015),
            // STARTING SLIDER
            SliderTheme(
              data: SliderThemeData(
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: height*0.015,
                ),
                  overlayShape: SliderComponentShape.noOverlay,
                trackHeight: height*0.005
              ),
              child: Slider(

                activeColor: AppColors.whitePrimary,
                thumbColor: AppColors.whitePrimary,
                 min: controller.startTempoMin,
                 max: controller.startTempoMax,
                 value: controller.startTempo, onChanged: (values){
                controller. setStartTempo(values);
              }),
            ),
            // SPACER
            SizedBox(height: height * 0.02),
            // TARGET TEMPO
            Heading(title: AppConstant.targetTempo, numbers: controller.targetTempo.toStringAsFixed(0)),
            // SPACER
            SizedBox(height: height * 0.015),
            // TARGET SLIDER
            SliderTheme(
              data: SliderThemeData(
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: height*0.015,
                  ),
                  overlayShape: SliderComponentShape.noOverlay,
                  trackHeight: height*0.005
              ),
              child: Slider(
                  activeColor: AppColors.whitePrimary,
                  thumbColor: AppColors.whitePrimary,
                  min: controller.targetTempoMin,
                  max: controller.targetTempoMax,
                  value: controller.targetTempo,
                  onChanged: (values){
                    controller.setTargetTempo(values);
                  }
              ),
            ),
            // SPACER
            SizedBox(height: height * 0.04),
            // BARS
            AddAndSubtractButton(
                title: AppConstant.bars,
                numbers:controller. bar.toString(),
                description: AppConstant.howManyBars,
                onAdd: (){
                  controller. increaseBar();
                },
                onSubtract: (){
                  controller. decreaseBar();
                }
            ),
            // SPACER
            SizedBox(height: height*0.03,),
            // INTERVAL BUTTONS
            AddAndSubtractButton(
                title: AppConstant.interval,
                numbers: controller.interval.toString(),
                description:  "${AppConstant.howMuchItShouldIncrease} ${controller.bar} Bars",
                onAdd: (){
                  controller. increaseInterval();
                },
                onSubtract: (){
                  controller. decreaseInterval();
                }
            ),
            // SPACER
            SizedBox(height: height * 0.035),
            // BPM VALUE SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppConstant.bpm,
                  style: TextStyle(
                    fontFamily: AppConstant.sansFont,
                    color: AppColors.whiteSecondary,
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  controller. bpm == null
                      ? AppConstant.bpmNull
                      : controller.bpm.toStringAsFixed(0),
                  style: TextStyle(
                    fontFamily: AppConstant.sansFont,
                    color: AppColors.whiteSecondary,
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // SPACER
            SizedBox(height: height * 0.020),
            // Reset and play pause BUTTON
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: width * 0.050,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [


                  // Reset
                  GestureDetector(
                    onTap: (){
                      controller.clearSpeedTrainer();
                    },
                    child: Container(
                      height: height * 0.045,
                      width: height * 0.045,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child:Image.asset(Images.iconReset,
                        color: AppColors.whitePrimary,
                      ),
                    ),
                  ),

                  // Play pause
                  Center(
                    child: GestureDetector(
                      onTap: ()async{
                        controller. startStop();
                      },
                      child: Container(
                        height: height * 0.095,
                        width: height * 0.095,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:  AppColors.redPrimary,
                        ),
                        child: Center(
                            child:
                            Icon(
                              controller.isPlaying == true ? Icons.pause :
                              Icons.play_arrow,color: AppColors.whitePrimary,size: width*0.10,)
                        ),
                      ),
                    ),
                  ),

                  // Spacer
                  SizedBox(
                    height: height * 0.02,
                    width: height * 0.02,
                  ),
                ],
              ),
            ),

          ],
        ),
      );
    });
  }
}

class Heading extends StatelessWidget {
  const Heading({super.key,required this.title,required this.numbers});
  final String  title;
  final String  numbers;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return   Padding(
      padding:  EdgeInsets.symmetric(horizontal:width*0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: AppConstant.sansFont,
              color: AppColors.whitePrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),

          Text(
            numbers,
            style: TextStyle(
              fontFamily: AppConstant.sansFont,
              color: AppColors.whitePrimary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),


        ],
      ),
    );
  }
}
class AddAndSubtractButton extends StatelessWidget {
  const AddAndSubtractButton({super.key,
    required this.title,
    required this.numbers,
    required this.description,
    required this.onAdd,
    required this.onSubtract});

  final String  title;
  final String  description;
  final String  numbers;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;



  @override
  Widget build(BuildContext context) {


    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return   Padding(
      padding: EdgeInsets.symmetric(horizontal:width*0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height*0.07,
            width: width,

            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //how many bars

                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppConstant.sansFont,
                    color: AppColors.whiteLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),


                Row(

                  children: [

                    // MINUS BUTTON
                    GestureDetector(
                      onTap: (onSubtract),
                      child: Container(
                        height: height * 0.038,
                        width: height * 0.038,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:  AppColors.redPrimary,
                        ),
                        child: Center(
                            child:
                            Icon(Icons.remove,color: AppColors.whitePrimary,)
                        ),
                      ),
                    ),

                    SizedBox(width: width * 0.05),



                      Container(
                        height: height * 0.055,
                        width: width * 0.18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color:  AppColors.greyPrimary,
                        ),
                        child: Center(
                          child:
                          Text(
                            numbers,
                            style: TextStyle(
                              fontFamily: AppConstant.sansFont,
                              color: AppColors.whitePrimary,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),


                    SizedBox(width: width * 0.05),
                    // PLUS BUTTON

                    GestureDetector(
                      onTap: (onAdd),
                      child: Container(
                        height: height * 0.038,
                        width: height * 0.038,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:  AppColors.redPrimary,
                        ),
                        child: Center(
                            child:
                            Icon(Icons.add,color: AppColors.whitePrimary,)
                        ),
                      ),
                    ),

                  ],)

              ],
            ),
          ),

          SizedBox(height: height*0.01,),

          Text(
            description,
            style: TextStyle(
              fontFamily: AppConstant.sansFont,
              color: AppColors.whiteLight,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}