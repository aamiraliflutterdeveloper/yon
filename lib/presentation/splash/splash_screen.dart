import 'dart:async';

import 'package:app/common/logger/log.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/authentication/mixins/login_mixin.dart';
import 'package:app/presentation/authentication/signIn_screen.dart';
import 'package:app/presentation/home/home_screen.dart';
import 'package:app/presentation/on_boarding/on_boarding_first.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with BaseMixin, LoginMixin {
  @override
  void initState() {
    GeneralViewModel generalViewModel = Provider.of(context, listen: false);
    generalViewModel.getCurrentLocation(context: context);

    d("ONBOARDED : ${iPrefHelper.getIsOnboarded().toString()}");
    d("IS LOGGED IN : ${iPrefHelper.getIsOnboarded().toString()}");
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                iPrefHelper.getIsLoggedIn() == true
                    ? const HomeScreen()
                    : iPrefHelper.getIsOnboarded() == true
                        ? const SignInScreen()
                        : const OnBoardingFirst()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().primaryColor,
      body: SafeArea(
        child: Container(
          height: med.height,
          width: med.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash.png'),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
