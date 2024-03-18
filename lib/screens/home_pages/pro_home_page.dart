import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:netdoc/screens/Find%20a%20Doctor%20Pages/general_doctor_page.dart';
import 'package:netdoc/screens/Find%20a%20Doctor%20Pages/hospitals_page.dart';
import 'package:netdoc/screens/Find%20a%20Doctor%20Pages/loading_provider_screen.dart';
import 'package:netdoc/screens/add_service.dart';
import 'package:netdoc/screens/followup_list.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/screens/prescription_page.dart';
import 'package:netdoc/screens/Find%20a%20Doctor%20Pages/specialist_page.dart';
import 'package:netdoc/screens/video_viewer_page.dart';
import 'package:netdoc/utilities/constants/user_constants.dart';
import 'package:netdoc/widgets/pro_homepage_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../Utilities/constants/color_constants.dart';
import '../../Utilities/constants/font_constants.dart';
import '../../controllers/appointments_controller.dart';
import '../../controllers/home_controller.dart';
import '../../models/common_functions.dart';
import '../../utilities/constants/word_constants.dart';
import '../forms_page_current.dart';




class HomePagePro extends StatefulWidget {
  static String id = 'HomePagePro';



  @override
  State<HomePagePro> createState() => _HomePageProState();
}

class _HomePageProState extends State<HomePagePro> {
  var orderStatus = [];
  var colours = [];
  var location = [];
  var storeLocation = "";
  var email = "";
  var customerName = [];
  var orderNumber = [];
  var formatter = NumberFormat('#,###,000');



  var orderContents = [];
  var instructions = [];
  var appointmentDate = [];
  var appointmentTime = [];
  var bookingFee = [];
  var note = [];
  var cardColor = [];
  var textColor = [];
  var phoneCircleColor = [];
  var names = [];
  var appointmentsToday = [];
  var customerPhone = [];
  var onlineStatus = [];
  var bellOpacity = [];
  List <Color> onlineStatusColour = [];
  var totalBill= [];
  var newOrderNumber = 0;
  late bool isCheckedIn;

  var weight = 10.0;
  var height = 153;
  var bmi = 34.6;

  String name = 'Bernard';
  String image = '';
  String storeId = '';
  CollectionReference outgoingCallCollection = FirebaseFirestore.instance.collection('outgoing');

  late Timer _timer;

  Future<void> updateIncomingCall(docId) {

    return outgoingCallCollection.doc(docId)
        .update({
      'callInprogress': false,
    })
        .then((value) => print("Call Ended"))
        .catchError((error) => print("Failed to send Communication: $error"));
  }



