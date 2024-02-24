import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget stateDropDown({required String? stateDropDownValue, required void Function(String?)? onChange, required BuildContext context}) {
  return Container(
    color: CustomAppTheme().backgroundColor,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomAppTheme().greyColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            icon: Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16),
            iconEnabledColor: CustomAppTheme().blackColor,
            style: CustomAppTheme().normalText,
            hint: const Text('Select State'),
            dropdownColor: CustomAppTheme().backgroundColor,
            value: stateDropDownValue,
            items: context
                .read<GeneralViewModel>()
                .allStates
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: <Widget>[
                          Text(value),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: onChange,
          ),
        ),
      ),
    ),
  );
}

Widget cityDropDown({required String? cityDropDownValue, required void Function(String?)? onChange, required BuildContext context}) {
  return Container(
    color: CustomAppTheme().backgroundColor,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomAppTheme().greyColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            icon: Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16),
            iconEnabledColor: CustomAppTheme().blackColor,
            hint: const Text('Select City'),
            style: CustomAppTheme().normalText,
            dropdownColor: CustomAppTheme().backgroundColor,
            value: cityDropDownValue,
            items: context
                .read<GeneralViewModel>()
                .allCities
                .map((String value) => DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: <Widget>[
                          Text(value),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: onChange,
          ),
        ),
      ),
    ),
  );
}
