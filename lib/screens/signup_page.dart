
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:netdoc/utilities/constants/user_constants.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utilities/InputFieldWidget.dart';
import 'package:intl/intl.dart';

import '../Utilities/constants/color_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../controllers/home_controller.dart';
import '../onboarding_questions/quiz_page0.dart';
import '../onboarding_questions/quiz_page6.dart';





class RegisterPage extends StatefulWidget {
  static String id = 'register_page';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  String kinNumber = '';
  String kin = '';
  String birthday = '';
  DateTime birthdayDate = DateTime.now();
  int height = 0;
  double weight = 0;
  var categoryName = ['Covid','Tetanus', 'Yellow Fever', 'DPT', 'MMR', 'OPV', 'Hepatitis', 'Hemophilys Influenza', 'HPV'];
  var categoryId = [];
  var arrayState = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];



  //bool showSpinner = false;
  String errorMessage = 'Error Signing Up';
  double errorMessageOpacity = 0.0;
  String countryCode = "+256";
  String token = '';
  final formKey = GlobalKey<FormState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void defaultInitialisation() async{
    _firebaseMessaging.getToken().then((value) => token = value!);
  }

  Future<void> uploadUserData() async {
    showDialog(context: context, builder: ( context) {return const Center(child: CircularProgressIndicator(color: kGreenThemeColor,));});
    print('Upload Started');
    final auth = FirebaseAuth.instance;
    final prefs = await SharedPreferences.getInstance();

    await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update(
        {
          // 'firstName': prefs.getString(kFirstNameConstant),
          'dateOfBirth': prefs.getString(kUserBirthday),
          'fullName': prefs.getString(kFullNameConstant),
          'lastName': prefs.getString(kFirstNameConstant),
          'weight': prefs.getDouble(kUserWeight),
          'height': prefs.getInt(kUserHeight),
          'sex': prefs.getString(kUserSex),
          'vaccines':[],
          'phoneNumber': prefs.getString(kPhoneNumberConstant),
          'subscribed': true,
          'token': token
        }).whenComplete(() {
          Navigator.pop(context);
      Navigator.pushNamed(context, ControlPage.id);
    } );
    prefs.setString(kToken, token);
    print("PEERRRRRFEEECTLY UPDATED");
  }

  void getBirthDay(){
    // DatePicker.showDatePicker(context,
    //     currentTime: DateTime(1990,06,10,10,00),
    //
    //
    //     // theme: DatePickerTheme(headerColor: kBabyPinkThemeColor, itemHeight: 50, itemStyle: kHeadingTextStyle.copyWith(color: kPureWhiteColor), backgroundColor: kBlack),
    //
    //     //showTitleActions: t,
    //
    //     onConfirm: (time) async{
    //       final prefs = await SharedPreferences.getInstance();
    //       birthday = DateFormat('dd-MMM-yyyy ').format(time);
    //       prefs.setString(kUserBirthday, birthday);
    //
    //       // DateTime opening = DateTime(2022,1,1,Provider.of<StyleProvider>(context, listen: false).openingTime,0);
    //       // DateTime closing = DateTime(2022,1,1,Provider.of<StyleProvider>(context, listen: false).closingTime,0);
    //       // DateTime selectedDateTime = DateTime(value.date!.year,value.date!.month,value.date!.day,time.hour, time.minute);
    //       // var referenceTime = DateTime(2022,1,1,0,0);
    //
    //
    //       // Navigator.pop(context);
    //       // Provider.of<StyleProvider>(context, listen: false).setUserBirthday(time);
    //       // Provider.of<StyleProvider>(context, listen: false).resetQuestionButtonColors();
    //
    //     //   Navigator.push(context,
    //     //       MaterialPageRoute(builder: (context)=> QuizPage3())
    //     //   );
    //     // });
    //       }
    // );
  }


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
      body: Form(
        key: formKey,

        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 0),

          child: SingleChildScrollView(
            child:
            SizedBox(
               height: 450,

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
                    InputFieldWidget(labelText:' Full Names' ,hintText: ' ', keyboardType: TextInputType.text, onTypingFunction: (value){
                      fullName = value;
                      firstName = fullName.split(" ")[0]; // Gets the first name in the 0 positiion from the full names
                    }, onFinishedTypingFunction: () {  },),
                    Row(
                      children: [
                        CountryCodePicker(
                          onChanged: (value){
                            countryCode = value.dialCode!;
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
                        InputFieldWidget(labelText: ' Mobile Number', hintText: ' ', keyboardType: TextInputType.number,  onTypingFunction: (value){
                          // setState(() {
                            if (value.split('')[0] == '7'){
                              invalidMessageDisplay = 'Incomplete Number';
                              if (value.length == 9 && value.split('')[0] == '7'){
                                phoneNumber = value;
                                // phoneNumber.split('0');
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
                    InputFieldWidget(labelText: ' Email', hintText: ' ', keyboardType: TextInputType.emailAddress, onTypingFunction: (value){
                      email = value;
                    }, onFinishedTypingFunction: () {  },),
                    // SizedBox(height: 8.0,),
                    InputFieldWidget(labelText: ' Password',hintText:' ', keyboardType: TextInputType.visiblePassword,passwordType: true, onTypingFunction: (value){
                      password = value;
                    }, onFinishedTypingFunction: () {  },),
                    // InputFieldWidget(labelText: ' Weight (kg)', hintText: ' ', keyboardType: TextInputType.number, onTypingFunction: (value){
                    //   weight = double.parse(value) ;
                    // }, onFinishedTypingFunction: () {  },),
                    // InputFieldWidget(labelText: ' Height (cm)', hintText: ' ', keyboardType: TextInputType.number, onTypingFunction: (value){
                    //   height = int.parse(value);
                    // }, onFinishedTypingFunction: () {  },),
                    // InputFieldWidget(labelText: ' Next of Kin', hintText: ' ', keyboardType: TextInputType.text, onTypingFunction: (value){
                    //   kin = value;
                    // }, onFinishedTypingFunction: () {  },),
                    // InputFieldWidget(labelText: ' Next of Kin Number', hintText: ' ', keyboardType: TextInputType.text, onTypingFunction: (value){
                    //   kinNumber = value;
                    // }, onFinishedTypingFunction: () {  },),
                    InputFieldWidget(labelText: ' Date of Birth', hintText: ' ', keyboardType: TextInputType.text, onTypingFunction: (value){
                      birthday = value;
                    }, onFinishedTypingFunction: () {  },),


                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child:
                      RoundedLoadingButton(
                        color: kGreenDarkColorOld,
                        child: Text('Register', style: kHeadingTextStyleWhite),
                        controller: _btnController,
                        onPressed: () async {


                          final isValidForm = formKey.currentState!.validate();

                            if (isValidForm){
                              print('Else activated');
                              var newPhoneNumber = "$countryCode$phoneNumber";
                              _btnController.reset();
                              // setState(() {
                              //   //showSpinner = true;
                              // });
                              try{
                                final newUser = await _auth.createUserWithEmailAndPassword(email: email,
                                    password: password);
                                if (newUser != null){

                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString(kFullNameConstant, fullName);
                                  prefs.setString(kNextOfKinNumber, kinNumber);
                                  prefs.setString(kNextOfKin, kin);
                                  prefs.setString(kFirstNameConstant, firstName);
                                  prefs.setString(kEmailConstant, email);
                                  prefs.setString(kPhoneNumberConstant, newPhoneNumber);
                                  prefs.setBool(kIsLoggedInConstant, true);
                                  prefs.setBool(kIsFirstTimeUser, true);
                                  prefs.setDouble(kUserWeight, weight);
                                  prefs.setInt(kUserHeight, height);
                                  prefs.setString(kUserBirthday, birthday);

                                  uploadUserData();

                                  // uploadUserData();



                                  // await callableEmail.call(<String, dynamic>{
                                  //   'name': firstName,
                                  //   'emailAddress':email,
                                  //   // 'templateID':kEmailWelcomeID,
                                  //   'subject': 'Welcome to Styleapp',
                                  // });

                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context)=> QuizPage6())
                                  // );



                                  // Navigator.pushNamed(context, OnboardingPage.id);


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
                            else{
                              _btnController.reset();
                            }
                          }


                        // },
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
      ),
    );
  }
}