  Future incomingVideoCallStream()async{
    final prefs = await SharedPreferences.getInstance();
    var videoAppId = '';
    var channelName = '';
    var token = '';
    var documentId = '';
    print('$email Kyekyo');

    var start = FirebaseFirestore.instance.collection('outgoing').where('patient_email', isEqualTo:
    // "bernardnt@yahoo.co.uk"
    //   "kangavebnt@gmail.com"
    email
    )
        .where('callInprogress', isEqualTo: true).where('agora_token', isNotEqualTo: "")
        .snapshots().listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {

        videoAppId = 'a6293127425146ceb482077eccd3cd33';
        channelName = doc['outgoing_id'];
        token = doc['agora_token'];
        documentId = doc.id;

        initiateCallScreen();

        setState(() {
          videoVariables.setCallAppId('a6293127425146ceb482077eccd3cd33');
          videoVariables.setCallChannelName(channelName);
          videoVariables.setCallTempToken(token);
          videoVariables.setDocumentId(documentId);

          prefs.setString(kVideoAppId, videoAppId);
          prefs.setString(kVideoChannelName, channelName);
          prefs.setString(kVideoToken, token);

          CoolAlert.show(
              lottieAsset: 'images/video.json',
              context: context,
              type: CoolAlertType.success,
              text: "A video call has been initiated!",
              title: "Doctors Call Appointment",
              confirmBtnText: 'Join Call',
              confirmBtnColor: kGreenThemeColor,
              backgroundColor: kBlack, onConfirmBtnTap: (){
            updateIncomingCall(documentId);
            Navigator.pop(context);
            Navigator.pushNamed(context, VideoViewer.id);

          }

          );

        });

      });
    });


    return start;
  }

  Future<void> addFieldsToConditions() async {
    // Get a reference to the "conditions" collection
    final CollectionReference conditionsCollection = FirebaseFirestore.instance.collection('condition_questions_tigirinya');

    // Get all the documents in the collection
    final QuerySnapshot querySnapshot = await conditionsCollection.get();
    // Loop through each document and update the fields
    for (final QueryDocumentSnapshot document in querySnapshot.docs) {
      // Update the "photoTwo" field to false
      await document.reference.update({
        'language': "French",

      });
    }
  }

  void initiateCallScreen()async{
    var _currentUuid = uuid.v4();

  }
  void defaultsInitiation () async{
    final prefs = await SharedPreferences.getInstance();

    String? newEmail = prefs.getString(kEmailConstant);
    name = prefs.getString(kFirstNameConstant)!;
    weight = prefs.getDouble(kUserWeight)!;
    height = prefs.getInt(kUserHeight)!;
    bmi = ((weight)/ ((height/100)*(height/100))).roundToDouble();

    setState((){});
    email  = newEmail!;
    incomingVideoCallStream();
    print(email);


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // appValuesStream();
    defaultsInitiation();

    // deliveryStream();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: kPureWhiteColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: PopScope(
        canPop: false,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            kLargeHeightSpacing,
            kLargeHeightSpacing,
            kLargeHeightSpacing,
            Text(
              "${salutation.tr} $name",
              style: kHeading3TextStyleBold.copyWith(
                  fontSize: 20, color: kBlack, fontWeight: FontWeight.w600),
            ),
            kLargeHeightSpacing,
            ProCustomWidget(
              title: "Find a Doctor",
                firstContainerIcon: LineIcons.medicalNotes,
                firstContainerTitle: "General Doctor",
                secondContainerIcon: LineIcons.heartbeat,
                secondContainerTitle: "Specialist",
                firstContainerPageRoute: "",
                secondContainerPageRoute: "secondContainerPageRoute",
              onPressedFirst: (){
                Navigator.pushNamed(context, GeneralDoctorsPage.id);

              },  onPressedSecond: (){
              Navigator.pushNamed(context, SpecialistPage.id);
            },),


            kLargeHeightSpacing,

            ProCustomWidget(
                title: "Find a Hospital",
                firstContainerIcon: LineIcons.medicalNotes,
                firstContainerTitle: "Clinics",
                secondContainerIcon: LineIcons.hospital,
                secondContainerTitle: "Hospitals",
                firstContainerPageRoute: "",
                secondContainerPageRoute: "secondContainerPageRoute",
            onPressedFirst: () {
                showBottomSheet(
                    context: context,
                    builder: (context) => Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: LoadingProvidersScreen(
                          title: 'Searching for Clinics',
                        )));
              }, onPressedSecond: () {
                // Navigator.pushNamed(context, LoadingProvidersScreen.id);

                showBottomSheet(
                    context: context,
                    builder: (context) => Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        child: LoadingProvidersScreen(
                          title: 'Finding Hospitals near you..',
                        )));
              },),



            kLargeHeightSpacing,
            ProCustomWidget(
                title: "Follow Up Section",
                firstContainerIcon: LineIcons.truck,
                firstContainerTitle: "Orders",
                secondContainerIcon: LineIcons.calendar,
                secondContainerTitle: "Follow up",
                firstContainerPageRoute: "",
                secondContainerPageRoute: "secondContainerPageRoute",
              onPressedFirst:  (){
                  showBottomSheet(
                      context: context, builder: (context) =>
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Scaffold(
                      appBar: AppBar(
                        // backgroundColor: kPureWhiteColor,
                              elevation: 0,
                        leading: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios, color: kBlack,)),
                      ),
                      body: AppointmentsController(),
                    ),
                  )
                  );
               // Navigator.pushNamed(context, AppointmentsController.id);
              },
              onPressedSecond: (){
                Navigator.pushNamed(context, FollowupPage.id);

              },),


            kLargeHeightSpacing,

          ],
        ),
      ),
    );
  }

  InkWell navigationCard(BuildContext context, Color cardColor, gotT ) {

    return
      InkWell(
        onTap: (){
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context)=> FormsPageCurrent())
          // );
          // var work =  Navigator.pushNamed(context, ConfirmationPage.id);
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=> FormsPage())
          );
        },
        child: Stack(
          children: [

            Container(
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5)
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
              child:

              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Container(
                      color: kPureWhiteColor,
                      child: CircleAvatar(
                        maxRadius: 35,
                        backgroundColor: kPureWhiteColor,
                        child: Icon(LineIcons.medicalBriefcase, color: kGreenThemeColor,size: 35,),
                      ),
                    ),
                    kSmallWidthSpacing,
                    kSmallWidthSpacing,
                    kSmallWidthSpacing,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Book Appointments', style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 16),),
                        Text('Book your appointments \nhere with the doctor',overflow: TextOverflow.ellipsis, style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12,),),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
  }

}



class RoundMedicalValueWidget extends StatelessWidget {
  const RoundMedicalValueWidget({
    required this.body, required this.title, this.ringColor = kAppGreenColor});
  final String body;
  final String title;
  final Color ringColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kBackgroundGreyColor,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.circular(10),
                color: ringColor,
              ),
              child: Icon(Icons.circle, color: kPureWhiteColor,size: 12,),
            ),
          ),
          kSmallWidthSpacing,
          Text('$title: $body', style: kNormalTextStyleWhiteLabel.copyWith( fontSize: 10),),
          kSmallWidthSpacing
        ],
      ),
    );
  }
}
