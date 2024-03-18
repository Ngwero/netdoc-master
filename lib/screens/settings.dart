
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:netdoc/controllers/payments_controller.dart';
import 'package:netdoc/screens/edit_page.dart';
import 'package:netdoc/screens/login_page.dart';
import 'package:netdoc/utilities/constants/user_constants.dart';
import 'package:netdoc/widgets/language_widget.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../Utilities/constants/color_constants.dart';
//import '../../../Utilities/constants/user_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../models/common_functions.dart';
import '../utilities/constants/word_constants.dart';
import '../widgets/rounded_icon_widget.dart';


class SettingsPage extends StatefulWidget {
  static String id = 'settings_page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void defaultsInitiation () async{

    final prefs = await SharedPreferences.getInstance();
    String newName = prefs.getString(kFullNameConstant) ?? 'User';
    String newSex = prefs.getString(kUserSex) ?? 'Kool';
    String newBirthday = prefs.getString(kUserBirthday) ?? '16-May-1989';
    String? newPhone = prefs.getString(kPhoneNumberConstant);
    String? newEmail = prefs.getString(kEmailConstant);

    String newPrivacy = prefs.getString(kPrivacy) ?? 'https://mjengoapp.com/netdocprivacy.html';
    String newCondition = prefs.getString(kConditions) ?? 'https://mjengoapp.com/netdocprivacy.html';
    double newWeight = prefs.getDouble(kUserWeight) ?? 80;
    int newHeight = prefs.getInt(kUserHeight)?? 180;


