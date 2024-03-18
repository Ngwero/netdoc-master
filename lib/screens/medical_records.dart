import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/screens/condition_diagnosis_page.dart';
import 'package:netdoc/screens/followup_screens/diagnosis_page.dart';
import 'package:netdoc/screens/followup_screens/imaging_report.dart';
import 'package:netdoc/screens/followup_screens/laboratory_report.dart';
import 'package:netdoc/screens/followup_screens/notes_page.dart';
import 'package:netdoc/screens/followup_screens/referral_page.dart';
import 'package:netdoc/utilities/constants/word_constants.dart';
import 'package:provider/provider.dart';



import '../Utilities/constants/color_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../utilities/constants/icon_constants.dart';
import 'followup_screens/correspondence_page.dart';
import 'followup_screens/medical_presciption.dart';


class MedicalRecords extends StatelessWidget {

  // ReviewsPage({required this.storeId});
  // final double storeId;

  static String id = 'medical_records';


  var checkboxList = [Colors.red, Colors.green, Colors.teal, Colors.blue, Colors.yellow, Colors.pink, Colors.black];
  var titleList = [ bookFollowup.tr,laboratoryReport.tr, imagingReport.tr, medicinePrescription.tr, diagnosis.tr, correspondence.tr, referralReport.tr,];
  var pagesList = [NotesPage(), LaboratoryPage(), ImagingReport(), MedicalPrescription(), DiagnosisPage(), CorrespondencePage(), ReferralPage()];
  var iconList = [ LineIcons.medicalNotes, Iconsax.microscope, LineIcons.xRay, LineIcons.tablets, LineIcons.thermometer, LineIcons.doctor, LineIcons.upload,];

  //  List <String> premisesUrlImages = ["https://mcusercontent.com/f78a91485e657cda2c219f659/images/0676bf80-7b87-d87e-5dc9-8aee87f24c65.jpeg", "https://mcusercontent.com/f78a91485e657cda2c219f659/images/ea86d963-d59c-ddd4-5f41-f7cd8b7c9d6f.jpeg"];


  @override
  Widget build(BuildContext context) {
    // var styleData = Provider.of<StyleProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: kBackgroundGreyColor,
      appBar: AppBar(
        foregroundColor: kPureWhiteColor,
        backgroundColor: kGreenDarkColorOld,
        title: Text("${Provider.of<DoctorProvider>(context, listen: false).doctorName} Follow Up", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              kLargeHeightSpacing,
              ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: titleList.length,
                      itemBuilder: (context, index){
                        //Provider.of<StyleProvider>(context, listen: false).setRatingsNumber(reviewComment.length);
                        return
                          Card(
                              margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                              shadowColor: kGreenThemeColor,
                              elevation: 2.0,
                              child: GestureDetector(
                                onTap: (){

                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context)=> pagesList[index])
                                  );
                                },
                                child: ListTile(
                                  title: Text(titleList[index],style: kNormalTextStyle.copyWith(fontSize: 15, color: kBlack)),
                                  subtitle: Text(titleList[index],style: kNormalTextStyle.copyWith(fontSize: 10)),
                                  trailing: Icon(Icons.circle, size: 15,),

                                  leading: Icon(iconList[index], size: 30, color: checkboxList[index],),     ),
                              )
                          );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

