
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:netdoc/Utilities/constants/font_constants.dart';

import 'package:netdoc/controllers/appointments_controller.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/screens/chat.dart';
import 'package:netdoc/screens/chat_list.dart';
import 'package:netdoc/screens/home_pages/pro_home_page.dart';
import 'package:netdoc/screens/notification.dart';

import 'package:netdoc/screens/settings.dart';
import 'package:netdoc/utilities/constants/user_constants.dart';
import 'package:netdoc/utilities/constants/word_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utilities/constants/color_constants.dart';
import '../screens/home_page.dart';





class ControlPage extends StatefulWidget {
  ControlPage();
  static String id = 'home_control_page';

  @override
  _ControlPageState createState() => _ControlPageState();

}

class _ControlPageState extends State<ControlPage> {


  int _currentIndex = 0;
  double buttonHeight = 40.0;
  int amount = 0;
  bool isProVersion = false;
  final tabs = [
    // HomePage(),
    HomePagePro(),
    AppointmentsController(),
    ChatListPage(),
    NotificationPage(),
    SettingsPage()
  ];
  final proTabs = [
    HomePagePro(),
    AppointmentsController(),
    ChatListPage(),
    NotificationPage(),
    SettingsPage()
  ];

  defaultInitialization()async{
   final prefs = await SharedPreferences.getInstance();
   isProVersion = prefs.getBool(kIsProUser)?? false;

    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    defaultInitialization();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: isProVersion  == true ?proTabs[_currentIndex] :tabs[_currentIndex],
      bottomNavigationBar:
      BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: kAppGreenColor,
        iconSize: 18,
        items:
        // Item 1
        [
          BottomNavigationBarItem(
              icon: Icon(Iconsax.home),label:homeTab.tr,
              backgroundColor: Colors.green),
          // Item 2
          // BottomNavigationBarItem(
          //     icon: Icon(CupertinoIcons.heart_fill , size: 18,),label:'Preparing',
          //     backgroundColor: Colors.purple),
          // Item 3
          BottomNavigationBarItem(
              icon: Icon(LineIcons.clock),label:appointmentTab.tr,
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(LineIcons.envelope),label:chatTab.tr,
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(LineIcons.bell),label:notificationTab.tr,
              backgroundColor: Colors.black),

          BottomNavigationBarItem(
              icon: Icon(Iconsax.user),label:'User',
              // icon: Icon(LineIcons.warehouse),label:'Store',
              backgroundColor: Colors.black),

          // BottomNavigationBarItem(
          //     //icon: Icon(LineIcons.greaterThanEqualTo),label:'More',
          //     icon: Icon(Iconsax.more),label:'More',
          //     backgroundColor: Colors.black),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });

        },

      ),
    );
  }

}
