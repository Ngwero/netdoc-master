import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netdoc/Utilities/constants/color_constants.dart';
import 'package:netdoc/Utilities/constants/font_constants.dart';

class CodeValidationScreen extends StatefulWidget {
  @override
  _CodeValidationScreenState createState() => _CodeValidationScreenState();
}

class _CodeValidationScreenState extends State<CodeValidationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final CollectionReference _firestore = FirebaseFirestore.instance.collection('referralCodes');
  var codeString = "";
  Future<void> _checkCode() async {
    String code = _codeController.text;
    QuerySnapshot query = await _firestore
        .where('code', isEqualTo: code).get();

    if (query.docs.isNotEmpty) {
      DocumentSnapshot doc = query.docs.first;
      if (doc['valid']) {
        // Code is valid and not used
        _showPopup('Code Success');
        print('Success');
      } else {
        // Code already used
        _showPopup('Code already used');
      }
    } else {
      // Code does not exist
      _showPopup('Code not Valid');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body:
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
    );
  }
}


