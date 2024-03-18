
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:netdoc/models/ConditionQuestions.dart';
import 'package:netdoc/models/conditionModal.dart';


class DoctorProvider extends ChangeNotifier{

  String appId = '';
  String flutterwaveTestKey = "FLWSECK_TEST-59ed89c716f1ca8e4309df9ac043e6bc-X";
  String flutterwavePublicKey = "FLWPUBK_TEST-15ec7ce670062494429cddc5c64cd177-X";

  String conditionConclusion = '';
  String conditionQuestionCollection = 'condition_questions';
  String conditionLanguage = 'English';
  String conditionName = '';
  int numberOfItems = 4;
  int fontSizeOfQuestions = 15;
  int answerFour = 230;
  int answerFive = 290;
  int answerSix = 360;
  int answerSeven = 400;
  int answerEight = 450;
  int answerNine = 510;
  int answerTen = 580;
  int answerEleven = 580;
  int answerTwelve = 580;
  int answerThirteen = 580;
  int answerFourteen = 580;
  int answerFifteen = 780;
  int answerOther = 900;
  int answerBaseNumber = 900;
  int answerBaseSpace = 900;
  int answerSecondNumber = 900;
  int answerSecondSpace = 900;
  int answerOtherSpace = 900;
  int answersFontSize = 14;
  late BuildContext pageContext;

  String conditionHeading = '';
  List conditionQuestions = [];
  List conditionListsKeys = [];
  List checkboxListsKeys = [];
  List checkboxListsValues = [];
  List checkboxMarkedForUse = [];
  List conditionListsValues = [];
  List allConditionData = [];
  String photoStatement = "";
  String photoTwoStatement = "";
  bool photoNeeded = false;
  bool photoTwoNeeded = false;
  bool uploadIsPhotoNeeded = false;
  bool bloodPressureForm = false;
  bool pulseForm = false;
  bool breathingRate = false;
  String extraStatement = '';
  String medicalConditionName = '';
  String highlightStatement = '';
  String uploadPhotoStatement = '';
  String imageToUpload = '';
  String terms = '';
  String privacy = '';
  String bp = '';
  String language = "en_US";
  List answerBooklet = [];
  String bookingOption = '';
  String patientsDocumentId = '';
  DateTime patientOrderDate = DateTime.now();
  String doctorName = '';
  String doctorId = '';


  List formQuestions = [];

  // List formLists = [];
  String formListQuestion = '';
  List<String> formListQuestionsAnswers = [];
  List<ConditionQuestion>uploadLists = [];
 List<ConditionQuestionsModal>weightedQuestions = [];

  // Checkbox answering variables
  String formCheckboxQuestion = '';
  List<String> formCheckboxAnswers = [];
  List<ConditionQuestion>uploadCheckboxes = [];
  List uploadCheckboxesErrorAnswers = [];

  // Logic for the forms to be done

  List filledInListAnswers = [];
  List filledInCheckboxAnswers = [];
  List filledInFormAnswers = [];
  DateTime appointmentDate = DateTime.now();


  void setConditionQuestionCollection(String collection, language){
    conditionQuestionCollection = collection;
    conditionLanguage = language;

    notifyListeners();
  }
  void setBookingOption(String option){
    bookingOption = option;
    notifyListeners();
  }

  void setBloodPressure(String bloodPressure){
    bp = bloodPressure;
    notifyListeners();
  }
  void setCommonVariables(number, questionFontSize, answers, four, five, six, seven, eight, nine, ten,eleven, twelve, thirteen, fourteen, fifteen, other, questionBaseNumber, questionBaseSpace, questionSecondNumber, questionSecondSpace,questionOtherSpace ){
    numberOfItems = number;
    fontSizeOfQuestions = questionFontSize;
    answersFontSize = answers;
    answerFour = four;
    answerFive = five;
    answerSix = six;
    answerSeven = seven;
    answerEight = eight;
    answerNine = nine;
    answerTen = ten;
    answerEleven = eleven;
    answerTwelve = twelve;
    answerThirteen = thirteen;
    answerFourteen = fourteen;
    answerFifteen = fifteen;
    answerOther = other;
   answerBaseNumber = questionBaseNumber;
   answerBaseSpace = questionBaseSpace;
   answerSecondNumber = questionSecondNumber;
   answerSecondSpace = questionSecondSpace;
    answerOtherSpace = questionOtherSpace;
    notifyListeners();
  }

