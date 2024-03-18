

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/utilities/constants/user_constants.dart';
import 'package:netdoc/utilities/constants/word_constants.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';
import 'dart:io';

import '../../Utilities/constants/color_constants.dart';
import '../../Utilities/constants/font_constants.dart';
import '../../utilities/paymentButtons.dart';





var uuid = Uuid();

class LaboratoryPage extends StatefulWidget {
  static String id = 'questions';

  @override
  State<LaboratoryPage> createState() => _LaboratoryPageState();
}

class _LaboratoryPageState extends State<LaboratoryPage> {
  var name = '';
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  String? dropValue;
  String errorMessage = '';
  var arrayState = [[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],];

  var errorMessageOpacity = 0.0;
  String description = '';
  CollectionReference storeItem = FirebaseFirestore.instance.collection('stores');
  CollectionReference trends = FirebaseFirestore.instance.collection('trends');
  CollectionReference serviceProvided = FirebaseFirestore.instance.collection('services');

  final storage = FirebaseStorage.instance;
  var imageUploaded = false;

  String serviceId = 'trend${uuid.v1().split("-")[0]}';
  UploadTask? uploadTask;
  final formKey = GlobalKey<FormState>();
  PlatformFile? pickedFile;



  Future selectFiles()async{
    final result = await FilePicker.platform.pickFiles(
      // type: FileType.custom,
      // allowedExtensions: ['pdf', 'doc'],
    );
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
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

  String tests = '';
  String samples = '';


  Future<dynamic> getTransaction() async {
    final prefs = await SharedPreferences.getInstance();
    String userUid = prefs.getString(kUserUid)!;

    final transactions = await FirebaseFirestore.instance
        .collection('lab_requests')
        .where('document', isEqualTo: Provider.of<DoctorProvider>(context, listen:false).patientsDocumentId)

        .get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {


        tests = doc['testRequested'];
        samples = doc['samplesTaken'];

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

    var doctorDataDisplay = Provider.of<DoctorProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: kBackgroundGreyColor,
      appBar: AppBar(title: Text('${Provider.of<DoctorProvider>(context, listen: false).doctorName} ${laboratoryReport.tr}', style: kNormalTextStyle.copyWith(color: kPureWhiteColor)),
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
                Text('Please do the following tests', style: kNormalTextStyle,),
                Padding(

                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(tests, style: kNormalTextStyle.copyWith(color: kFaintGrey),),
                  ),
                ) ,
                Text('The following samples should be taken', style: kNormalTextStyle,),
                Padding(

                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(samples, style: kNormalTextStyle.copyWith(color: kFaintGrey),),
                  ),
                ) ,
                Text('Please upload the results if they are available', style: kNormalTextStyle,),


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
                kLargeHeightSpacing,
                Text('If yours is in the form of a PDF, please upload here', style:  kNormalTextStyle,),
                kSmallHeightSpacing,
                pickedFile != null ? Container(height:150, child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, color: kGreenThemeColor,),
                    Text("${pickedFile!.name}"),
                  ],
                ))) :Center(
                  child: MaterialButton(
                      color: kBlack,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LineIcons.pdfFile, color: kPureWhiteColor,),
                          Text('Add pdf', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                        ],
                      ),
                      onPressed: (){
                        selectFiles();

                      }),
                ),

                SizedBox(height: 30,),



                RoundedLoadingButton(
                  width: double.maxFinite,
                  color: kGreenThemeColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Upload Results', style: TextStyle(color: kPureWhiteColor)),
                  ),
                  controller: _btnController,
                  onPressed: () async {

                    if ( image != null){
                      print("Great");

                      _btnController.reset();

                      Navigator.pop(context);
                      Get.snackbar('Success', "Your data has been uploaded");

                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context)=> NewWeightPage())
                      // );


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
                // This is for Pdf

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

  DropdownMenuItem <String> buildMenuItem (String item) => DropdownMenuItem(value: item, child: Text(item));

  Container questionBlocks(String headingText, index) {

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
            Expanded(
                child:

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value){

                      if (value == ""){
                        return 'This field needs to be answered';
                      } else {
                        return null;
                      }
                    },

                    onChanged: (value){
                      name = value;
                    },
                    keyboardType: TextInputType.text,

                    onEditingComplete: (){
                      Provider.of<DoctorProvider>(context, listen: false).setFilledInList(index, name);
                    },
                    decoration: InputDecoration(

                      hintText: "",
                      hintStyle: TextStyle(fontSize: 14, color: kBlack),
                      labelText: " Answer here",
                      labelStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kBlack, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: kGreenThemeColor),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      );
  }

}
