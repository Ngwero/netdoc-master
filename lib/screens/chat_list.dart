import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:netdoc/Utilities/constants/user_constants.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/utilities/constants/word_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utilities/constants/font_constants.dart';
import '../utilities/constants/color_constants.dart';
import 'chat.dart';






class ChatListPage extends StatefulWidget {
  static String id = 'chat_list';

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  // final dateNow = new DateTime.now();
  late int price = 0;
  late int quantity = 1;
  var formatter = NumberFormat('#,###,000');
  var userId = "";

  defaultInitialization()async{
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(kUserUid)!;
    setState(() {
      print(userId);
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
  var doctorIdList = [];
  var conditionList = [];
  var doctorNameList = [];
  var documentIdList = [];
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
      title: Text(doctorList.tr, style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
      centerTitle: true,
    ),

      body:
      StreamBuilder<QuerySnapshot> (
          stream: FirebaseFirestore.instance
              .collection('conditions')
              .where('hasDoctor', isEqualTo: true)
              .where('userUid', isEqualTo: userId)
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot)
          {
            if(!snapshot.hasData){
              return Container();
            }else{

              conditionList = [];
              doctorNameList = [];
              documentIdList = [];
              dateList = [];
              doctorIdList = [];

              var orders = snapshot.data?.docs;
              for( var doc in orders!){


                doctorNameList.add(doc['doctor']);
                conditionList.add(doc['condition']);
                doctorIdList.add(doc['doctorId']);
                documentIdList.add(doc['documentId']);
                dateList.add(doc['newDatew'].toDate());



              }
              // return Text('Let us understand this ${deliveryTime[3]} ', style: TextStyle(color: Colors.white, fontSize: 25),);
              return
                doctorNameList.length == 0? Center(child: Text("No Chats"),):ListView.builder(
                  itemCount: doctorNameList.length,
                  itemBuilder: (context, index){
                    return

                      GestureDetector(
                      onTap: ()  async{

                        Provider.of<DoctorProvider>(context, listen: false).setPatientsDocumentId(documentIdList[index], doctorNameList[index], doctorIdList[index]);
                         Navigator.pushNamed(context,ChatMessaging.id);

                      },
                      child:
                      Card(
                        margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                        shadowColor: kGreenThemeColor,
                        elevation: 2.0,
                        child: Column(
                          children: [
                            // Text('data')

                            ListTile(
                              leading: const Icon(Icons.person, color: kGreenDarkColorOld,size: 35,),
                              title:Text("${doctorNameList[index]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
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
                            Stack(
                                children: [
                                  ListTile(
                                  // onTap: (){
                                  // },

                                  title:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text('${conditionList[index]}', style: kNormalTextStyle.copyWith(fontSize: 12),),
                                      Text('${DateFormat('EE, dd, MMM').format(dateList[index])}', style: kNormalTextStyle.copyWith(fontSize: 14),),
                                      // Text("Payment: ${paidStatusList[index]}", style: TextStyle( color: paidStatusListColor[index], fontSize: 12),),
                                      //
                                    ],
                                  ),
                                  // trailing: Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.end,
                                  //   children: [
                                  //     Text("id: ", style: TextStyle( color: Colors.grey[500], fontSize: 12),),
                                  //
                                  //   ],
                                  // ),
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



