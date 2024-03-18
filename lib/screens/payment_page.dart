import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:line_icons/line_icons.dart';
import 'package:netdoc/Utilities/constants/color_constants.dart';
import 'package:netdoc/controllers/home_controller.dart';
import 'package:netdoc/models/conditionModal.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../Utilities/constants/font_constants.dart';
import '../models/common_functions.dart';
import '../utilities/constants/user_constants.dart';
import '../widgets/doctor_button.dart';
import '../widgets/referral_codes.dart';
import 'add_service.dart';

class PaymentPage extends StatefulWidget {
  static String id = 'payment_page';

  const PaymentPage({super.key});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController countryController = TextEditingController();
  CollectionReference conditions = FirebaseFirestore.instance.collection('conditions');
  User user = FirebaseAuth.instance.currentUser!;

  void defaultInitialization()async{

    final prefs  = await SharedPreferences.getInstance();
    name = prefs.getString(kFullNameConstant)!;
    email = prefs.getString(kEmailConstant)!;
    phone = prefs.getString(kPhoneNumberConstant)! ?? 'Male';
    // gender = prefs.getString(kUserSex)!;
    weight = prefs.getDouble(kUserWeight) ?? 80;
    height = prefs.getInt(kUserHeight)?? 180;
    amount = Provider.of<DoctorProvider>(context, listen: false).bookingOption != kSpecialist ? "35000": "75000";
    setState(() {
      bmi = ((weight)/ ((height/100)*(height/100))).roundToDouble();
    });
  }
  final CollectionReference _firestoreCodes = FirebaseFirestore.instance.collection('referralCodes');
  var codeString = "";
  final TextEditingController _codeController = TextEditingController();
  Future<void> _checkCode() async {
    String code = _codeController.text;
    QuerySnapshot query = await _firestoreCodes
        .where('code', isEqualTo: code).get();

    if (query.docs.isNotEmpty) {
      DocumentSnapshot doc = query.docs.first;
      if (doc['valid']) {
        // Code is valid and not used

        finalAnswers = [];
        finalDiagnosis = [];
        finalMedication = [];
        bool containsWord(String sentence, String word) {
          List<String> words = sentence.split(' ');
          return words.contains(word);
        }
        // This changes the paid status to true by-passing the payments
        paidStatus = true;

        List <ConditionQuestionsModal> data = Provider.of<DoctorProvider>(context, listen: false).weightedQuestions;
        condition =  Provider.of<DoctorProvider>(context, listen: false).conditionName;
        List answers = Provider.of<DoctorProvider>(context, listen: false).answerBooklet;
        for (var i = 0; i < data.length;i++ ){
          finalAnswers.add("${data[i].question}:${answers[i]}");
          if (data[i].type == 'checkbox'){
            finalDiagnosis.add("${data[i].question}:${answers[i]}");
          }else if (containsWord(data[i].question, "medications") == true || containsWord(data[i].question, "medications,") == true
              || containsWord(data[i].question, "medication?") == true
              || containsWord(data[i].question, "medicine") == true|| containsWord(data[i].question, "medicine,") == true
              || containsWord(data[i].question, "treatment,") == true|| containsWord(data[i].question, "treatment") == true
          ){
            print(data[i].question);
            finalMedication.add("${data[i].question}:${answers[i]}");
          }
          else if (data[i].type == 'dropdown'){
            finalSymptoms.add("${data[i].question}:${answers[i]}");
          }
        }
        // This uploads the info tp the dB
        uploadData();
        // This updates the referral code in the referrals collection
        _updateCodeDocument(doc.id);
        

      } else {
        // Code already used
        _showPopup('Code already used');
      }
    } else {
      // Code does not exist
      _showPopup('Code not Valid');
    }
  }
  Future<void> _updateCodeDocument(String documentId) async {
    await _firestoreCodes.doc(documentId).update({
      'valid': false,
    }).whenComplete(() {
      CommonFunctions().showNotification('$name your appointment has been received',
          "We have received your appointment request for $condition");
    Navigator.pushNamed(context, ControlPage.id);
    });
  }
  List<String> doctorsList = ['Dr. Wilbrode Okungu', 'Dr. Patrick Kaliika', 'Dr. Agenda Rogers', 'Dr. Amaro Rwot', 'Dr. Ivan Sawani', 'Dr. Asad Muyinda', 'Dr. John Obi', 'Dr. Irene Nakalema', 'Dr. Andrew Ndamira', 'Dr. Elizabeth Kiwuuwa', 'Dr. Tophias Tumwebaze', 'Dr. Pauline Byakika', 'Dr. Yiga Matovu', 'Dr. Faith Nakubulwa', 'Dr. Grace Tuhaise', 'Dr. Agnes Anyait']; // Add your actual list of doctors
  final CollectionReference doctorsCollection = FirebaseFirestore.instance.collection('doctors');






