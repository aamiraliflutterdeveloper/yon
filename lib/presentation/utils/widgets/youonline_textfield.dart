import 'package:app/common/logger/log.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YouOnlineTextField extends StatefulWidget {
  final String hintText;
  final String headingText;
  final bool? isObscure;
  final bool? isSuffix;
  final bool? enabled;
  final int? maxLine;
  final bool hasHeading;
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final  List<TextInputFormatter>? inputFormatters;

  const YouOnlineTextField({Key? key, required this.hintText, required this.headingText, this.isObscure = false, this.isSuffix = false, required this.controller, this.validator, this.maxLine = 1, this.keyboardType, this.inputFormatters, this.enabled = true, this.onChanged, this.hasHeading = true}) : super(key: key);

  @override
  State<YouOnlineTextField> createState() => _YouOnlineTextFieldState();
}

class _YouOnlineTextFieldState extends State<YouOnlineTextField> {
  bool obscured = false;

  @override
  void initState() {
    obscured = widget.isObscure!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
       widget.hasHeading == true ? Text(
          widget.headingText,
          style: CustomAppTheme().textFieldHeading,
        ) : const SizedBox.shrink(),
        Padding(
          padding: EdgeInsets.only(top: widget.hasHeading == true ? 5 : 0),
          child: TextFormField(
            onChanged: widget.onChanged,
            controller: widget.controller,
            validator: widget.validator,
            autocorrect: true,
            enabled: widget.enabled!,
            maxLines: widget.maxLine,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            cursorColor: CustomAppTheme().blackColor,
            decoration: InputDecoration(
              errorMaxLines: 1,
              errorBorder:  OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                borderSide: BorderSide(color: CustomAppTheme().redColor),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                borderSide: BorderSide(color: Color(0xffa3a8b6)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                borderSide: BorderSide(color: Color(0xffa3a8b6)),
              ),
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(5, 10, 20, widget.hasHeading == true ? 10 : 3.1),
    prefix: const Padding(
    padding: EdgeInsets.only(left: 15.0)),
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              filled: true,
              fillColor: Colors.white70,
              enabledBorder:  const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                borderSide: BorderSide(color: Color(0xffa3a8b6)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              suffixIconConstraints: BoxConstraints(maxHeight: med.height*0.03, minHeight: med.height*0.03, minWidth: med.width*0.1, maxWidth: med.width*0.1),
              suffixIcon: widget.isSuffix == false
                  ? null
                  : GestureDetector(
                      onTap: () {
                        d('obscured :$obscured');
                        setState(() {
                          obscured = !obscured;
                        });
                      },
                      child: Icon(obscured ? Icons.visibility_off_sharp : Icons.visibility_sharp, color: CustomAppTheme().blackColor, size: 15),
                    ),
            ),
            obscureText: obscured,
          ),
        ),
      ],
    );
  }
}




class YouOnlineNumberField extends StatefulWidget {
  final String hintText;
  final String headingText;
  final bool? isObscure;
  final bool? isSuffix;
  final bool? enabled;
  final bool hasHeading;
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final  List<TextInputFormatter>? inputFormatters;

  const YouOnlineNumberField({Key? key, required this.hintText, required this.headingText, this.isObscure = false, this.isSuffix = false, required this.controller, this.validator, this.keyboardType, this.inputFormatters, this.enabled = true, this.onChanged, this.hasHeading = true}) : super(key: key);

  @override
  State<YouOnlineNumberField> createState() => _YouOnlineNumberFieldState();
}

class _YouOnlineNumberFieldState extends State<YouOnlineNumberField> {
  bool obscured = false;

  @override
  void initState() {
    obscured = widget.isObscure!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Padding(
          padding: EdgeInsets.only(top: widget.hasHeading == true ? 5 : 0),
          child: TextFormField(
            onChanged: widget.onChanged,
            controller: widget.controller,
            validator: widget.validator,
            autocorrect: true,
            enabled: widget.enabled!,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            cursorColor: CustomAppTheme().blackColor,
            decoration: InputDecoration(
              errorBorder:  OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                borderSide: BorderSide(color: CustomAppTheme().redColor),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                borderSide: BorderSide(color: Color(0xffa3a8b6)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                borderSide: BorderSide(color: Color(0xffa3a8b6)),
              ),
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(5, 12, 20, widget.hasHeading == true ? 10 : 3.1),
              prefix: const Padding(
                  padding: EdgeInsets.only(left: 15.0)),
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              filled: true,
              fillColor: Colors.white70,
              enabledBorder:  const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                borderSide: BorderSide(color: Color(0xffa3a8b6)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              suffixIconConstraints: BoxConstraints(maxHeight: med.height*0.03, minHeight: med.height*0.03, minWidth: med.width*0.1, maxWidth: med.width*0.1),
              suffixIcon: widget.isSuffix == false
                  ? null
                  : GestureDetector(
                onTap: () {
                  d('obscured :$obscured');
                  setState(() {
                    obscured = !obscured;
                  });
                },
                child: Icon(obscured ? Icons.visibility_off_sharp : Icons.visibility_sharp, color: CustomAppTheme().blackColor, size: 15),
              ),
            ),
            obscureText: obscured,
          ));
  }
}
