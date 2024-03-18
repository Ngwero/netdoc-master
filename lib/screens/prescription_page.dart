import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:netdoc/screens/medical_records.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utilities/constants/font_constants.dart';
import '../../utilities/constants/color_constants.dart';
import '../Utilities/constants/user_constants.dart';
import '../models/doctor_provider.dart';
// import 'package:flutter_signature_pad/flutter_signature_pad.dart';








class PrescriptionPage extends StatefulWidget {
  static String id = 'prescription_page';
  final GlobalKey _signaturePadKey = GlobalKey();

  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  // final dateNow = new DateTime.now();
  late int price = 0;
  late int quantity = 1;
  var formatter = NumberFormat('#,###,000');
  var userId = "";

  defaultInitialization()async{
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(kUserUid)!;
    setState(() {
      print("KUUUUUUKUUUUKKAAAAA  $userId");
    });

  }

  bool isFirstLetterZero(String text) {
    if (text.isNotEmpty && text[0] == '0') {
      return true;
    } else {
      return false;
    }
  }


  Future<void> uploadSignature(documentId, value) async {

    final String collectionName = 'PrescriptionReports';

    try {
      await FirebaseFirestore.instance.collection(collectionName)
          .doc(documentId)
          .update({'phone': value},).whenComplete(() {

          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushNamed(context, PrescriptionPage.id);

          }
    );

      print('Signature value updated successfully');
    } catch (e) {
      // Handle any potential errors
      print('Error: $e');
    }
  }



  // void _showSignatureDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Signature'),
  //         content:
  //         Signature(
  //
  //
  //         )
  //         // SignaturePad(
  //         //   key: _signaturePadKey,
  //         //   width: 300,
  //         //   height: 300,
  //         //   backgroundColor: Colors.white,
  //         // ),
  //         ,
  //         actions: [
  //
  //         ],
  //       );
  //     },
  //   );
  // }


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
  var statusList = [];
  var paidStatusList = [];
  var paidStatusListColor = [];
  var doctorList = [];
  var phoneList = [];
  var signatureList = [];

  double textSize = 12.0;
  String fontFamilyMont = 'Montserrat-Medium';
  @override
  Widget build(BuildContext context) {double width = MediaQuery.of(context).size.width * 0.6;


  return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenThemeColor,
        foregroundColor: kPureWhiteColor,
        automaticallyImplyLeading: true,
        title: Text("Prescriptions", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
        centerTitle: true,
      ),

      body:
      StreamBuilder<QuerySnapshot> (
          stream: FirebaseFirestore.instance
          // .collection('followup')
              .collection('PrescriptionReports')
              .where('patient', isEqualTo:
          // "GwXy4zVGrROn2VfUaMG2MjdS0PB2"
           userId
          )
              .orderBy("date", descending: true)
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
              statusList = [];
              paidStatusList = [];
              doctorList = [];
              phoneList = [];

              var orders = snapshot.data?.docs;
              for( var doc in orders!){


                conditionList.add(doc['condition']);
                documentIdList.add(doc.id);
                messageList.add(doc['doctorName']);
                paidStatusList.add(doc['paymentMethod']);
                statusList.add(doc['statusOfTreatment']);
                doctorList.add(doc['doctorName']);
                phoneList.add(doc['phone']);
                signatureList.add(isFirstLetterZero(doc['phone']));


              }
              // return Text('Let us understand this ${deliveryTime[3]} ', style: TextStyle(color: Colors.white, fontSize: 25),);
              return ListView.builder(
                  itemCount: conditionList.length,
                  itemBuilder: (context, index){

                    return GestureDetector(
                      onTap: (){
                        Provider.of<DoctorProvider>(context, listen: false).setPatientsDocumentId(documentIdList[index], conditionList[index], "defaultDoctorList");
                        Provider.of<DoctorProvider>(context, listen: false).setPatientsBookingDate(statusList[index]);

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
                                    Text('${paidStatusList[index]}', style: kNormalTextStyle.copyWith(fontSize: 12),),
                                    Text('Treatment: ${statusList[index]}', style: kNormalTextStyle.copyWith(fontSize: 12),),

                                  ],
                                ),
                              ),
                              subtitle: Text("Dr. ${doctorList[index]}", style: const TextStyle( fontSize: 14, color: kBlack),),
                              // horizontalTitleGap: 0,Ugx


                              // minVerticalPadding: 0,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child:
                              Expanded(
                                child: ElevatedButton(
                                  
                                  style: signatureList[index]== false ? ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kGreenThemeColor)): ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kFaintGrey)),
                                  onPressed: () {
                                    if (signatureList[index] == false){
                                      showDialog(context: context, builder: (BuildContext context){
                                        return GestureDetector(

                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Column(
                                              children: [
                                                CupertinoAlertDialog(
                                                  title:  const Text("Enter your Signature"),
                                                  content: Column(
                                                    children: [
                                                      const Text("By confirming below, you acknowledge that, the order was successfully delivered, and received by you or in your presence. This helps in maintenance of records and making sure of the satisfaction of our patients. Please ensure that what you submit is of truthful value.",
                                                        style: kNormalTextStyle,textAlign: TextAlign.left,),
                                                      kSmallHeightSpacing,
                                                      Text("Provide your signature below.", style: kNormalTextStyle.copyWith(color: kBlack, fontWeight: FontWeight.bold, fontSize: 15),),
                                                      kSmallHeightSpacing,
                                                      Container(
                                                        color: kPureWhiteColor,
                                                        height: 100,
                                                        child:
                                                          Text("Press Confirm to Proceed")
                                                        // Signature(
                                                        //   strokeWidth: 3,
                                                        //
                                                        //   onSign: (){
                                                        //     // Navigator.pop(context);
                                                        //   },
                                                        // ),
                                                      ),
                                                    ],
                                                  ),

                                                  actions: [
                                                    CupertinoDialogAction(isDestructiveAction: true,
                                                      onPressed: (){
                                                        // _btnController.reset();
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Cancel'),

                                                    ),
                                                    CupertinoDialogAction(isDefaultAction: true,
                                                      onPressed: (){
                                                        // _btnController.reset();

                                                        uploadSignature(documentIdList[index], '0${phoneList[index]}');


                                                        // Navigator.pop(context);
                                                      },
                                                      child: const Text('Confirm'),

                                                    ),

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      );
                                    }



                                    // _showSignatureDialog;
                                  }, child: Text("Confirm Delivery", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),),
                              )
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



