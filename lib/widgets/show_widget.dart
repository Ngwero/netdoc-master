
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:share_plus/share_plus.dart';


import '../Utilities/constants/color_constants.dart';
import '../Utilities/constants/font_constants.dart';


ShowDialogBoxWindow(context, heading){







  return showDialog(context: context,barrierLabel: 'Items', builder: (context){


    return Center(
      //heightFactor: 300,

        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Material(
            elevation: 10.0,

            type: MaterialType.transparency,
            child:

            Container(

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
              ),
              padding: EdgeInsets.all(15),
              width:  MediaQuery.of(context).size.width,
              height: 800,
              // result.length < 100 ? 500 : 600,
              child:
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Flexible(
                      fit: FlexFit.loose,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(heading, overflow: TextOverflow.ellipsis, style:kHeading2TextStyleBold.copyWith(color: kBlack, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                          kSmallWidthSpacing,
                          kSmallWidthSpacing,


                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(

                      height: 500,
                      // result.length < 100 ? 80 : 200,
                      child:
                      ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Text('Your Call Has Ended', style: kNormalTextStyle.copyWith(fontSize: 16),);
                        },
                      ),
                    ),

                    const SizedBox(height: 10,),
                    TextButton(onPressed: (){
                      Navigator.pop(context);

                    }, child: Text('Cancel', style: kNormalTextStyle.copyWith(color: kGreenThemeColor),))

                  ]),
            ),
          ),
        ));

  });
}