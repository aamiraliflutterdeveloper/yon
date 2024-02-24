import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';

class FilterRangeTextField extends StatefulWidget {
  final String suffixText;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  const FilterRangeTextField(
      {Key? key,
      required this.suffixText,
      required this.hintText,
      this.controller,
      this.onChanged,
      this.textInputType})
      : super(key: key);

  @override
  State<FilterRangeTextField> createState() => _FilterRangeTextFieldState();
}

class _FilterRangeTextFieldState extends State<FilterRangeTextField> {
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return TextFormField(
      autocorrect: true,
      onChanged: widget.onChanged,
      controller: widget.controller,
      cursorColor: CustomAppTheme().blackColor,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Color(0xffa3a8b6)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Color(0xffa3a8b6)),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.white70,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Color(0xffa3a8b6)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIconConstraints: BoxConstraints(
            maxHeight: med.height * 0.03,
            minHeight: med.height * 0.03,
            minWidth: med.width * 0.14,
            maxWidth: med.width * 0.14),
        suffixIcon: Center(
            child: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text(widget.suffixText),
        )),
      ),
    );
  }
}
