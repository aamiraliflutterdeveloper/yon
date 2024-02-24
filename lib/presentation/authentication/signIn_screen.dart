import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/result.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/auth_res_models/login_res_model.dart';
import 'package:app/domain/entities/auth_entities/login_entities.dart';
import 'package:app/domain/entities/auth_entities/platform_entity.dart';
import 'package:app/domain/entities/auth_entities/resendCode_entities.dart';
import 'package:app/domain/use_case/auth_useCases/googleLogin_usecase.dart';
import 'package:app/domain/use_case/auth_useCases/login_usecase.dart';
import 'package:app/domain/use_case/auth_useCases/resendCode_usecase.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/authentication/forgot_password_screen.dart';
import 'package:app/presentation/authentication/mixins/login_mixin.dart';
import 'package:app/presentation/authentication/mixins/signup_mixin.dart';
import 'package:app/presentation/authentication/signup_screen.dart';
import 'package:app/presentation/authentication/verify_email.dart';
import 'package:app/presentation/authentication/view_model/user_view_model.dart';
import 'package:app/presentation/home/home_screen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/social_buttons.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with LoginMixin, BaseMixin
    implements Result<LoginResModel> {
  bool isSigning = false;
  bool isGoogleSignUp = false;
  bool isFacebookSignUp = false;

  @override
  Widget build(BuildContext context) {
    final UserViewModel userViewModel = context.watch<UserViewModel>();
    // UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    Size med = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomAppTheme().backgroundColor,
        body: Form(
          key: signInFormKey,
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
                      'SignIn',
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
                      controller: passController,
                      isObscure: true,
                      isSuffix: true,
                      validator: (value) {
                        return value!.isEmpty ? 'Password cannot be empty' : null;
                      },
                    ),
    
                    SizedBox(
                      height: med.height * 0.015,
                    ),
    
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen()));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: CustomAppTheme().normalText.copyWith(
                              color: CustomAppTheme().primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
    
                    SizedBox(
                      height: med.height * 0.05,
                    ),
    
                    SizedBox(
                      width: med.width,
                      child: isSigning
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: CustomAppTheme().primaryColor),
                            )
                          : YouOnlineButton(
                              text: 'Sign In',
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                if (signInFormKey.currentState!.validate()) {
                                  if (emailController.text.isNotEmpty &&
                                      passController.text.isNotEmpty) {
                                    if (signInFormKey.currentState!.validate()) {
                                      final login = LoginUseCase(repo);
                                      setState(() {
                                        isSigning = true;
                                      });
                                      final result = await login(
                                        LoginEntities(
                                          email: emailController.text,
                                          password: passController.text,
                                        ),
                                      );
                                      result.fold(
                                          (l) => onError(l), (r) => onSuccess(r));
                                    }
                                  } else {
                                    showOverlay(
                                        'Please fill all fields properly');
                                  }
                                }
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
                                    String _error = ErrorMessage.fromError(error)
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
                                    context.read<UserViewModel>().changeUserData(
                                        result.response!.profile!);
                                    iPrefHelper
                                        .saveUser(result.response!.profile!);
                                    iPrefHelper.saveToken(
                                        result.response!.accessToken.toString());
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
                                  final googleLogin = GoogleLoginUseCase(repo);
                                  setState(() {
                                    isGoogleSignUp = true;
                                  });
                                  final result = await googleLogin(
                                      PlatformEntity(platform: 'Google'));
                                  result.fold((error) {
                                    String _error = ErrorMessage.fromError(error)
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
                                    context.read<UserViewModel>().changeUserData(
                                        result.response!.profile!);
                                    iPrefHelper
                                        .saveUser(result.response!.profile!);
                                    iPrefHelper.saveToken(
                                        result.response!.accessToken.toString());
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
                          'Don\'t have an account? ',
                          style: CustomAppTheme().normalText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()));
                          },
                          child: Text(
                            'Signup',
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
  onError(Failure error) async {
    String _error = ErrorMessage.fromError(error).message.toString();
    d('ON ERROR : $_error');
    setState(() {
      isSigning = false;
    });
    showOverlay(_error);
    if (_error == 'Your Profile is not Active') {
      final resendCode = ResendCodeUseCase(repo);
      setState(() {
        isSigning = true;
      });
      final result =
          await resendCode(ResendCodeEntities(email: emailController.text));
      result.fold((error) {
        String _error = ErrorMessage.fromError(error).message.toString();
        d('ON ERROR : $_error');
        showOverlay(_error);
        setState(() {
          isSigning = false;
        });
      }, (result) {
        d('ON SUCCESS : ${result.toString()}');
        showOverlay(result.response!.message.toString());
        setState(() {
          isSigning = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyEmailScreen(
                      email: emailController.text,
                    )));
      });
    }
  }

  @override
  onSuccess(LoginResModel result) {
    d('ON SUCCESS : ${result.toString()}');
    d('PROFILE : ${result.response!.profile.toString()}');
    context.read<UserViewModel>().changeUserData(result.response!.profile!);
    iPrefHelper.saveUser(result.response!.profile!);
    iPrefHelper.saveToken(result.response!.accessToken.toString());
    iPrefHelper.setIsLoggedIn(true);
    d("USER TOKEN : ${iPrefHelper.retrieveToken().toString()}");
    d("USER ID : ${iPrefHelper.retrieveUser()?.id.toString()}");
    setState(() {
      isSigning = false;
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}
