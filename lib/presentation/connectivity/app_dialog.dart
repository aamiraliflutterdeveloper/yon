import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

showDialog() {
  return Get.defaultDialog(
      titlePadding: EdgeInsets.zero,
      titleStyle: const TextStyle(inherit: false),
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: [
          SizedBox(height: Get.height / 6, width: Get.height / 6, child: Lottie.asset('assets/lottieFiles/noInternet.json')),
          SizedBox(
            height: Get.height / 30,
          ),
          Text(
            'Connection Error',
            style: CustomAppTheme().normalText,
          ),
          SizedBox(
            height: Get.height / 50,
          ),
          YouOnlineButton(
              text: 'Try Again',
              onTap: () {
                Get.back();
              }),
          SizedBox(
            height: Get.height / 100,
          ),
        ],
      ));
}

hideDialog() {
  Get.isDialogOpen! ? Get.back() : null;
}