  void _showDoctorsDialog(radioValue, billedValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Material(
            child: StreamBuilder<QuerySnapshot>(    
              stream: doctorsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Extracting data from the snapshot
                final doctors = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index].data() as Map<String, dynamic>;
                    return

                      GestureDetector(
                        onTap: (){
                          print("Yes");

                          setState(() {
                            selectedDoctor = doctor['Names of specialists'];
                            _selectedSpecialistValue = radioValue;
                            amount = billedValue;
                            doctorSpeciality = doctor['Area of Speciality'];
                          });
                          Navigator.pop(context);

                        },
                        child: ListTile(
                          leading: Icon(Iconsax.profile_circle4, color: kGreenThemeColor,),
                        title: Text(doctor['Names of specialists'], style: kNormalTextStyle.copyWith(color: kBlueDarkColor, fontWeight: FontWeight.w600),),
                        subtitle: Text(doctor['Area of Speciality'], ),
                    ),
                      );
                  },
                );
              },
            ),
          ),
        );
        //   AlertDialog(
        //   title: Text('Select a Doctor'),
        //   content:
        //   StreamBuilder<QuerySnapshot>(
        //   stream: doctorsCollection.snapshots(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Center(child: CircularProgressIndicator());
        //     }
        //
        //     if (snapshot.hasError) {
        //   return Center(child: Text('Error: ${snapshot.error}'));
        //     }
        //
        //     // Extracting data from the snapshot
        //     final doctors = snapshot.data!.docs;
        //
        //     return ListView.builder(
        //   itemCount: doctors.length,
        //   itemBuilder: (context, index) {
        //     final doctor = doctors[index].data() as Map<String, dynamic>;
        //     return Text("Hi");
        //     //   ListTile(
        //     //   title: Text(doctor['Names of specialists']),
        //     //   subtitle: Text(doctor['Area of Speciality']),
        //     // );
        //   },
        //     );
        //   },
        //   ),
        //   actions: [
        //     TextButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       child: Text('Cancel'),
        //     ),
        //   ],
        // );
      },
    );
  }
  void _showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ooops..',textAlign:TextAlign.center,style: kNormalTextStyle.copyWith(color: kBlack, fontWeight: FontWeight.bold)),

          content: Text(message,textAlign:TextAlign.center,style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 20, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            TextButton(
              child: Text('Go Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  var name = '';
  double weight = 40;
  int height = 0;
  var email = '';
  var phone = '';
  var gender = '';
  var bmi = 0.0;
  var amount = "35000";
  var selectedDoctor = "";
  var doctorSpeciality = "";
  var paidStatus = false;
  @override
  void initState() {
    // TODO: implement initState

    countryController.text = "+256";
    super.initState();
    defaultInitialization();
  }
  List finalAnswers = [];
  List finalDiagnosis = [];
  List finalSymptoms = [];
  List finalMedication = [];
  var countryName = '';
  var otherPatient = '';
  var countryFlag = '';
  var countryCode = "+256";
  String condition = '';
  String serviceId = 'ios${uuid.v1().split("-")[0]}';

  var phoneNumber = '';
  String _selectedValue = 'For Myself';
  String _selectedSpecialistValue = 'No';
  final formKey = GlobalKey<FormState>();

  _handlePaymentInitialization() async {
    final Customer customer = Customer(
        name: name,
        phoneNumber: phone,
        email: email);

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey: Provider.of<DoctorProvider>(context, listen: false).flutterwavePublicKey,
        currency: "UGX",
        redirectUrl: 'https://google.com',
        txRef: Uuid().v1(),
        amount: amount,
        customer: customer,
        paymentOptions: "card, ussd",
        // customization: Customization(title: "Test Payment"),
        isTestMode: false,
        customization: Customization(title: "Netdoc Payment"));
    final ChargeResponse response = await flutterwave.charge();
    if (response != null) {
      showLoading(response.toString());

    } else {
      showLoading("No Response!");
    }
  }

  Future<void> uploadData() async {
    // Call the user's CollectionReference to add a new user
    String dateOfAppointment = DateFormat('dd, MMMM, yyyy ').format(Provider.of<DoctorProvider>(context, listen: false).appointmentDate);
    final prefs = await SharedPreferences.getInstance();
    return conditions.doc(serviceId)
        .set({
      'documentId': serviceId,
      'appointment': dateOfAppointment, // John Doe
      'condition': condition,
      'description': finalAnswers.join(", "),
      'diagnosis': finalDiagnosis.join(", "),
      'symptoms': finalSymptoms.join(", "),
      'doctor': '', 
      'medication': finalMedication.join(", "),
      'doctorId': '',
      'hasDoctor': false,
      'isPaid': paidStatus,
      'status': 'None',
      'statusCode' : 2,
      'timestamp':  DateTime.now(),
      'userKin': prefs.getString(kNextOfKin),
      'userKinNumber': prefs.getString(kNextOfKinNumber),
      'userNationalId': prefs.getString(kIdNumber),
      'userBMI': bmi.toString(),
      'userBP': prefs.getString(kBloodPressure),
      'userEmail': email,
      'userGender': prefs.getString(kUserSex),
      'userHeight': prefs.getInt(kUserHeight).toString(),
      'userMedications': '',
      'userAllergies': prefs.getString(kAllergies),
      'userPhone': phone,
      'userUid': user.uid,
      'userWeight': prefs.getDouble(kUserWeight).toString(),
      'username': name,
      'source': 'ios',
      'userVaccinations': prefs.getString(kVaccinations),
      'token': prefs.getString(kToken),
      'appointmentType': _selectedValue,
      'specialistDoctor': selectedDoctor,
      'otherPatient': otherPatient
    })
        .then((value) =>
        print("Done")
    )
        .catchError((error) => print("Failed to send Communication: $error"));
  }

  Future<void> showLoading(String message) {
    Navigator.pushNamed(context, ControlPage.id);
    return CoolAlert.show(
          lottieAsset: 'images/explanation.json',
          context: context,
          type: CoolAlertType.success,
          text: "Your Payment was successfully Received and Updated",
          title: "Payment Received",
          confirmBtnText: 'Ok 👍',
          confirmBtnColor: kGreenThemeColor,
          backgroundColor: kGreenDarkColorOld,
        onConfirmBtnTap: (){
            Navigator.pop(context);
            Get.snackbar('Appointment Confirmed','$name your appointment for $condition has been received and scheduled.');
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenDarkColorOld,
        foregroundColor: kPureWhiteColor,
        title: Text("Payment",style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  "Complete Payment to Book",
                  style: kNormalTextStyle.copyWith(color: kBlack, fontSize: 18),
                ),
                kLargeHeightSpacing,

                Card(
                  color: kPureWhiteColor,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                  shadowColor: kGreenThemeColor,
                  elevation: 1.0,
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Condition", style: kNormalTextStyleWhiteButtons.copyWith(color: kBlack, fontWeight: FontWeight.bold)),
                        Text(Provider.of<DoctorProvider>(context, listen: false).conditionName, style: kNormalTextStyleWhiteButtons.copyWith(color: kBlack)),
                      ],
                    ),
                    leading: Icon(LineIcons.medicalNotes, color: kGreenDarkColorOld,),
                  ),
                ),
                kLargeHeightSpacing,
                Card(
                  color: kPureWhiteColor,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                  shadowColor: kGreenThemeColor,
                  elevation: 1.0,
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Name", style: kNormalTextStyleWhiteButtons.copyWith(color: kBlack, fontWeight: FontWeight.bold)),
                        Text(name, style: kNormalTextStyleWhiteButtons.copyWith(color: kBlack)),
                      ],
                    ),
                    leading: Icon(LineIcons.user, color: kGreenDarkColorOld,),
                  ),
                ),
                kLargeHeightSpacing,
                Card(
                  color: kPureWhiteColor,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                  shadowColor: kGreenThemeColor,
                  elevation: 1.0,
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Cost", style: kNormalTextStyleWhiteButtons.copyWith(color: kBlack, fontWeight: FontWeight.bold)),
                        Text("$amount UGX", style: kNormalTextStyleWhiteButtons.copyWith(color: kBlack)),
                      ],
                    ),
                    leading: Icon(LineIcons.moneyBill, color: kGreenDarkColorOld,),
                  ),
                ),
                kLargeHeightSpacing,
                const Text(
                  'Select Appointment Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Radio<String>(
                      value: 'For Myself',
                      groupValue: _selectedValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value!;
                        });
                      },
                    ),
                    Text('For Myself'),
                    SizedBox(width: 16),
                    Radio<String>(
                      value: 'For Another Patient',
                      groupValue: _selectedValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value!;
                          _showPatientForm();
                        });
                      },
                    ),
                    Text('For Another Patient'),
                  ],
                ),
                kSmallHeightSpacing,
                const Text(
                  'Do you need a Specialist? This will incur extra charges.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Radio<String>(
                      value: 'No',
                      groupValue: _selectedSpecialistValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedSpecialistValue = value!;
                          selectedDoctor = "";
                          amount = "35000";

                        });
                      },
                    ),
                    Text('No'),
                    SizedBox(width: 16),
                    Radio<String>(
                      value: 'Yes',
                      groupValue: _selectedSpecialistValue,
                      onChanged: (value) {
                        setState(() {
                        //  _selectedSpecialistValue = value!;
                        //   amount = "75000";
                          _showDoctorsDialog(value!, "75000");
                        });
                      },
                    ),
                    Text('Yes'),


                  ],
                ),
                selectedDoctor ==""?Container():Text(
                  'Selected Doctor: $selectedDoctor\n($doctorSpeciality)',textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kGreenThemeColor
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(onPressed: (){
                  showDialog(context: context,

                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Material(
                            color: Colors.transparent,
                            child:
                            // CodeValidationScreen()
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Enter Referral Code Below", style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontWeight: FontWeight.bold, fontSize: 18),),
                                    kLargeHeightSpacing,
                                    kLargeHeightSpacing,
                                    TextField(
                                      controller: _codeController,
                                      maxLength: 8,
                                      style: kNormalTextStyle.copyWith(color: kBlack, fontWeight: FontWeight.bold, fontSize: 20),
                                      textAlign: TextAlign.center,
                                      onChanged: (value){
                                        codeString = value;
                                      },

                                      decoration: InputDecoration(
                                        hintText: 'Enter code',
                                        hintStyle: kNormalTextStyle.copyWith(color: kBlack),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),

                                        ),
                                        fillColor: kNewGreenThemeColor, // Set the background color to green
                                        filled: true,
                                      ),
                                      keyboardType: TextInputType.text,
                                    ),
                                    kLargeHeightSpacing,
                                    ElevatedButton(
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kBlueDarkColor)),
                                        onPressed: (){

                                          _checkCode();
                                        }, child: Text("  Continue  ", style: kNormalTextStyle.copyWith(color: kPureWhiteColor),))
                                  ],
                                ),
                              ),
                            ),

                          ),
                        );
                      }
                  );


                }, child: Text("Enter Referral Code", style: kNormalTextStyle.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),)),
                SizedBox(
                  width: double.infinity,
                  height: 43,
                  child:
                  doctorButton(title: 'Pay With Insurance', continueFunction: () {
                    // uploadData();
                    //       Navigator.push(context,
                    //           MaterialPageRoute(builder: (context)=> InsurancePage())
                    //       );
                    showDialog(context: context, builder: (BuildContext context){
                      return CupertinoAlertDialog(
                        title:Text('Insurance Coming Soon!'),
                        content: Text('The option to pay with insurance will be coming soon. Please proceed to other payment method.'),
                        actions: [
                          CupertinoDialogAction(isDestructiveAction: true,
                              onPressed: (){
                                // _btnController.reset();
                                Navigator.pop(context);

                                // Navigator.pushNamed(context, SuccessPageHiFive.id);
                              },

                              child: const Text('Cancel')
                          ),

                        ],
                      );
                    });

                  },)

                ),
                kLargeHeightSpacing,
            SizedBox(
              width: double.infinity,
              height: 43,
              child:
              doctorButton(title: 'Pay Now', continueFunction: () {
                        finalAnswers = [];
                        finalDiagnosis = [];
                        finalMedication = [];
                        bool containsWord(String sentence, String word) {
                          List<String> words = sentence.split(' ');
                          return words.contains(word);
                        }

                        List <ConditionQuestionsModal> data = Provider.of<DoctorProvider>(context, listen: false).weightedQuestions;
                        condition =  Provider.of<DoctorProvider>(context, listen: false).conditionName;
                        List answers = Provider.of<DoctorProvider>(context, listen: false).answerBooklet;
                        for (var i = 0; i < data.length;i++ ){
                          finalAnswers.add("${data[i].question}:${answers[i]}");
                          if (data[i].type == 'checkbox'){
                            finalDiagnosis.add("${data[i].question}:${answers[i]}");
                          }else if (containsWord(data[i].question, "medications") == true || containsWord(data[i].question, "medications,") == true
                              || containsWord(data[i].question, "medication?") == true
                              || containsWord(data[i].question, "medicine") == true|| containsWord(data[i].question, "medicine,") == true
                              || containsWord(data[i].question, "treatment,") == true|| containsWord(data[i].question, "treatment") == true
                          ){
                            print(data[i].question);
                            finalMedication.add("${data[i].question}:${answers[i]}");
                          }
                          else if (data[i].type == 'dropdown'){
                            finalSymptoms.add("${data[i].question}:${answers[i]}");
                          }
                        }
                        uploadData();
                        _handlePaymentInitialization();


              },) )

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fields for the patient information form
  TextEditingController patientNameController = TextEditingController();
  TextEditingController patientAgeController = TextEditingController();
  TextEditingController patientGenderController = TextEditingController();
  TextEditingController patientBloodPressureController = TextEditingController();
  TextEditingController patientHeightController = TextEditingController();
  TextEditingController patientWeightController = TextEditingController();
  TextEditingController patientAllergiesController = TextEditingController();
  TextEditingController patientMedicationController = TextEditingController();

  // Function to show the patient information form
  void _showPatientForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Patient Information'),
          content: SingleChildScrollView(
            child: Form(
              // Use a GlobalKey for the Form
              key: GlobalKey<FormState>(),
              child: Column(
                children: [
                  TextFormField(
                    controller: patientNameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the patient\'s name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: patientAgeController,
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the patient\'s age';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: patientGenderController,
                    decoration: InputDecoration(labelText: 'Gender'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the patient\'s Gender';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: patientHeightController,
                    decoration: InputDecoration(labelText: 'Height'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the patient\'s age';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: patientWeightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Weight'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the patient\'s weight';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: patientAllergiesController,
                    decoration: InputDecoration(labelText: 'Allergies'),
                    // keyboardType: TextInputType.,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the patient\'s allergies';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: patientMedicationController,
                    decoration: InputDecoration(labelText: 'Medication'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the patient\'s medication';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: patientBloodPressureController,
                    decoration: InputDecoration(labelText: 'Blood Pressure'),
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      if (text.length == 3 && !text.contains('/')) {
                        // Automatically add '/' when the first three characters are entered
                        patientBloodPressureController.text = '$text/';
                        patientBloodPressureController.selection = TextSelection.fromPosition(
                          TextPosition(offset: patientBloodPressureController.text.length),
                        );
                      }
                    },

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the patient\'s blood pressure';
                      }
                      return null;
                    },
                  ),
                  // Add other fields for Gender, Blood Pressure, Height, Weight, Allergies, Medication...
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Validate the form
                //
                // if (Form.of(context)!.validate()) {
                  otherPatient = "name: ${patientNameController.text}, age: ${patientAgeController.text}, "
                      "gender: ${patientGenderController.text}, allergies: ${patientAllergiesController.text}, height: ${patientHeightController.text}, "
                      "weight: ${patientWeightController.text}, medication: ${patientMedicationController.text}, bloodPressure: ${patientBloodPressureController.text}";

                  Navigator.pop(context);
                // }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

