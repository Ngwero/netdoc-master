
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lottie/lottie.dart';
import 'package:netdoc/onboarding_questions/quiz_page1.dart';
import 'package:netdoc/onboarding_questions/quiz_page2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../Utilities/constants/color_constants.dart';
import '../../Utilities/constants/font_constants.dart';
import '../utilities/constants/user_constants.dart';


class QuizPage0 extends StatefulWidget {

  static String id = "CustomizedPage";


  @override
  _QuizPage0State createState() => _QuizPage0State();
}

class _QuizPage0State extends State<QuizPage0> {
  var categoryName = ['Male', 'Female'];
  var categoryId = ['1','2'];
  var name = 'Kangave';

  void defaultInitialisation()async{
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString(kFirstNameConstant)!;
    setState((){});


  }
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialisation();


  }

  @override

  animationTimer() {
    Timer(const Duration(milliseconds: 500), () {
      // Provider.of<StyleProvider>(context, listen: false).resetQuestionButtonColors();
      // Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=> QuizPage2())
      );

      // Navigator.pop(context);
    });
  }

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
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top:40.0, left: 20, right: 20),
                      child: Text('Welcome $name,\nLet us get a few details to setup your account perfectly',
                          textAlign: TextAlign.center, style:kHeading2TextStyleBold.copyWith(color: kPureWhiteColor)),
                    ),),
                  height: 150,
                  decoration: const BoxDecoration(
                      color: kGreenDarkColorOld,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(60), bottomLeft: Radius.circular(60))),

                ),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kBlack)),
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> QuizPage1())
                      );

                    }, child: Text("Start", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),


              ]
          ),
        )
    );
  }


}



