



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdoc/utilities/constants/word_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utilities/constants/color_constants.dart';
import '../../Utilities/constants/font_constants.dart';
import '../../models/doctor_provider.dart';
import '../../utilities/constants/user_constants.dart';

class MedicalPrescription extends StatefulWidget {
  const MedicalPrescription({Key? key}) : super(key: key);

  @override
  State<MedicalPrescription> createState() => _MedicalPrescriptionState();
}



class _MedicalPrescriptionState extends State<MedicalPrescription> {

  String prescriptionName = '';
  String prescriptionForm = '';
  String prescriptionQty = '';
  String prescriptionDose = '';
  String prescriptionDuration = '';
  Future<dynamic> getTransaction() async {
    final prefs = await SharedPreferences.getInstance();
    String userUid = prefs.getString(kUserUid)!;

    final transactions = await FirebaseFirestore.instance
        .collection('prescriptions')
        .where('document', isEqualTo: Provider.of<DoctorProvider>(context, listen:false).patientsDocumentId)

        // .where('userUid', isEqualTo: userUid)
        // .orderBy('timestamp', descending: true)
        .get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {


        prescriptionName = doc['medName'];
        prescriptionDose = doc['medDose'];
        prescriptionQty = doc['medQty'];
        prescriptionForm = doc['medForm'];
        prescriptionDuration = doc['medDuration'];


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

      appBar: AppBar(title: Text('${Provider.of<DoctorProvider>(context, listen: false).doctorName} ${medicinePrescription.tr}', style: kNormalTextStyle.copyWith(color: kPureWhiteColor)),
        backgroundColor: kGreenThemeColor,
        leading: GestureDetector(
            onTap: (){Navigator.pop(context);},
            child: Icon(Icons.arrow_back, color: kPureWhiteColor,)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: prescriptionName ==''? Text(prescriptionNote.tr, style: kNormalTextStyle,): Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your prescription is as follows', style: kHeading2TextStyle,),
            kLargeHeightSpacing,
            Text('$prescriptionName for $prescriptionDuration', style: kNormalTextStyle,),
            Text('Dose: $prescriptionDose', style: kNormalTextStyle,),
            Text('Qty: $prescriptionQty', style: kNormalTextStyle,),
            Text('Form: $prescriptionForm', style: kNormalTextStyle,),
          ],
        ), 
      ),
    );
  }
}
