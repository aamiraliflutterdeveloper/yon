import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String? imagePath;
  final String? title;
  final String? totalAds;
  final int? bgColorCode;
  final double? titleFontSize;
  const CategoryCard(
      {Key? key,
      this.imagePath =
          'https://user-images.githubusercontent.com/10515204/56117400-9a911800-5f85-11e9-878b-3f998609a6c8.jpg',
      this.title = 'Electronic',
      this.totalAds,
      this.bgColorCode,
      this.titleFontSize = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Container(
      height: med.height * 0.15,
      width: med.width * 0.26,
      decoration: BoxDecoration(
        color: /*bgColorCode != null ? Color(bgColorCode!) :*/ const Color(
            0xffF8F7F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: med.height * 0.02,
          ),
          Center(
            child: Image.network(
              imagePath!,
              height: med.height * 0.05,
              width: med.width * 0.15,
            ),
            /*SvgPicture.asset(
                imagePath != null ? imagePath! :'assets/temp/app-development.svg',
              height: med.height*0.05,
              width: med.width*0.15,
            ),*/
          ),
          SizedBox(
            height: med.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: AutoSizeText(
              title.toString(),
              maxLines: 2,
              minFontSize: titleFontSize!,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomAppTheme()
                  .boldNormalText
                  .copyWith(fontSize: titleFontSize!),
            ),
          ),
          SizedBox(
            height: med.height * 0.01,
          ),
          Text(
            totalAds == null ? "0" : totalAds! + ' Ads',
            style: CustomAppTheme()
                .normalGreyText
                .copyWith(fontSize: 9, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
