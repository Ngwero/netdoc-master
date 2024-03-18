
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:netdoc/controllers/home_controller.dart';
import 'package:netdoc/models/common_functions.dart';
import 'package:netdoc/utilities/constants/user_constants.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utilities/InputFieldWidget.dart';
import 'package:intl/intl.dart';

import '../Utilities/constants/color_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../models/doctor_provider.dart';
import '../onboarding_questions/quiz_page0.dart';
import '../onboarding_questions/quiz_page6.dart';
import '../widgets/doctor_button.dart';
import 'add_service.dart';
import 'forms_page_current.dart';





class InsurancePage extends StatefulWidget {
  static String id = 'confirmations_page';
  @override
  _InsurancePageState createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  final _auth = FirebaseAuth.instance;

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  CollectionReference insurance = FirebaseFirestore.instance.collection('InsurancePayments');
  User user = FirebaseAuth.instance.currentUser!;
  String serviceId = 'iosInsure${uuid.v1().split("-")[0]}';


  String email= '';
  double changeInvalidMessageOpacity = 0.0;
  String invalidMessageDisplay = 'Invalid Number';
  String bloodPressure = '';
  String repeatPassword = '';
  String middleName = '';
  String lastName = '';
  String firstName = '';
  String phoneNumber = '';
  String kinNumber = '';
  String policyEmployer = '';
  String age = '';
  String policyHolder = '';
  String birthday = '';
  DateTime birthdayDate = DateTime.now();
  String policyEndDate = "";
  String policyNumber = '';
  double bmi = 0;

  //bool showSpinner = false;
  String errorMessage = 'Error Signing Up';
  double errorMessageOpacity = 0.0;
  late String countryCode;
  List insuranceProvider = [null, null, null];
  List sex = [null, null, null];
  String token = '';
  final formKey = GlobalKey<FormState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> uploadData() async {
    // Call the user's CollectionReference to add a new user
   // String dateOfAppointment = DateFormat('dd, MMMM, yyyy ').format(Provider.of<DoctorProvider>(context, listen: false).appointmentDate);
    final prefs = await SharedPreferences.getInstance();
    return insurance.doc(serviceId)
        .set({

      'Age':  age,
      'Condition': Provider.of<DoctorProvider>(context, listen: false).conditionName,
      'Email': email,
      'EmployerOfPolicyProvider': policyEmployer,
      'FullName': "$firstName $middleName $lastName" ,
      'Gender': sex[0],
      'InsuranceProvider': insuranceProvider[0],
      'NameOfPolicyProvider': policyHolder,
      'PhoneNumber': phoneNumber,
      'PolicyEndDate': policyEndDate,
      'timestamp': DateTime.now(),
      'userUid': user.uid,
     

      // Stokes and Sons

    })
        .then((value) => CommonFunctions().showNotification('$firstName your Insurance details have been submitted',"Thank you for choosing Netdoc") )
        .catchError((error) => print("Failed to send Communication: $error"));
  }


  // void defaultInitialisation() async{
  //   final prefs = await SharedPreferences.getInstance();
  //   middleName = prefs.getString(kFullNameConstant)!;
  //   email = prefs.getString(kEmailConstant)!;
  //   phoneNumber = prefs.getString(kPhoneNumberConstant)!;
  //   policyNumber = prefs.getDouble(kUserWeight)!;
  //   policyEndDate = prefs.getInt(kUserHeight)!;
  //   age = prefs.getString(kNextOfKin)??" ";
  //   kinNumber = prefs.getString(kNextOfKinNumber)??" ";
  //   policyEmployer = prefs.getString(kIdNumber)??" ";
  //   policyHolder = prefs.getString(kAllergies)??" ";
  //   bloodPressure = prefs.getString(kBloodPressure)??" ";
  //
  //
  //   setState(() {
  //     bmi = ((policyNumber)/ ((policyEndDate/100)*(policyEndDate/100))).roundToDouble();
  //
  //   });
  //
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // appValuesStream();

    // defaultInitialisation();

