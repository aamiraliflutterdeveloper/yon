import 'package:app/common/logger/log.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({Key? key}) : super(key: key);

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> with BaseMixin {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Support', context: context, onTap: () {Navigator.of(context).pop();}),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: med.height * 0.02,
              ),
              Text(
                'Do you have any query?',
                style: CustomAppTheme().normalText.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  'Team YouOnline would like to help you out.',
                  style: CustomAppTheme().normalText.copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              YouOnlineTextField(
                controller: fullNameController,
                headingText: 'Full name',
                hintText: 'Enter full name',
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              YouOnlineTextField(
                controller: emailController,
                headingText: 'Email',
                hintText: 'Enter email',
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              YouOnlineTextField(
                controller: subjectController,
                headingText: 'Subject',
                hintText: 'Enter subject',
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              YouOnlineTextField(
                controller: messageController,
                maxLine: 8,
                headingText: 'Message',
                hintText: 'Detail',
              ),
              SizedBox(
                height: med.height * 0.05,
              ),
              Align(
                alignment: Alignment.topRight,
                child: isSending
                    ? SizedBox(
                        height: med.height * 0.05,
                        width: med.width * 0.44,
                        child: Center(
                          child: CircularProgressIndicator(color: CustomAppTheme().primaryColor),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (fullNameController.text.isNotEmpty &&
                              emailController.text.isNotEmpty &&
                              subjectController.text.isNotEmpty &&
                              messageController.text.isNotEmpty) {
                            submitQuery(
                              fullName: fullNameController.text,
                              email: emailController.text,
                              subject: subjectController.text,
                              message: messageController.text,
                            );
                          } else {
                            helper.showToast('Fill the form properly');
                          }
                        },
                        child: Container(
                          height: med.height * 0.045,
                          width: med.width * 0.4,
                          decoration: BoxDecoration(
                            color: CustomAppTheme().primaryColor,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: CustomAppTheme().primaryColor, width: 1.5),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: Text(
                                'Send',
                                style: CustomAppTheme()
                                    .normalText
                                    .copyWith(color: CustomAppTheme().backgroundColor, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: med.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isSending = false;

  void submitQuery({required String fullName, required String email, required String subject, required String message}) async {
    Dio dio = Dio();
    setState(() {
      isSending = true;
    });
    await dio
        .post(
      '${iExternalValues.getBaseUrl()}api/contact_us/',
      data: {
        'full_name': fullName,
        'email': email,
        'subject': subject,
        'message': message,
      },
      options: Options(
        headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"},
      ),
    )
        .then(
      (value) {
        d('This is response ::: $value');
        if (value.statusCode == 200 || value.statusCode == 201) {
          d('value :::: ${value.data['response']}');
          helper.showToast(value.data['response']);
          Navigator.pop(context);
        }
        setState(() {
          isSending = false;
        });
      },
    );
  }
}
