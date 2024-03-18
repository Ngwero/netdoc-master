import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:netdoc/utilities/constants/word_constants.dart';
import 'package:provider/provider.dart';

import '../models/language_controller.dart';


class LanguageDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(chooseLanguage.tr),
        DropdownButton<String> (
          value:Provider.of<DoctorProvider>(context, listen: false).language, // Current language value
          onChanged: (newValue) {
            // When a language is selected, trigger the changeLanguage function
            LanguageController().changeLanguage(newValue?.split('_')[0], newValue?.split('_')[1]);
            Provider.of<DoctorProvider>(context, listen: false).setDefaultLanguage(newValue!);
          },
          items: <String>[
            'en_US', // English (United States)
            'luganda_UG',    // Luganda
            'french_FR',
            'swahili_KE',
            'tigrinya_ET'// French (France)
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}

