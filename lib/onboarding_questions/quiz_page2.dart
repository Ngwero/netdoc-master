
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:netdoc/onboarding_questions/quiz_page3.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utilities/constants/color_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../utilities/constants/user_constants.dart';




class QuizPage2 extends StatefulWidget {

  static String id = "CustomizedPage";


  @override
  _QuizPage2State createState() => _QuizPage2State();
}

class _QuizPage2State extends State<QuizPage2> {
  var categoryName = ['Male', 'Female'];
  var categoryId = ['1','2'];

  void defaultInitialisation(){
    // DatePicker.showDatePicker(context,
    //     currentTime: DateTime(1990,06,10,10,00),
    //
    //
    //     onConfirm: (time) async{
    //       final prefs = await SharedPreferences.getInstance();
    //       var birthDay = DateFormat('dd-MMM-yyyy ').format(time);
    //       prefs.setString(kUserBirthday, birthDay);
    //
    //       // DateTime opening = DateTime(2022,1,1,Provider.of<StyleProvider>(context, listen: false).openingTime,0);
    //       // DateTime closing = DateTime(2022,1,1,Provider.of<StyleProvider>(context, listen: false).closingTime,0);
    //       // DateTime selectedDateTime = DateTime(value.date!.year,value.date!.month,value.date!.day,time.hour, time.minute);
    //       // var referenceTime = DateTime(2022,1,1,0,0);
    //
    //
    //       // Provider.of<StyleProvider>(context, listen: false).setUserBirthday(time);
    //       // Provider.of<StyleProvider>(context, listen: false).resetQuestionButtonColors();
    //
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context)=> QuizPage3())
    //       );
    //       });


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // defaultInitialisation();

  }

  animationTimer() {
    Timer(const Duration(milliseconds: 500), () {
      // Provider.of<StyleProvider>(context, listen: false).resetQuestionButtonColors();
      Navigator.pop(context);

      // Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    // Provider.of<StyleProvider>(context, listen: false).resetQuestionButtonColors();
    return Scaffold(
        backgroundColor: kGreenDarkColorOld,
        // appBar: AppBar(
        //   backgroundColor: Colors.deepOrangeAccent,
        //
        // ),
        body:
        SafeArea(
          child: Column(
              children :
              [
                Container(
                  child:  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top:40.0, right: 20, left: 20),
                      child: Text('When were you born?',
                        textAlign: TextAlign.center, style: kHeading2TextStyleBold.copyWith(color: kPureWhiteColor)),
                    ),),
                  height: 150,
                  decoration: const BoxDecoration(
                      color: kGreenDarkColorOld,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(60), bottomLeft: Radius.circular(60))),

                ),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kBlack)),
                    onPressed: (){
                  defaultInitialisation();

                }, child: Text('Date of Birth', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),

              ]
          ),
        )
    );
  }


}



