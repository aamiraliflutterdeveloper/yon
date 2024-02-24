import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationBarItemWidget extends StatelessWidget {
  final String svgUrl;
  final String title;
  final VoidCallback onTab;
  final bool isActive;
  const NavigationBarItemWidget(
      {Key? key,
      required this.svgUrl,
      required this.title,
      required this.onTab,
      required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTab,
      child: SizedBox(
        width: med.width * 0.2,
        // color: Colors.green,
        child: Column(
          children: <Widget>[
            Container(
              width: med.width * 0.1,
              height: med.height * 0.004,
              decoration: BoxDecoration(
                color: isActive
                    ? CustomAppTheme().primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            SizedBox(height: med.height * 0.015),
            SvgPicture.asset(
              svgUrl,
              height: med.height * 0.03,
              // height: MediaQuery.of(context).size.height * 0.03,
              // width: med.width*0.06,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                title,
                style: CustomAppTheme().normalText.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: CustomAppTheme().darkGreyColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
