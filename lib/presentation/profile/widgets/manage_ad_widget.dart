import 'package:app/common/logger/log.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/presentation/profile/applicants/all_applicants_view.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class ManageAdWidget extends StatefulWidget {
  final String categoryType;
  final ValueChanged<bool> onToggle;
  final ClassifiedProductModel? classifiedProduct;
  final AutomotiveProductModel? automotiveProduct;
  final PropertyProductModel? propertyProduct;
  final JobProductModel? jobProduct;
  final VoidCallback onDeleteTap;
  final VoidCallback onEditTap;

  const ManageAdWidget({
    Key? key,
    required this.onToggle,
    required this.categoryType,
    required this.onDeleteTap,
    required this.onEditTap,
    this.classifiedProduct,
    this.automotiveProduct,
    this.propertyProduct,
    this.jobProduct,
  }) : super(key: key);

  @override
  State<ManageAdWidget> createState() => _ManageAdWidgetState();
}

class _ManageAdWidgetState extends State<ManageAdWidget> {
  String productTitle = '- -';
  String streetAddress = ' - -';
  String productPrice = '- -';
  String startingSalary = '- -';
  String endingSalary = '- -';
  String postedBy = '- -';
  String currencyCode = 'AED';
  String adImage = '';
  String userImage = '';
  bool isVerified = false;
  bool isFav = false;
  bool isActive = false;
  int totalApplicants = 0;
  String slug = '';

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    if (widget.categoryType == 'Classified') {
      d('CURRENCY CODE: : : ${widget.classifiedProduct!.currency!.code.toString()}');
      productTitle = widget.classifiedProduct!.name.toString();
      streetAddress = widget.classifiedProduct!.streetAdress.toString();
      productPrice = widget.classifiedProduct!.price.toString();
      // isActive = widget.classifiedProduct!.isActive!;
      isActive = widget.classifiedProduct!.isActive!;
      postedBy = widget.classifiedProduct!.profile!.firstName.toString();
      currencyCode = widget.classifiedProduct!.currency!.code.toString();
      userImage = widget.classifiedProduct!.profile!.profilePicture != null
          ? widget.classifiedProduct!.profile!.profilePicture.toString()
          : 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg';
      adImage = widget.classifiedProduct!.imageMedia!.isEmpty
          ? 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'
          : widget.classifiedProduct!.imageMedia![0].image.toString();
    } else if (widget.categoryType == 'Automotive') {
      productTitle = widget.automotiveProduct!.name.toString();
      streetAddress = widget.automotiveProduct!.streetAddress.toString();
      productPrice = widget.automotiveProduct!.price.toString();
      isActive = widget.automotiveProduct!.isActive!;
      postedBy = widget.automotiveProduct!.profile!.firstName.toString();
      currencyCode = widget.automotiveProduct!.currency!.code.toString();
      userImage = widget.automotiveProduct!.profile!.profilePicture != null
          ? widget.automotiveProduct!.profile!.profilePicture.toString()
          : 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg';
      adImage = widget.automotiveProduct!.imageMedia!.isEmpty
          ? 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'
          : widget.automotiveProduct!.imageMedia![0].image.toString();
    } else if (widget.categoryType == 'Property') {
      productTitle = widget.propertyProduct!.name.toString();
      streetAddress = widget.propertyProduct!.streetAddress.toString();
      productPrice = widget.propertyProduct!.price.toString();
      postedBy = widget.propertyProduct!.profile!.firstName.toString();
      isActive = widget.propertyProduct!.isActive!;
      currencyCode = widget.propertyProduct!.currency!.code.toString();
      userImage = widget.propertyProduct!.profile!.profilePicture != null
          ? widget.propertyProduct!.profile!.profilePicture.toString()
          : 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg';
      adImage = widget.propertyProduct!.imageMedia!.isEmpty
          ? 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'
          : widget.propertyProduct!.imageMedia![0].image.toString();
    } else if (widget.categoryType == 'Job') {
      d('JOB USER PROFILE : ${widget.jobProduct!.profile.toString()}');
      d("Job ID :: ${widget.jobProduct?.id}");
      d("this is job Id");
      d("this is job slug :: ${widget.propertyProduct?.slug}");
      d("this is job slug :: ${widget.propertyProduct?.id}");
      productTitle = widget.jobProduct!.title.toString();
      streetAddress = widget.jobProduct!.location.toString();
      isActive = widget.jobProduct!.isActive!;
      startingSalary = widget.jobProduct!.salaryStart.toString();
      endingSalary = widget.jobProduct!.salaryEnd.toString();
      postedBy = widget.jobProduct!.profile!.firstName.toString();
      currencyCode = widget.jobProduct!.salaryCurrency!.code.toString();
      userImage = widget.jobProduct!.profile!.profilePicture != null
          ? widget.jobProduct!.profile!.profilePicture.toString()
          : 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg';
      adImage = widget.jobProduct!.imageMedia!.isEmpty
          ? 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'
          : widget.jobProduct!.imageMedia![0].image.toString();
      totalApplicants = widget.jobProduct!.totalApplied!;
      slug = widget.jobProduct!.slug!;
      d("hahhahahhah :: == :: $slug");
    }

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
                      image: NetworkImage(adImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
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
                                  productTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomAppTheme().normalText.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: med.width * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: CustomAppTheme().primaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              .copyWith(
                                                  color: CustomAppTheme()
                                                      .backgroundColor,
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w600),
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
                                  width: med.width * 0.55,
                                  child: Text(
                                    streetAddress,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomAppTheme()
                                        .normalText
                                        .copyWith(fontSize: 9),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                '$currencyCode ${widget.categoryType == 'Job' ? '$startingSalary - $endingSalary' : productPrice}',
                                style: CustomAppTheme().normalText.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: CustomAppTheme().primaryColor),
                              ),
                              widget.categoryType == 'Job'
                                  ? const Spacer()
                                  : Container(),
                              /*Text(
                                '1200',
                                style: CustomAppTheme()
                                    .normalText
                                    .copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: CustomAppTheme().secondaryColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  'Views',
                                  style:
                                      CustomAppTheme().normalText.copyWith(color: CustomAppTheme().greyColor, fontSize: 8, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                '1200',
                                style: CustomAppTheme()
                                    .normalText
                                    .copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: CustomAppTheme().secondaryColor),
                              ),*/
                              widget.categoryType == 'Job'
                                  ? GestureDetector(
                                      onTap: () {
                                        Get.to(AllApplicantsView(slug: slug));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  CustomAppTheme().primaryColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              size: 13,
                                              color:
                                                  CustomAppTheme().primaryColor,
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              // '74 Applicants',
                                              totalApplicants.toString(),
                                              style: CustomAppTheme()
                                                  .normalText
                                                  .copyWith(
                                                      color: CustomAppTheme()
                                                          .blackColor
                                                          .withOpacity(.7),
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: med.height * 0.01,
            ),
            Divider(
              color: CustomAppTheme().greyColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //Posted By
                /*Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    optionTitle(title: 'Posted By:'),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: med.height * 0.02,
                            width: med.width * 0.05,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(userImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              postedBy,
                              style: CustomAppTheme().normalText.copyWith(fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),*/

                /*Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    optionTitle(title: 'Promote Ad:'),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Container(
                        height: med.height * 0.02,
                        decoration: BoxDecoration(
                          color: CustomAppTheme().primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Center(
                            child: Text(
                              'Feature Your Ad',
                              style: CustomAppTheme()
                                  .normalText
                                  .copyWith(color: CustomAppTheme().backgroundColor, fontSize: 7, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    optionTitle(title: 'Special Discount:'),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Container(
                        height: med.height * 0.02,
                        decoration: BoxDecoration(
                          color: CustomAppTheme().secondaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Center(
                            child: Text(
                              'Add Special Discount',
                              style: CustomAppTheme()
                                  .normalText
                                  .copyWith(color: CustomAppTheme().backgroundColor, fontSize: 7, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),*/

                // Action
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    optionTitle(title: 'Status:'),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        height: med.height * 0.02,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Active',
                              style: CustomAppTheme().normalText.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: FlutterSwitch(
                                height: med.height * 0.015,
                                width: med.width * 0.06,
                                toggleSize: 10.0,
                                value: isActive,
                                activeColor: CustomAppTheme().primaryColor,
                                padding: 1.0,
                                onToggle: widget.onToggle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Action
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    optionTitle(title: 'Action:'),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        height: med.height * 0.02,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: widget.onDeleteTap,
                              child: SvgPicture.asset(
                                'assets/svgs/delete_icon.svg',
                                height: med.height * 0.02,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: GestureDetector(
                                onTap: widget.onEditTap,
                                child: SvgPicture.asset(
                                  'assets/svgs/edit_circle_icon.svg',
                                  height: med.height * 0.02,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget optionTitle({required String title}) {
    return Text(
      title,
      style: CustomAppTheme().normalGreyText.copyWith(fontSize: 8),
    );
  }
}
