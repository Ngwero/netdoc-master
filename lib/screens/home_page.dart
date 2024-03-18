import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get_utils/get_utils.dart';
import 'package:google_translate/extensions/string_extension.dart';
import 'package:iconsax/iconsax.dart';

import 'package:line_icons/line_icons.dart';
import 'package:netdoc/controllers/home_controller.dart';
import 'package:netdoc/models/language_controller.dart';
import 'package:netdoc/screens/add_service.dart';
import 'package:netdoc/screens/followup_list.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/screens/confirmation_page.dart';

import 'package:netdoc/screens/medical_records.dart';
import 'package:netdoc/screens/prescription_page.dart';

import 'package:netdoc/screens/video_viewer_page.dart';
import 'package:netdoc/utilities/constants/user_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../l10n/app_localizations.dart';
import '../models/common_functions.dart';
import '../utilities/constants/color_constants.dart';
import '../utilities/constants/font_constants.dart';
import '../utilities/constants/word_constants.dart';
import 'forms_page_current.dart';



class HomePage extends StatefulWidget {
  static String id = 'HomePageDuplicate';



  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  // String salutation = 'Welcome';
  // String appointmentHeading = 'Book Appointments';
  // String appointSubheading = 'Book your appointments \nhere with the doctor';
  // String followupHeading = 'Follow up';
  // String followupSubheading = 'Click here to followup\nafter your visit';
  // String ordersHeading = 'Orders';
  // String ordersSubheading = 'View your prescription orders \nhere';

