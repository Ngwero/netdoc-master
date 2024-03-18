
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/screens/add_service.dart';
import 'package:netdoc/screens/new_weight_page.dart';
import 'package:netdoc/screens/payment_page.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import '../Utilities/InputFieldWidget.dart';
import '../Utilities/constants/color_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../utilities/paymentButtons.dart';



var uuid = Uuid();

class ConditionAddPage extends StatefulWidget {
  static String id = 'questions';

  @override
  State<ConditionAddPage> createState() => _ConditionAddPageState();
}

class _ConditionAddPageState extends State<ConditionAddPage> {
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


  void dateOfAppointment(){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Choose Appointment Date')));
    // DatePicker.showDatePicker(context,
    //     currentTime: DateTime.now(),
    //
    //     //
    //     // theme: DatePickerTheme(headerColor: kBabyPinkThemeColor, itemHeight: 50, itemStyle: kHeadingTextStyle.copyWith(color: kPureWhiteColor), backgroundColor: kGreenDarkColorOld),
    //
    //     //showTitleActions: t,
    //
    //     onConfirm: (time) {
    //       _btnController.reset();
    //
    //       var appointmentDate = DateFormat('dd-MMM-yyyy ')
    //           .format(time);
    //       Provider.of<DoctorProvider>(context, listen: false).setAppointmentDate(time);
    //
    //
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context)=> PaymentPage())
    //       );
    //     });


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
      appBar: AppBar(title: Text('${Provider.of<DoctorProvider>(context, listen: false).conditionName}', style: kNormalTextStyle.copyWith(color: kPureWhiteColor)),
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
            child: Center(child:
            // Container()

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child:Card(
                        color: kAirPink,
                        margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                        shadowColor: kGreenThemeColor,
                        elevation: 2.0,
                        child:
                        doctorDataDisplay.conditionHeading !=''?
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('${doctorDataDisplay.conditionHeading}', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
                        ): Container()
                    ),),
                ) ,
                // This is the questions Block
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: doctorDataDisplay.conditionQuestions.length,
                    itemBuilder: (context, index) {
                      //Provider.of<StyleProvider>(context, listen: false).setRatingsNumber(reviewComment.length);
                      return
                         questionBlocks('${doctorDataDisplay.conditionQuestions[index]}', index);
                        // Container(
                        //   height: 120,
                        //   child: Column(
                        //
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Padding(
                        //         padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        //         child: Text("headingText", style: kNormalTextStyle.copyWith(color: kBlack),),
                        //       ),
                        //       // InputFieldWidget(labelText: '',
                        //       //   labelTextColor: kBlack,
                        //       //   hintText: '',
                        //       //   hintTextColor: kFaintGrey,
                        //       //   keyboardType: TextInputType.text,
                        //       //   onTypingFunction: (value) {
                        //       //     name = value;
                        //       //   }, onFinishedTypingFunction: () {
                        //       //   Provider.of<DoctorProvider>(context, listen: false).setFilledInList(index, name);
                        //       //
                        //       //   },),
                        //       Expanded(
                        //           child:
                        //
                        //           Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: TextFormField(
                        //               validator: (value){
                        //
                        //                 if (value == ""){
                        //                   return 'Enter this value';
                        //                 } else {
                        //                   return null;
                        //                 }
                        //               },
                        //
                        //               onChanged: (value){
                        //                 name = value;
                        //               },
                        //               keyboardType: TextInputType.text,
                        //               decoration: InputDecoration(
                        //
                        //                 hintText: "",
                        //                 hintStyle: TextStyle(fontSize: 14, color: kBlack),
                        //                 labelText: " Answer here",
                        //                 labelStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        //                 contentPadding:
                        //                 const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        //                 border: const OutlineInputBorder(
                        //                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        //                 ),
                        //                 enabledBorder: OutlineInputBorder(
                        //                   borderSide: BorderSide(color: kBlack, width: 1.0),
                        //                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        //                 ),
                        //                 focusedBorder: const UnderlineInputBorder(
                        //                   borderSide: BorderSide(color: kGreenThemeColor),
                        //                 ),
                        //                 // focusedBorder: OutlineInputBorder(
                        //                 //   borderSide: BorderSide(color: Colors.green, width: 0),
                        //                 //   borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        //                 // ),
                        //               ),
                        //             ),
                        //           ))
                        //     ],
                        //   ),
                        // );
                    } ),
                // *************************THIS IS THE LIST CODE*********************************************
                ListView.builder(

                    shrinkWrap: true,
                    primary: false,
                    itemCount: doctorDataDisplay.conditionListsKeys.length,
                    itemBuilder: (context, index) {
                      //Provider.of<StyleProvider>(context, listen: false).setRatingsNumber(reviewComment.length);
                      return Container(
                        child: Padding(
                          padding:  EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text('${ doctorDataDisplay.conditionListsKeys[index]}', style: kNormalTextStyle.copyWith(color: kBlack),),
                              DropdownButton<String>(
                                  items: doctorDataDisplay.conditionListsValues[index].map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                        child: Text(value));
                                  }).toList() ,
                                  value: doctorDataDisplay.filledInListAnswers[index],
                                  onChanged: (value){
                                    setState(() {
                                      doctorDataDisplay.setFilledInList(index,value!);
                                    });
                                  }
                              ),
                            ],
                          ),
                        ),
                      );
                    } ),


                // *************************THIS IS THE CHECKBOX CODE*********************************************
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),

                    itemCount: doctorDataDisplay.checkboxListsKeys.length,
                    itemBuilder: (context, index) {
                      //Provider.of<StyleProvider>(context, listen: false).setRatingsNumber(reviewComment.length);
                      return
                        Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                              child: Text(doctorDataDisplay.checkboxListsKeys[index], style: kNormalTextStyle.copyWith(color: kBlack),),
                            ),
                          Container(
                            height:
                            doctorDataDisplay.checkboxListsValues[index].length <= 8 ? 350: 500,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kBackgroundGreyColor,
                              // boxShadow: const [ kBoxShadowGrey ]
                            ),
                            // child: Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Container(height: 20,color: Colors.red,),
                            // )
                            child:
