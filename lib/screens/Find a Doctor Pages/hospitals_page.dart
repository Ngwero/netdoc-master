import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:netdoc/screens/medical_records.dart';
import 'package:netdoc/utilities/constants/word_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utilities/constants/font_constants.dart';
import '../../../utilities/constants/color_constants.dart';
import '../../Utilities/constants/user_constants.dart';
import '../../models/doctor_provider.dart';
import '../forms_page_current.dart';

class HospitalsPage extends StatefulWidget {
  static String id = 'hospitals_page';

  @override
  _HospitalsPageState createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage> {
  // final dateNow = new DateTime.now();
  late int price = 0;
  late int quantity = 1;
  var formatter = NumberFormat('#,###,000');
  var userId = "";

  defaultInitialization() async {
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
  var staffIdList = [];
  var dateList = [];
  var paidStatusList = [];
  var paidStatusListColor = [];
  List<double> opacityList = [];

  double textSize = 12.0;
  String fontFamilyMont = 'Montserrat-Medium';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kGreenThemeColor,
          foregroundColor: kPureWhiteColor,
          automaticallyImplyLeading: true,
          title: Text(
            "Hospitals",
            style: kNormalTextStyle.copyWith(color: kPureWhiteColor),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('primeHospitals')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                conditionList = [];
                messageList = [];
                staffIdList = [];
                dateList = [];

                var orders = snapshot.data?.docs;
                for (var doc in orders!) {
                  conditionList.add(doc['name']);
                  staffIdList.add(doc['location']);
                }
                // return Text('Let us understand this ${deliveryTime[3]} ', style: TextStyle(color: Colors.white, fontSize: 25),);
                return ListView.builder(
                    itemCount: conditionList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FormsPage()));
                        },
                        child: Card(
                          margin:
                              const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          shadowColor: kGreenThemeColor,
                          elevation: 2.0,
                          color: kPureWhiteColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text('data')

                              ListTile(
                                leading: Container(
                                  // color: kGreenDarkColorOld,
                                  height: 170,
                                  width: 50,
                                  child: Icon(
                                    LineIcons.hospital,
                                    size: 30,
                                    color: kGreenDarkColorOld,
                                  ),
                                ),
                                title: Text(
                                  "${conditionList[index]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                subtitle: Row(
                                  children: [
                                    Icon(
                                      Icons.location_history,
                                      size: 20,
                                    ),
                                    kSmallWidthSpacing,
                                    Text(
                                      "${staffIdList[index]}",
                                      style: kNormalTextStyle.copyWith(
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }));
  }
}
