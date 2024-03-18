import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:netdoc/Utilities/constants/color_constants.dart';
import 'package:netdoc/Utilities/constants/font_constants.dart';
import 'package:netdoc/screens/login_page.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/home_controller.dart';
import '../models/common_functions.dart';
import '../models/video_singleton.dart';
import '../utilities/constants/user_constants.dart';
import 'error_page.dart';


SingletonModalClass videoVariables = SingletonModalClass();
class SplashPage extends StatefulWidget {
  static String id = 'splash_page';

  @override
  _SplashPageState createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {
  late Timer _timer;
  String currentVersion = '';
  String latestVersion = '';



  void defaultsInitiation () async{


    String? fcmToken = await FirebaseMessaging.instance.getToken();
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(kIsLoggedInConstant) ?? false;
    prefs.setString(kToken, fcmToken!);
    CommonFunctions().getVariableFromFirestore(context);
    setState(() {
      userLoggedIn = isLoggedIn;
      if (userLoggedIn == true) {
        Navigator.pushNamed(context, ControlPage.id);
      } else {
        _timer = Timer(const Duration(milliseconds: 1000), () {
          prefs.setBool(kIsLoggedInConstant, false);

          Navigator.pushNamed(context, LoginPage.id);
        });
      }
    });
  }

  Future deliveryStream() async {
    final prefs = await SharedPreferences.getInstance();
    final users = await FirebaseFirestore.instance
        .collection('variables').doc("RqU5WCz55UPeK0IUcYMz")
        .get();
    prefs.setBool(kPaymentIssues, users['payment']);
    prefs.setString(kCustomerCare, users['customerCare']);
  }

  _checkAppVersion() async {
    final newVersion = NewVersion(
      iOSId: "com.superdoc.netdoc",
    );
    final status = await newVersion.getVersionStatus();
    var latest = status!.localVersion;
    if (status.canUpdate!) {

      // Show bottom sheet for update
      showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
          onClosing: () {},
          builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "New Version Available",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "We have been hard at work to bring you an amazing new version of our app!\nGet version: ${status.storeVersion} From ${status.localVersion}",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kGreenThemeColor)),
                  onPressed: () {
                    newVersion.launchAppStore("https://apps.apple.com/us/app/netdoc/id6444231912");
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: Text("Update", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                    // defaultsInitiation();
                  },
                  child: Text("Cancel"),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // defaultsInitiation(); // Continue with the normal flow if no update is needed
    }
  }



  bool userLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();
    deliveryStream();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhiteColor,
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Center(child: ClipOval(child: Image.asset('images/logo.png', height: 100,)),),

      ),
    );
  }
}
