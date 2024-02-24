import 'package:app/common/logger/log.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';

class AppliedJobWidget extends StatefulWidget {
  final bool isAdActive;
  final String categoryType;
  final ValueChanged<bool> onToggle;
  final JobProductModel? jobProduct;
  final VoidCallback onDeleteTap;
  final VoidCallback onEditTap;

  const AppliedJobWidget({
    Key? key,
    required this.isAdActive,
    required this.onToggle,
    required this.categoryType,
    required this.onDeleteTap,
    required this.onEditTap,
    this.jobProduct,
  }) : super(key: key);

  @override
  State<AppliedJobWidget> createState() => _AppliedJobWidgetState();
}

class _AppliedJobWidgetState extends State<AppliedJobWidget> {
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
  bool isViewed = false;

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    if (widget.categoryType == 'Job') {
      d('This is widget.jobProduct!.salaryStart.toString() ::: ${widget.jobProduct!.salaryStart.toString()}');
      d('JOB USER PROFILE : ${widget.jobProduct!.profile!}');
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
      isViewed = widget.jobProduct!.isViewed!;
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
                                productTitle,
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
                                width: med.width * 0.55,
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
                          currencyCode + ' $startingSalary - $endingSalary',
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
            Divider(
              color: CustomAppTheme().greyColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Posted By
                Column(
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
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width*.65,
                    child: Text(isViewed == false ? "The employer has not viewed your resume yet" : "The employer has viewed your resume", style: const TextStyle(color: Colors.black, fontSize:
                    11)))
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
                            child: Text('Feature Your Ad',
                              style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().backgroundColor, fontSize: 7, fontWeight: FontWeight.w700),
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
                            child: Text('Add Special Discount',
                              style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().backgroundColor, fontSize: 7, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

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
                              style: CustomAppTheme().normalText.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
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
                ),*/
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