  List<Map<String, dynamic>> doctorsData = [{
    "Position": 1,
    "Names of specialists": "Dr Kaliika Patrick",
    "Contacts": 772873889,
    "Area of Speciality": " Physician",
    "Duty Station": "Platinum Hospital",
    "Status": "Boarded"
  },
    {
      "Position": 2,
      "Names of specialists": "Dr Mutahi Muzapher",
      "Contacts": 774517867,
      "Area of Speciality": "Physician",
      "Duty Station": "Nsambya hospital",
      "Status": "Boarded"
    },
    {
      "Position": 3,
      "Names of specialists": "Dr Mutaikirwa John Bosco",
      "Contacts": 772771968,
      "Area of Speciality": "Physician",
      "Duty Station": "Lubaga Specialised hospital",
      "Status": "Boarded"
    },
    {
      "Position": 22,
      "Names of specialists": "Dr Kalema Nelson",
      "Contacts": 782313109,
      "Area of Speciality": "Physician",
      "Duty Station": "Mulago Hospital",
      "Status": "Onboarding"
    },
    {
      "Position": 26,
      "Names of specialists": "Dr Muyanja David",
      "Contacts": 772489047,
      "Area of Speciality": "Physician",
      "Duty Station": "Midland consultants",
      "Status": "Onboarding"
    },
    {
      "Position": 4,
      "Names of specialists": "Dr Kibirango Ezra",
      "Contacts": 776077414,
      "Area of Speciality": "Physician",
      "Duty Station": "Mengo hospital",
      "Status": "Boarded"
    },
    {
      "Position": 32,
      "Names of specialists": "Dr Muyinda Asad",
      "Contacts": 754391593,
      "Area of Speciality": "Physician",
      "Duty Station": "Mt Elgon Hospital Mbale",
      "Status": "Boarded"
    },
    {
      "Position": 34,
      "Names of specialists": "Dr Nakalema Irene",
      "Contacts": 706139477,
      "Area of Speciality": "Physician",
      "Duty Station": "Kayunga refferal hospital",
      "Status": "Boarded"
    },
    {
      "Position": 45,
      "Names of specialists": "Dr Ivan Sawani",
      "Contacts": 757436262,
      "Area of Speciality": "Physician",
      "Duty Station": "Jinja Regional Referal Hospital",
      "Status": "Boarded"
    },
    {
      "Position": 5,
      "Names of specialists": "Dr Mukubya Mark",
      "Contacts": 775192246,
      "Area of Speciality": "Physician",
      "Duty Station": "Avimo Hospital",
      "Status": "Boarded"
    },
    {
      "Position": 28,
      "Names of specialists": "Dr Nampijja Joan",
      "Contacts": 756022506,
      "Area of Speciality": "Pediatrician",
      "Duty Station": "Lubaga hospital",
      "Status": "Onboarding"
    },
    {
      "Position": 15,
      "Names of specialists": "Dr Nabuma Tawusi",
      "Contacts": 703631317,
      "Area of Speciality": "Pediatrician",
      "Duty Station": "IHK",
      "Status": "Boarded"
    },
    {
      "Position": 6,
      "Names of specialists": "DR Atuhairwe Susan",
      "Contacts": 705629530,
      "Area of Speciality": "Gyanacologist",
      "Duty Station": "Mulago Women Specialized Hospital",
      "Status": "Boarded"
    },
    {
      "Position": 9,
      "Names of specialists": "Dr Sserubiri Lawrance",
      "Contacts": 772192019,
      "Area of Speciality": "Gyanacologist",
      "Duty Station": "Ruth Gaylord Hospital kawempe",
      "Status": "Boarded"
    },
    {
      "Position": 13,
      "Names of specialists": "Dr Alia Godi",
      "Contacts": 705777750,
      "Area of Speciality": "Gyanacologist",
      "Duty Station": "Dear mother",
      "Status": "Boarded"
    },
    {
      "Position": 10,
      "Names of specialists": "Dr Sabiti Edgar",
      "Contacts": 775822811,
      "Area of Speciality": "Gyanacologist",
      "Duty Station": "Value Family Hospital",
      "Status": "Boarded"
    },
    {
      "Position": 14,
      "Names of specialists": "Dr Erabu Walter Derrick",
      "Contacts": 778682577,
      "Area of Speciality": "Gyanacologist",
      "Duty Station": "Soroti hospital",
      "Status": "Boarded"
    },
    {
      "Position": 37,
      "Names of specialists": "Dr Odur Andrew",
      "Contacts": 772714386,
      "Area of Speciality": "Gyaenacologist",
      "Duty Station": "Lira regional hospital",
      "Status": "Boarded"
    },
    {
      "Position": 38,
      "Names of specialists": "Dr Kadaaga Henry Francis",
      "Contacts": 772195942,
      "Area of Speciality": "Gyaenacologist",
      "Duty Station": "Mulago hospital",
      "Status": "Boarded"
    },
    {
      "Position": 16,
      "Names of specialists": "Dr Okullo Emmanuel",
      "Contacts": 782538230,
      "Area of Speciality": "Gyanacologist",
      "Duty Station": "IHK",
      "Status": "Boarded"
    },
    {
      "Position": 43,
      "Names of specialists": "Dr Ndamira Andrew",
      "Contacts": 772714386,
      "Area of Speciality": "Consultant pediatrician",
      "Duty Station": "Mbarara Regional Referal Hospital",
      "Status": "Boarded"
    },
    {
      "Position": 36,
      "Names of specialists": "Dr Nabirye Stella",
      "Contacts": 759260205,
      "Area of Speciality": "Consultant Physician",
      "Duty Station": "Kirudu hospital",
      "Status": "Boarded"
    },
    {
      "Position": 41,
      "Names of specialists": "Dr Elizabeth Namukwaya Ssengooba",
      "Contacts": 772595672,
      "Area of Speciality": "Consultant Physician",
      "Duty Station": "Rubaga hospital",
      "Status": "Boarded"
    },
    {
      "Position": 17,
      "Names of specialists": "Dr Kasirye philip",
      "Contacts": 784560799,
      "Area of Speciality": "Consultant pediatrician",
      "Duty Station": "Platinum hospital",
      "Status": "Boarded"
    },
    {
      "Position": 18,
      "Names of specialists": "Dr Moses Tiri",
      "Contacts": 778505048,
      "Area of Speciality": "Gyn and fertility specialist",
      "Duty Station": "IHK",
      "Status": "Boarded"
    },
    {
      "Position": 7,
      "Names of specialists": "Dr Kagawa Nantamu Mike",
      "Contacts": 772449613,
      "Area of Speciality": "Obsetrician/gyaenacologist",
      "Duty Station": "Mulago Women Specialized Hospital",
      "Status": "Boarded"
    },
    {
      "Position": 8,
      "Names of specialists": "Dr Ndiwalana Billy Richard",
      "Contacts": 772853880,
      "Area of Speciality": "Obsetrician/gyaenacologist",
      "Duty Station": "Mengo hospital",
      "Status": "Boarded"
    },
    {
      "Position": 11,
      "Names of specialists": "Dr Daniel Zaake",
      "Contacts": 752325189,
      "Area of Speciality": "Obsetrician/gyaenacologist",
      "Duty Station": "LifesureFertility Centre/Nsambya",
      "Status": "Boarded"
    },
    {
      "Position": 12,
      "Names of specialists": "Dr Nyanzi Patrick",
      "Contacts": 751332797,
      "Area of Speciality": "Obsetrician/gyaenacologist",
      "Duty Station": "Medivan hospital",
      "Status": "Boarded"
    },
    {
      "Position": 19,
      "Names of specialists": "Dr Mwanje haruna Moses",
      "Contacts": 772514000,
      "Area of Speciality": "Obsetrician /gyaenacologist",
      "Duty Station": "Mulago Hospital",
      "Status": "Onboarding"
    },
    {
      "Position": 20,
      "Names of specialists": "Dr Busingye Charlse",
      "Contacts": 752720740,
      "Area of Speciality": "Obsetrician /gyaenacologist",
      "Duty Station": "Nakasero hospital",
      "Status": "Onboarding"
    },
    {
      "Position": 23,
      "Names of specialists": "Dr Tugume Rodgers",
      "Contacts": 771412807,
      "Area of Speciality": "Obsetrician /gyaenacologist",
      "Duty Station": "Nile hospital hoima",
      "Status": "Onboarding"
    },
    {
      "Position": 24,
      "Names of specialists": "Dr Nyombi Jafhar",
      "Contacts": 772475105,
      "Area of Speciality": "Obsetrician /gyaenacologist",
      "Duty Station": "Medical Hub",
      "Status": "Onboarding"
    },
    {
      "Position": 25,
      "Names of specialists": " Dr Kisegerwa Enock",
      "Contacts": 776667264,
      "Area of Speciality": "Obsetrician /gyaenacologist",
      "Duty Station": "Mulago Hospital",
      "Status": "Onboarding"
    },
    {
      "Position": 29,
      "Names of specialists": "Dr Damulira Adam",
      "Contacts": 782459837,
      "Area of Speciality": "Obsetrician /gyaenacologist",
      "Duty Station": "Naguru hospital",
      "Status": "Onboarding"
    },
    {
      "Position": 30,
      "Names of specialists": "Dr Sekikubo Musa",
      "Contacts": 782922846,
      "Area of Speciality": "Obsetrician /gyaenacologist",
      "Duty Station": "Mulago Hospital",
      "Status": "Onboarding"
    },
    {
      "Position": 27,
      "Names of specialists": "Dr Komagum Patrick",
      "Contacts": 782224305,
      "Area of Speciality": "Obsetrician /gyaenacologist",
      "Duty Station": "Mubende Hospital",
      "Status": "Onboarding"
    },
    {
      "Position": 39,
      "Names of specialists": "Dr Edward Kikabi",
      "Contacts": 782016267,
      "Area of Speciality": "Obsetrician /gyaenacologist",
      "Duty Station": "Medical Chambers Wandegya",
      "Status": "Onboarding"
    },
    {
      "Position": 40,
      "Names of specialists": "Dr Jonathan Mpanga",
      "Contacts": 782910384,
      "Area of Speciality": "Obsetrician /gyaenacologist",
      "Duty Station": "Nile International hospital",
      "Status": "Onboarding"
    },
    {
      "Position": 33,
      "Names of specialists": "Dr Micheal Oling",
      "Contacts": 782872266,
      "Area of Speciality": "General/laparoscopic surgeon",
      "Duty Station": "Angelo Surgery Centre",
      "Status": "Boarded"
    },
    {
      "Position": 31,
      "Names of specialists": "Dr Muhumuza Joseph",
      "Contacts": 785743055,
      "Area of Speciality": "Obsetrician /gyaenacologist",
      "Duty Station": "Value medical care",
      "Status": "Onboarding"
    },
    {
      "Position": 21,
      "Names of specialists": "Dr Jombwe Josehat",
      "Contacts": 772418071,
      "Area of Speciality": "Surgeon",
      "Duty Station": "platinum hospital",
      "Status": "Onboarding"
    },
    {
      "Position": 35,
      "Names of specialists": "Dr Micheal  Blessing Talemwa",
      "Contacts": 701110407,
      "Area of Speciality": "Neuro Surgeon",
      "Duty Station": "Rubaga hospital",
      "Status": "Boarded"
    },
    {
      "Position": 42,
      "Names of specialists": "Dr Bbale Dorothy Nakuya",
      "Contacts": 777958507,
      "Area of Speciality": "Plastic and Reconstructive surgeon",
      "Duty Station": "IHK",
      "Status": "Boarded"
    },
    {
      "Position": 44,
      "Names of specialists": "Dr Faith Nakubulwa",
      "Contacts": 774093672,
      "Area of Speciality": "0phthalmologist",
      "Duty Station": "IHK",
      "Status": "Boarded"
    },

    {
      "Position": 20,
      "Names of specialists": "Dr Wilbrode Okungu",
      "Credentail": "MBChB, MD (Internal & Family Medicine)",
      "Area of Speciality": "Consultant Physician, Specialist GP",
      "Duty Station": "Västerås, Sweden",

      "Status": "Onboarded"
    },
    {
      "Position": 17,
      "Names of specialists": "Dr Gloria Kiapi",
      "Contacts": 774093672,
      "Area of Speciality": "Clin Microbiologist, Infectious Disease",
      "Duty Station": "Oxford, UK",
      "Status": "Onboarding"
    },
    {
      "Position": 4,
      "Names of specialists": "Dr Nurfarah Sabtu",
      "Contacts": 774093672,
      "Area of Speciality": "Clin Microbiologist, Infectious Disease",
      "Duty Station": "Coventry, UK",
      "Status": "Onboarding"
    },
    {
      "Position": 31,
      "Names of specialists": "Dr Eleazer Okwor-Ojwang",
      "Contacts": 774093672,
      "Area of Speciality": "Consultant Physician, Specialist GP",
      "Duty Station": "Pearth, Australia",
      "Status": "Onboarding"
    },
    {
      "Position": 29,
      "Names of specialists": "Dr Albert Muweke",
      "Contacts": 774093672,
      "Area of Speciality": "Consultant Physician, Specialist GP",
      "Duty Station": "Gothenburg, Sweden",
      "Status": "Onboarding"
    },
    {
      "Position": 19,
      "Names of specialists": "Dr Rasha Hassonee",
      "Contacts": 774093672,
      "Area of Speciality": "Physician, Specialist GP",
      "Duty Station": "Västerås, Sweden",
      "Status": "Onboarding"
    }];

