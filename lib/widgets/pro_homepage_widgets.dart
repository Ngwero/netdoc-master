



import 'package:flutter/material.dart';
import 'package:netdoc/Utilities/constants/color_constants.dart';
import 'package:netdoc/Utilities/constants/font_constants.dart';

class ProCustomWidget extends StatelessWidget {
  final String title;
  final IconData firstContainerIcon;
  final String firstContainerTitle;
  final IconData secondContainerIcon;
  final String secondContainerTitle;
  final String firstContainerPageRoute;
  final String secondContainerPageRoute;
  final Function onPressedFirst;
  final Function onPressedSecond;

  ProCustomWidget({
    required this.title,
    required this.firstContainerIcon,
    required this.firstContainerTitle,
    required this.secondContainerIcon,
    required this.secondContainerTitle,
    required this.firstContainerPageRoute,
    required this.secondContainerPageRoute,
    required this.onPressedFirst,
    required this.onPressedSecond,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          textAlign: TextAlign.start,
          style: kNormalTextStyle.copyWith(fontWeight: FontWeight.w600, color: kBlack, fontSize: 18)
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRoundedContainer(
              firstContainerIcon,
              firstContainerTitle,
              firstContainerPageRoute,
              onPressedFirst,
            ),
            _buildRoundedContainer(
              secondContainerIcon,
              secondContainerTitle,
              secondContainerPageRoute,
              onPressedSecond,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundedContainer(
      IconData icon,
      String title,
      String pageRoute,
      Function onPressed,
      ) {
    return InkWell(
      onTap: () {
        onPressed();
        // Navigator.pushNamed(context, pageRoute);
      },
      child: Container(
        width: 140,
        height: 140,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: kGreenThemeColor,
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: kNormalTextStyle
            ),
          ],
        ),
      ),
    );
  }
}

