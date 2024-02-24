import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final GestureTapCallback? onTap;
  final bool? isEnabled;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  const RoundedTextField(
      {Key? key,
      this.hintText,
      this.icon,
      this.onChanged,
      this.iconColor = Colors.white,
      this.backgroundColor = Colors.blueAccent,
      this.controller,
      this.onTap,
      this.isEnabled = true,
      this.onFieldSubmitted,
      this.onSaved})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: CustomAppTheme().backgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0.3,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        onTap: onTap,
        onFieldSubmitted: onFieldSubmitted,
        onSaved: onSaved,
        autocorrect: true,
        enabled: isEnabled,
        onChanged: onChanged,
        cursorColor: CustomAppTheme().blackColor,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          prefixIconConstraints:
              BoxConstraints(maxHeight: med.height * 0.03, minHeight: med.height * 0.03, minWidth: med.width * 0.1, maxWidth: med.width * 0.1),
          prefixIcon: Icon(Icons.search_rounded, color: CustomAppTheme().blackColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          isDense: true,
          hintText: 'What are you looking for?',
          hintStyle: CustomAppTheme().normalGreyText.copyWith(fontSize: 12, color: Colors.grey),
          filled: true,
          fillColor: Colors.white70,
        ),
      ),
    );
  }
}
