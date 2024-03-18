
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../../Utilities/InputFieldWidget.dart';
import '../../Utilities/constants/color_constants.dart';
import '../../Utilities/constants/font_constants.dart';
import '../../models/common_functions.dart';
import '../../utilities/paymentButtons.dart';





var uuid = Uuid();

class NotesPage extends StatefulWidget {
  static String id = 'questions';

  @override
  State<NotesPage> createState() => _NotesPageState();
}



class _NotesPageState extends State<NotesPage> {
  var name = '';
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  String? dropValue;
  String errorMessage = '';
  List answers = ["","","", "",""];
  var arrayState = [[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],];

  var errorMessageOpacity = 0.0;
  String description = '';
  CollectionReference storeItem = FirebaseFirestore.instance.collection('stores');
  CollectionReference trends = FirebaseFirestore.instance.collection('trends');
  CollectionReference serviceProvided = FirebaseFirestore.instance.collection('services');

  final storage = FirebaseStorage.instance;
  var imageUploaded = false;
  CollectionReference notesCollection = FirebaseFirestore.instance.collection('patient_notes');

  String serviceId = 'iosNotes${uuid.v1().split("-")[0]}';
  UploadTask? uploadTask;
  final formKey = GlobalKey<FormState>();
  String warning = "Consultations requested 14 days after your last session will be subjected to changes, However, we highly value your"
      "loyalty and would like to extend a special discounted rate for consultations scheduled within 14 days. Thank you for your continued support and "
      "trust of our services";

  // Check whether the date of the appointment is greater than 14 days

  bool isMoreThan14DaysPassed(DateTime inputDate) {
    final currentDate = DateTime.now();
    final difference = currentDate.difference(inputDate).inDays;
    return difference > 14;
  }

  Future<void> uploadData() async {
    // Call the user's CollectionReference to add a new user

    return notesCollection.doc(serviceId)
        .set({
      'date': DateTime.now(),
      'patientFeeling': answers[0],
      'patientConsultationChanges': answers[1],
      'patientSideEffects': answers[2],
      'patientConcerns': answers[3],
      'patientDoctorConcerns': answers[4],
      'photo': "",
      'document': Provider.of<DoctorProvider>(context, listen:false).patientsDocumentId,
      'notesId': serviceId

    })
        .then((value) => CommonFunctions().showNotification('$name you Note has been Uploaded',"Note details for ${Provider.of<DoctorProvider>(context, listen: false).doctorName} uploaded") )
        .catchError((error) => print("Failed to send Communication: $error"));
  }



  Future<void> uploadFile(String filePath, String fileName)async {
    File file = File(filePath);
    try {
      uploadTask  = storage.ref('test/$fileName').putFile(file);
      final snapshot = await uploadTask!.whenComplete((){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trend Uploaded')));

      });
      final urlDownload = await snapshot.ref.getDownloadURL();

      // addTrend(serviceId, urlDownload);

      // Navigator.pushNamed(context, ControlPage.id);
    }  catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Uploading: $e')));
    }
  }

  File? image;


  Future pickImage(ImageSource source)async{
    try {
      final image = await ImagePicker().pickImage(source: source);
      // await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null){
        return ;
      }else {
        var file = File(image.path);

        final sizeImageBeforeCompression = file.lengthSync() / 1024;
        print("BEFORE COMPRESSION: ${sizeImageBeforeCompression}kb");

        setState(() {
          imageUploaded = true;
          this.image = file;
        });
      }
    } on PlatformException catch (e) {
      print('Failed to pick image $e');

    }
  }


  @override
  Widget build(BuildContext context) {

    var doctorDataDisplay = Provider.of<DoctorProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: kBackgroundGreyColor,
      appBar: AppBar(title: Text('${Provider.of<DoctorProvider>(context, listen: false).doctorName} Followup Notes', style: kNormalTextStyle.copyWith(color: kPureWhiteColor)),
        backgroundColor: kGreenDarkColorOld,
        leading: GestureDetector(
            onTap: (){Navigator.pop(context);},
            child: Icon(Icons.arrow_back, color: kPureWhiteColor,)),
      ),
      body: Form(
        key: formKey,

        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child:

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                    color: kAirPink,
                    margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                    shadowColor: kGreenThemeColor,
                    elevation: 2.0,
                    child:
                    true != false?
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('${warning}', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                    ): Container(), ),

                questionBlock2('Please tell the doctor how you are feeling today?', 0),
                questionBlock2('Since the previous video consultation do you notice any changes to your condition? Please explain', 1),
                questionBlock2('Have you noticed any side effects to your ongoing treatment(if any)?',2),
                questionBlock2('Do you have any specific concerns that you want the doctor to address?',3),
                questionBlock2('Are you happy to meet with the same doctor that you consulted initially or want change?', 4),

                Text('If there is any photo you want to attach, please upload from below', style: kNormalTextStyle,),

                Text('Your Photo', style: kNormalTextStyle,),
                // This is the questions Block

                kLargeHeightSpacing,
                SizedBox(
                  child: Column(
                    children: [
                      Text(doctorDataDisplay.photoStatement, style: kNormalTextStyle,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),

                        child:

                        image != null ? Image.file(image!, height: 180,) :
                        Container(
                          width: double.infinity,
                          height: 180,
                          child: Icon(Icons.photo_camera_front_outlined, color: kPureWhiteColor,size: 30,),
                          // Lottie.asset('images/scan.json'),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: kBlack),


                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                        child:
                        paymentButtons(
                          continueFunction: () {
                            pickImage(ImageSource.gallery);


                          }, continueBuyingText: "Gallery",  checkOutText: 'Camera', buyFunction: (){
                          pickImage(ImageSource.camera);
                        }, lineIconFirstButton: Icons.photo,lineIconSecondButton:  LineIcons.camera,),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30,),

                RoundedLoadingButton(
                  width: double.maxFinite,
                  color: kGreenThemeColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Confirm and Proceed', style: TextStyle(color: kPureWhiteColor)),
                  ),
                  controller: _btnController,
                  onPressed: () async {

                    if ( answers != null){


                      if (isMoreThan14DaysPassed( Provider.of<DoctorProvider>(context, listen: false).patientOrderDate)){
                        CommonFunctions().dateOfAppointment(context);

                      } else {
                        _btnController.reset();
                        Navigator.pop(context);
                        uploadData();
                      }




                    }else {
                      _btnController.error();
                      showDialog(context: context, builder: (BuildContext context){
                        return
                          CupertinoAlertDialog(
                            title: Text('Upload a photo'),
                            content: Text('Looks like you have not uploaded a photo'),
                            actions: [CupertinoDialogAction(isDestructiveAction: true,
                                onPressed: (){
                                  _btnController.reset();
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'))],
                          );
                      });

                      // uploadFile(image!.path, serviceId );


                      //Implement registration functionality.
                    }
                  },
                ),
                Opacity(
                    opacity: errorMessageOpacity,
                    child: Text(errorMessage, style: TextStyle(color: Colors.red),)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container questionBlock2(String headingText, index) {

    return
      Container(
        height: 130,
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Text(headingText, style: kNormalTextStyle.copyWith(color: kBlack),),
            ),
            InputFieldWidget(labelText: '',
              labelTextColor: kBlack,
              hintText: '',
              hintTextColor: kFaintGrey,
              keyboardType: TextInputType.text,
              onTypingFunction: (value) {
                name = value;
              }, onFinishedTypingFunction: () {
             answers[index] = name;
                // Provider.of<DoctorProvider>(context, listen: false).setFilledInList(index, name);

              },),

          ],
        ),
      );
  }


}
