
import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lottie/lottie.dart';
import 'package:netdoc/onboarding_questions/quiz_page2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utilities/constants/color_constants.dart';
import '../../Utilities/constants/font_constants.dart';
import '../utilities/constants/user_constants.dart';


class QuizPage1 extends StatefulWidget {

  static String id = "CustomizedPage";


  @override
  _QuizPage1State createState() => _QuizPage1State();
}

class _QuizPage1State extends State<QuizPage1> {
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
          child: Stack(
              children :
              [
                Container(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top:40.0),
                      child: Text('$name, are you male or female?',
                        textAlign: TextAlign.center, style:kHeading2TextStyleBold.copyWith(color: kPureWhiteColor)),
                    ),),
                  height: 150,
                  decoration: const BoxDecoration(
                      color: kGreenDarkColorOld,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(60), bottomLeft: Radius.circular(60))),

                ),
                Padding(
                  padding: const EdgeInsets.only(top:150.0),
                  child: ListView.builder(
                      itemCount: categoryId.length,
                      itemBuilder: (context, index) {
                        return questionBlocks(categoryName[index]);
                      }),

                ),

              ]
          ),
        )
    );
  }
  Padding questionBlocks(String sex) {
    var randomColors = [Colors.teal, Colors.blueAccent, Colors.black12, Colors.deepPurpleAccent, Colors.white12];
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector (
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(kUserSex, sex);

          // Provider.of<StyleProvider>(context, listen: false).setButtonBoxColors(index, sex);
          animationTimer();



          // );Na
        },
        child: Container(
          // color: Colors.white,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color:  kGreenJavasThemeColor
              // Provider.of<StyleProvider>(context).buttonColourQuestions[index]
          ),
          child: Center(child: Text(
            sex,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),)),
        ),
      ),
    );
  }

}