    // deliveryStream();
  }






  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: kBeigeColor,
      appBar: AppBar(
        iconTheme:const IconThemeData(
          color: kPureWhiteColor, //change your color here
        ),
        title: const Center(child: Text('Insurance Information', style: kNormalTextStyleWhiteButtons,)),
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
              height: 900,

              child:

              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8, top : 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Center(child: Image.asset('images/logo.png',height: 110,)),
                    Center(child: Text('FILL IN YOUR DETAILS',textAlign: TextAlign.center, style: kNormalTextStyle.copyWith(fontWeight: FontWeight.bold),)),
                    kLargeHeightSpacing,
                    kLargeHeightSpacing,
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Full Name", style: kNormalTextStyle.copyWith(fontWeight: FontWeight.bold),),
                    ),
                    kLargeHeightSpacing,
                    Row(
                      children: [
                        InputFieldWidget(readOnlyVariable: false, controller: firstName, labelText:' First Name' ,hintText: '', keyboardType: TextInputType.text, onTypingFunction: (value){
                          firstName = value; // Gets the first name in the 0 positiion from the full names
                        }, onFinishedTypingFunction: () {  },),
                        InputFieldWidget(readOnlyVariable: false,controller: middleName,  labelText:' Middle Name' ,hintText: '', keyboardType: TextInputType.text, onTypingFunction: (value){
                          middleName = value;
                         // Gets the first name in the 0 positiion from the full names
                        }, onFinishedTypingFunction: () {  },),
                      ],
                    ),
                    kLargeHeightSpacing,
                    InputFieldWidget(readOnlyVariable: false,controller: lastName,  labelText:' Last Name' ,hintText: '', keyboardType: TextInputType.text, onTypingFunction: (value){
                      lastName = value;
                     // Gets the first name in the 0 positiion from the full names
                    }, onFinishedTypingFunction: () {  },),

                    kSmallHeightSpacing,
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Age", style: kNormalTextStyle.copyWith(fontWeight: FontWeight.bold),),
                    ),
                    kSmallHeightSpacing,

                    // SizedBox(height: 10.0,),
                    InputFieldWidget(labelText: ' Age', hintText: '',controller: age,readOnlyVariable: false, keyboardType: TextInputType.number, onTypingFunction: (value){
                      age = value;
                    }, onFinishedTypingFunction: () {  },),
                    // SizedBox(height: 8.0,),
                    dropDownListSex("Sex", ['Male', 'Female                                                                          ']),
                    kLargeHeightSpacing,
                    InputFieldWidget(labelText: ' Phone Number', hintText: '',controller: phoneNumber,readOnlyVariable: false, keyboardType: TextInputType.text, onTypingFunction: (value){
                      phoneNumber = value;
                    }, onFinishedTypingFunction: () {  },),



                    InputFieldWidget(labelText: ' Email', hintText: '',controller: email,readOnlyVariable: false, keyboardType: TextInputType.emailAddress, onTypingFunction: (value){
                      email = value;
                    }, onFinishedTypingFunction: () {  },),

                    InputFieldWidget(labelText: ' Name of Policy Holder',controller: policyHolder, hintText: "",readOnlyVariable: false, keyboardType: TextInputType.text, onTypingFunction: (value){
                      policyHolder = value;
                    }, onFinishedTypingFunction: () {  },),
                    InputFieldWidget(labelText: ' Employer of Policy Holder',controller: policyEmployer, hintText: '',keyboardType: TextInputType.text, onTypingFunction: (value){
                      policyEmployer = value;
                    }, onFinishedTypingFunction: () {  },),

                    InputFieldWidget(labelText: ' Policy Number',readOnlyVariable: false,controller: policyNumber, hintText: '', keyboardType: TextInputType.text, onTypingFunction: (value){
                      policyNumber = value ;
                    }, onFinishedTypingFunction: () {  },),
                    InputFieldWidget(labelText: ' Policy End Date', hintText: '',controller: policyEndDate,readOnlyVariable: false, keyboardType: TextInputType.text, onTypingFunction: (value){
                      policyEndDate = value;
                    }, onFinishedTypingFunction: () {  },),
                    dropDownListInsurance("Insurance Provider", ['Insurance 1', 'Insurance 2', 'Insurance 3                                                                   ']),


                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child:
                        doctorButton(continueFunction: () async{

                          final prefs = await SharedPreferences.getInstance();

                              final isValidForm = formKey.currentState!.validate();



                              // else

                              if (isValidForm){
                                uploadData();
                                _btnController.reset();

                                // Navigator.pop(context);
                                Navigator.pushNamed(context, ControlPage.id);

                              }
                              else{
                                _btnController.reset();
                              }


                        }, title: 'Proceed',

                        )
                      // RoundedLoadingButton(
                      //   color: kGreenDarkColorOld,
                      //   child: Text('Proceed' , style: kHeadingTextStyleWhite),
                      //   controller: _btnController,
                      //   onPressed: () async {
                      //     final prefs = await SharedPreferences.getInstance();
                      //
                      //     final isValidForm = formKey.currentState!.validate();
                      //
                      //
                      //
                      //     // else
                      //
                      //     if (isValidForm){
                      //       uploadData();
                      //       _btnController.reset();
                      //
                      //       // Navigator.pop(context);
                      //       Navigator.pushNamed(context, ControlPage.id);
                      //
                      //     }
                      //     else{
                      //       _btnController.reset();
                      //     }
                      //
                      //
                      //
                      //   },
                      // ),
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
  dropDownListInsurance(String question, List answers) {
    return Padding(
      padding:  EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
      child: Container(
        color: kPureWhiteColor,
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(question, style: kNormalTextStyle.copyWith(color: kFontGreyColor, fontSize: 16),),
            Container(

              width: double.maxFinite,
              child: DropdownButton<String>(
                  items: answers.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: kNormalTextStyle.copyWith(fontSize: 14),));
                  }).toList() ,
                  value: insuranceProvider[0],

                  // doctorDataDisplay.answerBooklet[index],
                  //answers[0],
                  //doctorDataDisplay.filledInListAnswers[index],
                  onChanged: (value){
                    setState(() {
                      insuranceProvider[0] = value!;

                      //doctorDataDisplay.setNewAnswerBookletValue(index,value!);
                      // newAnswers = answers;
                    });
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
  dropDownListSex(String question, List answers) {
    return Padding(
      padding:  EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
      child: Container(
        color: kPureWhiteColor,
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(question, style: kNormalTextStyle.copyWith(color: kFontGreyColor, fontSize: 16),),
            Container(
              width: double.maxFinite,
              child: DropdownButton<String>(
                  items: answers.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: kNormalTextStyle.copyWith(fontSize: 14),));
                  }).toList() ,
                  value: sex[0],

                  // doctorDataDisplay.answerBooklet[index],
                  //answers[0],
                  //doctorDataDisplay.filledInListAnswers[index],
                  onChanged: (value){
                    setState(() {
                      sex[0] = value!;

                      //doctorDataDisplay.setNewAnswerBookletValue(index,value!);
                      // newAnswers = answers;
                    });
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}


