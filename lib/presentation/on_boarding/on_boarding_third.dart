import 'package:app/common/logger/log.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/on_boarding/get_started.dart';
import 'package:app/presentation/on_boarding/on_boarding_fourth.dart';
import 'package:app/presentation/on_boarding/widgets/custom_page_route.dart';
import 'package:app/presentation/on_boarding/widgets/onBoarding_center_image.dart';
import 'package:app/presentation/on_boarding/widgets/onBoarding_top_image.dart';
import 'package:app/presentation/on_boarding/widgets/skip_button.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:flutter/material.dart';

class OnBoardingThird extends StatefulWidget {
  const OnBoardingThird({Key? key}) : super(key: key);

  @override
  State<OnBoardingThird> createState() => _OnBoardingThirdState();
}

class _OnBoardingThirdState extends State<OnBoardingThird> with BaseMixin {
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const OnBoardingTopImage(imageUrl: 'assets/images/onBoarding_third.png'),
            const OnBoardingCenterImage(imageUrl: 'assets/images/property_onBoarding.png', width: 0.65),
            SizedBox(
              height: med.height * 0.05,
            ),
            Text(
              'Find Property',
              style: CustomAppTheme().headingText,
            ),
            SizedBox(
              height: med.height * 0.02,
            ),
            Center(
              child: SizedBox(
                width: med.width * 0.85,
                child: Text(
                  'Find the best properties in the town as per your interest and need',
                  textAlign: TextAlign.center,
                  style: CustomAppTheme().normalGreyText,
                ),
              ),
            ),
            SizedBox(
              height: med.height * 0.03,
            ),
            Container(
              height: med.height * 0.02,
              width: med.width * 0.1,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/third_onBoarding.png'), fit: BoxFit.fitWidth)),
            ),
            SizedBox(
              height: med.height * 0.03,
            ),
            SizedBox(
              width: med.width * 0.85,
              child: YouOnlineButton(
                  text: 'Next',
                  onTap: () {
                    Navigator.push(context, CustomPageRoute(child: const OnBoardingFourth(), direction: AxisDirection.left));
                  }),
            ),
            SizedBox(
              height: med.height * 0.03,
            ),
            SkipButton(onTap: () {
              iPrefHelper.setIsOnboarded(true);
              d("ONBOARDED : ${iPrefHelper.getIsOnboarded().toString()}");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GetStartedScreen()));
            }),
          ],
        ),
      ),
    );
  }
}
