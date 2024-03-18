



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:netdoc/utilities/constants/word_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utilities/constants/color_constants.dart';
import '../../Utilities/constants/font_constants.dart';
import '../../models/doctor_provider.dart';
import '../../utilities/constants/user_constants.dart';

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({Key? key}) : super(key: key);

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  String diagnosis = '';
  Future<dynamic> getTransaction() async {
    final prefs = await SharedPreferences.getInstance();
    String userUid = prefs.getString(kUserUid)!;

    final transactions = await FirebaseFirestore.instance
        .collection('Diagnosis')
        .where('document', isEqualTo: Provider.of<DoctorProvider>(context, listen:false).patientsDocumentId)
        // .where('document', isEqualTo: "zfw2dTJc0OqKD2UTmWmo")
        // .where('userUid', isEqualTo: userUid)
        // .orderBy('timestamp', descending: true)
        .get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {


        diagnosis = doc['lastDiagnosis'];


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
    return Scaffold(

      appBar: AppBar(title: Text('${Provider.of<DoctorProvider>(context, listen: false).doctorName} Diagnosis', style: kNormalTextStyle.copyWith(color: kPureWhiteColor)),
        backgroundColor: kGreenThemeColor,
        leading: GestureDetector(
            onTap: (){Navigator.pop(context);},
            child: Icon(Icons.arrow_back, color: kPureWhiteColor,)),
      ),

      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: diagnosis == ''? Text(diagnosisNote.tr, style: kNormalTextStyle,):Text('You have been diagnosed with: \n$diagnosis', style: kNormalTextStyle,),
        ),
      ),
    );
  }
}
