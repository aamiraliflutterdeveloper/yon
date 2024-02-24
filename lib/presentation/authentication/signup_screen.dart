import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/result.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/auth_res_models/login_res_model.dart';
import 'package:app/data/models/auth_res_models/signUp_res_model.dart';
import 'package:app/domain/entities/auth_entities/platform_entity.dart';
import 'package:app/domain/entities/auth_entities/signup_entities.dart';
import 'package:app/domain/use_case/auth_useCases/googleLogin_usecase.dart';
import 'package:app/domain/use_case/auth_useCases/signUp_usecase.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/authentication/mixins/signup_mixin.dart';
import 'package:app/presentation/authentication/signIn_screen.dart';
import 'package:app/presentation/authentication/terms_and_condition.dart';
import 'package:app/presentation/authentication/verify_email.dart';
import 'package:app/presentation/authentication/view_model/user_view_model.dart';
import 'package:app/presentation/home/home_screen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/social_buttons.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with BaseMixin, SignUpMixin
    implements Result<SignUpResModel> {
  bool isLoading = false;
  bool isFacebookSignUp = false;
  bool isGoogleSignUp = false;

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomAppTheme().backgroundColor,
        body: Form(
          key: signupFormKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: med.height * 0.03,
                    ),
                    Text(
                      'Create Account',
                      style: CustomAppTheme().headingText,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Start buy and sell anything today!',
                        style: CustomAppTheme()
                            .normalGreyText
                            .copyWith(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: med.height * 0.05,
                    ),
                    YouOnlineTextField(
                      headingText: 'Full Name',
                      hintText: 'Enter your name',
                      controller: fullNameController,
                      validator: (value) {
                        return value!.isEmpty ? 'Name cannot be empty' : null;
                      },
                    ),
                    SizedBox(
                      height: med.height * 0.025,
                    ),
                    YouOnlineTextField(
                      headingText: 'Email Address',
                      hintText: 'Enter your email',
                      controller: emailController,
                      validator: (input) => input!.isValidEmail()
                          ? null
                          : "Email format is not correct",
                    ),
                    SizedBox(
                      height: med.height * 0.025,
                    ),
                    YouOnlineTextField(
                      headingText: 'Password',
                      hintText: 'Enter your password',
                      isObscure: true,
                      isSuffix: true,
                      controller: passController,
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Password cannot be empty'
                            : null;
                      },
                    ),
                    SizedBox(
                      height: med.height * 0.025,
                    ),
                    YouOnlineTextField(
                        headingText: 'Confirm Password',
                        hintText: 'Confirm your password',
                        isObscure: true,
                        isSuffix: true,
                        controller: confirmPassController,
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Confirm Password cannot be empty'
                              : null;
                        }),
                    SizedBox(
                      height: med.height * 0.015,
                    ),
                    //Check terms and conditions
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAgree = !isAgree;
                            });
                          },
                          child: Icon(
                            isAgree ? LineIcons.checkSquare : LineIcons.square,
                            color: isAgree
                                ? CustomAppTheme().primaryColor
                                : const Color(0xffa3a8b6),
                            size: 28,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'I agree to ',
                            style: CustomAppTheme().textFieldHeading,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TermsAndCondition()));
                          },
                          child: Text(
                            'terms and conditions',
                            style: CustomAppTheme()
                                .textFieldHeading
                                .copyWith(color: CustomAppTheme().primaryColor),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: med.height * 0.03,
                    ),

                    SizedBox(
                      width: med.width,
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: CustomAppTheme().primaryColor),
                            )
                          : YouOnlineButton(
                              text: 'Sign Up',
                              onTap: () async {
                                if (signupFormKey.currentState!.validate()) {
                                  if (fullNameController.text.isNotEmpty &&
                                      emailController.text.isNotEmpty &&
                                      passController.text.isNotEmpty &&
                                      confirmPassController.text.isNotEmpty) {
                                    if (passController.text.length >= 8) {
                                      if (passController.text ==
                                          confirmPassController.text) {
                                        if (isAgree) {
                                          if (signupFormKey.currentState!
                                              .validate()) {
                                            final createUser =
                                                SignupUseCase(repo);
                                            setState(() {
                                              isLoading = true;
                                            });
                                            final result = await createUser(
                                              SignUpEntities(
                                                fullName:
                                                    fullNameController.text,
                                                email: emailController.text,
                                                password: passController.text,
                                                confirmPass:
                                                    confirmPassController.text,
                                              ),
                                            );
                                            setState(() {
                                              isLoading = false;
                                            });
                                            result.fold((l) => onError(l),
                                                (r) => onSuccess(r));
                                          }
                                        } else {
                                          showOverlay(
                                              'Please agree to terms and conditions!');
                                        }
                                      } else {
                                        showOverlay(
                                            'Confirm password does\'t match with password');
                                      }
                                    } else {
                                      showOverlay(
                                          'Please enter a strong password');
                                    }
                                  } else {
                                    showOverlay(
                                        'Please fill all fields properly');
                                  }
                                }
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>  PinCodeVerificationScreen(emailController.text)));
                              },
                            ),
                    ),

                    SizedBox(
                      height: med.height * 0.02,
                    ),

                    //Divider
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10.0),
                            child: const Divider(
                              color: Colors.black,
                              height: 36,
                            ),
                          ),
                        ),
                        Text(
                          "Or Signup with",
                          style: CustomAppTheme()
                              .normalText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            child: const Divider(
                              color: Colors.black,
                              height: 36,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: med.height * 0.02,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        isFacebookSignUp
                            ? SizedBox(
                                height: med.height * 0.05,
                                width: med.width * 0.44,
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: CustomAppTheme().primaryColor),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  final googleLogin = GoogleLoginUseCase(repo);
                                  setState(() {
                                    isFacebookSignUp = true;
                                  });
                                  final result = await googleLogin(
                                      PlatformEntity(platform: 'Facebook'));
                                  result.fold((error) {
                                    String _error =
                                        ErrorMessage.fromError(error)
                                            .message
                                            .toString();
                                    d('ON ERROR : $_error');
                                    setState(() {
                                      isFacebookSignUp = false;
                                    });
                                    showOverlay('Something went wrong!');
                                  }, (LoginResModel result) {
                                    d('ON SUCCESS : ${result.toString()}');
                                    d('PROFILE : ${result.response!.profile.toString()}');
                                    context
                                        .read<UserViewModel>()
                                        .changeUserData(
                                            result.response!.profile!);
                                    iPrefHelper
                                        .saveUser(result.response!.profile!);
                                    iPrefHelper.saveToken(result
                                        .response!.accessToken
                                        .toString());
                                    iPrefHelper.setIsLoggedIn(true);
                                    d("USER TOKEN : ${iPrefHelper.retrieveToken().toString()}");
                                    d("USER ID : ${iPrefHelper.retrieveUser()?.id.toString()}");
                                    setState(() {
                                      isFacebookSignUp = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()));
                                  });
                                },
                                child: const SocialButton(
                                    iconUrl: 'assets/images/facebookIcon.png',
                                    text: 'Facebook')),
                        isGoogleSignUp
                            ? SizedBox(
                                height: med.height * 0.05,
                                width: med.width * 0.44,
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: CustomAppTheme().primaryColor),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  /*final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    
                            d('GOOGLE : USER : $googleUser');
    
                            final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    
                            final credential = GoogleAuthProvider.credential(
                              accessToken: googleAuth?.accessToken,
                              idToken: googleAuth?.idToken,
                            );*/
                                  final googleLogin = GoogleLoginUseCase(repo);
                                  setState(() {
                                    isGoogleSignUp = true;
                                  });
                                  final result = await googleLogin(
                                      PlatformEntity(platform: 'Google'));
                                  result.fold((error) {
                                    String _error =
                                        ErrorMessage.fromError(error)
                                            .message
                                            .toString();
                                    d('ON ERROR : $_error');
                                    setState(() {
                                      isGoogleSignUp = false;
                                    });
                                    showOverlay('Something went wrong!');
                                  }, (LoginResModel result) {
                                    d('ON SUCCESS : ${result.toString()}');
                                    d('PROFILE : ${result.response!.profile.toString()}');
                                    context
                                        .read<UserViewModel>()
                                        .changeUserData(
                                            result.response!.profile!);
                                    iPrefHelper
                                        .saveUser(result.response!.profile!);
                                    iPrefHelper.saveToken(result
                                        .response!.accessToken
                                        .toString());
                                    iPrefHelper.setIsLoggedIn(true);
                                    d("USER TOKEN : ${iPrefHelper.retrieveToken().toString()}");
                                    d("USER ID : ${iPrefHelper.retrieveUser()?.id.toString()}");
                                    setState(() {
                                      isGoogleSignUp = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()));
                                  });
                                },
                                child: const SocialButton(
                                    iconUrl: 'assets/images/google.png',
                                    text: 'Google'),
                              ),
                      ],
                    ),

                    SizedBox(
                      height: med.height * 0.02,
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Already have an account? ',
                          style: CustomAppTheme().normalText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen()));
                          },
                          child: Text(
                            'Sign in',
                            style: CustomAppTheme().normalText.copyWith(
                                color: CustomAppTheme().primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
  }

  @override
  onSuccess(SignUpResModel result) {
    d('ON SUCCESS : ${result.response!.message.toString()}');
    showOverlay(result.response!.message.toString());
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VerifyEmailScreen(email: emailController.text)));
  }
}
