import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JobAdsWidget extends StatefulWidget {
  final bool? isFeatured;
  final bool? isOff;
  final String? imageUrl;
  final String? title;
  final VoidCallback? onFavTap;
  final bool? isFav;
  final String? address;
  final String? startingSalary;
  final String? endingSalary;
  final String? currencyCode;
  final String? description;
  final String? beds;
  final String? baths;
  const JobAdsWidget({
    Key? key,
    this.isFeatured = false,
    this.isOff = false,
    this.imageUrl = 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg',
    this.title = '',
    this.address = '',
    this.startingSalary = '',
    this.currencyCode = '',
    this.description = '',
    this.baths = '',
    this.beds = '',
    this.endingSalary = '',
    this.onFavTap,
    this.isFav = false,
  }) : super(key: key);
  @override
  State<JobAdsWidget> createState() => _JobAdsWidgetState();
}

class _JobAdsWidgetState extends State<JobAdsWidget> {
  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    print(widget.isFav);
    print("hahahhaahaha === === ==== ");
    String imageUrl;
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      imageUrl = 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg';
    } else {
      imageUrl = widget.imageUrl!;
    }
    String description = removeAllHtmlTags(widget.description!);
    return Container(
      // height: med.height * 0.26,
      width: med.width * 0.45,
      margin: EdgeInsets.only(bottom: med.height * 0.005, right: med.width * 0.005),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CustomAppTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0.4,
            blurRadius: 1,
            offset: const Offset(1, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: med.height * 0.05,
              width: med.width * 0.12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: CustomAppTheme().lightGreyColor,
              ),
              child: Center(
                child: Image.network(
                  imageUrl,
                  height: med.height * 0.04,
                  width: med.width * 0.1,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: med.height * 0.01,
            ),
            //Title and fav
            Row(
              children: <Widget>[
                SizedBox(
                  width: med.width * 0.33,
                  child: Text(
                    widget.title.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CustomAppTheme().normalText.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onFavTap,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xffe6fff9),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(widget.isFav! == true ? Icons.favorite : Icons.favorite_border, color: CustomAppTheme().primaryColor, size: 16),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on_rounded,
                    color: CustomAppTheme().primaryColor,
                    size: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: SizedBox(
                      width: med.width * 0.35,
                      child: Text(
                        widget.address.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CustomAppTheme().normalText.copyWith(fontSize: 9),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: med.height * 0.015,
            ),
            SizedBox(
              height: med.height * 0.05,
              child: /*HtmlWidget(widget.description!,
                  textStyle: CustomAppTheme().normalText.copyWith(
                        fontSize: 9,
                        overflow: TextOverflow.ellipsis,
                      )),*/
                  Text(
                description,
                // 'You will be responsible for the Visual design for multi-device. Understand basic design, User Journey, Ideation and Wireframing etc…',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: CustomAppTheme().normalText.copyWith(fontSize: 9),
              ),
            ),
            SizedBox(
              height: med.height * 0.015,
            ),
            Text(
              '${widget.currencyCode} ${widget.startingSalary} - ${widget.currencyCode} ${widget.endingSalary} ',
              style: CustomAppTheme().normalText.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: CustomAppTheme().primaryColor),
            ),
            SizedBox(
              height: med.height * 0.008,
            ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  propertyFeatureWidget(svgUrl: 'assets/svgs/jobPositionIcon.svg', type: widget.beds ?? 'Full Time'),
                  propertyFeatureWidget(svgUrl: 'assets/svgs/typeIcon.svg', type: widget.baths ?? '3-5 Years'),
                  // propertyFeatureWidget(
                  //     svgUrl: 'assets/svgs/sqftIcon.svg', type: '74 Applied'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget propertyFeatureWidget({required String svgUrl, required String type}) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(
          svgUrl,
          height: MediaQuery.of(context).size.height * 0.012,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(
            type,
            style: CustomAppTheme().normalText.copyWith(fontSize: 8),
          ),
        ),
      ],
    );
  }
}
