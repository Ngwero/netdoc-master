
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/screens/add_checkboxs.dart';
import 'package:netdoc/widgets/ticket_dots.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

import '../Utilities/constants/color_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../models/basket_items.dart';
import '../utilities/InputFieldWidget.dart';
import '../utilities/constants/icon_constants.dart';
import '../widgets/order_contents.dart';
import 'add_lists.dart';
var uuid = Uuid();


class AddServicePage extends StatefulWidget {
  static String id = 'input_page';
  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _auth = FirebaseAuth.instance;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final _random = new Random();
  CollectionReference items = FirebaseFirestore.instance.collection('items');
  CollectionReference ingredients = FirebaseFirestore.instance.collection('ingredients');
  CollectionReference serviceProvided = FirebaseFirestore.instance.collection('condition_questions_tigirinya');
  var onlineSwitchValue = false;

  var activeStatus;





  void defaultInitialization(){
    onlineSwitchValue = Provider.of <DoctorProvider>   (context, listen: false).uploadIsPhotoNeeded;
  }
  Future<void> uploadToServer() async{
    final prefs = await SharedPreferences.getInstance();

    // Call the user's CollectionReference to add a new user
    return serviceProvided.doc(serviceId)
        .set({
      'lists': optionsToUploadLists,
      'checkboxs':  optionsToUploadCheckbox,
      'conclusion': 'Is there anything else you would like to tell us?',
      'heading': Provider.of<DoctorProvider>(context, listen: false).highlightStatement,
      'id':serviceId,
      'photo': Provider.of<DoctorProvider>(context, listen: false).uploadIsPhotoNeeded,
      'photoStatement': Provider.of<DoctorProvider>(context, listen: false).uploadPhotoStatement,
      'questions': Provider.of<DoctorProvider>(context, listen: false).formQuestions,
      'title': Provider.of<DoctorProvider>(context, listen: false).medicalConditionName,
      'bloodPressure': false,
      'photoTwo': false,
      'pulse': false,
      'breathingRate': false,
      'extraInputStatement': "",
      'photoTwoStatement': "",

    })
        .then((value) {

      Get.snackbar('Uploaded', 'NICE WORK< KEEP GOING',
          snackPosition: SnackPosition.TOP,
          backgroundColor: kGreenThemeColor,
          colorText: kBlack,
          icon: Icon(Icons.check_circle, color: kPureWhiteColor,));
    }
    )
        .catchError((error) => print("Failed to add service: $error"));
  }


  @override

  String serviceId = 'testServ${uuid.v1().split("-")[0]}';
  String photoStatement= '';
  int basePrice= 0;
  double changeInvalidMessageOpacity = 0.0;
  String invalidMessageDisplay = 'Invalid Number';
  String password = '';
  String serviceName = '';
  String highlightStatement = '';
  String optionName = '';
  int optionValue = 0;
  int price = 0;
  Container containerToShow = Container();
  Map<String, List> optionsToUploadLists = {};
  Map<String, List> optionsToUploadCheckbox = {};

  List<BasketItem> options =[ BasketItem(amount: 0, quantity: 1, name: 'name', details: 'details')];


  //bool showSpinner = false;
  String errorMessage = 'Error Signing Up';
  double errorMessageOpacity = 0.0;
  String countryCode = ' ';
  double opacityOfTextFields = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // defaultInitialization();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(

