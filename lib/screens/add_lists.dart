import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netdoc/models/ConditionQuestions.dart';
import 'package:provider/provider.dart';

import '../Utilities/InputFieldWidget.dart';
import '../Utilities/constants/color_constants.dart';
import '../Utilities/constants/font_constants.dart';
import '../models/doctor_provider.dart';
import '../widgets/order_contents.dart';

class AddLists extends StatefulWidget {
  const AddLists({Key? key}) : super(key: key);

  @override
  State<AddLists> createState() => _AddListsState();
}

class _AddListsState extends State<AddLists> {
  var serviceName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kGreenDarkColorOld,foregroundColor: kPureWhiteColor,),
      body: SingleChildScrollView(
        child: Column(

            children: [
              Provider.of<DoctorProvider>(context, listen: false).formListQuestion == '' ?
              Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text("New List Question", textAlign: TextAlign.start,
                      style: kHeading3TextStyleBold.copyWith(fontSize: 16,),),
                  ),
                  SizedBox(
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        InputFieldWidget(labelText: ' List Question',
                          hintText: 'List question goes here',
                          keyboardType: TextInputType.text,
                          onTypingFunction: (value) {
                            serviceName = value;
                            Provider.of<DoctorProvider>(context, listen: false).setListMainQuestion(serviceName);
                          }, onFinishedTypingFunction: () {  },
                        ),
                      ],
                    ),
                  ),

                ],
              ) : Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: Container(
                  child: Text('${Provider.of<DoctorProvider>(context, listen: false).formListQuestion}',
                    style: kHeading2TextStyle,),
                ),
              ),



              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    if ( serviceName == ''){
                    }else{
                      var question = '';

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
                                        question = enteredQuestion;
                                        // instructions = customerName;
                                        // setState(() {
                                        // });
                                      },
                                      decoration: InputDecoration(
                                        // border: InputBorder.none,
                                          labelText: 'Answers',
                                          labelStyle: kNormalTextStyleExtraSmall,
                                          hintText: 'Select this',
                                          hintStyle: kNormalTextStyle
                                      ) ,
                                    ),
                                  ],
                                ),
                              )
                          ),
                          // text: 'Enter customers details',
                          title: 'Add List Answer',
                          confirmBtnText: 'Ok',
                          confirmBtnColor: Colors.green,
                          backgroundColor: kBlueDarkColor,
                          onConfirmBtnTap: (){

                            Provider.of<DoctorProvider>(context, listen:false).setFormList(question);
                            // if (bookingButtonName == 'Book'){
                            //   Provider.of<StyleProvider>(context, listen:false).setPaymentStatus('Submitted');
                            //   Navigator.pushNamed(context, CalendarPage.id);
                            // } else {
                            //   Provider.of<StyleProvider>(context, listen:false).setPaymentStatus('Paid');
                            //   Navigator.pushNamed(context, SuccessPage.id);
                            //
                            Navigator.pop(context);
                            setState(() {

                            });
                          }
                      );

                    }
                  },

                  child: CircleAvatar(
                    backgroundColor: kGreenThemeColor,
                    radius: 35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: kPureWhiteColor,size: 15,),
                        Text("Answers", textAlign: TextAlign.center,style: kNormalTextStyleExtraSmall.copyWith(color: kPureWhiteColor),)
                      ],
                    ),
                  ),
                ),
              ),
              kSmallHeightSpacing,
              ListView.builder(

                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Provider.of<DoctorProvider>(context, listen: false).formListQuestionsAnswers.length,
                  itemBuilder: (context, i){
                    return
                      OrderedContentsWidget(
                        fontSize: 15,

                        orderIndex: i + 1,
                        productDescription: '1',
                        productName: Provider.of<DoctorProvider>(context, listen: false).formListQuestionsAnswers[i],
                      );
                  }),
              kLargeHeightSpacing,
              kLargeHeightSpacing,
              kLargeHeightSpacing,
              kLargeHeightSpacing,
              kLargeHeightSpacing,
              kLargeHeightSpacing,
              kLargeHeightSpacing,
              kLargeHeightSpacing,
              kLargeHeightSpacing,
              kLargeHeightSpacing,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kGreenDarkColorOld,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  Provider.of<DoctorProvider>(context, listen: false).setUploadLists(ConditionQuestion(answers:
                  Provider.of<DoctorProvider>(context, listen: false).formListQuestionsAnswers.join(", "),
                      question: Provider.of<DoctorProvider>(context, listen: false).formListQuestion));
                  Navigator.pop(context);
                },

                child:  Text('Add Info', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),)
            ]),
      ),
    );
  }


}
