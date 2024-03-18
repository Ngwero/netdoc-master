



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:netdoc/utilities/constants/word_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utilities/constants/color_constants.dart';
import '../../Utilities/constants/font_constants.dart';
import '../../models/doctor_provider.dart';
import '../../utilities/constants/user_constants.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({Key? key}) : super(key: key);

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {


  String clinicalNotes = '';
  String clinic = '';
  String clinician = '';
  String reasonForReferal = '';
  String prescriptionDuration = '';
  Future<dynamic> getTransaction() async {
    final prefs = await SharedPreferences.getInstance();
    String userUid = prefs.getString(kUserUid)!;

    final transactions = await FirebaseFirestore.instance
        .collection('refferal')
        .where('document', isEqualTo: Provider.of<DoctorProvider>(context, listen:false).patientsDocumentId)

        .get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {

        reasonForReferal = doc['reasonsForRefferal'];
        clinic = doc['Clinic'];
        clinician = doc['clinician_name'];
        clinicalNotes = doc['Clinicalnotes'];



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

      appBar: AppBar(title: Text(referralReport.tr, style: kNormalTextStyle.copyWith(color: kPureWhiteColor)),
        backgroundColor: kGreenThemeColor,
        foregroundColor: kPureWhiteColor,

      ),

      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: clinic ==''? Text(referralNote.tr, style: kNormalTextStyle,):
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your have been referred by $clinician', style: kHeading2TextStyle,),
              kLargeHeightSpacing,
              Text('To $clinic medical Centre', style: kNormalTextStyle,),
              Text('And the reasons for the referral are "$reasonForReferal"', style: kNormalTextStyle,),
              Text('The clinical notes are as follows:\n$clinicalNotes', style: kNormalTextStyle,),

            ],
          ),
        ),
      ),
    );
  }
}
