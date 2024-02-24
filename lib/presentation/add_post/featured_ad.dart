import 'package:app/presentation/add_post/review_your_ad_screen.dart';
import 'package:app/presentation/add_post/view_all_plans.dart';
import 'package:app/presentation/on_boarding/widgets/custom_page_route.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeaturedYourAd extends StatefulWidget {
  final int categoryIndex;
  const FeaturedYourAd({Key? key, required this.categoryIndex}) : super(key: key);

  @override
  State<FeaturedYourAd> createState() => _FeaturedYourAdState();
}

class _FeaturedYourAdState extends State<FeaturedYourAd> {
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Step 3 of 4', context: context, onTap: () {Navigator.of(context).pop();}),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: med.height * 0.05,
            ),
            Center(
              child: SvgPicture.asset(
                'assets/svgs/featuredAd.svg',
                height: med.height * 0.3,
                width: med.width * 0.85,
              ),
            ),
            SizedBox(
              height: med.height * 0.08,
            ),
            Text(
              'Featured Your Ad',
              style: CustomAppTheme().headingText,
            ),
            SizedBox(
              height: med.height * 0.015,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Feature your ad to get more audience throughout Globe.',
                textAlign: TextAlign.center,
                style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: med.width,
              child: YouOnlineButton(
                  text: 'View Plans',
                  onTap: () {
                    Navigator.push(context, CustomPageRoute(child: const ViewAllPlansScreen(), direction: AxisDirection.down));
                  }),
            ),
            SizedBox(
              height: med.height * 0.02,
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>ReviewYourAd(categoryIndex: widget.categoryIndex)));
                Navigator.push(context, CustomPageRoute(child: ReviewYourAd(categoryIndex: widget.categoryIndex), direction: AxisDirection.left));
              },
              child: Text(
                'Skip for later',
                style: CustomAppTheme().normalGreyText.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: med.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}
