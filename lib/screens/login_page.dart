
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/screens/signup_page.dart';
import 'package:netdoc/screens/welcomeToNetDoc.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../Utilities/constants/color_constants.dart';
import '../controllers/home_controller.dart';
import '../models/common_functions.dart';
import '../onboarding_questions/quiz_page_name.dart';
import '../utilities/constants/font_constants.dart';

import '../utilities/constants/user_constants.dart';
import'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../utilities/google_auth_service.dart';


class LoginPage extends StatefulWidget {
  static String id = 'login_page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final auth = FirebaseAuth.instance;
  String email = ' ';
  String token = '';
  String password = ' ';
  String link = '';
  String linkTest = '';
  String privacy = '';


  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  bool showSpinner = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void subscribeToTopic()async{
    await FirebaseMessaging.instance.subscribeToTopic('kitchen').then((value) =>
    print('Succefully Subscribed')
    );
  }
  String capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1).toLowerCase();
  }
  List<String> splitName(String fullName) {
    final List<String> names = fullName.trim().split(' ');

    if (names.length < 2) {
      throw ArgumentError('Full name must have at least two names separated by a space');
    }

    final String firstName = capitalize(names.first);
    final String lastName = capitalize(names.last);

    return [firstName, lastName];
  }
  Future<void> handleGoogleSignIn() async {
    final prefs = await SharedPreferences.getInstance();


    try {
      showDialog(context: context, builder:
          ( context) {
        return const Center(child: CircularProgressIndicator(color: kGreenThemeColor,));
      });
      final UserCredential userCredential = await GoogleAuthService().signInWithGoogle();
      Navigator.pop(context) ;
      final User user = userCredential.user!;

      // Check if the user is new or existing and navigate accordingly
      var names = splitName(user.displayName!);
      print("WE ARE IN ${names[0]}");
      // If the user doesnt exist
      if (userCredential.additionalUserInfo ?.isNewUser ?? false) {
        print("New useeeeeerrrrrrr ${names[0]}");

        // prefs.setString(user.displayName!,kFullNameConstant);
        prefs.setString(kFirstNameConstant,names[0]);
        prefs.setString(kFullNameConstant, names.join(" "));
        prefs.setString(kUserUid, user.uid!);
        prefs.setString(kEmailConstant, user.email!);
        prefs.setBool(kIsLoggedInConstant, true);
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> WelcomeToNetdoc())
        );


      } else {
        print("Old useeeeeerrrrrrr ${names[0]}");
        final users = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (users.exists){
          print("UUUUseeeeeerrrrrrr ${names[0]} EXISTS");


            prefs.setDouble(kUserWeight, users['weight']);
            prefs.setInt(kUserHeight,users['height']);
            prefs.setString(kFullNameConstant, users['fullName']);
            prefs.setString(kFirstNameConstant, users['lastName']);
            prefs.setString(kEmailConstant,  user.email!);
            prefs.setString(kPhoneNumberConstant, users['phoneNumber']);
            prefs.setString(kUserBirthday, users['dateOfBirth']);
            prefs.setString(kUserSex, users['sex']);
            prefs.setString(kFruitButtonCategory, users['vaccines'].join());
            prefs.setBool(kIsLoggedInConstant, true);
            prefs.setString(kUserUid,users.id);

            // Navigate to the home page
            Navigator.pushNamed(context, ControlPage.id);
            Get.snackbar('Welcome Back ${names[0]}', '🙂',
                snackPosition: SnackPosition.TOP,
                backgroundColor: kGreenThemeColor,
                colorText: kBlack,
                icon: Icon(Iconsax.smileys, color: kGreenThemeColor,));
            CommonFunctions().uploadUserToken(token);
        } else {

          print("UUUUseeeeeerrrrrrr ${names[0]} DOES NOT EXISTS");

        }

      }
    } catch (e) {
      // Handle sign-in errors
      showDialog(context: context, builder: (BuildContext context){

        return CupertinoAlertDialog(
          title: const Text('Ooops Something Happened'),
          content: Text('There was an issue $e', style: kNormalTextStyle.copyWith(color: kBlack),),
          actions: [CupertinoDialogAction(isDestructiveAction: true,
              onPressed: (){
                // _btnController.reset();
                Navigator.pop(context);
              },
              child: const Text('Cancel'))],
        );
      });
      print(e);
    }
  }
  Future deliveryStream() async {

    final prefs = await SharedPreferences.getInstance();
    final users = await FirebaseFirestore.instance
        .collection('terms').doc("Eocb8FbSnQZIUQCqNppA")
        .get();
    link = users['conditions'];
    privacy = users['privacy'];

    Provider.of<DoctorProvider>(context,  listen: false).setTermsAndConditions(link, privacy);
    prefs.setString(kConditions, link);
    prefs.setString(kPrivacy, privacy);
  }


  void defaultsInitialization () async{
    _firebaseMessaging.getToken().then((value) => token = value!);
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(kIsLoggedInConstant) ?? false;
    setState(() {
      userLoggedIn = isLoggedIn ;
      if(userLoggedIn == true){
        Navigator.pushNamed(context, ControlPage.id);
      }else{
        print('NOT LOGGED IN');
      }
    });
  }
  bool userLoggedIn = false;
  bool obscureValue = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliveryStream();
    defaultsInitialization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: kGreenThemeColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
                image: AssetImage('images/background2.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                height: 280,
                //color: Colors.red,
                child:


                Stack(
                  children: [

                  ],
                ),
              ),

                //åSizedBox(height: 10,),
                Padding(padding: EdgeInsets.only(left: 50, right: 50, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Netdoc Prime',
                          style: kHeading3TextStyleBold.copyWith(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            bool value = false;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                          child: Row(
                            children: [
                              Text(
                                "If you are new/",
                                textAlign: TextAlign.left,
                                style: kNormalTextStyle.copyWith(
                                    color: kPureWhiteColor),
                              ),
                              Text(
                                " Create Account",
                                textAlign: TextAlign.left,
                                style: kNormalTextStyle.copyWith(
                                    color: kPureWhiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: kGreenDarkColorOld,
                                  blurRadius: 1,
                                  offset: Offset(0,0),
                                )
                              ]
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                        color: kGreenDarkColorOld
                                    ))
                                ),
                                child: TextField(

                                  onChanged: (value){
                                    email = value;
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:  'Email Address',
                                      hintStyle: TextStyle(color: Colors.grey)
                                  ) ,
                                )
                                ,),
                              // SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(10),

                                child: TextField(
                                  obscureText: obscureValue,
                                  onChanged: (value){
                                    password = value;
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: GestureDetector(
                                        onTap: (){
                                          obscureValue = !obscureValue;
                                          setState(() {

                                          });
                                        },
                                        child: obscureValue == false?Icon(LineIcons.eye, color: kGreenThemeColor,):Icon(LineIcons.eyeSlash, color: kGreenThemeColor,)),
                                    border: InputBorder.none,
                                    hintText:  'Password',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ) ,
                                )
                                ,),
                            ],
                          ) ,
                        ),
                        TextButton(onPressed: (){
                          if(email != ''){
                            auth.sendPasswordResetEmail(email: email);
                            showDialog(context: context, builder: (BuildContext context){
                              return CupertinoAlertDialog(
                                title: Text('Reset Email Sent'),
                                content: Text('Check email $email for the reset link'),
                                actions: [CupertinoDialogAction(isDestructiveAction: true,
                                    onPressed: (){
                                      _btnController.reset();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'))],
                              );
                            });
                          }else{
                            showDialog(context: context, builder: (BuildContext context){
                              return CupertinoAlertDialog(
                                title: Text('Type Email'),
                                content: Text('Please type your email Address and Click on the forgot password!'),
                                actions: [CupertinoDialogAction(isDestructiveAction: true,
                                    onPressed: (){
                                      //_btnController.reset();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'))],
                              );
                            });
                          }

                        }, child: Text('Forgot Password')),
                        RoundedLoadingButton(
                          color: kBlack,
                          child: Text('Login',
                              style: TextStyle(color: Colors.white)),
                          controller: _btnController,
                          onPressed: () async {
                            try {
                              await auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                              final users = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(auth.currentUser!.uid)
                                  .get();
                              // if (email == 'cathy@netdoc.com'){
                              final prefs =
                                  await SharedPreferences.getInstance();
                              //   prefs.setDouble(kUserWeight, 70);
                              //   prefs.setInt(kUserHeight,180);
                              //   prefs.setString(kFullNameConstant, 'Cathy Nalya');
                              //   prefs.setString(kFirstNameConstant, 'Cathy');
                              //   prefs.setString(kEmailConstant, email);
                              //   prefs.setBool(kIsLoggedInConstant, true);
                              //
                              //
                              //   Navigator.pushNamed(context, ControlPage.id);
                              //
                              // }
                            if (users.exists){
                              showModalBottomSheet(
                                  context: context,
                                  // isScrollControlled: true,
                                  builder: (context) {
                                    return Container(color: kBackgroundGreyColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20.0, right: 10, left: 10),
                                                child: Text("By Pressing Continue yor are agreeing to Netdoc Terms and Conditions", textAlign: TextAlign.center, style: kHeading2TextStyleBold.copyWith(color: kBlack),),
                                              ),
                                              Lottie.asset('images/terms.json', height: 70, ),
                                              kLargeHeightSpacing,
                                              GestureDetector(
                                                  onTap:(){


                                                    launchUrlString( Provider.of<DoctorProvider>(context,  listen: false).terms);

                                                  },
                                                  child: Text('Terms and Conditions', style: kNormalTextStyle.copyWith(color: Colors.red),)),
                                              kLargeHeightSpacing, 
                                              GestureDetector(
                                                  onTap:(){
                                                    print("LOLOLOLO $link");
                                                    // CommonFunctions().websiteLinkUrl('www.google.com');
                                                    //  launchUrl(Uri.parse(link));
                                                    launchUrlString( Provider.of<DoctorProvider>(context,  listen: false).privacy);

                                                  },
                                                  child: Text('Privacy Policy', style: kNormalTextStyle.copyWith(color: Colors.red),)),

                                              MaterialButton(
                                                color: kGreenThemeColor,
                                                  child: Text('Continue', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                                                  onPressed: (){
                                                      Navigator.pushNamed(context, ControlPage.id);

                                                  })
                                            ],
                                          ),

                                        ),
                                      ),
                                      // InputPage()
                                    );
                                  });


                              prefs.setDouble(kUserWeight, users['weight']);
                                prefs.setInt(kUserHeight,users['height']);
                                prefs.setString(kFullNameConstant, users['fullName']);
                                prefs.setString(kFirstNameConstant, users['lastName']);
                                prefs.setString(kEmailConstant, users['email']);
                                prefs.setString(kPhoneNumberConstant, users['phoneNumber']);
                                prefs.setString(kUserBirthday, users['dateOfBirth']);
                                prefs.setString(kUserSex, users['sex']);
                                prefs.setString(kFruitButtonCategory, users['vaccines'].join());
                                prefs.setBool(kIsLoggedInConstant, true);
                                prefs.setString(kUserUid,users.id);
                              //
                              //




                            } else{
                              prefs.setString(kEmailConstant, email);
                              prefs.setString(kToken, token);
                              Navigator.pushNamed(context, QuizPageName.id);
                                // showDialog(context: context, builder: (BuildContext context){
                                //   return CupertinoAlertDialog(
                                //     title: Text('Login Functionality will be fully implemented'),
                                //     content: Text('Your login credentials are perfectly fine but right now we need you to create a new account to see these new features'),
                                //     actions: [CupertinoDialogAction(isDestructiveAction: true,
                                //         onPressed: (){
                                //           _btnController.reset();
                                //           Navigator.pop(context);
                                //           setState(() {
                                //
                                //           });
                                //         },
                                //         child: Text('Cancel'))],
                                //   );
                                // });
                              }


                              //showSpinner = false;
                            }catch(e) {
                              _btnController.error();
                              print(e);
                              // Navigator.pushNamed(context, ControlPage.id);
                              showDialog(context: context, builder: (BuildContext context){
                                return CupertinoAlertDialog(
                                  title: Text('$e'),
                                  content: Text('The credentials you have entered are incorrect'),
                                  actions: [CupertinoDialogAction(isDestructiveAction: true,
                                      onPressed: (){
                                        _btnController.reset();
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'))],
                                );
                              });
                            }
                          },
                        ),
                        kLargeHeightSpacing,
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 20.0, left: 20),
                        //   child: SizedBox(
                        //     width: double.infinity,
                        //     height: 43,
                        //     child:
                        //     ElevatedButton(
                        //         style: ElevatedButton.styleFrom(
                        //             backgroundColor: Colors.blue,
                        //             shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(10))),
                        //         onPressed: () async{
                        //           // GoogleAuthService().signInWithGoogle();
                        //           handleGoogleSignIn();
                        //
                        //         },
                        //
                        //
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Text("Sign In with Google", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                        //             kSmallWidthSpacing,
                        //             Icon(Iconsax.chrome, color: kPureWhiteColor,),
                        //           ],
                        //         )),
                        //
                        //   ),
                        // ),


                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
