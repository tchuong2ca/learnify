
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/widgets.dart';

import 'colors.dart';

class CustomDropDownBox extends StatelessWidget {
  final value;
  final List<String> itemsList;
  final Function(dynamic value) onChanged;

  const CustomDropDownBox({
    required this.value,
    required this.itemsList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3, bottom: 3),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(
                color: AppColors.ultraRed
            )
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton2(
                  isExpanded: true,
                  value: value,
                  iconEnabledColor: AppColors.cultured,
                  iconDisabledColor: AppColors.cultured,
                  items: itemsList
                      .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: NeoText(
                      item,
                      textStyle: TextStyle(fontSize: 16, color: AppColors.black),
                    ),
                  ))
                      .toList(),
                  onChanged: (value) => onChanged(value),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  dropdownMaxHeight: MediaQuery.of(context).size.height/2,
                  dropdownWidth: MediaQuery.of(context).size.width/2+25,
                ),
              )
          ),
        ),
      ),
    );
  }
}