    setState(() {
      termsAndConditions = newCondition;
      privacyPolicy = newPrivacy;
      birthday = newBirthday;
      weight = newWeight;
      name = newName;
      sex = newSex;
      phone = newPhone!;
      email= newEmail!;

      height = newHeight;
      bmi = ((weight)/ ((height/100)*(height/100))).roundToDouble();
      // phoneNumber = prefs.getString(kCustomerCare)!;


    });
  }
  double textSize = 15;
  String preferences = '';
  String phone = '';
  String name = '';
  String sex = '';
  String email = '';
  double bmi = 20.0;
  String birthday = '';
  double weight = 40;
  String phoneNumber = '';
  String privacyPolicy = '';
  String termsAndConditions = '';
  int height = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultsInitiation();
  }
  final auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kBackgroundGreyColor,
        title: Center(child: Text(settingsPage.tr, style: kNormalTextStyle.copyWith(color: kGreenDarkColorOld),)),
        actions: [
          // IconButton(
          //   icon:  Icon(Icons.support_agent, color: kBlueDarkColor,),
          //   onPressed: (){
          //     CommonFunctions().callPhoneNumber('0782081219');
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.share, color: kGreenDarkColorOld,),
            onPressed: (){
              Share.share('Check out this Doctor booking app called NetDoc. You can download it on Android and iOS', subject: 'Check out this app');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kGreenThemeColor,
        onPressed: () async{
          final prefs = await SharedPreferences.getInstance();
          var phoneNumber = prefs.getString(kCustomerCare) ?? "0709323332";
          CommonFunctions().callPhoneNumber(phoneNumber);
        },
        child:Icon(Icons.support_agent, color: kPureWhiteColor,),
      ),

      backgroundColor: kBackgroundGreyColor,
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // RoundImageRing(radius: 80, outsideRingColor: kPureWhiteColor, networkImageToUse: 'https://mcusercontent.com/f78a91485e657cda2c219f659/images/e80988fd-e61d-2234-2b7e-dced6e5f3a1a.jpg',),
              //
              LanguageDropdown(),
              kSmallWidthSpacing,
              // Text(name, style: kNormalTextStyleWhiteButtons.copyWith(color: kGreenDarkColorOld)),
              GestureDetector(
                onTap: () async{

                  Navigator.pushNamed(context, PaymentsController.id);


                },
                child: Card(
                  color: kPureWhiteColor,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                  shadowColor: kGreenThemeColor,
                  elevation: 5.0,
                  child: ListTile(
                    title: Text(payments.tr, style: kNormalTextStyleWhiteButtons.copyWith(color: kBlack)),
                    leading: Icon(LineIcons.wallet, color: kGreenDarkColorOld,),
                    //  trailing: const Icon(Icons.edit, color: Colors.white,),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async{
                  final prefs = await SharedPreferences.getInstance();
                  var termsUrl = prefs.getString(kConditions)??"https://mjengoapp.com/netdocprivacy.html";

                  launchUrlString( termsUrl!);

                },
                child: Card(
                  color: kPureWhiteColor,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                  shadowColor: kGreenThemeColor,
                  elevation: 5.0,
                  child: ListTile(
                    title: Text(settingsTerms.tr, style: kNormalTextStyleWhiteButtons.copyWith(color: kBlack)),
                    leading: Icon(LineIcons.medicalNotes, color: kGreenDarkColorOld,),
                    //  trailing: const Icon(Icons.edit, color: Colors.white,),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ()async{
                  final prefs = await SharedPreferences.getInstance();
                  var termsUrl = prefs.getString(kConditions)??"https://mjengoapp.com/netdocprivacy.html";

                  launchUrlString( termsUrl!);

                },
                child: Card(
                  color: kPureWhiteColor,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                  shadowColor: kGreenThemeColor,
                  elevation: 5.0,
                  child: ListTile(
                    title: Text(privacy.tr, style: kNormalTextStyleWhiteButtons.copyWith(color: kBlack)),
                    leading: Icon(LineIcons.paperHandAlt, color: kGreenDarkColorOld,),
                    //  trailing: const Icon(Icons.edit, color: Colors.white,),
                  ),
                ),
              ),

              kSmallHeightSpacing,
              Center(child: Text(healthInfo.tr, style: kNormalTextStyleSmall,)),

              Stack(
                children: [
                  Card(
                    margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                    shadowColor: kGreenDarkColorOld,
                    elevation: 5.0,
                    child:
                    Column(
                      children: [
                        ListTile(
                          leading: Icon(Iconsax.people, color: kGreenDarkColorOld,),
                          title:Text(sex, style: kNormalTextStyle),
                          // trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(Iconsax.ruler, color: kGreenDarkColorOld,),
                          title:Text( '$height cm', style: kNormalTextStyle),
                          // trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(Iconsax.weight, color:kGreenDarkColorOld,),
                          title:Text('$weight kg', style: kNormalTextStyle),
                          // trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(Iconsax.health, color: kGreenDarkColorOld,),
                          title:Text('BMI: $bmi', style:kNormalTextStyle),
                          // trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(Iconsax.cake, color: kGreenDarkColorOld,),
                          title:Text('DOB: $birthday', style:kNormalTextStyle),
                          // trailing: Icon(Icons.keyboard_arrow_right),
                        ),

                      ],
                    ),
                  ),
                  Positioned(

                    child:
                  GestureDetector(
                    onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfilePage()));
                    },
                    child: CircleAvatar(
                        backgroundColor: kGreenThemeColor,
                        child: Icon(Icons.edit, color: kPureWhiteColor,)),
                  ),
                    top: 0, right: 10,),
                ],
              ),
              Center(child: Text(personalInfo.tr, style: kNormalTextStyleSmall,)),


              Card(
                margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                shadowColor: kGreenDarkColorOld,
                elevation: 5.0,
                child:
                Column(
                  children: [

                    ListTile(
                      leading: Icon(Icons.phone, color: kGreenDarkColorOld,),
                      title:Text( phone, style: kNormalTextStyle),
                      // trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Icon(Icons.email, color:kGreenDarkColorOld,),
                      title:Text(email, style: kNormalTextStyle),
                      // trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    _buildDivider(),
                    GestureDetector(
                      onTap: (){
                        // showModalBottomSheet(
                        //     context: context,
                        //     builder: (context) {
                        //       return Container(color: kBackgroundGreyColor,
                        //         child: InputPage(),
                        //       );
                        //     });
                        //

                      },
                      child: const ListTile(
                        leading: Icon(LineIcons.flag, color: kGreenDarkColorOld,),
                        title:Text('Uganda', style:kNormalTextStyle),
                        // trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    // _buildDivider(),
                    // ListTile(
                    //   leading: Icon(Iconsax.scissor, color: kGreenDarkColorOld,),
                    //   title:Text(preferences, style: kNormalTextStyle),
                    //   // trailing: Icon(Icons.keyboard_arrow_right),
                    // ),
                  ],
                ),
              ),


              const SizedBox(height: 10,),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: (){
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              widget: Column(
                                children: [
                                  Text('Are you sure you want to Log Out?', textAlign: TextAlign.center, style: kNormalTextStyle,),

                                ],
                              ),
                              title: 'Log Out?',

                              confirmBtnColor: kFontGreyColor,
                              confirmBtnText: 'Yes',
                              confirmBtnTextStyle: kNormalTextStyleWhiteButtons,
                              lottieAsset: 'images/sad.json', showCancelBtn: true, backgroundColor: kBlack,


                              onConfirmBtnTap: () async{
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setBool(kIsLoggedInConstant, false);
                                prefs.setBool(kIsFirstTimeUser, true);
                                await auth.signOut().then((value) => Navigator.pushNamed(context, LoginPage.id));



                              }


                          );
                        },
                        child: Text("Log Out", style:kNormalTextStyleBoldPink.copyWith(color: Colors.blue) ,)),

                    TextButton(onPressed: (){

                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.success,
                          widget: Column(
                            children: const [
                              Text('Are you sure you want Delete this Account? All your data will be lost and this action cannot be undone', textAlign: TextAlign.center, style: kNormalTextStyle,),
                            ],
                          ),
                          title: 'Delete Account!',

                          confirmBtnColor: kFontGreyColor,
                          confirmBtnText: 'Yes',
                          confirmBtnTextStyle: kNormalTextStyleWhiteButtons,
                          lottieAsset: 'images/delete.json', showCancelBtn: true, backgroundColor: kFaintGrey,


                          onConfirmBtnTap: () async{
                            // FirebaseUser user = await FirebaseAuth.instance.currentUser!();
                            // user.delete();
                            // CommonFunctions().signOut();
                            // // Navigator.pop(context);
                            // // Navigator.pop(context);
                            // // Navigator.pop(context);
                            // Navigator.pushNamed(context, WelcomePage.id)


                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool(kIsLoggedInConstant, false);
                            prefs.setBool(kIsFirstTimeUser, true);

                            await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).delete().then((value) async =>
                            await auth.signOut().then((value) => Navigator.pushNamed(context, LoginPage.id)));

                            // await auth.signOut().then((value) => Navigator.pushNamed(context, WelcomePage.id));


                          }
                      );



                    }, child: Text("Delete Account")),

                    const SizedBox(height: 10,),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(LineIcons.copyright, color: Colors.black,size: 15,),
                          SizedBox(width: 5,),
                          Opacity (opacity: 0.7,
                              child: Text('Netdoc 2024', style: kHeadingTextStyle,)),
                        ],
                      ),
                    )
                  ],
                ),

              ),

            ],

          ),
        ),
      ),
    );

  }




  Container _buildDivider(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[200],

    );
  }
}
