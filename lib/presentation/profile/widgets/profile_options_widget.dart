import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileOptionWidget extends StatelessWidget {
  final Color iconBgColor;
  final String optionText;
  final VoidCallback onTap;
  final String svgUrl;
  const ProfileOptionWidget({Key? key, required this.iconBgColor, required this.optionText, required this.onTap, required this.svgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            Container(
              height: med.height*0.05,
              width: med.width*0.11,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: SvgPicture.asset(
                    svgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(optionText,
                style: CustomAppTheme().normalText.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),

            const Spacer(),

            Icon(Icons.arrow_forward_ios_outlined, size: 15, color: CustomAppTheme().darkGreyColor)

          ],
        ),
      ),
    );
  }
}
