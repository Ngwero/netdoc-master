import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:netdoc/controllers/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utilities/constants/color_constants.dart';
import '../../Utilities/constants/font_constants.dart';
import '../utilities/constants/user_constants.dart';


class QuizPage6 extends StatefulWidget {

  @override
  _QuizPage6State createState() => _QuizPage6State();
}

class _QuizPage6State extends State<QuizPage6> {
  var categoryName = ['Covid','Tetanus', 'Yellow Fever', 'DPT Diphtheria/Pertussis/Tetanus', 'MMR Measles/ Mumps/ Rubella', 'OPv: Oral Polio Vaccine ', 'Hepatitis', 'Heamophylus Inflenza', 'HPV'];
  var categoryId = [];
  var arrayState = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var token = "old token";


  void defaultInitialisation() async{
    _firebaseMessaging.getToken().then((value) => token = value!);
  }
  Future<void> uploadUserData() async {
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
          'vaccines':categoryId,
          'phoneNumber': prefs.getString(kPhoneNumberConstant),
          'subscribed': true,
          'token': token
        });
    prefs.setString(kToken, token);
    print("PEERRRRRFEEECTLY UPDATED");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialisation();


  }

  @override

  Widget build(BuildContext context) {
    // var styleData = Provider.of<StyleProvider>(context, listen: false);
    // var styleDataDisplay = Provider.of<StyleProvider>(context);
    // Provider.of<StyleProvider>(context, listen: false).resetQuestionButtonColors();
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kGreenThemeColor,
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.setString(kFruitButtonCategory, categoryId.join());
            uploadUserData();

            Navigator.pushNamed(context, ControlPage.id);

          },
          label: const Text("Enter Netdoc", style: kNormalTextStyleWhiteButtons,),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        backgroundColor: kPureWhiteColor,
        // appBar: AppBar(
        //   backgroundColor: Colors.deepOrangeAccent,
        //
        // ),
        body:
        Stack(
            children :
            [
              Container(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top:50.0, right: 10, left: 10),
                    child: Text('Which of these vaccines have you received? ',
                        textAlign: TextAlign.center, style:kHeading2TextStyleBold.copyWith(color: kBlack)),
                  ),),
                height: 150,
                decoration: const BoxDecoration(
                    color: kPureWhiteColor,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(60), bottomLeft: Radius.circular(60))),

              ),
              Padding(
                  padding: const EdgeInsets.only(top:130.0, right: 12, left: 12),
                  child:ListView.builder(

                      itemCount: categoryName.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          checkColor: kGreenThemeColor,
                          activeColor: kPureWhiteColor,

                          title: Text(categoryName[index], style: kNormalTextStyle.copyWith(color: kBlack),),
                          value: arrayState[index], onChanged: (bool? value) {
                            arrayState[index] = !arrayState[index];
                            if (value == true){
                              categoryId.add(categoryName[index]);
                              print(categoryId);

                            }else {
                              categoryId.remove(categoryName[index]);
                              print(categoryId);
                            }
                            setState(() {

                            });

                        },);
                      }

                  )
              ),

            ]
        )
    );
  }


}



