import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utilities/constants/font_constants.dart';
import '../models/common_functions.dart';
import '../utilities/constants/color_constants.dart';






class PaymentMobileMoney extends StatefulWidget {
  static String id = 'payment_mobile_money';

  @override
  _PaymentMobileMoneyState createState() => _PaymentMobileMoneyState();
}

class _PaymentMobileMoneyState extends State<PaymentMobileMoney> {
  // final dateNow = new DateTime.now();
  late int price = 0;
  late int quantity = 1;
  String uid = "";
  var formatter = NumberFormat('#,###,000');


  void defaultInitialization(){
    final User? user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;
    print(uid);

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
              .collection('payments')
          .where('paidBy', isEqualTo: uid)
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
                print(doc['condition']);


                priceList.add(doc['amount']);

               descList.add(doc['condition']);
               transIdList.add(doc['payerPhone']);
               dateList.add(doc['timestamp'].toDate());



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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text('data')

                            ListTile(
                              leading: Text("${descList[index]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                              title:Text("", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
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
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(priceList[index].toString(), style: kNormalTextStyle),
                            ),
                            Stack(
                                children: [ListTile(
                                  onTap: (){
                                  },

                                  title:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text(transIdList[index], style: kNormalTextStyle.copyWith(fontSize: 14, color: Colors.red)),
                                      // Text("Payment: ${paidStatusList[index]}", style: TextStyle( color: paidStatusListColor[index], fontSize: 12),),
                                      //
                                    ],
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(" ", style: TextStyle( color: Colors.grey[500], fontSize: 12),),

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



