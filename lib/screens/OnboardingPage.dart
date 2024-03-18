//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fancy_on_boarding/fancy_on_boarding.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:netdoc/screens/login_page.dart';
// import 'package:netdoc/utilities/constants/color_constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Utilities/constants/user_constants.dart';
// import '../controllers/homepage_controller.dart';
// import '../utilities/constants/font_constants.dart';
//
//
//
//
// class OnboardingPage extends StatefulWidget {
//   static String id = 'onboarding_page';
//
//
//   @override
//   _OnboardingPageState createState() => new _OnboardingPageState();
// }
// class _OnboardingPageState extends State<OnboardingPage> {
//   //Create a list of PageModel to be set on the onBoarding Screens.
//   CollectionReference userDetails = FirebaseFirestore.instance.collection('orders');
//   final auth = FirebaseAuth.instance;
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   // void defaultInitialization()async{
//   //
//   //   final prefs =  await SharedPreferences.getInstance();
//   //
//   //   name = prefs.getString(kFirstNameConstant)!;
//   //   _firebaseMessaging.getToken().then((value) => token = value!);
//   //   // prefs.setString(kToken, value!)
//   // }
//   // Future<void> uploadUserData() async {
//   //
//   //   final prefs = await SharedPreferences.getInstance();
//   //
//   //   final users = await FirebaseFirestore.instance
//   //       .collection('users').doc(auth.currentUser!.uid)
//   //       .update(
//   //       {
//   //         'firstName': prefs.getString(kFirstNameConstant),
//   //         'lastName': prefs.getString(kFullNameConstant),
//   //         'phoneNumber': prefs.getString(kPhoneNumberConstant),
//   //         'subscribed': true,
//   //         'token': token
//   //       });
//   //   prefs.setString(kToken, token);
//   //
//   // }
//   var token = "old token";
//   String name = '';
//   double fontSize = 28;
//   final pageList = [
//     PageModel(
//       color: kBlack,
//       //(0xff17183c),
//       heroImagePath: 'images/smiledoc smile.png',
//       title: Text('Welcome to NetDoctor',
//           style: kHeadingExtraLargeTextStyle.copyWith(color: kPureWhiteColor)),
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         child: Text(
//             'Your digital medical provider. We are with you every step of your health journey',
//             textAlign: TextAlign.center,
//             style: kHeadingTextStyle.copyWith(color: kPureWhiteColor)),
//       ),
//       icon: const Icon(
//         LineIcons.stethoscope,
//         color:kPureWhiteColor,
//       ),
//     ),
//
//     PageModel(
//       color: kGreenDarkColorOld,
//       heroImagePath: 'images/phonetype.png',
//       title: const Text('Get Easy Access to Health Care',
//           style: TextStyle(fontSize: 20, color: kPureWhiteColor, fontFamily: 'Futura', fontStyle: FontStyle.normal, )),
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         child: Text('See real feedback from previous customers and make the best decisions before booking',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize:15, color: kPureWhiteColor, fontFamily: 'Futura', fontStyle: FontStyle.normal, )),
//       ),
//       icon: const Icon(
//         LineIcons.calendar,
//         color: kPureWhiteColor,
//       ),
//     ),
//     // SVG Pages Example
//     PageModel(
//       color: kGreenThemeColor,
//       heroImagePath: 'images/videodoc.png',
//       title: const Text('Book and Connect with the best',
//           textAlign: TextAlign.center,
//           style:  TextStyle(fontSize: 20, color: kPureWhiteColor, fontFamily: 'Futura', fontStyle: FontStyle.normal, )),
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         child: const Text('Book your appointment and have it at the comfort of your home or office',
//             textAlign: TextAlign.center,
//             style:  TextStyle(fontSize: 15, color: kPureWhiteColor, fontFamily: 'Futura', fontStyle: FontStyle.normal, )),
//       ),
//       icon: const Icon(
//         LineIcons.video,
//         color: kGreenDarkColorOld,
//       ),
//     ),
//   ];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // defaultInitialization();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       //Pass pageList and the mainPage route.
//       body: FancyOnBoarding(
//         doneButtonText: "Enter",
//         skipButtonText: "Skip",
//         pageList: pageList,
//         onDoneButtonPressed: ()async {
//
//           Navigator.pushNamed(context, LoginPage.id);
//         },
//       ),
//     );
//   }
// }