  void setTermsAndConditions(link, privacyTerms){
    terms = link;
    privacy = privacyTerms;


    notifyListeners();
  }

  void setPatientsBookingDate(DateTime date){
    patientOrderDate = date;
    notifyListeners();
  }


  void setPatientsDocumentId(patientDocId, doctor, docId){
    patientsDocumentId = patientDocId;
    doctorName = doctor;
    doctorId = docId;

    notifyListeners();
  }


  void setFlutterwaveValues(String publicKey, String testKey){
    flutterwaveTestKey = testKey;
    flutterwavePublicKey = publicKey;

    print("testKey: $flutterwaveTestKey, publicKey: $flutterwavePublicKey");

    notifyListeners();
  }

  void setImageToUpload(String image){
    imageToUpload = image;

    notifyListeners();
  }


  void setAppointmentDate(date){

    appointmentDate = date;
    notifyListeners();
  }

  void resetAnswerValuesForConditions (){
    filledInFormAnswers.clear();
    filledInCheckboxAnswers.clear();
    filledInListAnswers.clear();
    notifyListeners();
  }

  void rearrangeWeigtedQuestions (){

    List <ConditionQuestionsModal> book = weightedQuestions;

    // Here the code is being rearranged in order of how it should appear
    book.sort((a, b) => a.weight.compareTo(b.weight));
    weightedQuestions = book;
    notifyListeners();
  }

  void setAnswerBooklet(int numberOfQuestions){
    for (var i = 0; i< numberOfQuestions; i++){
      answerBooklet.add(null);
    }
  }
  void setDefaultLanguage(String lang){
    language = lang;
    notifyListeners();

  }

  void resetAnswerValuesForCondition(){
   filledInListAnswers = [];
   filledInCheckboxAnswers = [];
   filledInFormAnswers = [];
   notifyListeners();
  }

  void setAnswerValuesForCondition(int listNumber, int checkbox, int formNumber){
    clearAnswerBookletValues();


     resetAnswerValuesForCondition();
    for (var i = 0; i< listNumber; i++){
      filledInListAnswers.add(null);
    }
    for (var i = 0; i< checkbox; i++){
      filledInCheckboxAnswers.add(null);
    }
    for (var i = 0; i< formNumber; i++){
      filledInFormAnswers.add(null);
    }
    print('-----------------------------------------------------------');

    print('List: $filledInListAnswers total: ${filledInListAnswers.length}');
    print('Checkboxes: $filledInCheckboxAnswers  total: ${filledInCheckboxAnswers.length}');
    print('Forms: $filledInFormAnswers  total: ${filledInFormAnswers.length}');
    print('-----------------------------------------------------------');

    notifyListeners();
  }

  void setFilledInList (index, element){
    filledInListAnswers[index] = element;
    print(filledInListAnswers);
    notifyListeners();
  }



  void setNewAnswerBookletValue (index, element){
    answerBooklet[index] = element;
    print(answerBooklet);
    notifyListeners();
  }

  void clearAnswerBookletValues (){
    answerBooklet.clear();
    notifyListeners();
  }

  void setFilledInForm (index, element){
    filledInFormAnswers[index] = element;
    print(filledInFormAnswers);
    notifyListeners();
  }

  void setFilledInCheckbox (index, element){
    filledInCheckboxAnswers[index] = element;
    print(filledInCheckboxAnswers);
    notifyListeners();
  }

  // Photos variable


