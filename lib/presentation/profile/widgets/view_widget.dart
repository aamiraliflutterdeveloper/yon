
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';

Widget viewWidget({required String heading, required String text}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text(heading,
        style: CustomAppTheme().headingText.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(text,
          style: CustomAppTheme().normalGreyText.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}