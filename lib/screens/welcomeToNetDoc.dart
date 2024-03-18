
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





class WelcomeToNetdoc extends StatefulWidget {
  static String id = 'register_page';
  @override
  _WelcomeToNetdocState createState() => _WelcomeToNetdocState();
}

class _WelcomeToNetdocState extends State<WelcomeToNetdoc> {
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
    final prefs = await SharedPreferences.getInstance();
    fullName = prefs.getString(kFullNameConstant)!;
    firstName = prefs.getString(kFirstNameConstant)!;


    _firebaseMessaging.getToken().then((value) => token = value!);
    setState(() {

    });
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

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // appValuesStream();
    defaultInitialisation();

    // deliveryStream();
  }



  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: kBackgroundGreyColor,
      appBar: AppBar(
        iconTheme:const IconThemeData(
          color: kPureWhiteColor, //change your color here
        ),
        title: Text('Welcome $firstName', style: kNormalTextStyleWhiteButtons,),
        centerTitle: true,

        backgroundColor: kGreenDarkColorOld,
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: formKey,

        child: Padding(
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
                    InputFieldWidget(controller:fullName ,labelText:' Full Names' ,hintText: ' ', keyboardType: TextInputType.text, onTypingFunction: (value){
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


                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString(kFullNameConstant, fullName);
                                  prefs.setString(kNextOfKinNumber, kinNumber);
                                  prefs.setString(kNextOfKin, kin);
                                  prefs.setString(kFirstNameConstant, firstName);

                                  prefs.setString(kPhoneNumberConstant, newPhoneNumber);
                                  prefs.setBool(kIsLoggedInConstant, true);
                                  prefs.setBool(kIsFirstTimeUser, true);
                                  prefs.setDouble(kUserWeight, weight);
                                  prefs.setInt(kUserHeight, height);
                                  prefs.setString(kUserBirthday, birthday);

                                  uploadUserData();

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
