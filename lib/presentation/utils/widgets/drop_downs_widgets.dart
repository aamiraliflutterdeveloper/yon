import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';

Widget categoryDropDown(
    {required String? categoryDropDownValue,
    required void Function(String?)? onChange,
    required List<String> itemsList}) {
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
            icon: Icon(Icons.keyboard_arrow_down_sharp,
                color: CustomAppTheme().blackColor, size: 16),
            iconEnabledColor: CustomAppTheme().blackColor,
            style: CustomAppTheme().normalText,
            dropdownColor: CustomAppTheme().backgroundColor,
            value: categoryDropDownValue,
            hint: const Text('Select Category'),
            items: itemsList
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

Widget subCategoryDropDown(
    {required String? subCateDropDownValue,
    required void Function(String?)? onChange,
    String? categoryValue,
    required List<String> itemsList}) {
  return Container(
    color: CustomAppTheme().backgroundColor,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomAppTheme().greyColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 10),
        child: IgnorePointer(
          ignoring: categoryValue == null ? true : false,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(Icons.keyboard_arrow_down_sharp,
                  color: CustomAppTheme().blackColor, size: 16),
              iconEnabledColor: CustomAppTheme().blackColor,
              style: CustomAppTheme().normalText,
              dropdownColor: CustomAppTheme().backgroundColor,
              value: subCateDropDownValue,
              hint: const Text('Select Sub Category'),
              items: itemsList
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
    ),
  );
}

Widget brandDropDown(
    {required String? brandDropDownValue,
    String hint = "Select Brand",
    required void Function(String?)? onChange,
    required List<String> itemsList}) {
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
            icon: Icon(Icons.keyboard_arrow_down_sharp,
                color: CustomAppTheme().blackColor, size: 16),
            iconEnabledColor: CustomAppTheme().blackColor,
            style: CustomAppTheme().normalText,
            dropdownColor: CustomAppTheme().backgroundColor,
            value: brandDropDownValue,
            hint: Text(hint),
            items: itemsList
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


Widget conditionDropdown(
    {required String? brandDropDownValue,
      String hint = "Select Condition",
      required void Function(String?)? onChange,
      required List<String> itemsList}) {
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
            icon: Icon(Icons.keyboard_arrow_down_sharp,
                color: CustomAppTheme().blackColor, size: 16),
            iconEnabledColor: CustomAppTheme().blackColor,
            style: CustomAppTheme().normalText,
            dropdownColor: CustomAppTheme().backgroundColor,
            value: brandDropDownValue,
            hint: Text(hint),
            items: itemsList
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