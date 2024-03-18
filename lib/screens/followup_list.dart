import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:netdoc/screens/medical_records.dart';
import 'package:netdoc/utilities/constants/word_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utilities/constants/font_constants.dart';
import '../../utilities/constants/color_constants.dart';
import '../Utilities/constants/user_constants.dart';
import '../models/doctor_provider.dart';

class FollowupPage extends StatefulWidget {
  static String id = 'followup_list';

  @override
  _FollowupPageState createState() => _FollowupPageState();
}

class _FollowupPageState extends State<FollowupPage> {
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
  var clientList = [];
  var conditionList = [];
  var messageList = [];
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
        automaticallyImplyLeading: true,
        title: Text("Follow Up", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
        centerTitle: true,
      ),

      body:
      StreamBuilder<QuerySnapshot> (
          stream: FirebaseFirestore.instance
              // .collection('followup')
              .collection('conditions')
              .where('hasDoctor', isEqualTo: true)
              .where('userUid', isEqualTo: userId)
          .orderBy("timestamp", descending: true)
          //.where('beautician_id', isEqualTo: 'salonOrd97047db0')
              .snapshots(),
          builder: (context, snapshot)
          {
            if(!snapshot.hasData){
              return Container();
            }else{

              conditionList = [];
              messageList = [];
              documentIdList = [];
              dateList = [];

              var orders = snapshot.data?.docs;
              for( var doc in orders!){


                // conditionList.add(doc['name']);
                // dateList.add(doc['date'].toDate());
                conditionList.add(doc['condition']);
                documentIdList.add(doc['documentId']);
                // documentIdList.add(doc['documentId']);


                dateList.add(doc['newDatew'].toDate());



              }
              // return Text('Let us understand this ${deliveryTime[3]} ', style: TextStyle(color: Colors.white, fontSize: 25),);
              return ListView.builder(
                  itemCount: conditionList.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        Provider.of<DoctorProvider>(context, listen: false).setPatientsDocumentId(documentIdList[index], conditionList[index], "defaultDoctorList");
                        Provider.of<DoctorProvider>(context, listen: false).setPatientsBookingDate(dateList[index]);

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=> MedicalRecords())
                        );
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
                              // leading: const Icon(Icons.person, color: kGreenDarkColorOld,size: 35,),
                              title:Text("${conditionList[index]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 10, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Text('${conditionList[index]}', style: kNormalTextStyle.copyWith(fontSize: 12),),
                                    Text('${DateFormat('EE, dd, MMM').format(dateList[index])}', style: kNormalTextStyle.copyWith(fontSize: 12),),

                                  ],
                                ),
                              ),
                              // horizontalTitleGap: 0,Ugx


                              // minVerticalPadding: 0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(virtualAppointment.tr, style: kNormalTextStyle.copyWith(fontSize: 14),),
                            ),


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



