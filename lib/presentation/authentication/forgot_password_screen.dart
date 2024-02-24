import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/domain/entities/auth_entities/resendCode_entities.dart';
import 'package:app/domain/use_case/auth_useCases/resendCode_usecase.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/authentication/mixins/login_mixin.dart';
import 'package:app/presentation/authentication/mixins/signup_mixin.dart';
import 'package:app/presentation/authentication/verify_email.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with LoginMixin, BaseMixin {
  bool isSubmitting = false;
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomAppTheme().backgroundColor,
        appBar: customAppBar(
            title: 'Forgot Password',
            context: context,
            bgColor: CustomAppTheme().backgroundColor,
            isTextWhite: true, onTap: () {Navigator.of(context).pop();}),
        body: SingleChildScrollView(
          child: Form(
            key: forPassEmailFormKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: med.height * 0.03,
                  ),
                  Text(
                    'Forgot Password?',
                    style: CustomAppTheme().headingText,
                  ),
                  SizedBox(
                    height: med.height * 0.05,
                  ),
                  YouOnlineTextField(
                    headingText: 'Email Address',
                    hintText: 'Enter your email',
                    controller: forgotPassEmailController,
                    validator: (input) => input!.isValidEmail()
                        ? null
                        : "Email format is not correct",
                  ),
                  SizedBox(
                    height: med.height * 0.05,
                  ),
                  SizedBox(
                    width: med.width,
                    child: isSubmitting
                        ? Center(
                            child: CircularProgressIndicator(
                                color: CustomAppTheme().primaryColor),
                          )
                        : YouOnlineButton(
                            text: 'Send OTP',
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              if (forgotPassEmailController.text.isNotEmpty) {
                                if (forPassEmailFormKey.currentState!
                                    .validate()) {
                                  final sendCode = ResendCodeUseCase(repo);
                                  setState(() {
                                    isSubmitting = true;
                                  });
                                  final result = await sendCode(
                                      ResendCodeEntities(
                                          email:
                                              forgotPassEmailController.text));
                                  result.fold(
                                    (error) {
                                      String _error =
                                          ErrorMessage.fromError(error)
                                              .message
                                              .toString();
                                      d('ON ERROR : $_error');
                                      showOverlay(_error);
                                      setState(() {
                                        isSubmitting = false;
                                      });
                                    },
                                    (r) {
                                      d('ON SUCCESS : ${r.toString()}');
                                      showOverlay(
                                          r.response!.message.toString());
                                      setState(() {
                                        isSubmitting = false;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VerifyEmailScreen(
                                            email:
                                                forgotPassEmailController.text,
                                            isForgotPass: true,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              } else {
                                showOverlay('Please Enter Email');
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
