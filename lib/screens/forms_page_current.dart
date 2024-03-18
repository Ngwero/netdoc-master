import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/screens/conditionNewArrangement.dart';
import 'package:provider/provider.dart';
import '../Utilities/constants/color_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../models/conditionModal.dart';
import '../utilities/constants/word_constants.dart';



class FormsPage extends StatefulWidget {
  static String id = 'list_of_conditions';

  @override
  State<FormsPage> createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {

  void clearCheck(){

    print("QOOQOQOQOQOQOQOQO ${Provider.of<DoctorProvider>(context, listen: false).allConditionData.length}") ;
  }

  void bringDataTogether (){

    // This function brings all the data together in one pool that can then be accessed
    //clearCheck();

    allData = Provider.of<DoctorProvider>(context, listen: false).allConditionData;


    for (var i = 0; i < allData.length; i++){


      if(allData[i].runtimeType == List<dynamic>) {
        print("The List<Dynamic> is : ${allData[i]}");
        var donuts = allData[i];
        for (var b = 0; b< donuts.length; b++){
          Map actualValue = donuts[b];

          var questionPosition = actualValue.values.toList().join();
          var questionQuestion = actualValue.keys.toList().join();
          // print("WOLOLOLOLO: ${questionPosition}, question $questionQuestion! ");


          Provider.of<DoctorProvider>(context, listen: false).setModalConditionQuestions(ConditionQuestionsModal(
              weight: int.parse(questionPosition)
              , question: questionQuestion, answers: [], type: 'question'));
        }
      }

      // else if (allData[i].values.toList().length > 5) {
      else {
        Map data = allData[i];
        var listOfKeys = data.keys.toList();
        var listOfValues = data.values.toList();


       // print("TITITIITITITITITI - ${listOfValues[i].length},Question: ${listOfKeys[i]}, Values: ${listOfValues[i]} ");
        // This is a checkbox
        // List newListOfValues = List.from(listOfValues).map((array) => array.removeLast()).toList();

        for (var b = 0; b< data.length; b++){

          var checksum = listOfValues[b].last;
          // var finalAnswers = newListOfValues[b];
          // finalAnswers.removeLast();

         //  final finalAnswers = listOfValues[b].removeLast();
          if (listOfValues[b].length > Provider.of<DoctorProvider>(context, listen: false).numberOfItems) {
            // print("LOPOPOPOPJIJIJIJ ${listOfValues}");
            // print(listOfValues[b].last);
            Provider.of<DoctorProvider>(context, listen: false).setModalConditionQuestions(
                ConditionQuestionsModal(
                    weight: int.parse(listOfValues[b].last) ,
                    question: listOfKeys[b],
                    answers: listOfValues[b],
                    type: 'checkbox'));
            // finalAnswers = listOfValues[b];
          } else {
                Provider.of<DoctorProvider>(context, listen: false).setModalConditionQuestions(
                    ConditionQuestionsModal(
                        weight: int.parse(listOfValues[b].last) ,
                        question: listOfKeys[b],
                        answers: listOfValues[b],
                        type: 'dropdown'));

          }

        }
      }



    }
    List <ConditionQuestionsModal> book = Provider.of<DoctorProvider>(context, listen: false).weightedQuestions;


    // Here the code is being rearranged in order of how it should appear

    book.sort((a, b) => a.weight.compareTo(b.weight));

    // Print the sorted list of people

    for (var books in book) {
      print(books.question + ': ' + books.weight.toString()+ ': '+ books.type) ;
    }
    Provider.of<DoctorProvider>(context, listen: false).rearrangeWeigtedQuestions();

    // THIS PIECE OF CODE CREATES AN ARRAY WITH NULL VALUES EQUAL TO THE NUMBER OF QUESTIONS SELECTED. THE NULL WILL BE REPLACED WITH A FINAL ANSWER SELECTED
    Provider.of<DoctorProvider>(context, listen: false).setAnswerBooklet(Provider.of<DoctorProvider>(context, listen: false).weightedQuestions.length);

  }




  var allData = [];
  var checkboxList = [];

  var titleList = [];
  var conclusionList = [];
  var headingList = [];
  var idList= [];
  List<Map> listsList= [];
  var photoList= [];
  var photoSecondList= [];
  var bloodPressureList= [];
  var extraStatementList= [];
  var breathingRateList= [];
  var pulseList= [];
  var photoStatementList= [];
  var photoSecondStatementList= [];
  var picOpacity = [];
  var questionsList  = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clearCheck();

  }

  @override

