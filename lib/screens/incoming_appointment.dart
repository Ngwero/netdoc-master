import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_icons/line_icons.dart';

import 'package:intl/intl.dart';
import 'package:netdoc/Utilities/constants/user_constants.dart';
import 'package:netdoc/utilities/constants/word_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../Utilities/constants/font_constants.dart';

import '../utilities/constants/color_constants.dart';






class TransactionsUpcomingPage extends StatefulWidget {
  static String id = 'orders_page';

  @override
  _TransactionsUpcomingPageState createState() => _TransactionsUpcomingPageState();
}

class _TransactionsUpcomingPageState extends State<TransactionsUpcomingPage> {
  // final dateNow = new DateTime.now();
  late int price = 0;
  late int quantity = 1;
  var uid = "";
  var formatter = NumberFormat('#,###,000');


  defaultInitialization()async{
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(kUserUid)!;
    setState(() {

    });



  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultInitialization();

  }

  var productList = [];
  var orderStatusList = [];
  var clientList = [];
  var priceList = [];
  var descList = [];
  var transIdList = [];
  var dateList = [];
  var paidStatusList = [];
  var paidStatusListColor = [];
  List<double> opacityList = [];

  double textSize = 12.0;
  String fontFamilyMont = 'Montserrat-Medium';
  @override
  Widget build(BuildContext context) {double width = MediaQuery.of(context).size.width * 0.6;
  // var blendedData = Provider.of<BlenditData>(context);

  return Scaffold(

      body:
      StreamBuilder<QuerySnapshot> (
          stream: FirebaseFirestore.instance
              .collection('conditions')
              .where('userUid', isEqualTo: uid)
              .snapshots(),
          builder: (context, snapshot)
          {
            if(!snapshot.hasData){
              return Container();
            }else{

              priceList = [];
              descList = [];
              transIdList = [];
              dateList = [];

              var orders = snapshot.data?.docs;
              for( var doc in orders!){
                if (doc.id.startsWith('ios')) {
                  descList.add(doc['condition']);
                  dateList.add(doc['timestamp'].toDate());
                }






                  // // priceList.add(doc['totalFee']);





              }
              // return Text('Let us understand this ${deliveryTime[3]} ', style: TextStyle(color: Colors.white, fontSize: 25),);
              return ListView.builder(
                  itemCount: descList.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: ()  async{
                        // final prefs = await SharedPreferences.getInstance();
                        //
                        //
                        // videoVariables.setCallAppId(prefs.getString(kVideoAppId));
                        // videoVariables.setCallChannelName( prefs.getString(kVideoChannelName));
                        // videoVariables.setCallTempToken(prefs.getString(kVideoToken));
                        //
                        // Navigator.pushNamed(context, VideoViewer.id);
                      },
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                        shadowColor: kGreenThemeColor,
                        elevation: 2.0,
                        child: Column(
                          children: [
                            // Text('data')

                            ListTile(
                              leading: const Icon(LineIcons.stethoscope, color: kGreenDarkColorOld,size: 25,),
                              title:Text("${descList[index]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 10, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [

                                    Text('${DateFormat('EE, dd, MMM').format(dateList[index])}', style: kNormalTextStyle.copyWith(fontSize: 12),),
                                  ],
                                ),
                              ),
                              // horizontalTitleGap: 0,Ugx


                              // minVerticalPadding: 0,
                            ),
                            Stack(
                                children: [ListTile(
                                  onTap: (){
                                  },

                                  title:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text(virtualAppointment.tr, style: kNormalTextStyle.copyWith(fontSize: 13)),
                                      // Text("Payment: ${paidStatusList[index]}", style: TextStyle( color: paidStatusListColor[index], fontSize: 12),),
                                      //
                                    ],
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("id: ", style: TextStyle( color: Colors.grey[500], fontSize: 12),),

                                    ],
                                  ),
                                ),

                                ]),

                            // _buildDivider(),
                          ],
                        ),
                      ),
                    );}
              );
            }

          }

      )
  );
  }
}