//
                            ListView.builder(

                            itemCount: doctorDataDisplay.checkboxListsValues[index].length,
                            itemBuilder: (context, i){
                              return CheckboxListTile(
                                checkColor: kGreenThemeColor,
                                activeColor: kPureWhiteColor,
                                title: Text('${i+1}. ${doctorDataDisplay.checkboxListsValues[index][i]}', style: kNormalTextStyle.copyWith(color: kFontGreyColor),),
                                //${i}. ${doctorDataDisplay.checkboxListsValues[index][i]}
                                // subtitle: Text("$i"),
                                value: arrayState[index][i],
                                onChanged: (bool? value) {
                                arrayState[index][i] = !arrayState[index][i];
                                setState(() {
                                });

                              },); }
                            ),
                          )],
                        );
                    } ),
                kLargeHeightSpacing,
              // image != null ? Image.file(image!, height: 180,) : Container(
                doctorDataDisplay.photoNeeded == false ? Container( ):
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
                questionBlock2(doctorDataDisplay.conditionConclusion),
                kLargeHeightSpacing,
                RoundedLoadingButton(
                  width: double.maxFinite,
                  color: kGreenThemeColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Book Appointment', style: TextStyle(color: kPureWhiteColor)),
                  ),
                  controller: _btnController,
                  onPressed: () async {
                    final isValidForm = formKey.currentState!.validate();
                    if ( isValidForm){
                      print("Great");

                      _btnController.reset();

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> NewWeightPage())
                      );


                    }else {
                      _btnController.error();
                      showDialog(context: context, builder: (BuildContext context){
                        return
                          CupertinoAlertDialog(
                            title: Text('Oops Something is Missing'),
                            content: Text('Make sure you have filled in all the fields'),
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
            )
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
                  // InputFieldWidget(labelText: '',
                  //   labelTextColor: kBlack,
                  //   hintText: '',
                  //   hintTextColor: kFaintGrey,
                  //   keyboardType: TextInputType.text,
                  //   onTypingFunction: (value) {
                  //     name = value;
                  //   }, onFinishedTypingFunction: () {
                  //   Provider.of<DoctorProvider>(context, listen: false).setFilledInList(index, name);
                  //
                  //   },),
                  Expanded(
                      child:

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        TextFormField(
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
  Container questionBlock2(String headingText) {

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
                    // Provider.of<DoctorProvider>(context, listen: false).setFilledInList(index, name);

                    },),

                ],
              ),
            );
  }
}