  // Function to add data to Firestore collection with generated UUIDs
  final CollectionReference doctorsCollection = FirebaseFirestore.instance.collection('doctors');
  Future<void> addDoctorsData() async {
    for (final doctor in doctorsData) {
      final uuid = Uuid().v4();
      await doctorsCollection.doc(uuid);
    }

    print('Doctors data added to Firestore collection successfully.');
  }


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

        print("DOCIDDOCID : $documentId");


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

      // Update the "photoTwoStatement" field to an empty string
      // await document.reference.update({
      //   'photoTwoStatement': '',
      // });
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

      floatingActionButton: GestureDetector(
          onTap:
              ()async{
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool(kIsProUser, true);
            Navigator.pushNamed(context, ControlPage.id);
          },
        child: Container(
          height: 40,
            width: 150,
            decoration: BoxDecoration(
             // color: kGreenThemeColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF008000), // Dark Green
                    Color(0xFF00FF00), // Lime Green
                  ],
                ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Center(child: Text("Go NetDoc Prime", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontWeight: FontWeight.bold),))),
      ),

      // FloatingActionButton(
      //
      //
      //   onPressed:
      //       ()async{
      //     final prefs = await SharedPreferences.getInstance();
      //     prefs.setBool(kIsProUser, true);
      //     Navigator.pushNamed(context, ControlPage.id);
      //   },
      //   //     (){
      //   //   // addDoctorsData();
      //   //    // addFieldsToConditions();
      //   //   //
      //   //   // Navigator.push(context,
      //   //   //     MaterialPageRoute(builder: (context)=>
      //   //   //         AddServicePage()
      //   //   //    // PaymentPage()
      //   //   //     )
      //   //   // );
      //   //   // initiateCallScreen();
      //   // },
      //
      //   backgroundColor: kAppGreenColor,
      //  // child:
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Text("Go Prime",textAlign: TextAlign.center, style: kHeading2TextStyleBold,),
      //   )
      //
      //   //ClipOval(child: Image.asset('images/logo.png', fit: BoxFit.contain,))
      //  // Icon(LineIcons.stethoscope, color: kPureWhiteColor,),
      //
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: Colors.white,
        // foregroundColor: Colors.blue,

        // brightness: Brightness.light,
        elevation:0,

        // title: Container(
        //     height: 50,
        //     child: GestureDetector(
        //       onTap: ()async{
        //         final prefs = await SharedPreferences.getInstance();
        //         prefs.setBool(kIsProUser, true);
        //         Navigator.pushNamed(context, ControlPage.id);
        //       },
        //       child: ClipOval(
        //
        //           child: Image.asset('images/logo.png', fit: BoxFit.contain,)
        //       ),
        //     )),
        centerTitle: true,
        // leading: GestureDetector(
        //     onTap: (){
        //       ZoomDrawer.of(context)!.toggle();
        //
        //     },
        //     child: Icon(Icons.menu))
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false; // return a `Future` with false value so this route cant be popped or closed.
        },
        child: ListView(
          padding: EdgeInsets.all(20),

          children: [
            kLargeHeightSpacing,
            kLargeHeightSpacing,
            Text("${salutation.tr} $name", style: kHeading3TextStyleBold.copyWith(fontSize: 20, color: kBlack, fontWeight: FontWeight.w600),),
            kLargeHeightSpacing,
            InkWell(
              onTap: (){
                CommonFunctions().cancelLocalNotifications();
                CommonFunctions().getVariableFromFirestore(context);
                if ( Provider.of<DoctorProvider>(context, listen: false).language == 'french_FR'){ // English (United States)
                  // Luganda

                  Provider.of<DoctorProvider>(context, listen: false).setConditionQuestionCollection("condition_questions_tigirinya", "French");
                } else if( Provider.of<DoctorProvider>(context, listen: false).language == "en_US"){
                  Provider.of<DoctorProvider>(context, listen: false).setConditionQuestionCollection("condition_questions", "English");
                }  else if( Provider.of<DoctorProvider>(context, listen: false).language == "swahili_KE"){
                  Provider.of<DoctorProvider>(context, listen: false).setConditionQuestionCollection("condition_questions_tigirinya", "Swahili");
                } else if( Provider.of<DoctorProvider>(context, listen: false).language == "tigrinya_ET"){
                  Provider.of<DoctorProvider>(context, listen: false).setConditionQuestionCollection("condition_questions_tigirinya", "Tigrinyi");
                }

                else {
                  print(Provider.of<DoctorProvider>(context, listen: false).language);
                  Provider.of<DoctorProvider>(context, listen: false).setConditionQuestionCollection("condition_questions", "English");
                }

                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> FormsPage())
                );
                // Navigator.pushNamed(context, ConfirmationPage.id);
                Provider.of<DoctorProvider>(context, listen: false).setBookingOption(kOrdinaryBooking);
              },
              child: Stack(
                children: [

                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                        color: kGreenThemeColor,
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
                            child: const CircleAvatar(
                              maxRadius: 35,
                              backgroundColor: kPureWhiteColor,
                              child: Icon(LineIcons.medicalBriefcase, color: kBlueDarkColor,size: 35,),
                            ),
                          ),
                          kSmallWidthSpacing,
                          kSmallWidthSpacing,
                          kSmallWidthSpacing,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(AppLocalizations.of(context)!.translate('conditionTitle')),
                              Text(appointmentHeading.tr, style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 16),),
                              Text(appointSubheading.tr,overflow: TextOverflow.ellipsis, style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12,),),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            kLargeHeightSpacing,
            InkWell(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> FollowupPage())
                );
              },
              child: Stack(
                children: [

                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                        color: kBlueDarkColor,
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
                              child: Icon(Iconsax.calendar_search, color: kBlueDarkColor,size: 35,),
                            ),
                          ),
                          kSmallWidthSpacing,
                          kSmallWidthSpacing,
                          kSmallWidthSpacing,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(followupHeading.tr, style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 16),),
                              Text(followupSubheading.tr,overflow: TextOverflow.ellipsis, style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12,),),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            kLargeHeightSpacing,
            InkWell(
              onTap: (){
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context)=> FormsPageCurrent())
                // );
                Navigator.pushNamed(context, PrescriptionPage.id);
                Provider.of<DoctorProvider>(context, listen: false).setBookingOption(kSpecialist);
              },
              child: Stack(
                children: [

                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                        color: kNewGreenThemeColor,
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
                            child: const CircleAvatar(
                              maxRadius: 35,
                              backgroundColor: kPureWhiteColor,
                              child: Icon(LineIcons.motorcycle, color: kBlueDarkColor,size: 35,),
                            ),
                          ),
                          kSmallWidthSpacing,
                          kSmallWidthSpacing,
                          kSmallWidthSpacing,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ordersHeading.tr, style: kNormalTextStyle.copyWith(color: kBlueDarkColor, fontSize: 16),),
                              Text(ordersSubheading.tr,overflow: TextOverflow.ellipsis, style: kNormalTextStyle.copyWith(color: kBlueDarkColor, fontSize: 12,),),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
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
