
import 'package:netdoc/utilities/constants/user_constants.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utilities/InputFieldWidget.dart';

import '../Utilities/constants/color_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../onboarding_questions/quiz_page0.dart';





class RegisterPageDuplicate extends StatefulWidget {
  static String id = 'register_page';
  @override
  _RegisterPageDuplicateState createState() => _RegisterPageDuplicateState();
}

class _RegisterPageDuplicateState extends State<RegisterPageDuplicate> {
  final _auth = FirebaseAuth.instance;
  // final HttpsCallable callableSMS = FirebaseFunctions.instance.httpsCallable('sendWelcomeSMS');
  // final HttpsCallable callableEmail = FirebaseFunctions.instance.httpsCallable('sendEmail');
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();


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


  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: kBackgroundGreyColor,
      appBar: AppBar(
        iconTheme:const IconThemeData(
          color: kPureWhiteColor, //change your color here
        ),
        title: const Center(child: Text('Sign Up', style: kNormalTextStyleWhiteButtons,)),
        backgroundColor: kGreenDarkColorOld,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 0),

        child: SingleChildScrollView(
          child:
          SizedBox(
             height: 350,

            child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Center(child: Image.asset('images/logo.png',height: 110,)),
                  Opacity(
                      opacity: changeInvalidMessageOpacity,
                      child: Text(invalidMessageDisplay, style: TextStyle(color:Colors.red , fontSize: 12),)),
                  InputFieldWidget(labelText:' Full Names' ,hintText: 'Fred Okiror', keyboardType: TextInputType.text, onTypingFunction: (value){
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
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),
                      InputFieldWidget(labelText: ' Mobile Number', hintText: '77100100', keyboardType: TextInputType.number,  onTypingFunction: (value){
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
                  kSmallHeightSpacing,
                  // SizedBox(height: 10.0,),
                  InputFieldWidget(labelText: ' Email', hintText: 'abc@gmail.com', keyboardType: TextInputType.emailAddress, onTypingFunction: (value){
                    email = value;
                  }, onFinishedTypingFunction: () {  },),
                  // SizedBox(height: 8.0,),
                  InputFieldWidget(labelText: ' Password',hintText:'Password', keyboardType: TextInputType.visiblePassword,passwordType: true, onTypingFunction: (value){
                    password = value;
                  }, onFinishedTypingFunction: () {  },),
                  // InputFieldWidget(labelText: ' Repeat Password',hintText:'Password', keyboardType: TextInputType.visiblePassword,passwordType: true, onTypingFunction: (value){
                  //   repeatPassword = value;
                  // }),
                  //SizedBox(height: 8.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child:
                    RoundedLoadingButton(
                      color: kGreenDarkColorOld,
                      child: Text('Register', style: kHeadingTextStyleWhite),
                      controller: _btnController,
                      onPressed: () async {
                        if (email ==''|| phoneNumber == '' || email =='' || password == '' || fullName == ''){
                          _btnController.error();
                          showDialog(context: context, builder: (BuildContext context){

                            return CupertinoAlertDialog(
                              title: const Text('Oops Something is Missing'),
                              content: const Text('Make sure you have filled in all the fields'),
                              actions: [CupertinoDialogAction(isDestructiveAction: true,
                                  onPressed: (){
                                    _btnController.reset();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'))],
                            );
                          });
                        }else {
                          print('Else activated');
                          setState(() {
                            //showSpinner = true;
                          });
                          try{
                            final newUser = await _auth.createUserWithEmailAndPassword(email: email,
                                password: password);
                            if (newUser != null){

                              final prefs = await SharedPreferences.getInstance();
                              prefs.setString(kFullNameConstant, fullName);
                              prefs.setString(kFirstNameConstant, firstName);
                              prefs.setString(kEmailConstant, email);
                              prefs.setString(kPhoneNumberConstant, phoneNumber);
                              prefs.setBool(kIsLoggedInConstant, true);
                              prefs.setBool(kIsFirstTimeUser, true);

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=> QuizPage0())
                              );


                              // SAVE THE VALUES TO THE USER DEFAULTS AND DATABASE
                            }else{
                              setState(() {
                                errorMessageOpacity = 1.0;
                              });
                            }

                          }catch(e){
                            _btnController.error();
                            showDialog(context: context, builder: (BuildContext context){
                              return CupertinoAlertDialog(
                                title: Text('Oops Register Error'),
                                content: Text('${e}'),
                                actions: [CupertinoDialogAction(isDestructiveAction: true,
                                    onPressed: (){
                                      _btnController.reset();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'))],
                              );
                            });
                            //print('error message is: $e');
                          }
                          //Implement registration functionality.
                        }

                      },
                    ),
                  ),
                  Opacity(
                      opacity: errorMessageOpacity,
                      child: Text(errorMessage, style: TextStyle(color: Colors.red),)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
