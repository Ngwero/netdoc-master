import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:netdoc/utilities/constants/word_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../utilities/constants/color_constants.dart';
import 'chat.dart';






class NotificationPage extends StatefulWidget {
  static String id = 'notification_page';

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // final dateNow = new DateTime.now();
  late int price = 0;
  late int quantity = 1;
  var formatter = NumberFormat('#,###,000');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  var productList = [];
  var orderStatusList = [];
  var clientList = [];
  var conditionList = [];
  var messageList = [];
  var transIdList = [];
  var dateList = [];
  var paidStatusList = [];
  var paidStatusListColor = [];
  List<double> opacityList = [];

  double textSize = 12.0;
  String fontFamilyMont = 'Montserrat-Medium';
  @override
  Widget build(BuildContext context) {double width = MediaQuery.of(context).size.width * 0.6;


  return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenThemeColor,
        foregroundColor: kPureWhiteColor,
        automaticallyImplyLeading: false,
        title: Text(notificationTab.tr, style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
        centerTitle: true,
      ),

      body:
      StreamBuilder<QuerySnapshot> (
          stream: FirebaseFirestore.instance
              .collection('notification')
          //.where('beautician_id', isEqualTo: 'salonOrd97047db0')
              .snapshots(),
          builder: (context, snapshot)
          {
            if(!snapshot.hasData){
              return Container();
            }else{

              conditionList = [];
              messageList = [];
              transIdList = [];
              dateList = [];

              var orders = snapshot.data?.docs;
              for( var doc in orders!){




                // // priceList.add(doc['totalFee']);

                messageList.add(doc['message']);
                // conditionList.add(doc['condition']);
                //
                //
                // dateList.add(doc['appointmentDate'].toDate());



              }
              // return Text('Let us understand this ${deliveryTime[3]} ', style: TextStyle(color: Colors.white, fontSize: 25),);
              return ListView.builder(
                  itemCount: messageList.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: ()  async{

                        // Navigator.pushNamed(context,     ChatMessaging.id);

                      },
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),

                        shadowColor: kBlack,
                        elevation: 1.0,
                        child: Column(
                          children: [
                            // Text('data')

                            ListTile(
                              leading: const Icon(Icons.notifications_active_outlined, color: kGreenDarkColorOld,size: 15,),
                              title:Text(notificationTab.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              // trailing: Padding(
                              //   padding: const EdgeInsets.only(right: 10, top: 20),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.end,
                              //     children: [
                              //       Text('${conditionList[index]}', style: kNormalTextStyle.copyWith(fontSize: 12),),
                              //       Text('${DateFormat('EE, dd, MMM').format(dateList[index])}', style: kNormalTextStyle.copyWith(fontSize: 12),),
                              //
                              //     ],
                              //   ),
                              // ),
                              // horizontalTitleGap: 0,Ugx


                              // minVerticalPadding: 0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(messageList[index], style: kNormalTextStyle.copyWith(color: kBlack),),
                            )
                            // Stack(
                            //     children: [ListTile(
                            //       onTap: (){
                            //       },
                            //
                            //       title:Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //
                            //           Text('${conditionList[index]}', style: kNormalTextStyle.copyWith(fontSize: 12),),
                            //           Text('${DateFormat('EE, dd, MMM').format(dateList[index])}', style: kNormalTextStyle.copyWith(fontSize: 14),),
                            //           // Text("Payment: ${paidStatusList[index]}", style: TextStyle( color: paidStatusListColor[index], fontSize: 12),),
                            //           //
                            //         ],
                            //       ),
                            //       // trailing: Column(
                            //       //   crossAxisAlignment: CrossAxisAlignment.end,
                            //       //   children: [
                            //       //     Text("id: ", style: TextStyle( color: Colors.grey[500], fontSize: 12),),
                            //       //
                            //       //   ],
                            //       // ),
                            //     ),
                            //
                            //     ]),

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



