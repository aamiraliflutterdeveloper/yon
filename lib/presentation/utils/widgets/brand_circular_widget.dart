import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandCircularWidget extends StatelessWidget {
  final int index;
  final String? brandName;
  final String? totalCount;

  const BrandCircularWidget({Key? key, required this.index, this.brandName = '- -', this.totalCount = '0'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          height: med.height * 0.08,
          width: med.width * 0.25,
          decoration: const BoxDecoration(
            color: Color(0xffF8F5F5),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/samsung.png'),
            ),
          ),
          // child: Center(
          //   child: SvgPicture.asset(
          //     'assets/temp/UIDesignIcon.svg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
        ),
        SizedBox(
          height: med.height * 0.01,
        ),
        Text(
          brandName!,
          style: CustomAppTheme().boldNormalText,
        ),
        SizedBox(
          height: med.height * 0.01,
        ),
        Text(
          totalCount! + ' Ads',
          style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
