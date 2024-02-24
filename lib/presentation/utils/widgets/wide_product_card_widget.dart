import 'package:app/common/logger/log.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WideProductCard extends StatefulWidget {
  final PropertyProductModel? propertyProduct;
  final AutomotiveProductModel? automotiveProduct;
  final JobProductModel? jobProduct;

  const WideProductCard({Key? key, this.propertyProduct, this.automotiveProduct, this.jobProduct}) : super(key: key);

  @override
  State<WideProductCard> createState() => _WideProductCardState();
}

class _WideProductCardState extends State<WideProductCard> {
  String title = '';
  String streetAddress = '';
  String imagePath = '';
  String currencyCode = '';
  String price = '';
  String userName = '';
  String userImagePath = '';
  String adType = '';

  setPropertyValues() {
    title = widget.propertyProduct!.name.toString();
    streetAddress = widget.propertyProduct!.streetAddress.toString();
    imagePath = widget.propertyProduct!.imageMedia != null
        ? widget.propertyProduct!.imageMedia![0].image.toString()
        : 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg';
    currencyCode = widget.propertyProduct!.currency!.code.toString();
    price = widget.propertyProduct!.price.toString();
    userName = widget.propertyProduct!.profile!.firstName.toString();
    userImagePath = widget.propertyProduct!.profile!.profilePicture == null
        ? 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'
        : widget.propertyProduct!.profile!.profilePicture.toString();
  }

  setAutomotiveValues() {
    setState(() {
      title = widget.automotiveProduct!.name.toString();
      streetAddress = widget.automotiveProduct!.streetAddress.toString();
      imagePath = widget.automotiveProduct!.imageMedia != null
          ? widget.automotiveProduct!.imageMedia![0].image.toString()
          : 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg';
      currencyCode = widget.automotiveProduct!.currency!.code.toString();
      price = widget.automotiveProduct!.price.toString();
      userName = widget.automotiveProduct!.profile!.firstName.toString();
      userImagePath = widget.automotiveProduct!.profile!.profilePicture == null
          ? 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'
          : widget.automotiveProduct!.profile!.profilePicture.toString();
      print("Inside auto motive ads $title");
    });
  }

  setJobValues() {
    d('This is widget.jobProduct!.imageMedia :::::: ${widget.jobProduct!.imageMedia}');
    title = widget.jobProduct!.title.toString();
    streetAddress = widget.jobProduct!.location.toString();
    imagePath = widget.jobProduct!.imageMedia != null && widget.jobProduct!.imageMedia!.isNotEmpty
        ? widget.jobProduct!.imageMedia![0].image.toString()
        : 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg';
    currencyCode = widget.jobProduct!.salaryCurrency!.code.toString();
    price = '${widget.jobProduct!.salaryStart.toString()} - ${widget.jobProduct!.salaryEnd.toString()}';
    userName = widget.jobProduct!.profile!.firstName.toString();
    userImagePath = widget.jobProduct!.profile!.profilePicture == null
        ? 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'
        : widget.jobProduct!.profile!.profilePicture.toString();
  }

  @override
  void initState() {
    super.initState();
    if (widget.automotiveProduct != null) {
      setAutomotiveValues();
      adType = 'Automotive';
      setState(() {});
    } else if (widget.propertyProduct != null) {
      setPropertyValues();
      adType = 'Property';
    } else if (widget.jobProduct != null) {
      setJobValues();
      adType = 'Job';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    // print(widget.automotiveProduct!.name);
    if (widget.automotiveProduct != null) {
      setAutomotiveValues();
      adType = 'Automotive';
      setState(() {});
    } else if (widget.propertyProduct != null) {
      setPropertyValues();
      adType = 'Property';
    } else if (widget.jobProduct != null) {
      setJobValues();
      adType = 'Job';
    }
    print(title);
    print("This is inside === :: ====");
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: med.height * 0.08,
                  width: med.width * 0.2,
                  decoration: BoxDecoration(
                    color: CustomAppTheme().lightGreyColor,
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    height: med.height * 0.08,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            SizedBox(
                              width: med.width * 0.47,
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CustomAppTheme().normalText.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: med.width * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: CustomAppTheme().primaryColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.verified_outlined,
                                      color: CustomAppTheme().backgroundColor,
                                      size: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Text(
                                        'Verified',
                                        style: CustomAppTheme()
                                            .normalText
                                            .copyWith(color: CustomAppTheme().backgroundColor, fontSize: 8, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on_rounded,
                              color: CustomAppTheme().primaryColor,
                              size: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: SizedBox(
                                width: med.width * 0.5,
                                child: Text(
                                  streetAddress,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomAppTheme().normalText.copyWith(fontSize: 9),
                                ),
                              ),
                            )
                          ],
                        ),
                        Text(
                          '$currencyCode $price',
                          style:
                              CustomAppTheme().normalText.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: CustomAppTheme().primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: med.height * 0.01,
            ),
            Row(
              children: <Widget>[
                adType == 'Property'
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          propertyFeatureWidget(svgUrl: 'assets/svgs/bedIcon.svg', value: widget.propertyProduct!.bedrooms.toString(), type: 'Beds'),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: propertyFeatureWidget(
                                svgUrl: 'assets/svgs/bathIcon.svg', value: widget.propertyProduct!.baths.toString(), type: 'Baths'),
                          ),
                        ],
                      )
                    : adType == 'Automotive'
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              propertyFeatureWidget(
                                  svgUrl: 'assets/svgs/typeIcon.svg', value: widget.automotiveProduct!.category!.title.toString(), type: ''),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: propertyFeatureWidget(
                                    svgUrl: 'assets/svgs/conditionIcon.svg', value: widget.automotiveProduct!.carType.toString(), type: ''),
                              ),
                            ],
                          )
                        : adType == 'Job'
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  propertyFeatureWidget(
                                      svgUrl: 'assets/svgs/jobPositionIcon.svg', value: widget.jobProduct!.positionType.toString(), type: ''),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: propertyFeatureWidget(
                                        svgUrl: 'assets/svgs/typeIcon.svg', value: widget.jobProduct!.jobType.toString(), type: ''),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                const Spacer(),
                Row(
                  children: <Widget>[
                    Container(
                      height: med.height * 0.03,
                      width: med.width * 0.13,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(userImagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      userName,
                      style: CustomAppTheme().normalText.copyWith(fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget propertyFeatureWidget({required String svgUrl, required String type, required String value}) {
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
            '$value $type',
            style: CustomAppTheme().normalText.copyWith(fontSize: 8),
          ),
        ),
      ],
    );
  }
}
