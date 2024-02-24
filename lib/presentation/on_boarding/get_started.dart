import 'package:app/common/logger/log.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/authentication/signIn_screen.dart';
import 'package:app/presentation/authentication/signup_screen.dart';
import 'package:app/presentation/on_boarding/widgets/custom_page_route.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> with BaseMixin {
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/getStarted_bg.png',
            height: med.height,
            width: med.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: med.height * 0.45,
                ),
                Text(
                  'Let\'s get Started',
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 50),
                  ),
                ),
                SizedBox(
                  height: med.height * 0.03,
                ),
                SizedBox(
                  width: med.width * 0.8,
                  child: Text(
                    'Start buying, selling, posting, and many more on Youonline, the best marketplace for you.',
                    style: GoogleFonts.inter(textStyle: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().backgroundColor)),
                  ),
                ),
                SizedBox(
                  height: med.height * 0.05,
                ),
                SizedBox(
                  width: med.width,
                  child: YouOnlineButton(
                      onTap: () {
                        iPrefHelper.setIsOnboarded(true);
                        d("ONBOARDED : ${iPrefHelper.getIsOnboarded().toString()}");
                        Navigator.pushReplacement(context, CustomPageRoute(child: const SignUpScreen(), direction: AxisDirection.down));
                      },
                      text: 'Signup Now',
                      isButtonWhite: true),
                ),
                SizedBox(
                  height: med.height * 0.03,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already have an account? ',
                      style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().backgroundColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        iPrefHelper.setIsOnboarded(true);
                        d("ONBOARDED : ${iPrefHelper.getIsOnboarded().toString()}");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                      },
                      child: Text(
                        'Sign in',
                        style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().backgroundColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
