import 'package:app/common/logger/log.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/categories/mixins/category_screens_mixin.dart';
import 'package:app/presentation/profile/business_mode/create_business_profile.dart';
import 'package:app/presentation/profile/business_mode/view_model/business_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ModuleOptionScreen extends StatefulWidget {
  const ModuleOptionScreen({Key? key}) : super(key: key);

  @override
  State<ModuleOptionScreen> createState() => _ModuleOptionScreenState();
}

class _ModuleOptionScreenState extends State<ModuleOptionScreen>
    with CategoriesScreenMixin, BaseMixin {
  bool isDataFetching = false;

  getBusinessProfile() async {
    BusinessViewModel businessViewModel = context.read<BusinessViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result = await businessViewModel.getMyBusinessProfiles();
    result.fold((l) {}, (r) {
      d('My Business Profiles : $r');
      for (int i = 0; i < r.response!.length; i++) {
        if (r.response![i].companyType == 'Classified') {
          businessViewModel.classifiedBusinessProfile = r.response![i];
          iPrefHelper.saveClassifiedProfile(
              businessViewModel.classifiedBusinessProfile);
        } else if (r.response![i].companyType == 'Automotive') {
          businessViewModel.automotiveBusinessProfile = r.response![i];
          iPrefHelper.saveAutomotiveProfile(
              businessViewModel.automotiveBusinessProfile);
        } else if (r.response![i].companyType == 'Property') {
          businessViewModel.propertyBusinessProfile = r.response![i];
          iPrefHelper
              .savePropertyProfile(businessViewModel.propertyBusinessProfile);
        } else if (r.response![i].companyType == 'Job') {
          businessViewModel.jobBusinessProfile = r.response![i];
          iPrefHelper.saveJobProfile(businessViewModel.jobBusinessProfile);
        }
      }
    });
    setState(() {
      isDataFetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getBusinessProfile();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    BusinessViewModel businessViewModel = context.watch<BusinessViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Category', context: context, onTap: () {Navigator.of(context).pop();}),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: med.height * 0.035,
            ),
            Text(
              'What are you offering?',
              style: CustomAppTheme().headingText,
            ),
            /*SizedBox(
              height: med.height * 0.015,
            ),
            Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              textAlign: TextAlign.start,
              style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
            ),*/
            SizedBox(
              height: med.height * 0.04,
            ),
            isDataFetching == false
                ? GridView.builder(
                    itemCount: categoryList.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          bool isCreateProfile = true;
                          if (categoryList[index].categoryTitle ==
                              'Classified') {
                            isCreateProfile = businessViewModel
                                        .classifiedBusinessProfile.id ==
                                    null 
                                ? true
                                : false;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateBusinessProfile(
                                  isCreateProfile: isCreateProfile,
                                  module: categoryList[index].categoryTitle,
                                  businessData: businessViewModel
                                      .classifiedBusinessProfile,
                                  isPending: businessViewModel
                                              .classifiedBusinessProfile
                                              .verificationStatus ==
                                          "Pending"
                                      ? true
                                      : false,
                                  isRejected: businessViewModel
                                              .classifiedBusinessProfile
                                              .verificationStatus ==
                                          "Rejected"
                                      ? true
                                      : false,
                                ),
                              ),
                            );
                          } else if (categoryList[index].categoryTitle ==
                              'Automotive') {
                            isCreateProfile = businessViewModel
                                        .automotiveBusinessProfile.id ==
                                    null
                                ? true
                                : false;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateBusinessProfile(
                                  isCreateProfile: isCreateProfile,
                                  module: categoryList[index].categoryTitle,
                                  businessData: businessViewModel
                                      .automotiveBusinessProfile,
                                  isPending: businessViewModel
                                              .automotiveBusinessProfile
                                              .verificationStatus ==
                                          "Pending"
                                      ? true
                                      : false,
                                  isRejected: businessViewModel
                                              .automotiveBusinessProfile
                                              .verificationStatus ==
                                          "Rejected"
                                      ? true
                                      : false,
                                ),
                              ),
                            );
                          } else if (categoryList[index].categoryTitle ==
                              'Property') {
                            isCreateProfile =
                                businessViewModel.propertyBusinessProfile.id ==
                                        null
                                    ? true
                                    : false;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateBusinessProfile(
                                  isCreateProfile: isCreateProfile,
                                  module: categoryList[index].categoryTitle,
                                  businessData:
                                      businessViewModel.propertyBusinessProfile,
                                  isPending: businessViewModel
                                              .propertyBusinessProfile
                                              .verificationStatus ==
                                          "Pending"
                                      ? true
                                      : false,
                                  isRejected: businessViewModel
                                              .propertyBusinessProfile
                                              .verificationStatus ==
                                          "Rejected"
                                      ? true
                                      : false,
                                ),
                              ),
                            );
                          } else if (categoryList[index].categoryTitle ==
                              'Job') {
                            isCreateProfile =
                                businessViewModel.jobBusinessProfile.id == null
                                    ? true
                                    : false;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateBusinessProfile(
                                  isCreateProfile: isCreateProfile,
                                  module: categoryList[index].categoryTitle,
                                  businessData:
                                      businessViewModel.jobBusinessProfile,
                                  isPending: businessViewModel
                                              .jobBusinessProfile
                                              .verificationStatus ==
                                          "Pending"
                                      ? true
                                      : false,
                                  isRejected: businessViewModel
                                              .jobBusinessProfile
                                              .verificationStatus ==
                                          "Rejected"
                                      ? true
                                      : false,
                                ),
                              ),
                            );
                          }
                        },
                        child: Card(
                          elevation: 2,
                          shadowColor: CustomAppTheme().lightGreyColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: med.height * 0.02,
                              ),
                              Center(
                                child: SvgPicture.asset(
                                  categoryList[index].svgIconUrl,
                                  height: med.height * 0.08,
                                  width: med.width * 0.2,
                                ),
                              ),
                              SizedBox(
                                height: med.height * 0.02,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: AutoSizeText(
                                  categoryList[index].categoryTitle,
                                  maxLines: 1,
                                  minFontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomAppTheme()
                                      .boldNormalText
                                      .copyWith(fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: med.height * 0.01,
                              ),
                              index == 0
                                  ? businessViewModel.classifiedBusinessProfile
                                              .verificationStatus ==
                                          null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Text(
                                            //   "Status: ",
                                            //   style: CustomAppTheme()
                                            //       .normalGreyText
                                            //       .copyWith(
                                            //           fontSize: 13,
                                            //           fontWeight: FontWeight.w500),
                                            // ),
                                            Text(
                                              "Create Now",
                                              style: TextStyle(
                                                  color: CustomAppTheme()
                                                      .blackColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Text(
                                            //   "Status: ",
                                            //   style: CustomAppTheme()
                                            //       .normalGreyText
                                            //       .copyWith(
                                            //           fontSize: 13,
                                            //           fontWeight:
                                            //               FontWeight.w500),
                                            // ),
                                            Text(
                                              businessViewModel
                                                  .classifiedBusinessProfile
                                                  .verificationStatus
                                                  .toString(),
                                              style: TextStyle(
                                                  color: businessViewModel
                                                              .classifiedBusinessProfile
                                                              .verificationStatus ==
                                                          "Pending"
                                                      ? Colors.orange
                                                      : businessViewModel
                                                                  .classifiedBusinessProfile
                                                                  .verificationStatus ==
                                                              "Rejected"
                                                          ? Colors.red
                                                          : businessViewModel
                                                                      .classifiedBusinessProfile
                                                                      .verificationStatus ==
                                                                  "Verified"
                                                              ? Colors.green
                                                              : CustomAppTheme()
                                                                  .blackColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        )
                                  : index == 1
                                      ? businessViewModel
                                                  .propertyBusinessProfile
                                                  .verificationStatus ==
                                              null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Text(
                                                //   "Status: ",
                                                //   style: CustomAppTheme()
                                                //       .normalGreyText
                                                //       .copyWith(
                                                //           fontSize: 13,
                                                //           fontWeight: FontWeight.w500),
                                                // ),
                                                Text(
                                                  "Create Now",
                                                  style: TextStyle(
                                                      color: CustomAppTheme()
                                                          .blackColor,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Text(
                                                //   "Status: ",
                                                //   style: CustomAppTheme()
                                                //       .normalGreyText
                                                //       .copyWith(
                                                //           fontSize: 13,
                                                //           fontWeight:
                                                //               FontWeight.w500),
                                                // ),
                                                Text(
                                                  businessViewModel
                                                      .propertyBusinessProfile
                                                      .verificationStatus
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: businessViewModel
                                                                  .propertyBusinessProfile
                                                                  .verificationStatus ==
                                                              "Pending"
                                                          ? Colors.orange
                                                          : businessViewModel
                                                                      .propertyBusinessProfile
                                                                      .verificationStatus ==
                                                                  "Rejected"
                                                              ? Colors.red
                                                              : businessViewModel
                                                                          .propertyBusinessProfile
                                                                          .verificationStatus ==
                                                                      "Verified"
                                                                  ? Colors.green
                                                                  : CustomAppTheme()
                                                                      .blackColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            )
                                      : index == 2
                                          ? businessViewModel
                                                      .automotiveBusinessProfile
                                                      .verificationStatus ==
                                                  null
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // Text(
                                                    //   "Status: ",
                                                    //   style: CustomAppTheme()
                                                    //       .normalGreyText
                                                    //       .copyWith(
                                                    //           fontSize: 13,
                                                    //           fontWeight: FontWeight.w500),
                                                    // ),
                                                    Text(
                                                      "Create Now",
                                                      style: TextStyle(
                                                          color:
                                                              CustomAppTheme()
                                                                  .blackColor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // Text(
                                                    //   "Status: ",
                                                    //   style: CustomAppTheme()
                                                    //       .normalGreyText
                                                    //       .copyWith(
                                                    //           fontSize: 13,
                                                    //           fontWeight:
                                                    //               FontWeight
                                                    //                   .w500),
                                                    // ),
                                                    Text(
                                                      businessViewModel
                                                          .automotiveBusinessProfile
                                                          .verificationStatus
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: businessViewModel
                                                                      .automotiveBusinessProfile
                                                                      .verificationStatus ==
                                                                  "Pending"
                                                              ? Colors.orange
                                                              : businessViewModel
                                                                          .automotiveBusinessProfile
                                                                          .verificationStatus ==
                                                                      "Rejected"
                                                                  ? Colors.red
                                                                  : businessViewModel
                                                                              .automotiveBusinessProfile
                                                                              .verificationStatus ==
                                                                          "Verified"
                                                                      ? Colors
                                                                          .green
                                                                      : CustomAppTheme()
                                                                          .blackColor,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ],
                                                )
                                          : index == 3
                                              ? businessViewModel
                                                          .jobBusinessProfile
                                                          .verificationStatus ==
                                                      null
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Text(
                                                        //   "Status: ",
                                                        //   style: CustomAppTheme()
                                                        //       .normalGreyText
                                                        //       .copyWith(
                                                        //           fontSize: 13,
                                                        //           fontWeight: FontWeight.w500),
                                                        // ),
                                                        Text(
                                                          "Create Now",
                                                          style: TextStyle(
                                                              color:
                                                                  CustomAppTheme()
                                                                      .blackColor,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Text(
                                                        //   "Status: ",
                                                        //   style: CustomAppTheme()
                                                        //       .normalGreyText
                                                        //       .copyWith(
                                                        //           fontSize: 13,
                                                        //           fontWeight:
                                                        //               FontWeight
                                                        //                   .w500),
                                                        // ),
                                                        Text(
                                                          businessViewModel
                                                              .jobBusinessProfile
                                                              .verificationStatus
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: businessViewModel
                                                                          .jobBusinessProfile
                                                                          .verificationStatus ==
                                                                      "Pending"
                                                                  ? Colors
                                                                      .orange
                                                                  : businessViewModel
                                                                              .jobBusinessProfile
                                                                              .verificationStatus ==
                                                                          "Rejected"
                                                                      ? Colors
                                                                          .red
                                                                      : businessViewModel.jobBusinessProfile.verificationStatus ==
                                                                              "Verified"
                                                                          ? Colors
                                                                              .green
                                                                          : CustomAppTheme()
                                                                              .blackColor,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ],
                                                    )
                                              : Container(),

                              // Text(
                              //       categoryList[index].totalProducts + ' Ads',
                              //       style: CustomAppTheme()
                              //           .normalGreyText
                              //           .copyWith(
                              //               fontSize: 13,
                              //               fontWeight: FontWeight.w500),
                              //     ),
                              SizedBox(
                                height: med.height * 0.02,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : GridView.builder(
                    itemCount: 4,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: CustomAppTheme().lightGreyColor,
                        highlightColor: CustomAppTheme().backgroundColor,
                        child: Container(
                          decoration: BoxDecoration(
                            color: CustomAppTheme().lightGreyColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
