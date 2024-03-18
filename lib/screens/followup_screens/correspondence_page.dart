


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdoc/Utilities/constants/color_constants.dart';
import 'package:netdoc/Utilities/constants/font_constants.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities/constants/user_constants.dart';
import '../../utilities/constants/word_constants.dart';

class CorrespondencePage extends StatefulWidget {


  @override
  State<CorrespondencePage> createState() => _CorrespondencePageState();
}

class _CorrespondencePageState extends State<CorrespondencePage> {



  String correspondence = '';
  Future<dynamic> getTransaction() async {
    final prefs = await SharedPreferences.getInstance();
    String userUid = prefs.getString(kUserUid)!;

    final transactions = await FirebaseFirestore.instance
        .collection('correspondence')
        .where('document', isEqualTo: Provider.of<DoctorProvider>(context, listen:false).patientsDocumentId)

        .get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {


        correspondence = doc['details'];



      });
      setState(() {

      });
    });
    return transactions;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTransaction();

  }



  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(
        foregroundColor: kPureWhiteColor,
        backgroundColor: kGreenThemeColor,
        title: Text('${Provider.of<DoctorProvider>(context, listen: false).doctorName} Correspondence'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: correspondence == ''?Text(correspondenceNote.tr, style: kNormalTextStyle,):Text('Based on the results you uploaded, the doctors results are as follows:\n$correspondence', style: kNormalTextStyle),
      ),
    );
  }
}
