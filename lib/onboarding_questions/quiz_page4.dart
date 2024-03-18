
import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netdoc/onboarding_questions/quiz_page2.dart';
import 'package:netdoc/onboarding_questions/quiz_page6.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utilities/constants/color_constants.dart';
import '../../Utilities/constants/font_constants.dart';
import '../Utilities/InputFieldWidget.dart';
import '../utilities/constants/user_constants.dart';


class QuizPage4 extends StatefulWidget {

  static String id = "CustomizedPage";


  @override
  _QuizPage4State createState() => _QuizPage4State();
}

class _QuizPage4State extends State<QuizPage4> {
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
  String email= '';
  double changeInvalidMessageOpacity = 0.0;
  String invalidMessageDisplay = 'Invalid Number';
  String password = '';
  String repeatPassword = '';
  String fullName = '';
  String firstName = '';
  String phoneNumber = '';

  //bool showSpinner = false;
  String errorMessage = 'Error Signing Up';
  double errorMessageOpacity = 0.0;
  late String countryCode;

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
                      padding: EdgeInsets.only(top:40.0),
                      child: Text('$name, who is your next of kin?',
                          textAlign: TextAlign.center, style:kHeading2TextStyleBold.copyWith(color: kPureWhiteColor)),
                    ),),
                  height: 150,
                  decoration: const BoxDecoration(
                      color: kGreenDarkColorOld,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(60), bottomLeft: Radius.circular(60))),

                ),
                Container(
                  height: 120,
                  child:  Column(
                    children: [
                      InputFieldWidget(labelText:' Next of Kin Names' ,hintText: '', keyboardType: TextInputType.text, onTypingFunction: (value){
                        fullName = value;
                        firstName = fullName.split(" ")[0]; // Gets the first name in the 0 positiion from the full names
                      }, onFinishedTypingFunction: () {  },),
                      Row(
                        children: [
                          CountryCodePicker(
                            onChanged: (value){
                              countryCode = value.name!;

                            },
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: 'UG',
                            favorite: const ['+256','UG'],
                            // optional. Shows only country name and flag
                            showCountryOnly: true,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                          ),
                          InputFieldWidget(labelText: ' Mobile Number Next of Kin', hintText: '77100100', keyboardType: TextInputType.number,  onTypingFunction: (value){
                            // setState(() {
                            if (value.split('')[0] == '7'){
                              invalidMessageDisplay = 'Incomplete Number';
                              if (value.length == 9 && value.split('')[0] == '7'){
                                phoneNumber = value;
                                phoneNumber.split('0');
                                // print(phoneNumber.split(''));
                                changeInvalidMessageOpacity = 0.0;
                              } else if(value.length !=9 || value.split('')[0] != '7'){
                                changeInvalidMessageOpacity = 1.0;
                              }
                            }else {
                              invalidMessageDisplay = 'Number should start with 7';
                              changeInvalidMessageOpacity = 1.0;
                            }
                            // });

                            phoneNumber = value;
                          }, onFinishedTypingFunction: () {  },),
                        ],
                      ),
                    ],
                  ),
                ),
                kLargeHeightSpacing,
                kLargeHeightSpacing,
                kLargeHeightSpacing,
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kGreenThemeColor)),
                    onPressed: (){
                      if (fullName!='' && phoneNumber!=''){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=> QuizPage6())
                        );
                      } else {
                        showDialog(context: context, builder: (BuildContext context){

                          return CupertinoAlertDialog(
                            title: const Text('Oops Something is Missing'),
                            content: const Text('Make sure you have filled in all the fields'),
                            actions: [CupertinoDialogAction(isDestructiveAction: true,
                                onPressed: (){

                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'))],
                          );
                        });
                      }


                    }, child: Text("Done", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),



              ]
          ),
        )
    );
  }


}



