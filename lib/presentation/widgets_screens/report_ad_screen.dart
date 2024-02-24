import 'package:app/common/logger/log.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReportAdScreen extends StatefulWidget {
  final String adId;
  final String moduleName;
  const ReportAdScreen({Key? key, required this.adId, required this.moduleName})
      : super(key: key);

  @override
  State<ReportAdScreen> createState() => _ReportAdScreenState();
}

class _ReportAdScreenState extends State<ReportAdScreen> with BaseMixin {
  TextEditingController commentController = TextEditingController();
  String selectedReportOption = '';
  List<String> reportOptions = [
    'Offensive content',
    'Fraud',
    'Duplicate ad',
    'Product already sold',
    'Other'
  ];

  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        // height: med.height * 0.6,
        width: med.width,
        decoration: BoxDecoration(
          color: CustomAppTheme().backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: med.height * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
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
                      child: Icon(Icons.arrow_back_ios_rounded,
                          size: 17, color: CustomAppTheme().blackColor),
                    ),
                  ),
                  Text(
                    'Report ad',
                    style: CustomAppTheme()
                        .normalText
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.transparent,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 17,
                      color: Colors.transparent,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              ListView.builder(
                itemCount: reportOptions.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, reportIndex) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter seState) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: reportOptionWidget(
                            title: reportOptions[reportIndex]),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              YouOnlineTextField(
                hintText: '',
                headingText: 'Comment',
                controller: commentController,
                maxLine: 4,
              ),
              const Spacer(),
              isSending
                  ? Center(
                      child: CircularProgressIndicator(
                          color: CustomAppTheme().primaryColor),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: med.height * 0.045,
                            width: med.width * 0.4,
                            decoration: BoxDecoration(
                              color: CustomAppTheme().backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: CustomAppTheme().primaryColor,
                                  width: 1.5),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Text(
                                  'Cancel',
                                  style: CustomAppTheme().normalText.copyWith(
                                      color: CustomAppTheme().primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            reportAd(
                                id: widget.adId,
                                module: widget.moduleName,
                                message: commentController.text,
                                reportType: selectedReportOption);
                          },
                          child: Container(
                            height: med.height * 0.045,
                            width: med.width * 0.4,
                            decoration: BoxDecoration(
                              color: CustomAppTheme().primaryColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: CustomAppTheme().primaryColor,
                                  width: 1.5),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Text(
                                  'Send',
                                  style: CustomAppTheme().normalText.copyWith(
                                      color: CustomAppTheme().backgroundColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget reportOptionWidget({required String title}) {
    Size med = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          d('selectedReportOption ## $selectedReportOption');
          selectedReportOption = title;
        });
      },
      child: Row(
        children: <Widget>[
          Icon(
            selectedReportOption != title
                ? Icons.circle_outlined
                : Icons.circle,
            color: CustomAppTheme().darkGreyColor,
          ),
          SizedBox(
            width: med.width * 0.02,
          ),
          Text(
            title,
            style: CustomAppTheme()
                .normalText
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void reportAd(
      {required String id,
      required String module,
      required String reportType,
      required String message}) async {
    Dio dio = Dio();
    setState(() {
      isSending = true;
    });
    d('This is ad id ::: $id');
    await dio
        .post(
      '${iExternalValues.getBaseUrl()}api/report_ads/',
      data: {
        'id': id,
        'module_name': module,
        'report_type': reportType,
        'message': message,
      },
      options: Options(
        headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"},
      ),
    )
        .then(
      (value) {
        d('Status Code : ${value.statusCode}');
        d('VALUE : $value');
        setState(() {
          isSending = false;
        });
        if (value.statusCode == 200 || value.statusCode == 201) {
          helper.showToast(value.data['response']['message']);
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
