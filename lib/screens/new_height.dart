
import 'package:flutter/material.dart';

import 'package:netdoc/Utilities/constants/color_constants.dart';
import 'package:netdoc/onboarding_questions/quiz_page4.dart';
import 'package:netdoc/onboarding_questions/quiz_page5.dart';
import 'package:netdoc/screens/new_weight_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utilities/constants/font_constants.dart';
import '../utilities/constants/user_constants.dart';





class NewHeightPage extends StatefulWidget {


  @override
  _NewHeightPageState createState() => _NewHeightPageState();
}

class _NewHeightPageState extends State<NewHeightPage> {
  int height = 180;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: kBlack,
        foregroundColor: kPureWhiteColor,
        automaticallyImplyLeading: true,
      ),

      backgroundColor: kBlack,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kGreenThemeColor,
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setInt(kUserHeight, height);

          Navigator.push(context,
              MaterialPageRoute(builder: (context)=> NewWeightPage())
          );


        },
        label: const Text("Record Height", style: kNormalTextStyleWhiteButtons,),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: SafeArea(
        child: Stack(
            children: [
              // Center(
              //   child: HeightSlider(
              //     maxHeight: 200,
              //     minHeight: 165,
              //     accentColor: Colors.red,
              //     // personImagePath: "images/doc_checking_tab.png",
              //
              //     numberLineColor: kGreenThemeColor,
              //     sliderCircleColor: kGreenThemeColor,
              //     primaryColor: kGreenThemeColor,
              //     height: height,
              //     onChange: (val) => setState(() => height = val),
              //     unit: 'cm', // optional
              //   ),
              // ),
              Positioned(
                left: 20,
                right: 20,
                top: 20,
                child: Text('What is the Patient Height?',
                    textAlign: TextAlign.center, style:kHeading2TextStyleBold.copyWith(color: kPureWhiteColor)),
              ),
            ]
        ),

      ),
    );
  }
}
