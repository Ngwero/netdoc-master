


import 'package:flutter/material.dart';
import 'package:netdoc/Utilities/constants/color_constants.dart';

class ErrorPage extends StatefulWidget {


  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dangerous_outlined, color: Colors.red, size: 100,),
              Text('Server Error 512', style: TextStyle(fontSize: 20, color: kPureWhiteColor),),
              // ElevatedButton(
              //   onPressed: () {
              //     // Navigator.pop(context);
              //   },
              //   child: Text('Go Back'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
