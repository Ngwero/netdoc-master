
import 'dart:math';

import 'package:file_picker/file_picker.dart';
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
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/screens/forms_page_current.dart';
import 'package:netdoc/screens/new_height.dart';
import 'package:netdoc/screens/payment_page.dart';
import 'package:netdoc/widgets/doctor_button.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../Utilities/InputFieldWidget.dart';
import '../Utilities/constants/color_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../models/common_functions.dart';
import '../utilities/paymentButtons.dart';




var uuid = Uuid();

class ConditionNewArrangement extends StatefulWidget {
  static String id = 'questions';


  @override
  State<ConditionNewArrangement> createState() => _ConditionNewArrangementState();
}

class _ConditionNewArrangementState extends State<ConditionNewArrangement> {
  var name = '';
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  String? dropValue;
  String errorMessage = '';
  double questionFontSize = 14;
  double answersFontSize = 14;
  var arrayState = [[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],];
  List finalAnswersCheckboxes = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[], ];
  List newAnswers = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[], ];


  var errorMessageOpacity = 0.0;
  String description = '';
  CollectionReference storeItem = FirebaseFirestore.instance.collection('stores');
  CollectionReference trends = FirebaseFirestore.instance.collection('trends');
  CollectionReference serviceProvided = FirebaseFirestore.instance.collection('services');

  final storage = FirebaseStorage.instance;
  var imageUploaded = false;

  String imageId = 'iosImage${uuid.v1().split("-")[0]}';
  UploadTask? uploadTask;
  final formKey = GlobalKey<FormState>();
  var allData = [];





  Future<void> uploadFile(String filePath, String fileName)async {

    File file = File(filePath);
    try {
      uploadTask  = storage.ref('Patient Images/$fileName').putFile(file);
      final snapshot = await uploadTask!.whenComplete((){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image Uploaded')));

      });
      final urlDownload = await snapshot.ref.getDownloadURL();
      Provider.of<DoctorProvider>(context, listen: false).setImageToUpload(urlDownload);


      // addTrend(serviceId, urlDownload);

      // Navigator.pushNamed(context, ControlPage.id);
    }  catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Uploading: $e')));
    }
  }

  File? image;
  PlatformFile? pdfFile;

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

  Future selectFile()async{
    final result = await FilePicker.platform.pickFiles();
    if(result == null ){
      return;
    }
    setState((){
      pdfFile = result.files.first;
    });


  }


  void defaultInitialization(){
    questionFontSize = Provider.of<DoctorProvider>(context, listen: false).fontSizeOfQuestions/1.0;
    answersFontSize = Provider.of<DoctorProvider>(context, listen: false).answersFontSize/1.0;
  }



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    defaultInitialization();

  }
  @override

  Widget build(BuildContext context) {

    var doctorDataDisplay = Provider.of<DoctorProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: kBeigeColor,
      appBar: AppBar(
        title: Text('${Provider.of<DoctorProvider>(context, listen: false).conditionName}', style: kNormalTextStyle.copyWith(color: kPureWhiteColor)),
        backgroundColor: kGreenDarkColorOld,
        foregroundColor: kPureWhiteColor,
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
                  child: Card(
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
                  ),
                ) ,
                // This is the questions Block
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: doctorDataDisplay.weightedQuestions.length,
                    itemBuilder: (context, index) {

                      //Provider.of<StyleProvider>(context, listen: false).setRatingsNumber(reviewComment.length);
                      /* THIS STATEMENT MEANS THAT IF THE QUESTION IN THE WEIGHTED ARRAY HAS TYPE OF QUESTION THEN EXECUTE THE
                      * THE QUESTION BLOCK, ELSE IF THE TYPE IS DROPDOWN EXECUTE THE DROPDOWN VALUE AND IF ITS CHECKBOX THEN EXECUTE THE CHECKBOX VALUES
                      * */

                      return doctorDataDisplay.weightedQuestions[index].type == 'question' ?
                      questionBlocks(doctorDataDisplay.weightedQuestions[index].question, index):
                      doctorDataDisplay.weightedQuestions[index].type == 'dropdown' ?
                      // Text('This is a List'):

                      ListsQuestionBlock(doctorDataDisplay.weightedQuestions[index].question, doctorDataDisplay.weightedQuestions[index].answers, index):
                      //questionBlocks('${doctorDataDisplay.weightedQuestions[index].question}', index):
                      // questionBlocks('${doctorDataDisplay.weightedQuestions[index].question}', index);
                      //    Text(doctorDataDisplay.weightedQuestions[index].question);
                      // // :
                      checkboxQuestionBlock(doctorDataDisplay.weightedQuestions[index].question, doctorDataDisplay.weightedQuestions[index].answers, index);
                      //  Text('This the number of items ${doctorDataDisplay.weightedQuestions.length}');
                      // doctorDataDisplay.weightedQuestions[index].type != 'question' ? Image.file(image!, height: 180,) :
                      //  questionBlocks('${doctorDataDisplay.conditionQuestions[index]}', index);
                    } ),
                // *************************THIS IS THE LIST CODE*********************************************

                // *************************THIS IS THE CHECKBOX CODE*********************************************

                // kLargeHeightSpacing,
                // image != null ? Image.file(image!, height: 180,) : Container(
                doctorDataDisplay.photoNeeded == false ? Container():
                SizedBox(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:0.0, right: 00),
                        child: Text(doctorDataDisplay.photoStatement, textAlign: TextAlign.start, style: kNormalTextStyle.copyWith(color: kBlack, fontWeight: FontWeight.w500, fontSize: questionFontSize),),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),

                        child:

                        image != null ? Image.file(image!, height: 220,) :
                        Container(
                          width: double.infinity,
                          height: 220,
                          // Lottie.asset('images/scan.json'),
                          decoration: BoxDecoration(

                              border: Border.all(color: kFontGreyColor),

                              borderRadius: const BorderRadius.all(Radius.circular(0)),
                              color: kBlack),
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(Icons.photo_camera_front_outlined, color: kBlack,size: 30,),
                              Text("Selected Photo", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontWeight: FontWeight.w500, fontSize: questionFontSize,),),
                            ],
                          ),


                        ),
                      ),


                    ],
                  ),
                ),
                // This is for the PDF UPLOAD
                doctorDataDisplay.photoTwoNeeded == false ? Container():
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:20.0, right: 20, top: 15),
                        child: Text(doctorDataDisplay.photoTwoStatement, textAlign: TextAlign.start, style: kNormalTextStyle.copyWith(color: kBlack, fontWeight: FontWeight.w500, fontSize: questionFontSize),),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),

                        child:

                        pdfFile != null ? Container(height:150, child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, color: kGreenThemeColor,),
                            Text("${pdfFile!.name}"),
                          ],
                        ))) :
                        GestureDetector(
                          onTap: (){
                            selectFile();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            // Lottie.asset('images/scan.json'),
                            decoration: BoxDecoration(

                                // border: Border.all(color: kFontGreyColor),

                                borderRadius: const BorderRadius.all(Radius.circular(0)),
                                color: kBeigeColor),
                            child:
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload, color: kGreenThemeColor,size: 100,),
                               // Text("Selected Photo", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontWeight: FontWeight.w500, fontSize: questionFontSize,),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // THIS IS FOR THE BLOOD PRESSURE QUESTIONS
                doctorDataDisplay.bloodPressureForm == false? Container(): SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:20.0, right: 20, top: 15),
                        child: Text(doctorDataDisplay.extraStatement, textAlign: TextAlign.start, style: kNormalTextStyle.copyWith(color: kBlack, fontWeight: FontWeight.w500, fontSize: questionFontSize),),
                      ),
                      kLargeHeightSpacing,

                      Row(
                        children: [
                          InputFieldWidget(readOnlyVariable: false,  labelText:' Weight in Kgs' ,hintText: '', keyboardType: TextInputType.number, onTypingFunction: (value){
                             // Gets the first name in the 0 positiion from the full names
                          }, onFinishedTypingFunction: () {  },),
                          InputFieldWidget(readOnlyVariable: false,  labelText:' Height in cm' ,hintText: '', keyboardType: TextInputType.number, onTypingFunction: (value){
                            // Gets the first name in the 0 positiion from the full names
                          }, onFinishedTypingFunction: () {  },),
                        ],

                      ),
                      kLargeHeightSpacing,

                      Container(
                        width: double.infinity,
                        // height: 90,
                        child: InputFieldWidget(readOnlyVariable: false, labelText:' Blood Pressure' ,hintText: '', keyboardType: TextInputType.text, onTypingFunction: (value){

                          // Gets the first name in the 0 positiion from the full names
                        }, onFinishedTypingFunction: () {  },),
                      ),
                      kLargeHeightSpacing
                    ],
                  ),
                ),
                // THIS IS FOR THE PULSE QUESTIONS
                doctorDataDisplay.pulseForm == false? Container(): SizedBox(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:20.0, right: 20, top: 15),
                        child: Text(doctorDataDisplay.extraStatement, textAlign: TextAlign.start, style: kNormalTextStyle.copyWith(color: kBlack, fontWeight: FontWeight.w500, fontSize: questionFontSize),),
                      ),
                      kLargeHeightSpacing,

                      Row(
                        children: [
                          InputFieldWidget(readOnlyVariable: false,  labelText:' Weight in Kgs' ,hintText: '', keyboardType: TextInputType.number, onTypingFunction: (value){
                            // Gets the first name in the 0 positiion from the full names
                          }, onFinishedTypingFunction: () {  },),
                          InputFieldWidget(readOnlyVariable: false,  labelText:' Height in cm' ,hintText: '', keyboardType: TextInputType.number, onTypingFunction: (value){
                            // Gets the first name in the 0 positiion from the full names
                          }, onFinishedTypingFunction: () {  },),
                        ],

                      ),
                      kLargeHeightSpacing,
                      Row(
                        children: [
                          InputFieldWidget(readOnlyVariable: false,  labelText:' Blood Pressure' ,hintText: '', keyboardType: TextInputType.number, onTypingFunction: (value){
                            // Gets the first name in the 0 positiion from the full names
                          }, onFinishedTypingFunction: () {  },),
                          InputFieldWidget(readOnlyVariable: false,  labelText:' Pulse Rate' ,hintText: '', keyboardType: TextInputType.number, onTypingFunction: (value){
                            // Gets the first name in the 0 positiion from the full names
                          }, onFinishedTypingFunction: () {  },),
                        ],

                      ),
                      kLargeHeightSpacing,
                      doctorDataDisplay.breathingRate == false? Container(): Container(
                        height: 70,
                        child: InputFieldWidget(readOnlyVariable: false,  labelText:' Breathing Rate' ,hintText: '', keyboardType: TextInputType.number, onTypingFunction: (value){
                          // Gets the first name in the 0 positiion from the full names
                        }, onFinishedTypingFunction: () {  },),
                      ),
                    ],
                  ),
                ),
                //
                questionBlock2(doctorDataDisplay.conditionConclusion),
                // kLargeHeightSpacing,
                doctorButton(continueFunction: () async{

                  final isValidForm = formKey.currentState!.validate();
                  if ( isValidForm){
                    // Check whether the form is valid then continue
                    print('This is it');

                    _btnController.reset();

                     CommonFunctions().dateOfAppointment(context);



                  }else {
                    _btnController.error();
                    showDialog(context: context, builder: (BuildContext context){
                      return
                        CupertinoAlertDialog(
                          title: const Text('Oops Something is Missing'),
                          content: const Text('Make sure you have filled in all the fields'),
                          actions: [CupertinoDialogAction(isDestructiveAction: true,
                              onPressed: (){
                                _btnController.reset();
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'))],
                        );
                    });
                  }


                }, title: "Confirm and Proceed to Pay",),

                Opacity(
                    opacity: errorMessageOpacity,
                    child: Text(errorMessage, style: const TextStyle(color: Colors.red),)),
              ],
            )
            ),
          ),
        ),
      ),
    );
  }

  checkboxQuestionBlock(String questions,List answers, int index) {
    var doctorDataDisplay = Provider.of<DoctorProvider>(context, listen: false);
    List newCheckboxes = answers;

    // THIS FUNCTION REMOVES THE NUMBER IN THE ARRAY THAT IS PINGED AT THE END AS THE WEIGHT NUMNBER
    newCheckboxes.removeWhere((element) => element == '0'|| element == '1'||element == '2'|| element == '3'||element == '4'|| element == '5'||element == '6'|| element == '7'||element == '8'||
        element == '9'||element == '10'|| element == '11'||element == '12'|| element == '13'||element == '14'|| element == '15'||element == '16'|| element == '17'||element == '18'|| element == '19'||element == '20'|| element == '21');
    // newCheckboxes.removeLast();
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Text(questions, style: kNormalTextStyle.copyWith(color: kBlack, fontWeight: FontWeight.w500, fontSize: questionFontSize),),
        ),
        SizedBox(height: 10,),
        Container(

          height:
          answers.length <= 4 ? doctorDataDisplay.answerFour.toDouble() :answers.length <= 5 ? doctorDataDisplay.answerFive.toDouble(): answers.length <= 6 ? doctorDataDisplay.answerSix.toDouble():  answers.length <= 7 ? doctorDataDisplay.answerSeven.toDouble(): answers.length <= 8 ? doctorDataDisplay.answerEight.toDouble():answers.length <= 9 ? doctorDataDisplay.answerNine.toDouble():answers.length <= 10 ? doctorDataDisplay.answerTen.toDouble():answers.length <= 11 ?doctorDataDisplay.answerEleven.toDouble():answers.length <= 12 ?doctorDataDisplay.answerTwelve.toDouble():answers.length <= 13 ?doctorDataDisplay.answerThirteen.toDouble():answers.length <= 14 ? doctorDataDisplay.answerFourteen.toDouble(): answers.length <= 15 ? doctorDataDisplay.answerFifteen.toDouble(): doctorDataDisplay.answerOther.toDouble(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kBeigeColor,
            //kBackgroundGreyColor,
            // boxShadow: const [ kBoxShadowGrey ]
          ),
          child:
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),

              itemCount: answers.length,
              itemBuilder: (context, i){
                return CheckboxListTile(

                  // dense: true,
                  checkColor: kGreenThemeColor,
                  activeColor: kPureWhiteColor,
                  title: Text('${i+1}. ${newCheckboxes[i]}', style: kNormalTextStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w400, fontSize: answersFontSize),),
                  //${i}. ${doctorDataDisplay.checkboxListsValues[index][i]}
                  // subtitle: Text("$i"),
                  value: arrayState[index][i],
                  onChanged: (bool? value) {
                    arrayState[index][i] = !arrayState[index][i];
                    if (value == true){
                      finalAnswersCheckboxes[index].add(newCheckboxes[i]);
                    }else {
                      finalAnswersCheckboxes[index].remove(newCheckboxes[i]);
                    }

                    setState(() {

                      doctorDataDisplay.setNewAnswerBookletValue(index, finalAnswersCheckboxes[index]);
                      // newCheckboxes = answers;
                    });

                  },); }
          ),
        )],
    );


  }
  ListsQuestionBlock(String question, List answers, index) {
    var doctorDataDisplay = Provider.of<DoctorProvider>(context, listen: false);
    print("${doctorDataDisplay.answerBooklet}");
    newAnswers[index] = answers;
    // newAnswers[index].removeWhere((element) => (element) == '1' ||  '2');

    // THIS FUNCTION REMOVES THE NUMBER IN THE ARRAY THAT IS PINGED AT THE END AS THE WEIGHT NUMNBER
    newAnswers[index].removeWhere((element) => element == '0'|| element == '1'||element == '2'|| element == '3'||element == '4'|| element == '5'||element == '6'|| element == '7'||element == '8'||
        element == '9'||element == '10'|| element == '11'||element == '12'|| element == '13'||element == '14'|| element == '15'||element == '16'|| element == '17'||element == '18'|| element == '19'||element == '20'|| element == '21');



    return Padding(
      padding:  EdgeInsets.only(left: 20, right: 20, bottom: 00, top: 10),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(question, style: kNormalTextStyle.copyWith(color: kBlack, fontWeight: FontWeight.w500, fontSize: questionFontSize),),
          SizedBox(height: 15,),
          SizedBox(
            width: double.maxFinite,
            child: Container(
              color: kPureWhiteColor,
              child: DropdownButton<String>(
                  hint: const Text("    --Select--"),
                  isExpanded: true,
                  underline: Text(""),

                  items: newAnswers[index].map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      // alignment: AlignmentDirectional.bottomCenter,
                        value: value,
                        child: Text(value, style: kNormalTextStyle.copyWith(fontSize: answersFontSize),));
                  }).toList() ,
                  value: doctorDataDisplay.answerBooklet[index],
                  //answers[0],
                  //doctorDataDisplay.filledInListAnswers[index],
                  onChanged: (value){
                    setState(() {
                      doctorDataDisplay.setNewAnswerBookletValue(index,value!);
                      // newAnswers = answers;
                    });
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }



  Container questionBlocks(String headingText, index) {
    var doctorDataDisplay = Provider.of<DoctorProvider>(context, listen: false);


    return
      Container(
        height: headingText.length <= doctorDataDisplay.answerBaseNumber? doctorDataDisplay.answerBaseSpace.toDouble() : headingText.length <= doctorDataDisplay.answerSecondNumber? doctorDataDisplay.answerSecondSpace.toDouble(): doctorDataDisplay.answerOtherSpace.toDouble(),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
              child: Text(headingText, style: kNormalTextStyle.copyWith(color: kBlack, fontWeight: FontWeight.w500, fontSize: questionFontSize),),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: TextFormField(
              validator: (value) {
                if (value == "") {
                    return 'This field needs to be answered';
                  } else {
                    return null;
                  }
                },
              onChanged: (value) {
                name = value;
              },
              keyboardType: TextInputType.text,
              onEditingComplete: () {
                  Provider.of<DoctorProvider>(context, listen: false)
                      .setNewAnswerBookletValue(index, name);
              },
              decoration: InputDecoration(
                // hintText: hintText,
                  filled: true,
                  border: InputBorder.none,
                  fillColor: kPureWhiteColor,

                labelStyle: TextStyle(fontSize: 16, color: Colors.grey[500]),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kGreenThemeColor),
                ),
              ),
            ),
            )
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
              child: Text(headingText, style: kNormalTextStyle.copyWith(color: kBlack, fontWeight: FontWeight.w500, fontSize: questionFontSize),),
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
