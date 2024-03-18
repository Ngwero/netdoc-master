


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_translate/components/google_translate.dart';
import 'package:netdoc/controllers/appointments_controller.dart';
import 'package:netdoc/controllers/home_controller.dart';
import 'package:netdoc/controllers/payments_controller.dart';
import 'package:netdoc/screens/Find%20a%20Doctor%20Pages/general_doctor_page.dart';
import 'package:netdoc/screens/Find%20a%20Doctor%20Pages/hospitals_page.dart';
import 'package:netdoc/screens/Find%20a%20Doctor%20Pages/loading_provider_screen.dart';
import 'package:netdoc/screens/followup_list.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/onboarding_questions/quiz_page_name.dart';
import 'package:netdoc/screens/chat.dart';
import 'package:netdoc/screens/chat_list.dart';
import 'package:netdoc/screens/confirmation_page.dart';
import 'package:netdoc/screens/home_page.dart';
import 'package:netdoc/screens/home_pages/pro_home_page.dart';
import 'package:netdoc/screens/login_page.dart';
import 'package:netdoc/screens/medical_records.dart';
import 'package:netdoc/screens/notification.dart';
import 'package:netdoc/screens/prescription_page.dart';
import 'package:netdoc/screens/settings.dart';
import 'package:netdoc/screens/signup_page.dart';
import 'package:netdoc/screens/Find%20a%20Doctor%20Pages/specialist_page.dart';
import 'package:netdoc/screens/splash_page.dart';
import 'package:netdoc/screens/video_viewer_page.dart';
import 'package:provider/provider.dart';

// import 'l10n/app_localizations.dart';
// import 'models/video_singleton.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'models/translations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async{
  // SingletonModalClass videoCallSettings = SingletonModalClass();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GoogleTranslate.initialize(
    apiKey: "AIzaSyDvqjhVSxwOq_40lK7hPfNcQ_JvA-1iSak",
    targetLanguage: "it",
  );

  runApp(MyApp());
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // App received a notification when it was killed
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
          create: (BuildContext context) {
            return DoctorProvider();
          },

        child: GetMaterialApp(
          locale: Locale('en', 'US'),
          translations: Translation(),
          theme: ThemeData(

            primarySwatch: Colors.green,
          ),

          debugShowCheckedModeBanner: false,
          initialRoute: SplashPage.id,


          routes: {
            '/': (context) => SplashPage(),
            // '/': (context) => AddServicePage(),
            HomePage.id: (context) => HomePage(),
            // HomePageController.id: (context) => HomePageController(),
            ControlPage.id: (context) => ControlPage(),
            RegisterPage.id: (context) => ControlPage(),
            AppointmentsController.id: (context) => AppointmentsController(),
            PaymentsController.id: (context) => PaymentsController(),
            VideoViewer.id: (context) => VideoViewer(),
            SettingsPage.id: (context) => SettingsPage(),
            QuizPageName.id: (context) => QuizPageName(),
            // OnboardingPage.id: (context) => OnboardingPage(),
            LoginPage.id: (context) => LoginPage(),
            MedicalRecords.id: (context) => MedicalRecords(),
            ConfirmationPage.id: (context) => ConfirmationPage(),
            ChatMessaging.id: (context) => ChatMessaging(),
            ChatListPage.id: (context) => ChatListPage(),
            NotificationPage.id: (context) => NotificationPage(),
            FollowupPage.id: (context) => FollowupPage(),
            PrescriptionPage.id: (context) => PrescriptionPage(),
            HomePagePro.id: (context)=> HomePagePro(),
            SpecialistPage.id: (context)=> SpecialistPage(),
            GeneralDoctorsPage.id: (context)=> GeneralDoctorsPage(),
          HospitalsPage.id: (context) => HospitalsPage(),
          LoadingProvidersScreen.id: (context) => LoadingProvidersScreen(
                title: 'Loading..',
              ),
        },
        ),
    );
  }
}