  void resetEverything (){

    appId = '';
    conditionConclusion = '';
    conditionHeading = '';
   conditionQuestions.clear();
    conditionListsKeys.clear();
   checkboxListsKeys.clear();
    checkboxListsValues.clear();
    conditionListsValues.clear();
    photoStatement = "";
    photoNeeded = false;
    uploadIsPhotoNeeded = false;
     medicalConditionName = '';
     highlightStatement = '';
     uploadPhotoStatement = '';
    formQuestions.clear();

    // List formLists = [];
   formListQuestion = '';
    formListQuestionsAnswers.clear();
    uploadLists.clear();

    // Checkbox answering variables
    formCheckboxQuestion = '';
    formCheckboxAnswers.clear();
    uploadCheckboxes.clear();

    notifyListeners();
  }

  void resetCheckboxes (){
    formCheckboxQuestion = '';
    formCheckboxAnswers.clear();

    notifyListeners();
  }

  void resetLists (){
    formListQuestion = '';
    formListQuestionsAnswers.clear();
    notifyListeners();
  }

  void setUploadIsPhotoNeeded (value){
    uploadIsPhotoNeeded = value ;
    notifyListeners();
  }
  void setUploadCheckboxes (ConditionQuestion checkboxData){
    uploadCheckboxes.add(checkboxData);
    uploadCheckboxesErrorAnswers.insert(0, checkboxData.answers);
    // add(checkboxData) ;

    print('YUYUYUYUYUYUYUYU $checkboxData');
    print('Upload ${uploadCheckboxes[0].answers} ');
    print('Upload ${uploadCheckboxes[0].question} ');
    notifyListeners();
  }

  void setUploadLists (ConditionQuestion listData){
    uploadLists.add(listData) ;

    print('YUYUYUYUYUYUYUYU ${listData.answers}');
    notifyListeners();
  }

  void setModalConditionQuestions (ConditionQuestionsModal listData){
    weightedQuestions.add(listData);
    // print('YUYUYUYUYUYUYUYU ${listData.answers}');
    notifyListeners();
  }


  void setFormList (list){
    formListQuestionsAnswers.add(list) ;
    notifyListeners();
  }

  void addAllDataForCondition(list){
    allConditionData.add(list) ;
    print('INFORMATION ADDED ALL CONDITIONS: ${allConditionData.length} and WEIGHTED QUESTIONS: ${weightedQuestions.length}');

    notifyListeners();
  }

  void dataInAllConditionCleared(){
    print('INFORMATION CLEARED ALL CONDITIONS: ${allConditionData.length} and WEIGHTED QUESTIONS: ${weightedQuestions.length}');
    allConditionData.clear();
    weightedQuestions.clear();
    notifyListeners();
  }


  void setMedicalCondition (question){
    medicalConditionName = question;
    notifyListeners();
  }

  void setUploadPhotoStatement (question){
    uploadPhotoStatement = question;
    notifyListeners();
  }

  void setHighlightStatement (question){
    highlightStatement = question;
    notifyListeners();
  }


  void setCheckBoxMainQuestion (question){
    formCheckboxQuestion = question;
    notifyListeners();
  }

  void setListMainQuestion (question){
    formListQuestion = question;
    notifyListeners();
  }
  void setFormCheckboxes (checkbox){
    formCheckboxAnswers.add(checkbox) ;
    notifyListeners();
  }
  void setFormQuestion (question){
    formQuestions.add(question) ;
    notifyListeners();
  }

  void setConditionStatements (title, heading, conclusion, questions, listsKeys, listValues, photoHeader, photoRequired, checkKeys, checkValues, photoTwoRequired, photoTwoHeader, bloodPressure, pulse, extraHeading, breathing){
    // Map optionsDataStored =  lists[index];
    conditionName = title;
    conditionConclusion = conclusion;
    conditionHeading = heading;
    conditionQuestions = questions;
    conditionListsKeys = listsKeys;
    conditionListsValues = listValues;
    photoStatement = photoHeader;
    photoNeeded = photoRequired;
    checkboxListsKeys = checkKeys;
    checkboxListsValues = checkValues;
    photoTwoNeeded = photoTwoRequired;
    photoTwoStatement = photoTwoHeader;
    bloodPressureForm = bloodPressure;
    pulseForm = pulse;
    extraStatement = extraHeading;
    breathingRate = breathing;
    // for (var i = 0; i< checkValues.length; i++){
    //   checkboxMarkedForUse.add
    // }
    notifyListeners();

  }



}
