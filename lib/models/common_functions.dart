


import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/screens/video_viewer_page.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utilities/constants/color_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../Utilities/constants/user_constants.dart';
import '../main.dart';
import '../screens/endcall_page.dart';
import '../screens/payment_page.dart';

class CommonFunctions {
  var formatter = NumberFormat('#,###,000');
  final auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  CollectionReference testingTesting = FirebaseFirestore.instance.collection('testing');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // CollectionReference appointments = FirebaseFirestore.instance.collection('testing');

  // This function signs out the User


  Future deliveryStream(context) async {

    final users = await FirebaseFirestore.instance
        .collection('flutterwave').doc("AR2sgPrN3jN7DKHzaPKp")
        .get();
    Provider.of<DoctorProvider>(context, listen: false).setFlutterwaveValues(users['publicKey'],users['testKey']);

  }
  notificationOfWrongDate (){
    Get.snackbar('Passed Date Selected', 'Select a future Date',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: kBlack,
        icon: const Icon(Icons.cancel, color: kPureWhiteColor,));
  }

  void dateOfAppointment(context) async {
    Get.snackbar('Enter Appointment Date', 'Select when you are available for this appointment',
        snackPosition: SnackPosition.TOP,
        backgroundColor: kGreenThemeColor,
        colorText: kBlack,
        icon: const Icon(Icons.check_circle, color: kPureWhiteColor));

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      // last date should be one year after the current date
      lastDate: DateTime.now().add(const Duration(days: 365))
    );

