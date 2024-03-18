
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:netdoc/screens/incoming_appointment.dart';
import 'package:netdoc/screens/payment_mobile_money.dart';
import 'package:netdoc/utilities/constants/font_constants.dart';

import '../utilities/constants/color_constants.dart';






class PaymentsController extends StatefulWidget {
  static String id = 'payments_controller';
  @override
  _PaymentsControllerState createState() => _PaymentsControllerState();
}

class _PaymentsControllerState extends State<PaymentsController> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child:
      Scaffold(

          appBar: AppBar(
            automaticallyImplyLeading: true,
            toolbarHeight: 40,
            backgroundColor: kBackgroundGreyColor,
            //title: Center(child: Text("Stock Page", style: TextStyle(color: kBiegeThemeColor, fontSize: 13, fontWeight: FontWeight.bold),),),
            bottom: TabBar(
              indicator: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [kGreenThemeColor, kGreenThemeColor]),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.redAccent),

              //indicatorColor: kPinkDarkThemeColor,
              labelColor: kPureWhiteColor,
              unselectedLabelColor: kGreenDarkColorOld,
              tabs: [
                Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      // Icon(LineIcons.scissorsHandAlt, size: 20,),
                      // SizedBox(width: 4,),
                      Text('Mobile Money')]
                ),),
                // ),),
                Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      // Icon(LineIcons.gifts, size: 16,),
                      // SizedBox(width: 4,),
                      Text('Insurance')]
                ),),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              PaymentMobileMoney(),
              Container(color: kPureWhiteColor,
                child: Center(child: Text('No Insurance Transaction', style: kHeading2TextStyleBold,),),
              ),


              // VisaPage(),
            ],
          )
      ),
    );
  }
}
