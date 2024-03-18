import 'package:get/get.dart';
import '../utilities/constants/word_constants.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      salutation: 'Welcome',
      appointmentHeading: 'Book Appointments',
      appointSubheading: 'Book your appointments \nhere with the doctor',
      followupSubheading: 'Click here to follow up\nafter your visit',
      followupHeading: 'Follow up',
      ordersHeading: 'Orders',
      ordersSubheading: 'View your prescription orders \nhere',
      homeTab: 'Home',
      appointmentTab: 'Appointment',
      chatTab: 'Chat',
      notificationTab: 'Notification',
      doctorList: 'Doctor List',
      noMessage : 'No Message',
      virtualAppointment: 'Virtual Appointment',
      followUp :'Follow Up',
      laboratoryReport :  'Laboratory Report',
      imagingReport : 'Imaging Report',
      medicinePrescription: 'Medicine Prescription',
      diagnosis: 'Diagnosis',
      correspondence: 'Correspondence',
      referralReport: 'Referral Report',
      referralNote: 'When a referral is made it shall appear here.',
      correspondenceNote: 'Doctors correspondence will appear here when uploaded.',
      diagnosisNote: 'Your diagnosis will appear here when uploaded',
      prescriptionNote: 'When ready, your prescription will appear here.',
      imagingNote :  'imagingNote',
      labNote: 'labNote',
      followupNote : 'followupNote',
      bookFollowup : 'Book Followup Appointment',
      bookingAppointment: 'Book An Appointment',
      bookingAppointmentQuestion: 'What condition do you have?',
      bookingAppointmentQuestionFollowup: 'Select Below',
      chooseLanguage: 'Choose your Language',
      settingsPage : "Settings Page",
      settingsTerms : "Terms and Conditions",
      privacy : "Privacy Policy",
      healthInfo : "Health Info",
      payments : "Payments",
    },
    'luganda_UG': {
      salutation: 'Oli Otya',
      appointmentHeading: 'Funa appointment yo wano',
      appointSubheading: "Funa appointments zo\nwano n'omusawo",
      followupSubheading: "Nyiga wano ogoberere\noluvannyuma lw'okukyala kwo",
      followupHeading: 'Okugoberera',
      ordersHeading: 'Ebiragiro',
      ordersSubheading: "Laba ebiragiro byo\neby'eddagala lyo wano",
      homeTab: 'Ewaka',
      appointmentTab: 'Appointmenti',
      chatTab: 'Okunyumya',
      notificationTab: 'Ebimanyisibwa',
      doctorList: "Olukalala lw'Abasawo",
      noMessage: 'Tewali Bubaka',
      virtualAppointment: 'Meeting ku Yintaneeti',
      followUp: 'Okugoberera',
      laboratoryReport: 'Lipoota ya laboratory',
      imagingReport: 'Lipoota y’okukuba ebifaananyi',
      medicinePrescription: 'Eddagala Eriwandiikiddwa',
      diagnosis: 'Okuzuula Obulwadde',
      correspondence: 'Ebbaluwa eziwandiikiragana',
      referralReport: 'Alipoota y’okusindika abantu',
      referralNote: 'Okusindikibwa bwe kukolebwa kijja kulabika wano.',
      correspondenceNote: "Ebbaluwa z'abasawo zijja kulabika wano nga ziteekeddwa ku mukutu.",
      diagnosisNote: "Diagnosis yo ejja kulabika wano nga eteekeddwa ku mukutu",
      prescriptionNote: 'Bwe tunaaba twetegese, eddagala lyo lijja kulabika wano.',
      imagingNote: 'imagingNote',
      labNote: 'labNote',
      followupNote: 'followupNote',
      bookFollowup : 'Funa Appointment endala',
      bookingAppointment: "Funa obudde z'okulaba omusawo",
      bookingAppointmentQuestion: 'Olina bulwadde ki?',
      bookingAppointmentQuestionFollowup: 'Londa Wansi',
      chooseLanguage: 'Londa olulimi lwo',
      settingsPage : "Omuko gw'Ensengeka",
      settingsTerms : "Ebiragiro n’Obukwakkulizo",
      privacy : "Enkola y’Ebyama",
      healthInfo : "Amawulire g'ebyobulamu",
      personalInfo : "Ebikwata ku Muntu",
      payments : "Okusasula",
    },
    'french_FR': {
      salutation: 'Bienvenue',
      appointmentHeading: 'Prendre des rendez-vous',
      appointSubheading: 'Prenez vos rendez-vous \nici avec le médecin',
      followupSubheading: 'Cliquez ici pour le suivi\naprès votre visite',
      followupHeading: 'Suivi',
      ordersHeading: 'Commandes',
      ordersSubheading: 'Consultez vos commandes\nde prescription ici',
      homeTab: 'Accueil',
      appointmentTab: 'Rendez-vous',
      chatTab: 'Discussion',
      notificationTab: 'Notification',
      doctorList: 'Liste des médecins',
      noMessage: 'Pas de message',
      virtualAppointment: 'Rendez-vous virtuel',
      followUp: 'Suivi',
      laboratoryReport: 'Rapport de laboratoire',
      imagingReport: "Rapport d'imagerie",
      medicinePrescription: 'Ordonnance médicale',
      diagnosis: 'Diagnostic',
      correspondence: 'Correspondance',
      referralReport: 'Rapport de renvoi',
      referralNote: 'Lorsqu\'un renvoi est effectué, il apparaîtra ici.',
      correspondenceNote: 'La correspondance des médecins apparaîtra ici lorsqu\'elle sera téléchargée.',
      diagnosisNote: 'Votre diagnostic apparaîtra ici lorsqu\'il sera téléchargé.',
      prescriptionNote: 'Lorsque vous serez prêt, votre ordonnance apparaîtra ici.',
      imagingNote: 'imagingNote',
      labNote: 'labNote',
      followupNote: 'followupNote',
      bookFollowup : "Trouver un autre rendez-vous",
      bookingAppointment: 'Prendre rendez-vous chez le médecin',
      bookingAppointmentQuestion: 'De quelle maladie souffrez-vous?',
      bookingAppointmentQuestionFollowup: 'Sélectionnez ci-dessous',
      chooseLanguage: 'Choisissez votre langue',
      settingsPage : "Page Paramètres",
      settingsTerms : "Termes et conditions",
      privacy : "Politique de confidentialité",
      healthInfo : "Information sur la santé",
      personalInfo : "Informations Personnelles",
      payments: "Paiements"
    },
    'swahili_KE': {
      salutation: 'Karibu',
      appointmentHeading: 'Fanya Uteuzi',
      appointSubheading: 'Fanya uteuzi wako wa\nhapa na daktari',
      followupSubheading: 'Bonyeza hapa kufuatilia\nbaada ya ziara yako',
      followupHeading: 'Kufuatilia',
      ordersHeading: 'Maagizo',
      ordersSubheading: 'Angalia maagizo yako ya dawa\nhapa',
      homeTab: 'Nyumbani',
      appointmentTab: 'Uteuzi',
      chatTab: 'Mazungumzo',
      notificationTab: 'Taarifa',
      doctorList: 'Orodha ya Madaktari',
      noMessage: 'Hakuna Ujumbe',
      virtualAppointment: 'Uteuzi wa Kivitual',
      followUp: 'Kufuatilia',
      laboratoryReport: 'Ripoti ya Maabara',
      imagingReport: 'Ripoti ya Uchunguzi wa Picha',
      medicinePrescription: 'Dawa Iliyowekewa Dawa',
      diagnosis: 'Uchunguzi',
      correspondence: 'Mawasiliano',
      referralReport: 'Ripoti ya Kuhamisha',
      referralNote: 'Wakati wa rufaa itaonekana hapa.',
      correspondenceNote: 'Mawasiliano ya madaktari yataonekana hapa wakati yanapopakiwa.',
      diagnosisNote: 'Uchunguzi wako utaonekana hapa wakati unapopakiwa.',
      prescriptionNote: 'Wakati utakapokuwa tayari, dawa yako itaonekana hapa.',
      imagingNote: 'imagingNote',
      labNote: 'labNote',
      followupNote: 'followupNote',
      bookFollowup: 'Fanya Uteuzi wa Kufuatilia',
      bookingAppointment: 'Fanya Uteuzi wa Kliniki',
      bookingAppointmentQuestion: 'Unaugua nini?',
      bookingAppointmentQuestionFollowup: 'Chagua Chini',
      chooseLanguage: 'Chagua Lugha yako',
      settingsPage: "Ukurasa wa Mipangilio",
      settingsTerms: "Sheria na Masharti",
      privacy: "Sera ya Faragha",
      healthInfo: "Taarifa ya Afya",
      payments: "Malipo",
    },
    'tigrinya_ET': {
      salutation: 'እንኳዕ ደሓን መፁ',
      appointmentHeading: 'ቆጸራታት ምዝገባ',
      appointSubheading: 'ቆጸራታትኩም ኣብዚ ምስ ሓኪም ምዝገባ ግበሩ',
      followupSubheading: 'ድሕሪ ምብጻሕኩም ክትከታተሉ ኣብዚ ጠውቑ',
      followupHeading: 'ክትትል',
      ordersHeading: 'ትእዛዛት።',
      ordersSubheading: 'ትእዛዝ ሓኪምኩም ኣብዚ ርኣዩ።',
      homeTab: 'ገዛ',
      appointmentTab: 'ቆፀራ',
      chatTab: 'ፀወታ',
      notificationTab: 'መፍለጢ',
      doctorList: 'ዝርዝር ሓካይም',
      noMessage : 'መልእኽቲ የለን',
      virtualAppointment: 'ቨርቹዋል ቆጸራ',
      followUp :'ክትትል',
      laboratoryReport :  'ጸብጻብ ላቦራቶሪ',
      imagingReport : 'ጸብጻብ ምስሊ',
      medicinePrescription: 'መድሃኒት ትእዛዝ ሓኪም',
      diagnosis: 'መርመራ',
      correspondence: 'ደብዳቤታት',
      referralReport: 'ሪፈራል ሪፖርት።',
      referralNote: 'ሪፈራል ክግበር ከሎ ኣብዚ ይቐርብ።',
      correspondenceNote: 'ናይ ሓካይም ደብዳቤታት ምስ ተሰቐለ ኣብዚ ክቐርብ እዩ።',
      diagnosisNote: 'መርመራኻ ምስ ተሰቐለ ኣብዚ ክረአ እዩ።',
      prescriptionNote: 'ድሉው ምስ ኮንካ፡ ትእዛዝካ ኣብዚ ክቐርብ እዩ።',
      imagingNote :  'ናይ ምስሊ መዘኻኸሪ',
      labNote: 'ናይ ላቦራቶሪ መዘኻኸሪ',
      followupNote : 'ምክትታል መዘኻኸሪ',
      bookFollowup : 'ቆጸራ ምክትታል መጽሓፍ',
      bookingAppointment: 'ቆጸራ ምዝገባ',
      bookingAppointmentQuestion: 'እንታይ ኩነታት ኣለካ?',
      bookingAppointmentQuestionFollowup: 'ኣብ ታሕቲ ምረጽ',
      chooseLanguage: 'ቋንቋኻ ምረጽ',
      settingsPage : "ገጽ ቅጥዕታት",
      settingsTerms : "ውዕላትን ቅጥዕታትን",
      privacy : "ፖሊሲ ውልቃዊ ሓበሬታ",
      healthInfo : "ሓበሬታ ጥዕና",
      payments : "ክፍሊት",
    },
  };
}