    if (selectedDate == null) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) return;

    final deliveryTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    var nowDate = DateTime.now();

    // Check if the delivery time is before the current time
    if (deliveryTime.isBefore(nowDate)) {
      notificationOfWrongDate();
    } else {
      deliveryStream(context);
      Provider.of<DoctorProvider>(context, listen: false).setAppointmentDate(deliveryTime);

      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage()));
    }
  }
  // void dateOfAppointment(context) async{
  //
  //   Get.snackbar('Enter Appointment Date', 'Select when you are available for this appointment',
  //       snackPosition: SnackPosition.TOP,
  //       backgroundColor: kGreenThemeColor,
  //       colorText: kBlack,
  //       icon: Icon(Icons.check_circle, color: kPureWhiteColor,));
  //
  //     final selectedDate = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(2023),
  //       lastDate: DateTime(2024),
  //     );
  //
  //     if (selectedDate == null) return;
  //
  //     final selectedTime = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.now(),
  //     );
  //
  //     if (selectedTime == null) return;
  //
  //     final deliveryTime = DateTime(
  //       selectedDate.year,
  //       selectedDate.month,
  //       selectedDate.day,
  //       selectedTime.hour,
  //       selectedTime.minute,
  //     );
  //   var nowDate = DateTime.now();
  //     // Check if the delivery time is between 8 am and 6 pm
  //     if (nowDate.day > deliveryTime.day && nowDate.month >= deliveryTime.month) {
  //       notificationOfWrongDate();
  //     } else {
  //       deliveryStream(context);
  //       Provider.of<DoctorProvider>(context, listen: false).setAppointmentDate(deliveryTime);
  //
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context)=> PaymentPage())
  //       );
  //     }
  // }

  MaterialStateProperty<Color> convertToMaterialStateProperty(Color color) {
    return MaterialStateProperty.all(color);
  }

  Future<void> signOut() async {
    // Provider.of<DoctorProvider>(context).appId;
    await auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kIsLoggedInConstant, false);
    prefs.setBool(kIsFirstTimeUser, true);


  }

  //This gets the phone User  token of the user
  String getUserTokenOfPhone (){
    var token = '';
    _firebaseMessaging.getToken().then((value) => token = value!);
    return token;
  }

  Future <String> getVideoId () async{


    var token = '';
    _firebaseMessaging.getToken().then((value) => token = value!);
    return token;
  }

  void websiteLinkUrl (String link){
    launchUrl(Uri.parse(link));
  }




  Future<dynamic> AlertPopUpDialogueMain(BuildContext context,
      {required String imagePath, required String text, required String title,

      }) {
    return CoolAlert.show(
        lottieAsset: imagePath,
        context: context,
        type: CoolAlertType.success,
        text: text,
        title: title,
        confirmBtnText: 'Add',
        cancelBtnText: 'Cancel',
        showCancelBtn: true,
        confirmBtnColor: Colors.green,
        backgroundColor: kBlueDarkColor,
        onConfirmBtnTap: (){
          Navigator.pop(context);
          // bottomSheetAddIngredients(context, vegProvider, fruitProvider, extraProvider, blendedData);
        }
    );
  }
  // This function uploads the user token to the server

  // Get options from app
  Future getVariableFromFirestore(context) async {

    final users = await FirebaseFirestore.instance
        .collection('variables').doc("RqU5WCz55UPeK0IUcYMz")
        .get();

    Provider.of<DoctorProvider>(context,listen: false).setCommonVariables(
      users['itemsNumber'],
      users['questionsFontSize'],
      users['answersFontSize'],
      users['four'],
      users['five'],
      users['six'],
      users['seven'],
      users['eight'],
      users['nine'],
      users['ten'],
      users['eleven'],
      users['twelve'],
      users['thirteen'],
      users['fourteen'],
      users['fifteen'],
      users['other'],
      users['questionBaseNumber'],
      users['questionBaseSpace'],
      users['questionSecondNumber'],
      users['questionSecondSpace'],
      users['questionOtherSpace'],
    );

  }


  // Launch Google Maps to webview
  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    launchUrl(Uri.parse(googleUrl));
  }

  void callPhoneNumber (String phoneNumber){
    launchUrl(Uri.parse('tel://$phoneNumber'));
  }

  Future<void> uploadUserToken(token) async {


    final users = await FirebaseFirestore.instance
        .collection('users').doc(auth.currentUser!.uid)
        .update(
        {
          'token': token
        });
  }


  Future<void> testUploader ( )async {

    //final prefs =  await SharedPreferences.getInstance();

    return testingTesting.doc('asdasdasdasdas')
        .set({

      'items': [
        {
          'product':"basketProducts[i].name",
          'description': "basketProducts[i].details",
          'quantity': "basketProducts[i].quantity",
          'totalPrice': 20000,
        }
      ]
    })
        .then((value) {
          print("Done");
      // showNotification('Order Received', '${prefs.getString(kFirstNameConstant)} we have received your order! We shall have it ready for Delivery');
    } )
        .catchError((error) {

      // Navigator.pop(context);
      print(error);

    } );
  }



  // Check for internet connectivity
  Future<void> execute(InternetConnectionChecker internetConnectionChecker,
      ) async {

    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // ignore: avoid_print
    print(
      isConnected.toString(),
    );
    // returns a bool

    // We can also get an enum instead of a bool
    // ignore: avoid_print
    print(
      'Current status: ${await InternetConnectionChecker().connectionStatus}',
    );
    // Prints either InternetConnectionStatus.connected
    // or InternetConnectionStatus.disconnected

    // actively listen for status updates
    final StreamSubscription<InternetConnectionStatus> listener =
    InternetConnectionChecker().onStatusChange.listen(
          (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
          // ignore: avoid_print
          //   Get.snackbar('Internet Restored', 'You are back online');
          //   print('PARARARARA we are back on.');
            break;
          case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
            //Get.snackbar('No Internet', 'Please check your internet connection');

            print('OH NOOOOOOO GAGENZE');
            break;
        }
      },
    );

    // close listener after 30 seconds, so the program doesn't run forever
    await Future<void>.delayed(const Duration(seconds: 30));
    await listener.cancel();
  }


  // Removing Appointment from the server
  Future <dynamic> removeAppointment(docId ){

    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(docId)
        .update({
      'active':  false
    })
        .then((value) => print("Done"));
  }

  // This removes post favourites
  Future <dynamic> removeDocumentFromServer(docId, collection ){
    print(docId);
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .update({
      'active':  false
    })
        .then((value) =>print(collection));
  }

  // This removes favourites in Tab
  Future <dynamic> removeFavouritesInTab(postId, email){
    return FirebaseFirestore.instance
        .collection('trends')
        .doc(postId)
        .update({
      'favourites':  FieldValue.arrayRemove([email])
    })
        .then((value) => print('Favourites Updated'))
        .catchError((error) => print('Failed to update')
    );// //.update({'company':'Stokes and Sons'}
  }
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      // 'This channel is used for important Notifications',
      importance: Importance.high,
      playSound: true
  );
  void executeRemoveCall(){
    Builder(
      builder: (context) {

        return EndCallPage();
      },
    );


  }
  void showNotification(String notificationTitle, String notificationBody){
    flutterLocalNotificationsPlugin.show(0, notificationTitle, notificationBody,
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // channel.description,
              importance: Importance.high,
              color: Colors.green,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: IOSNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
                subtitle: channel.description

            )
        ));

  }
  cancelLocalNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print("ALL NOTIFICATIONS CANCELLED");

  }

  initializeNotification() async {
    _configureLocalTimeZone();
    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  tz.TZDateTime _convertTime(int year, int month, int day, int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      year,
      month,
      day,
      hour,
      minutes,
    );
    // if (scheduleDate.isBefore(now)) {
    //   scheduleDate = scheduleDate.add(const Duration(days: 1));
    // }
    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = 'Africa/Kampala';
    //await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  scheduledNotification({required String heading,required String body,required int year,required int month,required int day, required int hour, required int minutes, required int id}) async {

    initializeNotification();
    await
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      heading,
      body,
      _convertTime(year, month, day, hour, minutes),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '0',
          'name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          //  sound: RawResourceAndroidNotificationSound(sound),
        ),
        iOS: IOSNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      // payload: 'It could be anything you pass',
    );
    print("Scheduled messaege $heading for $year-$month-$day $hour:$minutes with id: $id");
  }



}