          'Add New Condition', style: kNormalTextStyle.copyWith(color: kGreenDarkColorOld)),
        backgroundColor: kPureWhiteColor,
        foregroundColor: kBlack,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete_forever, color: kPureWhiteColor,),
          backgroundColor: kBlack,
          onPressed: (){

        Provider.of<DoctorProvider>(context, listen: false).resetEverything();
        setState(() {

        });
      }),

      backgroundColor: kBackgroundGreyColor,
      // appBar: AppBar(title: Text('Create Ingredient'),
      //   automaticallyImplyLeading: false,
      //   centerTitle: true,
      //   backgroundColor: Colors.black,),
      body:
      SingleChildScrollView(
        child:
        Column(
          children: [
            Provider.of<DoctorProvider>(context).formQuestions.length == 0 ?
            Column(
              children: [


                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text("Enter Service Info",textAlign: TextAlign.start, style: kHeading3TextStyleBold.copyWith(fontSize: 16, ),),
                ),
                SizedBox(
                  height: 220,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera_alt_outlined),
                        title: Text('Needs a Photo', style: kNormalTextStyle.copyWith(),),

                        trailing: buildSwitch(),
                      ),

                      InputFieldWidget(
                        controller: Provider.of<DoctorProvider>(context, listen: false).medicalConditionName,
                        labelText:' Medical Condition Name' ,hintText: 'Abdominal Pain', keyboardType: TextInputType.text,
                        onTypingFunction: (value){
                        serviceName = value;
                        print(Provider.of<DoctorProvider>(context, listen: false).medicalConditionName);
                        // Provider.of<DoctorProvider>(context, listen: false).setMedicalCondition(serviceName);
                      }, onFinishedTypingFunction: () { Provider.of<DoctorProvider>(context, listen: false).setMedicalCondition(serviceName); },),
                      InputFieldWidget(labelText:' Highlight Statement' ,hintText: 'If there is something wrong', keyboardType: TextInputType.text,
                        controller: Provider.of<DoctorProvider>(context, listen: false).highlightStatement,
                        onTypingFunction: (value){
                          highlightStatement = value;

                        }, onFinishedTypingFunction: () {
                          Provider.of<DoctorProvider>(context, listen: false).setHighlightStatement(highlightStatement);
                        },
                      ),
                      onlineSwitchValue == true ?  InputFieldWidget(
                        controller: Provider.of<DoctorProvider>(context, listen: false).uploadPhotoStatement,
                        labelText: ' Photo Statement', hintText: 'Take a photo of your stomach', keyboardType: TextInputType.text, onTypingFunction: (value){
                        photoStatement = value;
                      }, onFinishedTypingFunction: () {
                        Provider.of<DoctorProvider>(context, listen: false).setUploadPhotoStatement(photoStatement);
                      },): Container(),


                    ],
                  ),
                ),

              ],
            ) : Padding(
              padding: const EdgeInsets.only(top:20.0, bottom: 20),
              child: Container(
                child: Text('${Provider.of<DoctorProvider>(context, listen: false).medicalConditionName}',style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 18),)
              ),
            ),

            TicketDots(mainColor: kGreenDarkColorOld, backgroundColor: kBackgroundGreyColor,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){

                  if ( '' != ''){
                    CupertinoAlertDialog(
                      title: Text('Oops Something is Missing'),
                      content: Text('Make sure you have filled in Service fields'),
                      actions: [CupertinoDialogAction(isDestructiveAction: true,
                          onPressed: (){
                            _btnController.reset();
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'))],
                    );

                  }else{
                    var question;
                    int randomNumber = Random().nextInt(10) + 1;

                    CoolAlert.show(

                        // lottieAsset: 'images/details.json',
                        context: context,
                        type: CoolAlertType.success,
                        widget: SingleChildScrollView(

                            child:
                            Container(
                              child: Column(
                                children: [
                                  TextField(
                                    onChanged: (enteredQuestion){
                                      question = {enteredQuestion: "$randomNumber"};
                                      // instructions = customerName;
                                      // setState(() {
                                      // });
                                    },
                                    decoration: InputDecoration(
                                      // border: InputBorder.none,
                                        labelText: 'Question',
                                        labelStyle: kNormalTextStyleExtraSmall,
                                        hintText:  'What is the disease?',
                                        hintStyle: kNormalTextStyle
                                    ) ,
                                  ),

                                ],
                              ),
                            )
                        ),
                        // text: 'Enter customers details',
                        title: 'Condition Question',
                        confirmBtnText: 'Ok',
                        confirmBtnColor: Colors.green,
                        backgroundColor: kBlueDarkColor,
                        onConfirmBtnTap: (){

                          Provider.of<DoctorProvider>(context, listen:false).setFormQuestion(question);

                          Navigator.pop(context);
                        }
                    );

                  }
                },

                child: CircleAvatar(
                  backgroundColor: kGreenThemeColor,
                  radius: 25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: kPureWhiteColor,size: 15,),
                      Text("Questions", textAlign: TextAlign.center,style: kNormalTextStyleExtraSmall.copyWith(color: kPureWhiteColor),)
                    ],
                  ),
                ),
              ),
            ),
            kSmallHeightSpacing,
            ListView.builder(

                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: Provider.of<DoctorProvider>(context, listen: false).formQuestions.length,
                itemBuilder: (context, i){
                  return
                    OrderedContentsWidget(
                    fontSize: 15,

                      orderIndex: i + 1,
                      productDescription: '1',
                      productName: "${Provider.of<DoctorProvider>(context, listen: false).formQuestions[i]}",
                      );
                }),

            // CHECK LIST UPDATE INFO
            TicketDots(mainColor: kGreenDarkColorOld, backgroundColor: kBackgroundGreyColor,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  if (serviceName == '') {


                  } else {
                    Provider.of<DoctorProvider>(context, listen: false).resetCheckboxes();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> AddCheckboxes())
                    );

                  }
                },

                child: CircleAvatar(
                  backgroundColor: kBlueDarkColor,
                  radius: 25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: kPureWhiteColor,size: 15,),
                      Text("Checklist", textAlign: TextAlign.center,style: kNormalTextStyleExtraSmall.copyWith(color: kPureWhiteColor),)
                    ],
                  ),
                ),
              ),
            ),
            kSmallHeightSpacing,
            ListView.builder(


                shrinkWrap: true,
                itemCount: Provider.of<DoctorProvider>(context, listen: false).uploadCheckboxes.length,
                itemBuilder: (context, i){
                  return
                    OrderedContentsWidget(
                      fontSize: 15,

                      orderIndex: i + 1,
                      productDescription: '1',
                      productName:'${ Provider.of<DoctorProvider>(context, listen: false).uploadCheckboxes[i].answers}',
                    );
                }),

            // LIST UPDATE INFO
            TicketDots(mainColor: kGreenDarkColorOld, backgroundColor: kBackgroundGreyColor,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  if (serviceName == '') {
                  } else {
                    Provider.of<DoctorProvider>(context, listen: false).resetLists();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> AddLists())
                    );

                  }
                },

                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: kPureWhiteColor,size: 15,),
                      Text("Lists", textAlign: TextAlign.center,style: kNormalTextStyleExtraSmall.copyWith(color: kPureWhiteColor),)
                    ],
                  ),
                ),
              ),
            ),

            kSmallHeightSpacing,
            ListView.builder(


                shrinkWrap: true,
                itemCount: Provider.of<DoctorProvider>(context, listen: false).uploadLists.length,
                itemBuilder: (context, i){
                  return
                    OrderedContentsWidget(
                      fontSize: 15,

                      orderIndex: i + 1,
                      productDescription: '1',
                      productName: '${Provider.of<DoctorProvider>(context, listen: false).uploadLists[i].answers}',
                    );
                }),
            TicketDots(mainColor: kGreenDarkColorOld, backgroundColor: kBackgroundGreyColor,),

            kLargeHeightSpacing,
            RoundedLoadingButton(
              color: kGreenDarkColorOld,
              child: Text('Finished: Upload Form', style: TextStyle(color: Colors.white)),
              controller: _btnController,
              onPressed: () async {
                if (
               Provider.of<DoctorProvider>(context, listen:false).medicalConditionName == ''||
                    Provider.of<DoctorProvider>(context, listen:false).uploadCheckboxes.length ==0 || Provider.of<DoctorProvider>(context, listen:false).uploadLists.length ==0){
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
                }else {
                  for(var i = 0; i < Provider.of<DoctorProvider>(context, listen: false).uploadLists.length; i++){
                    var uploadArray = Provider.of<DoctorProvider>(context, listen: false).uploadLists[i].answers.split(', ').toList();
                    optionsToUploadLists.addAll({Provider.of<DoctorProvider>(context, listen: false).uploadLists[i].question: uploadArray

                   // Provider.of<DoctorProvider>(context, listen: false).uploadLists[i].answers
                    });
                  }

                  for(var i = 0; i < Provider.of<DoctorProvider>(context, listen: false).uploadCheckboxes.length; i++){
                    var uploadArray = Provider.of<DoctorProvider>(context, listen: false).uploadCheckboxes[i].answers.split(', ').toList();
                    optionsToUploadCheckbox.addAll({Provider.of<DoctorProvider>(context, listen: false).uploadCheckboxes[i].question:
                    uploadArray
                    //Provider.of<DoctorProvider>(context, listen: false).uploadCheckboxes[i].answers

                    });
                  }

                  // optionsToUploadLists.addAll(Provider.of<DoctorProvider>(context, listen: false).uploadCheckboxes);
                  uploadToServer();

                  Navigator.pop(context);
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
    );
  }
  Widget buildSwitch() => Switch.adaptive(
      activeColor: kGreenThemeColor,
      inactiveThumbColor: Colors.red,


      value: onlineSwitchValue,
      onChanged: (value){
        if (value == false){
          print(value);
          onlineSwitchValue = value;

          Provider.of<DoctorProvider>(context, listen: false).setUploadIsPhotoNeeded(value);
          print('WOWE${Provider.of<DoctorProvider>(context, listen: false).uploadIsPhotoNeeded}');




          setState((){

            // final prefs = await SharedPreferences.getInstance();

          });
        }else {
          activeStatus = 'On';
          onlineSwitchValue = value;
          Provider.of<DoctorProvider>(context, listen: false).setUploadIsPhotoNeeded(value);
          print(value);
          print('WOWE${Provider.of<DoctorProvider>(context, listen: false).uploadIsPhotoNeeded}');
          setState((){

            // final prefs = await SharedPreferences.getInstance();

          });

        }
      }


  );
}
