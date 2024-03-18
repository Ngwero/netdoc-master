import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:netdoc/Utilities/constants/font_constants.dart';

import '../Utilities/constants/color_constants.dart';






class doctorButton extends StatelessWidget {
  doctorButton({ required this.continueFunction, required this.title});

  final VoidCallback continueFunction;
  final String title;

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: double.infinity,
        height: 45,
        child: TextButton(onPressed: continueFunction,
          style: TextButton.styleFrom(
            //elevation: ,
              shadowColor:  kBlueDarkColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18), topRight:Radius.circular(18) )
              ),
              backgroundColor: kGreenThemeColor),
          child: Text(title, style: kNormalTextStyle.copyWith(color: kPureWhiteColor),), ),
      );
  }
}