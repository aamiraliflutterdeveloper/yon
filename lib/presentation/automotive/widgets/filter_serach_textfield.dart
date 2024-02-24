import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';

class FilterSearchTextField extends StatelessWidget {
  const FilterSearchTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          // BoxShadow(
          //   color: Colors.black.withOpacity(0.2),
          //   spreadRadius: 0.2,
          //   blurRadius: 2,
          //   offset: const Offset(0, 2), // changes position of shadow
          // ),
        ],
      ),
      child: TextFormField(
        autocorrect: true,
        cursorColor: CustomAppTheme().blackColor,
        decoration: InputDecoration(
          errorBorder:  const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            borderSide: BorderSide(color: Color(0xffa3a8b6)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            borderSide: BorderSide(color: Color(0xffa3a8b6)),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          hintText: 'Search brands or model',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: CustomAppTheme().backgroundColor,
          enabledBorder:  const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            borderSide: BorderSide(color: Color(0xffa3a8b6)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          suffixIcon: Icon(Icons.search, color: CustomAppTheme().blackColor),
        ),
      ),
    );
  }
}
