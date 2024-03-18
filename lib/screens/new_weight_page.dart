
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:netdoc/Utilities/constants/color_constants.dart';
import 'package:netdoc/models/common_functions.dart';
import 'package:netdoc/onboarding_questions/quiz_page4.dart';
import 'package:netdoc/screens/payment_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

import '../Utilities/constants/font_constants.dart';
import '../models/doctor_provider.dart';
import '../utilities/constants/user_constants.dart';





class NewWeightPage extends StatefulWidget {


  @override
  _NewWeightPageState createState() => _NewWeightPageState();
}

class _NewWeightPageState extends State<NewWeightPage> {
  int height = 170;
  late WeightSliderController _controller;
  double weight = 65.0;

  void defaultInitialization()async{

    final prefs = await SharedPreferences.getInstance();
    _controller = WeightSliderController(
        initialWeight: prefs.getDouble(kUserWeight)!, minWeight: 10, interval: 1);
    setState(() {

    });
  }
  CollectionReference challengeImage = FirebaseFirestore.instance.collection('flutterwave');

  Future deliveryStream() async {

    final users = await FirebaseFirestore.instance
        .collection('flutterwave').doc("AR2sgPrN3jN7DKHzaPKp")
        .get();
    Provider.of<DoctorProvider>(context, listen: false).setFlutterwaveValues(users['publicKey'],users['testKey']);
    print("DODODOODODODODODOODODODODODODO");

  }

  void dateOfAppointment(){

    Get.snackbar('Enter Appointment Date', 'Select when you are available for this appointment',
        snackPosition: SnackPosition.TOP,
        backgroundColor: kGreenThemeColor,
        colorText: kBlack,
        icon: Icon(Icons.check_circle, color: kPureWhiteColor,));
    //
    // DatePicker.showDatePicker(context, currentTime: DateTime.now(),
    //    // theme: DatePickerTheme(headerColor: kBabyPinkThemeColor, itemHeight: 50, itemStyle: kHeadingTextStyle.copyWith(color: kPureWhiteColor), backgroundColor: kBlack),
    //     //showTitleActions: t,
    //     onConfirm: (time) {
    //       var random = Random();
    //       deliveryStream();
    //       Provider.of<DoctorProvider>(context, listen: false).setAppointmentDate(time);
    //       CommonFunctions().scheduledNotification(heading: "Appointment for ${Provider.of<DoctorProvider>(context, listen: false).conditionName} due",   body: "You Scheduled an appointment for today", year: time.year, month:time.month, day: time.day, hour: 8, minutes: 0, id: random.nextInt(100));
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context)=> PaymentPage())
    //       );
    //     });


  }
  @override
  void initState() {
    super.initState();
    defaultInitialization();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPureWhiteColor,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: kPureWhiteColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kGreenThemeColor,
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setDouble(kUserWeight, weight);

          dateOfAppointment();

        },
        label: const Text("Record Weight", style: kNormalTextStyleWhiteButtons,),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: SafeArea(
        child: Stack(
            children: [
              Center(
                child:

                Column(
                  children: [
                    Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: Text(
                        "${weight.toStringAsFixed(1)} kg",
                        style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    VerticalWeightSlider(
                      isVertical: true,

                      maxWeight: 200,
                      controller: _controller,
                      decoration: const PointerDecoration(
                        width: 130.0,
                        height: 10,
                        largeColor: kGreenThemeColor,
                        mediumColor: Color(0xFFC5C5C5),
                        smallColor: Color(0xFFF0F0F0),
                        gap:30.0,
                      ),
                      onChanged: (double value) {
                        setState(() {
                          weight = value;
                        });
                      },
                      indicator: Container(
                        height: 3.0,
                        width: 200.0,
                        alignment: Alignment.centerLeft,
                        color: Colors.red[300],
                      ),
                    ),
                  ],), ),


              Positioned(
                left: 20,
                right: 20,
                top: 20,
                child: Text('What is your Current Weight?',
                    textAlign: TextAlign.center, style:kHeading2TextStyleBold.copyWith(color: kBlack)),
              ),
            ]
        ),

      ),
    );
  }
}
