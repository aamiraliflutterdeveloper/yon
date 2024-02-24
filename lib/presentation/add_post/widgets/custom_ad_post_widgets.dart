import 'package:app/common/logger/log.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget currencyDropDown({required String? currencyDropDownValue, required void Function(String?)? onChange, required BuildContext context}) {
  currencyDropDownValue ?? '';
  return Container(
    height: MediaQuery.of(context).size.height * 0.047,
    color: CustomAppTheme().backgroundColor,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomAppTheme().greyColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            icon: Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16),
            iconEnabledColor: CustomAppTheme().blackColor,
            style: CustomAppTheme().normalText,
            dropdownColor: CustomAppTheme().backgroundColor,
            value: currencyDropDownValue,
            items: context
                .read<GeneralViewModel>()
                .currenciesList
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

Widget makeDropDown({
  required List<String> itemsList,
  String? makeDropDownValue, required void Function(String?)? onChange, required BuildContext context}) {
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
            hint: const Text('Select Make'),
            dropdownColor: CustomAppTheme().backgroundColor,
            value: makeDropDownValue,
            items: context
                .read<AutomotiveViewModel>()
                .automotiveBrandsList!
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

Widget modelDropDown({String? modelDropDownValue, required void Function(String?)? onChange, required BuildContext context}) {
  d('THIS IS MODEL DROPDOWNVALUE : $modelDropDownValue');
  d('Model dropdown list: ${context.read<AutomotiveViewModel>().automotiveModelsByBrandList!}');
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
            hint: const Text('Select Model'),
            dropdownColor: CustomAppTheme().backgroundColor,
            value: modelDropDownValue,
            items: context
                .read<AutomotiveViewModel>()
                .automotiveModelsByBrandList!
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

Widget countryCodeDropDown({required String? countryCodeDropDownValue, required void Function(String?)? onChange, required BuildContext context}) {
  countryCodeDropDownValue ?? '';
  return Container(
    color: CustomAppTheme().backgroundColor,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomAppTheme().greyColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            icon: Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16),
            iconEnabledColor: CustomAppTheme().blackColor,
            style: CustomAppTheme().normalText,
            dropdownColor: CustomAppTheme().backgroundColor,
            value: countryCodeDropDownValue,
            items: context
                .read<GeneralViewModel>()
                .countriesCode
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

Widget countryDropDown({required String? countryCodeDropDownValue, required void Function(String?)? onChange, required BuildContext context}) {
  countryCodeDropDownValue ?? '';
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
            hint: const Text('Select Country'),
            dropdownColor: CustomAppTheme().backgroundColor,
            value: countryCodeDropDownValue,
            items: context
                .read<GeneralViewModel>()
                .countries
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

Widget businessCategoryDropDown({required String? businessCategoryValue, required void Function(String?)? onChange, required BuildContext context}) {
  businessCategoryValue ?? '';
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
            hint: const Text('Select Business Category'),
            dropdownColor: CustomAppTheme().backgroundColor,
            value: businessCategoryValue,
            items: <String>['Classified', 'Automotive', 'Property', 'Job']
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
