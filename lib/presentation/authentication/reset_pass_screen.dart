import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/domain/entities/auth_entities/reset_pass_entities.dart';
import 'package:app/domain/use_case/auth_useCases/reset_pass_useCase.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/authentication/mixins/login_mixin.dart';
import 'package:app/presentation/authentication/signIn_screen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordScreen({Key? key, required this.email, required this.code})
      : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
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
            title: '',
            onTap: () {Navigator.of(context).pop();},
            context: context,
            bgColor: CustomAppTheme().backgroundColor,
            isTextWhite: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: med.height * 0.03,
                ),
                Text(
                  'Reset Password',
                  style: CustomAppTheme().headingText,
                ),
                SizedBox(
                  height: med.height * 0.05,
                ),
                YouOnlineTextField(
                  headingText: 'New Password',
                  hintText: 'Enter new password',
                  controller: newPassController,
                  isSuffix: true,
                ),
                SizedBox(
                  height: med.height * 0.025,
                ),
                YouOnlineTextField(
                  headingText: 'Confirm Password',
                  hintText: 'confirm password',
                  controller: confirmPassController,
                  isSuffix: true,
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
                          text: 'Submit',
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if (newPassController.text.length < 8) {
                              showOverlay(
                                  'Password length must be greater than 8');
                            } else {
                              if (newPassController.text ==
                                  confirmPassController.text) {
                                final resetPass = ResetPassUseCase(repo);
                                setState(() {
                                  isSubmitting = true;
                                });
                                final result = await resetPass(
                                  ResetPassEntities(
                                    code: widget.code,
                                    email: widget.email,
                                    confirmPassword: confirmPassController.text,
                                    newPassword: newPassController.text,
                                  ),
                                );
                                result.fold((error) {
                                  String _error = ErrorMessage.fromError(error)
                                      .message
                                      .toString();
                                  d('ON ERROR : $_error');
                                  showOverlay(_error);
                                  setState(() {
                                    isSubmitting = false;
                                  });
                                }, (r) {
                                  d('SUCCESS : $r');
                                  showOverlay(r.response!.message.toString());
                                  setState(() {
                                    isSubmitting = false;
                                  });
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInScreen()));
                                });
                              } else {
                                showOverlay(
                                    'New password and confirm password does\'t match');
                              }
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
