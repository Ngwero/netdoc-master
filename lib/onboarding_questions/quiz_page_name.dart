
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lottie/lottie.dart';
import 'package:netdoc/onboarding_questions/quiz_page1.dart';
import 'package:netdoc/utilities/constants/user_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../Utilities/InputFieldWidget.dart';
import '../../Utilities/constants/color_constants.dart';
import '../../Utilities/constants/font_constants.dart';


class QuizPageName extends StatefulWidget {

  static String id = "CustomizedPage";


  @override
  _QuizPageNameState createState() => _QuizPageNameState();
}

class _QuizPageNameState extends State<QuizPageName> {

  var fullName = '';
  var firstName = '';
  var countryName = '';
  var countryFlag = '';
  var countryCode = "+256";
  var phoneNumber = "+256";
  final formKey = GlobalKey<FormState>();

  Future<void> uploadUserData() async {
    print('Upload Started');
    final auth = FirebaseAuth.instance;
    final prefs = await SharedPreferences.getInstance();

    await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .set(
        {

          'dateOfBirth': '',
          'email': prefs.getString(kEmailConstant),
          'fullName': fullName,
          'lastName': firstName,
          'weight': 70,
          'height': 175,
          'sex': 'Female',
          'vaccines':[],
          'phoneNumber': phoneNumber,
          'subscribed': true,
          'token': prefs.getString(kToken)
        });

    print("PEERRRRRFEEECTLY CREATED");
  }


  void initState() {
    // TODO: implement initState
    super.initState();



  }

  @override

  animationTimer() {
    Timer(const Duration(milliseconds: 500), () {
      // Provider.of<StyleProvider>(context, listen: false).resetQuestionButtonColors();
      // Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=> QuizPage1())
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
        Form(
          key: formKey,
          child: Column(
              children :
              [
                Container(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top:50.0, left: 20, right: 20),
                      child: Text('Looks these details are missing on your Account:',
                          textAlign: TextAlign.center, style:kHeading2TextStyleBold.copyWith(color: kPureWhiteColor)),
                    ),),
                  height: 150,
                  decoration: const BoxDecoration(
                      color: kGreenDarkColorOld,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(60), bottomLeft: Radius.circular(60))),

                ),
                Container(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InputFieldWidget(  leftPadding: 10,  labelText:' Full Names' ,hintText: 'Cathy Nalya', keyboardType: TextInputType.text, onTypingFunction: (value){
                          fullName = value;
                          firstName = fullName.split(" ")[0]; // Gets the first name in the 0 positiion from the full names
                        }, onFinishedTypingFunction: () {  },),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 20),
                          child: Container(
                            height: 53,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),

                                CountryCodePicker(
                                  textStyle: kNormalTextStyle.copyWith(color: kPureWhiteColor),
                                  onInit: (value){
                                    countryCode = value!.dialCode!;
                                    countryName = value!.name!;
                                    countryFlag = value!.flagUri!;
                                    print('$countryName, $countryFlag');
                                  },
                                  onChanged: (value){
                                    countryCode = value.dialCode!;
                                    countryName = value.name!;
                                    countryFlag = value.flagUri!;
                                    print(countryCode);

                                  },
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: 'UG',
                                  favorite: const ['+256','UG'],
                                  // optional. Shows only country name and flag
                                  showCountryOnly: false,
                                  // optional. Shows only country name and flag when popup is closed.
                                  showOnlyCountryWhenClosed: false,
                                  // optional. aligns the flag and the Text left
                                  alignLeft: false,
                                ),
                                Text(
                                  "|",
                                  style: TextStyle(fontSize: 25, color: kPureWhiteColor),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: TextFormField(
                                      style: kNormalTextStyle.copyWith(color: kPureWhiteColor),
                                      validator: (value){
                                        List letters = List<String>.generate(
                                            value!.length,
                                                (index) => value[index]);
                                        print(letters);


                                        if (value!=null && value.length > 10){
                                          return 'Number is too long';
                                        }else if (value == "") {
                                          return 'Enter phone number';
                                        } else if (letters[0] == '0'){
                                          return 'Number cannot start with a 0';
                                        } else if (value!= null && value.length < 9){
                                          return 'Number short';

                                        }
                                        else {
                                          return null;
                                        }
                                      },

                                      onChanged: (value){
                                        phoneNumber = value;
                                      },
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        // border: OutlineInputBorder(
                                        //   borderRadius: BorderRadius.all(Radius.circular(10)),
                                        // ),
                                        // enabledBorder: OutlineInputBorder(
                                        //   borderSide: BorderSide(color: kButtonGreyColor, width: 1.0),
                                        //   borderRadius: BorderRadius.all(Radius.circular(10)),
                                        // ),
                                        // focusedBorder: UnderlineInputBorder(
                                        //   borderSide: BorderSide(color:  Colors.pink),
                                        // ),
                                          border: InputBorder.none,
                                          hintText: "771234567",
                                          hintStyle: kNormalTextStyle.copyWith(color: Colors.grey[500])

                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kGreenThemeColor)),
                    onPressed: () async{
                      final isValidForm = formKey.currentState!.validate();
                      final prefs = await SharedPreferences.getInstance();
                      if (fullName == ''){
                        showDialog(context: context, builder: (BuildContext context){
                          return CupertinoAlertDialog(
                            title: const Text('Enter a Valid Name'),
                            content: Text('No name has been entered in the name field. Please enter a valid name', style: kNormalTextStyle.copyWith(color: kBlack),),
                            actions: [CupertinoDialogAction(isDestructiveAction: true,
                                onPressed: (){
                                  // _btnController.reset();
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'))],
                          );
                        });

                      } else {
                        if (isValidForm){
                          prefs.setString(kFullNameConstant, fullName);
                          prefs.setString(kFirstNameConstant, firstName);
                          prefs.setString(kPhoneNumberConstant, phoneNumber);
                          uploadUserData();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> QuizPage1())
                          );
                        }


                      }


                    }, child: Text("Continue", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),)),


              ]
          ),
        )
    );
  }


}



