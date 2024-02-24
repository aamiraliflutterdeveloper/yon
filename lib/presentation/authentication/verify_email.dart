import 'dart:async';

import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/result.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/auth_res_models/verify_email_res_model.dart';
import 'package:app/domain/entities/auth_entities/resendCode_entities.dart';
import 'package:app/domain/entities/auth_entities/verify_email_entities.dart';
import 'package:app/domain/use_case/auth_useCases/resendCode_usecase.dart';
import 'package:app/domain/use_case/auth_useCases/veryifyEmail_usecase.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/authentication/mixins/signup_mixin.dart';
import 'package:app/presentation/authentication/reset_pass_screen.dart';
import 'package:app/presentation/authentication/signIn_screen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyEmailScreen extends StatefulWidget {
  final bool isForgotPass;
  final String email;

  const VerifyEmailScreen({required this.email, this.isForgotPass = false});

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with BaseMixin, SignUpMixin
    implements Result<VerifyEmailResModel> {
  late TapGestureRecognizer onTapRecognizer;
  late TapGestureRecognizer onResendRecognizer;

  TextEditingController pinCodeController = TextEditingController();

  late StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  final signupFormKey = GlobalKey<FormState>();

  late Timer _timer;
  int _start = 45;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void resendCode() async {
    startTimer();
    setState(() {
      _start = 45;
    });
    final resendCode = ResendCodeUseCase(repo);
    final result = await resendCode(ResendCodeEntities(email: widget.email));
    result.fold((error) {
      String _error = ErrorMessage.fromError(error).message.toString();
      d('ON ERROR : $_error');
      showOverlay(_error);
    }, (result) {
      d('ON SUCCESS : ${result.toString()}');
      showOverlay(result.response!.message.toString());
    });
  }

  bool isSubmitting = false;

  @override
  void initState() {
    startTimer();
    onTapRecognizer = TapGestureRecognizer()..onTap = () {};
    errorController = StreamController<ErrorAnimationType>();

    onResendRecognizer = TapGestureRecognizer()
      ..onTap = () {
        resendCode();
      };

    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: customAppBar(title: '', context: context, onTap: () {Navigator.of(context).pop();}),
        backgroundColor: CustomAppTheme().backgroundColor,
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: med.height * 0.03),
                  Center(
                    child: SvgPicture.asset(
                      'assets/svgs/verify_email.svg',
                      height: MediaQuery.of(context).size.height * 0.22,
                      width: med.width * 0.55,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: med.height * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Email Verification',
                      style: CustomAppTheme().headingText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8),
                    child: RichText(
                      text: TextSpan(
                        text:
                            "We send a text message with 4 digit code to your ",
                        children: [
                          TextSpan(
                            text: widget.email,
                            style: CustomAppTheme().normalGreyText.copyWith(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                        style: CustomAppTheme()
                            .normalGreyText
                            .copyWith(fontSize: 14),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: med.height * 0.05),
                  SizedBox(
                    width: med.width * 0.65,
                    child: Form(
                      key: signupFormKey,
                      child: PinCodeTextField(
                        showCursor: true,
                        hintCharacter: '-',
                        hintStyle: CustomAppTheme().normalGreyText,
                        appContext: context,
                        pastedTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        length: 4,
                        obscureText: false,
                        obscuringCharacter: '*',
                        animationType: AnimationType.fade,
                        // validator: (v) {
                        //   if (v!.length < 4) {
                        //     return "Enter 4 digit pin code";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        pinTheme: PinTheme(
                          // activeColor: CustomAppTheme().greyColor,
                          // inactiveColor: CustomAppTheme().greyColor,
                          inactiveFillColor: CustomAppTheme().backgroundColor,
                          selectedFillColor: CustomAppTheme().backgroundColor,
                          // disabledColor: CustomAppTheme().backgroundColor,
                          // errorBorderColor: CustomAppTheme().redColor,
                          selectedColor: CustomAppTheme().greyColor,
                          borderWidth: 0.6,
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: med.height * 0.055,
                          fieldWidth: med.width * 0.12,
                          activeFillColor: hasError
                              ? CustomAppTheme().backgroundColor
                              : Colors.white,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        textStyle: const TextStyle(fontSize: 20, height: 1.6),
                        backgroundColor: CustomAppTheme().backgroundColor,
                        enableActiveFill: true,
                        errorAnimationController: errorController,
                        controller: pinCodeController,
                        keyboardType: TextInputType.number,
                        onCompleted: (v) {
                          print("Completed");
                        },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          return true;
                        },
                      ),
                    ),
                  ),
                  _start == 0
                      ? RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Didn't received the code? ",
                            style: CustomAppTheme()
                                .normalGreyText
                                .copyWith(fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Resend',
                                recognizer: onResendRecognizer,
                                style: CustomAppTheme().normalGreyText.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: CustomAppTheme().primaryColor),
                              ),
                            ],
                          ),
                        )
                      : RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Resend code in ",
                            style: CustomAppTheme()
                                .normalGreyText
                                .copyWith(fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                text: _start.toString() + 's',
                                recognizer: onTapRecognizer,
                                style: CustomAppTheme().normalGreyText.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: CustomAppTheme().blackColor),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: med.height * 0.05),
                  SizedBox(
                    width: med.width,
                    child: isSubmitting
                        ? Center(
                            child: CircularProgressIndicator(
                                color: CustomAppTheme().primaryColor),
                          )
                        : YouOnlineButton(
                            onTap: widget.isForgotPass
                                ? () async {
                                    FocusScope.of(context).unfocus();
                                    signupFormKey.currentState!.validate();
                                    if (currentText.length != 4) {
                                      errorController
                                          .add(ErrorAnimationType.shake);
                                      setState(() => hasError = true);
                                    } else {
                                      setState(
                                        () {
                                          hasError = false;
                                        },
                                      );
                                      final verifyCode =
                                          VerifyEmailUseCase(repo);
                                      setState(() {
                                        isSubmitting = true;
                                      });
                                      final result = await verifyCode(
                                          VerifyEmailEntities(
                                              email: widget.email,
                                              code: pinCodeController.text));
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
                                          setState(() {
                                            isSubmitting = false;
                                          });
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ResetPasswordScreen(
                                                email: widget.email,
                                                code: pinCodeController.text,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }
                                : () async {
                                    signupFormKey.currentState!.validate();
                                    if (currentText.length != 4) {
                                      errorController
                                          .add(ErrorAnimationType.shake);
                                      setState(() => hasError = true);
                                    } else {
                                      setState(
                                        () {
                                          hasError = false;
                                        },
                                      );
                                      final verifyCode =
                                          VerifyEmailUseCase(repo);
                                      setState(() {
                                        isSubmitting = true;
                                      });
                                      final result = await verifyCode(
                                          VerifyEmailEntities(
                                              email: widget
                                                  .email /* widget.phoneNumber*/,
                                              code: pinCodeController.text));
                                      result.fold((l) => onError(l),
                                          (r) => onSuccess(r));
                                    }
                                  },
                            text: 'Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  onError(Failure error) {
    String _error = ErrorMessage.fromError(error).message.toString();
    d('ON ERROR : $_error');
    showOverlay(_error);
    setState(() {
      isSubmitting = false;
    });
  }

  @override
  onSuccess(VerifyEmailResModel result) {
    d('ON SUCCESS : ${result.response!.data.toString()}');
    setState(() {
      isSubmitting = false;
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignInScreen()));
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const HomeScreen()), (route) => false);
  }
}