  Widget build(BuildContext context) {
    // var styleData = Provider.of<StyleProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: kBackgroundGreyColor,
      appBar: AppBar(
        foregroundColor: kPureWhiteColor,
        backgroundColor: kGreenDarkColorOld,
        title: Text(bookingAppointment.tr, style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Icon(LineIcons.stethoscope, color: kGreenThemeColor,),
                  kSmallWidthSpacing,
                  Text(bookingAppointmentQuestion.tr, style: kHeadingExtraLargeTextStyle.copyWith(color: kBlack, fontSize: 15),),
                  kSmallWidthSpacing,
                  Container(color: kFaintGrey, height: 20, width: 1,),
                  kSmallWidthSpacing,
                  Text(bookingAppointmentQuestionFollowup.tr, style: kHeadingExtraLargeTextStyle.copyWith(color: kBlack, fontSize: 15),),
                ],
              ),
              kLargeHeightSpacing,
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(Provider.of<DoctorProvider>(context, listen: false).conditionQuestionCollection) // 'condition_questions'
                    .orderBy('title',descending: false)
                    .where('language', isEqualTo: Provider.of<DoctorProvider>(context, listen: false).conditionLanguage)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {



                    return Center(child: const Text('Loading Conditions', style: kHeading2TextStyleBold,),);
                  } else {
                    checkboxList = [];
                    conclusionList = [];
                    headingList = [];
                    idList = [];
                    listsList = [];
                    photoList = [];
                    photoSecondList = [];
                    bloodPressureList = [];
                    extraStatementList = [];
                    pulseList = [];
                    photoStatementList = [];
                    photoSecondStatementList = [];
                    breathingRateList = [];
                    questionsList = [];
                    titleList = [];

                    var docQuestions = snapshot.data!.docs;
                    for (var question in docQuestions) {
                      checkboxList.add(question.get('checkboxs'));
                      conclusionList.add(question.get('conclusion'));
                      headingList.add(question.get('heading'));
                      idList.add(question.get('id'));
                      listsList.add(question.get('lists'));
                      photoList.add(question.get('photo'));
                      photoSecondList.add(question.get('photoTwo'));
                      pulseList.add(question.get('pulse'));
                      bloodPressureList.add(question.get('bloodPressure'));
                      extraStatementList.add(question.get('extraInputStatement'));
                      breathingRateList.add(question.get('breathingRate'));
                      photoSecondStatementList.add(question.get('photoTwoStatement'));
                      photoStatementList.add(question.get('photoStatement'));
                      questionsList.add(question.get('questions'));
                      titleList.add(question.get('title'));
                      // if(question.get('hasPic')==true){
                      //   picOpacity.add(1.0);
                      // }else {
                      //   picOpacity.add(0.0);
                      // }


                    }
                    // print(checkboxList);

                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: headingList.length,
                      itemBuilder: (context, index){
                        //Provider.of<StyleProvider>(context, listen: false).setRatingsNumber(reviewComment.length);
                        return
                          Card(
                              margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                              shadowColor: kGreenThemeColor,
                              elevation: 2.0,
                              child: GestureDetector(
                                onTap: (){
                                  Provider.of<DoctorProvider>(context, listen: false).dataInAllConditionCleared();

                                  Provider.of<DoctorProvider>(context, listen: false).setConditionStatements(
                                      titleList[index],
                                      headingList[index],
                                      conclusionList[index],
                                      questionsList[index],
                                      listsList[index].keys.toList(),
                                      listsList[index].values.toList(),
                                      photoStatementList[index],
                                      photoList[index],
                                      checkboxList[index].keys.toList(),
                                      checkboxList[index].values.toList(),
                                      photoSecondList[index],
                                      photoSecondStatementList[index],
                                      bloodPressureList[index],
                                      pulseList[index],
                                      extraStatementList[index],
                                    breathingRateList[index]

                                  );


                                  /* Adulterated Code*/

                                  // Firstly clear the data that is saved in the Condition Data


                                  // Secondly add the information here

                                  Provider.of<DoctorProvider>(context, listen: false).addAllDataForCondition(listsList[index]);
                                  Provider.of<DoctorProvider>(context, listen: false).addAllDataForCondition(checkboxList[index]);
                                  Provider.of<DoctorProvider>(context, listen: false).addAllDataForCondition(questionsList[index]);


                                  Provider.of<DoctorProvider>(context, listen: false).resetAnswerValuesForConditions();
                                  Provider.of<DoctorProvider>(context, listen: false)
                                      .setAnswerValuesForCondition(
                                    // 3,
                                      listsList[index].length,
                                      // 3,
                                      checkboxList[index].length,
                                      // 2
                                      questionsList[index].length
                                  );


                                  bringDataTogether();
                                  Navigator.pop(context);
                                  // Navigator.pushNamed(context, ConfirmationPage.id);

                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context)=> ConditionNewArrangement())
                                  );
                                },
                                child: ListTile(
                                  title: Text(titleList[index]),
                                  subtitle: Text(titleList[index]),
                                  trailing: Icon(Icons.forward),

                                  leading: Icon(Icons.sick_outlined, size: 40,),     ),
                              )
                          );
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

