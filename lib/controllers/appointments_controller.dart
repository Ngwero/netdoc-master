
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:netdoc/screens/incoming_appointment.dart';
import 'package:netdoc/utilities/constants/font_constants.dart';

import '../utilities/constants/color_constants.dart';






class AppointmentsController extends StatefulWidget {
  static String id = 'appointment_controller';
  @override
  _AppointmentsControllerState createState() => _AppointmentsControllerState();
}

class _AppointmentsControllerState extends State<AppointmentsController> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:
      Scaffold(

          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 40,
            backgroundColor: kBackgroundGreyColor,
            //title: Center(child: Text("Stock Page", style: TextStyle(color: kBiegeThemeColor, fontSize: 13, fontWeight: FontWeight.bold),),),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(

                  gradient: const LinearGradient(
                      colors: [kGreenThemeColor, kGreenThemeColor]),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.redAccent),

              //indicatorColor: kPinkDarkThemeColor,
              labelColor: kPureWhiteColor,
              unselectedLabelColor: kGreenDarkColorOld,
              tabs: [
                Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Text('Upcoming')]
                ),),
                // ),),
                Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Text('Completed')]
                ),),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TransactionsUpcomingPage(),
              Container(color: kPureWhiteColor,
              child: Center(child: Text('No Completed Appointments', style: kHeading2TextStyleBold,),),
              ),


              // VisaPage(),
            ],
          )
      ),
    );
  }
}
