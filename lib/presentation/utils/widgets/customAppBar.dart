import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar({Widget? actionWidget, required GestureTapCallback onTap, required final String title, final bool isTextWhite = false, required final BuildContext context, final Color? bgColor =  Colors.white}){
  return AppBar(
    centerTitle: true,
    backgroundColor: bgColor,
    elevation: 0.0,
    title: Text(
      title,
      style: CustomAppTheme().headingText.copyWith(fontSize: 20, color: isTextWhite ? CustomAppTheme().backgroundColor : CustomAppTheme().blackColor),
    ),
    leading: Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: onTap,
        // onTap: (){
        //   Navigator.of(context).pop();
        // },
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: CustomAppTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.3,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(Icons.arrow_back_ios_rounded, size: 15, color: CustomAppTheme().blackColor),
        ),
      ),
    ),
    actions: <Widget>[
      actionWidget ?? const SizedBox.shrink(),
    ],
  );
}