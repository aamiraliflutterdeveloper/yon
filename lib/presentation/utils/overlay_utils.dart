import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class OverlyHelper {
  showToast(String msg) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0);

  showLongToast(String msg) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 7,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0);

  Widget showLoader() => Container(
        color: Colors.limeAccent,
        child: Lottie.asset(
          'assets/lottieFiles/loader.json',
          // width: 60,
          // height: 60,
          fit: BoxFit.fill,
        ),
      );
}
