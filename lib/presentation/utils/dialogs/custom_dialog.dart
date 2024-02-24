import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CustomDialog {

 static Future<void> blockAdDialog(
     {required BuildContext context,
      required VoidCallback cancelCallBack,
       required String title,
       required String rightButtonText,
      required VoidCallback blockCallBack}) async {
   Size med = MediaQuery.of(context).size;
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(title, style: CustomAppTheme().normalText.copyWith(
                  fontWeight: FontWeight.w600,
                  color: CustomAppTheme().blackColor)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: cancelCallBack,

                        child: Container(
                          height: med.height * 0.038,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: CustomAppTheme().primaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              child: Text(
                                'Cancel',
                                style: CustomAppTheme().normalText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: blockCallBack,
                          // setState(() {
                          //   isLoading = true;
                          // });
                          // await blockAd(adId).then((value) {
                          //   setState(() {
                          //     isLoading = false;
                          //     Get.back();
                          //     Get.back();
                          //   });
                          // });
                          // Get.back();
                          // Get.back();
                        child: Container(
                          height: med.height * 0.038,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: CustomAppTheme().primaryColor),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              child: Text(
                                rightButtonText,
                                style: CustomAppTheme().normalText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: CustomAppTheme().primaryColor),
                              ),
                            ),
                          )
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }

 static Future<void> showAlertDialog() async{
      Get.dialog(
        barrierDismissible: false,
              const Center(child: CircularProgressIndicator()),
          barrierColor: Colors.white10,
          useSafeArea: true
      );
    }
}



