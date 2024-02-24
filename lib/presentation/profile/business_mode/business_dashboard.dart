import 'package:app/common/logger/log.dart';
import 'package:app/data/models/business_module_models/business_profile_stats_res_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/upload_images_videos.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/notification/notification_screen.dart';
import 'package:app/presentation/profile/business_mode/view_model/business_view_model.dart';
import 'package:app/presentation/profile/business_mode/widgets/module_dropDown_option.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/profile/widgets/delete_dialog_box.dart';
import 'package:app/presentation/profile/widgets/manage_ad_widget.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BusinessDashboard extends StatefulWidget {
  const BusinessDashboard({Key? key}) : super(key: key);

  @override
  State<BusinessDashboard> createState() => _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard> with BaseMixin {
  int totalAds = 0;
  bool isDataFetching = false;
  BusinessStatsModel businessStats = BusinessStatsModel();

  getClassifiedBusinessAds({String? sortedBy}) async {
    BusinessViewModel businessViewModel = context.read<BusinessViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result =
        await businessViewModel.getBusinessClassifiedAds(sortedBy: sortedBy);
    result.fold((l) {}, (r) {
      businessViewModel.changeClassifiedBusinessAds(r.results!);
      setState(() {
        totalAds = r.results!.length;
        isDataFetching = false;
      });
    });
  }

  getAutomotiveBusinessAds({String? sortedBy}) async {
    BusinessViewModel businessViewModel = context.read<BusinessViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result =
        await businessViewModel.getBusinessAutomotiveAds(sortedBy: sortedBy);
    result.fold((l) {}, (r) {
      businessViewModel.changeAutomotiveBusinessAds(r.automotiveAdsList!);
      setState(() {
        totalAds = r.automotiveAdsList!.length;
        isDataFetching = false;
      });
    });
  }

  getPropertyBusinessAds({String? sortedBy}) async {
    BusinessViewModel businessViewModel = context.read<BusinessViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result =
        await businessViewModel.getBusinessPropertyAds(sortedBy: sortedBy);
    result.fold((l) {}, (r) {
      businessViewModel.changePropertyBusinessAds(r.propertyProductList!);
      setState(() {
        totalAds = r.propertyProductList!.length;
        isDataFetching = false;
      });
    });
  }

  getJobBusinessAds({String? sortedBy}) async {
    BusinessViewModel businessViewModel = context.read<BusinessViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result =
        await businessViewModel.getBusinessJobAds(sortedBy: sortedBy);
    result.fold((l) {}, (r) {
      businessViewModel.changeJobBusinessAds(r.jobAdsList!);
      setState(() {
        totalAds = r.jobAdsList!.length;
        isDataFetching = false;
      });
    });
  }

  getBusinessStats({required String module}) async {
    BusinessViewModel businessViewModel = context.read<BusinessViewModel>();
    final result = await businessViewModel.getBusinessStats(module: module);
    result.fold((l) {}, (r) {
      setState(() {
        businessStats = r.stats!;
        d('$module businessStats : ${businessStats.activeAds}');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (iPrefHelper.retrieveClassifiedProfile() != null &&
        iPrefHelper.retrieveClassifiedProfile()!.id!.isNotEmpty) {
      moduleList.add('Classified');
    }
    if (iPrefHelper.retrieveAutomotiveProfile() != null &&
        iPrefHelper.retrieveAutomotiveProfile()!.id!.isNotEmpty) {
      moduleList.add('Automotive');
    }
    if (iPrefHelper.retrievePropertyProfile() != null &&
        iPrefHelper.retrievePropertyProfile()!.id!.isNotEmpty) {
      moduleList.add('Property');
      getPropertyBusinessAds();
    }
    if (iPrefHelper.retrieveJobProfile() != null &&
        iPrefHelper.retrieveJobProfile()!.id!.isNotEmpty) {
      moduleList.add('Job');
    }

    if (iPrefHelper.retrieveClassifiedProfile() != null &&
        iPrefHelper.retrieveClassifiedProfile()!.id!.isNotEmpty) {
      getClassifiedBusinessAds();
      getBusinessStats(module: 'Classified');
      selectedModule = 'Classified';
    } else if (iPrefHelper.retrieveAutomotiveProfile() != null &&
        iPrefHelper.retrieveAutomotiveProfile()!.id!.isNotEmpty) {
      getAutomotiveBusinessAds();
      getBusinessStats(module: 'Automotive');
      selectedModule = 'Automotive';
    } else if (iPrefHelper.retrievePropertyProfile() != null &&
        iPrefHelper.retrievePropertyProfile()!.id!.isNotEmpty) {
      getPropertyBusinessAds();
      getBusinessStats(module: 'Property');
      selectedModule = 'Property';
    } else if (iPrefHelper.retrieveJobProfile() != null &&
        iPrefHelper.retrieveJobProfile()!.id!.isNotEmpty) {
      getJobBusinessAds();
      getBusinessStats(module: 'Job');
      selectedModule = 'Job';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    BusinessViewModel businessViewModel = context.watch<BusinessViewModel>();
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    ClassifiedViewModel classifiedViewModel =
        context.watch<ClassifiedViewModel>();
    PropertiesViewModel propertyViewModel =
        context.watch<PropertiesViewModel>();
    AutomotiveViewModel automotiveViewModel =
        context.watch<AutomotiveViewModel>();
    JobViewModel jobViewModel = context.watch<JobViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Dashboard', context: context, onTap: () {Navigator.of(context).pop();}),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.location_on_rounded,
                        color: CustomAppTheme().secondaryColor),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        iPrefHelper.userCurrentCountry().toString(),
                        style: CustomAppTheme()
                            .normalText
                            .copyWith(color: CustomAppTheme().darkGreyColor),
                      ),
                    ),
                    /*Icon(
                      Icons.keyboard_arrow_down,
                      color: CustomAppTheme().darkGreyColor,
                      size: 16,
                    ),*/
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationScreen()));
                      },
                      child: Icon(Icons.notifications,
                          color: CustomAppTheme().darkGreyColor),
                    ),
                  ],
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: med.height * 0.048,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
                    },
                    child: const RoundedTextField(isEnabled: false),
                  ),
                ),
              ),*/
              SizedBox(
                height: med.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  headingText(title: 'Business Overview'),
                  ModuleDropDown(
                    hint: 'Module',
                    icon: null,
                    buttonWidth: med.width * 0.3,
                    dropdownWidth: med.width * 0.3,
                    buttonHeight: med.height * 0.04,
                    dropdownItems: moduleList,
                    value: selectedModule,
                    onChanged: (value) {
                      setState(() {
                        selectedModule = value!;
                        if (value == 'Classified') {
                          getClassifiedBusinessAds();
                          getBusinessStats(module: 'Classified');
                        } else if (value == 'Automotive') {
                          getAutomotiveBusinessAds();
                          getBusinessStats(module: 'Automotive');
                        } else if (value == 'Property') {
                          getPropertyBusinessAds();
                          getBusinessStats(module: 'Property');
                        } else if (value == 'Job') {
                          getJobBusinessAds();
                          getBusinessStats(module: 'Property');
                        }
                      });
                    },
                  ),
                ],
              ),
              /*SizedBox(
                height: med.height * 0.02,
              ),
              Container(
                height: med.height * 0.15,
                width: med.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomAppTheme().primaryColor,
                ),
              ),*/
              /*SizedBox(
                height: med.height * 0.02,
              ),
              headingText(title: 'Business Overview'),*/
              SizedBox(
                height: med.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  overViewCard(
                      value: businessStats.activeAds != null
                          ? businessStats.activeAds!
                          : 0,
                      text: 'Active Ads',
                      svgUrl: 'assets/svgs/promotion (2) 1.svg',
                      color: CustomAppTheme().secondaryColor),
                  overViewCard(
                      value: businessStats.totalAdView != null
                          ? businessStats.totalAdView!
                          : 0,
                      text: 'Total Ad Views',
                      svgUrl: 'assets/svgs/eye (1) 1.svg',
                      color: const Color(0xff4460F0)),
                  overViewCard(
                      value: businessStats.totalProfileView != null
                          ? businessStats.totalProfileView!
                          : 0,
                      text: 'Profile Views',
                      svgUrl: 'assets/svgs/view 1.svg',
                      color: const Color(0xffFF6B6B)),
                ],
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              headingText(title: '$totalAds Active Ads'),
              SizedBox(
                height: med.height * 0.02,
              ),
              isDataFetching
                  ? ListView.builder(
                      itemCount: 4,
                      padding: const EdgeInsets.only(bottom: 10),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Shimmer.fromColors(
                            baseColor: CustomAppTheme().lightGreyColor,
                            highlightColor: CustomAppTheme().backgroundColor,
                            child: Container(
                              height: med.height * 0.15,
                              width: med.width,
                              decoration: BoxDecoration(
                                color: CustomAppTheme().lightGreyColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: selectedModule == 'Classified'
                          ? businessViewModel.classifiedBusinessAds.length
                          : selectedModule == 'Automotive'
                              ? businessViewModel.automotiveBusinessAds.length
                              : selectedModule == 'Property'
                                  ? businessViewModel.propertyBusinessAds.length
                                  : selectedModule == 'Job'
                                      ? businessViewModel.jobBusinessAds.length
                                      : 0,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return selectedModule == 'Classified'
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                        productType: 'Classified',
                                        classifiedProduct: businessViewModel
                                            .classifiedBusinessAds[index],
                                      ),
                                    ),
                                  );
                                },
                                child: ManageAdWidget(
                                  onDeleteTap: () {
                                    showAlertDialog(
                                        context: context,
                                        onDelete: () {
                                          profileViewModel.deleteClassified(
                                              adId: businessViewModel
                                                  .classifiedBusinessAds[index]
                                                  .id!);
                                          businessViewModel
                                              .classifiedBusinessAds
                                              .removeAt(index);
                                          businessViewModel
                                              .changeClassifiedBusinessAds(
                                                  businessViewModel
                                                      .classifiedBusinessAds);
                                          profileViewModel.myFavClassifiedAds
                                              .removeWhere((element) =>
                                                  element.id ==
                                                  businessViewModel
                                                      .classifiedBusinessAds[
                                                          index]
                                                      .id!);
                                          profileViewModel
                                              .changeMyFavClassified(
                                                  profileViewModel
                                                      .myFavClassifiedAds);
                                          profileViewModel.myClassifiedAds
                                              .removeWhere((element) =>
                                                  element.id ==
                                                  businessViewModel
                                                      .classifiedBusinessAds[
                                                          index]
                                                      .id!);
                                          profileViewModel
                                              .changeMyClassifiedAds(
                                                  profileViewModel
                                                      .myClassifiedAds);
                                          classifiedViewModel.classifiedAllAds!
                                              .removeWhere((element) =>
                                                  element.id ==
                                                  businessViewModel
                                                      .classifiedBusinessAds[
                                                          index]
                                                      .id!);
                                          classifiedViewModel
                                              .changeClassifiedAllAds(
                                                  classifiedViewModel
                                                      .classifiedAllAds!);
                                          classifiedViewModel
                                              .classifiedFeaturedAds!
                                              .removeWhere((element) =>
                                                  element.id ==
                                                  businessViewModel
                                                      .classifiedBusinessAds[
                                                          index]
                                                      .id!);
                                          classifiedViewModel
                                              .changeClassifiedFeaturedAds(
                                                  classifiedViewModel
                                                      .classifiedFeaturedAds!);
                                          classifiedViewModel.classifiedDealAds!
                                              .removeWhere((element) =>
                                                  element.id ==
                                                  businessViewModel
                                                      .classifiedBusinessAds[
                                                          index]
                                                      .id!);
                                          classifiedViewModel
                                              .changeClassifiedDealAds(
                                                  classifiedViewModel
                                                      .classifiedDealAds!);
                                          classifiedViewModel
                                              .classifiedRecommendedAds!
                                              .removeWhere((element) =>
                                                  element.id ==
                                                  businessViewModel
                                                      .classifiedBusinessAds[
                                                          index]
                                                      .id!);
                                          classifiedViewModel
                                              .changeClassifiedRecommendedAds(
                                                  classifiedViewModel
                                                      .classifiedRecommendedAds!);
                                          Navigator.pop(context);
                                        });
                                  },
                                  onEditTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UploadImagesVideosScreen(
                                          categoryIndex: 0,
                                          classifiedEditProduct:
                                              businessViewModel
                                                  .classifiedBusinessAds[index],
                                          isEdit: true,
                                        ),
                                      ),
                                    );
                                  },
                                  onToggle: (value) {
                                    // businessViewModel
                                    //     .classifiedBusinessAds[index]
                                    //     .isActive = value;
                                    businessViewModel
                                        .classifiedBusinessAds[index]
                                        .isActive = value;
                                    classifiedViewModel
                                        .classifiedActiveInactive(
                                            adId: businessViewModel
                                                .classifiedBusinessAds[index]
                                                .id!);
                                    businessViewModel
                                        .changeClassifiedBusinessAds(
                                            businessViewModel
                                                .classifiedBusinessAds);
                                    for (int i = 0;
                                        i <
                                            profileViewModel
                                                .myClassifiedAds.length;
                                        i++) {
                                      if (profileViewModel
                                              .myClassifiedAds[i].id ==
                                          businessViewModel
                                              .classifiedBusinessAds[index]
                                              .id!) {
                                        // profileViewModel.myClassifiedAds[i]
                                        //     .isActive = value;
                                        profileViewModel.myClassifiedAds[i]
                                            .isActive = value;
                                        profileViewModel.changeMyClassifiedAds(
                                            profileViewModel.myClassifiedAds);
                                      }
                                    }
                                  },
                                  categoryType: 'Classified',
                                  classifiedProduct: businessViewModel
                                      .classifiedBusinessAds[index],
                                ),
                              )
                            : selectedModule == 'Automotive'
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailScreen(
                                            productType: 'Automotive',
                                            automotiveProduct: businessViewModel
                                                .automotiveBusinessAds[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: ManageAdWidget(
                                      onDeleteTap: () {
                                        profileViewModel.deleteAutomotive(
                                            adId: businessViewModel
                                                .automotiveBusinessAds[index]
                                                .id!);
                                        businessViewModel.automotiveBusinessAds
                                            .removeAt(index);
                                        businessViewModel
                                            .changeAutomotiveBusinessAds(
                                                businessViewModel
                                                    .automotiveBusinessAds);
                                        profileViewModel.myFavAutomotiveAds
                                            .removeWhere((element) =>
                                                element.id ==
                                                businessViewModel
                                                    .automotiveBusinessAds[
                                                        index]
                                                    .id!);
                                        profileViewModel.changeMyFavAutomotive(
                                            profileViewModel
                                                .myFavAutomotiveAds);
                                        profileViewModel.myAutomotiveAds
                                            .removeWhere((element) =>
                                                element.id ==
                                                businessViewModel
                                                    .automotiveBusinessAds[
                                                        index]
                                                    .id!);
                                        profileViewModel.changeMyAutomotiveAds(
                                            profileViewModel.myAutomotiveAds);
                                        automotiveViewModel.automotiveAllAds
                                            .removeWhere((element) =>
                                                element.id ==
                                                businessViewModel
                                                    .automotiveBusinessAds[
                                                        index]
                                                    .id!);
                                        automotiveViewModel
                                            .changeAutomotiveAllAds(
                                                automotiveViewModel
                                                    .automotiveAllAds);
                                        automotiveViewModel
                                            .automotiveFeaturedAds!
                                            .removeWhere((element) =>
                                                element.id ==
                                                businessViewModel
                                                    .automotiveBusinessAds[
                                                        index]
                                                    .id!);
                                        automotiveViewModel
                                            .changeAutomotiveFeaturedAds(
                                                automotiveViewModel
                                                    .automotiveFeaturedAds!);
                                      },
                                      onEditTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UploadImagesVideosScreen(
                                              categoryIndex: 2,
                                              automotiveEditProduct:
                                                  businessViewModel
                                                          .automotiveBusinessAds[
                                                      index],
                                              isEdit: true,
                                            ),
                                          ),
                                        );
                                      },
                                      onToggle: (value) {
                                        profileViewModel
                                            .automotiveActiveInactive(
                                                adId: businessViewModel
                                                    .automotiveBusinessAds[
                                                        index]
                                                    .id!);
                                        businessViewModel
                                            .automotiveBusinessAds[index]
                                            .isActive = value;
                                        businessViewModel
                                            .changeAutomotiveBusinessAds(
                                                businessViewModel
                                                    .automotiveBusinessAds);
                                        for (int i = 0;
                                            i <
                                                profileViewModel
                                                    .myAutomotiveAds.length;
                                            i++) {
                                          if (profileViewModel
                                                  .myAutomotiveAds[i].id ==
                                              businessViewModel
                                                  .automotiveBusinessAds[index]
                                                  .id!) {
                                            profileViewModel.myAutomotiveAds[i]
                                                .isActive = value;
                                            profileViewModel
                                                .changeMyAutomotiveAds(
                                                    profileViewModel
                                                        .myAutomotiveAds);
                                          }
                                        }
                                      },
                                      categoryType: 'Automotive',
                                      automotiveProduct: businessViewModel
                                          .automotiveBusinessAds[index],
                                    ),
                                  )
                                : selectedModule == 'Property'
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailScreen(
                                                productType: 'Property',
                                                propertyProduct:
                                                    businessViewModel
                                                            .propertyBusinessAds[
                                                        index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: ManageAdWidget(
                                          onDeleteTap: () {
                                            profileViewModel.deleteProperty(
                                                adId: businessViewModel
                                                    .propertyBusinessAds[index]
                                                    .id!);
                                            businessViewModel
                                                .propertyBusinessAds
                                                .removeAt(index);
                                            businessViewModel
                                                .changePropertyBusinessAds(
                                                    businessViewModel
                                                        .propertyBusinessAds);
                                            profileViewModel.myFavPropertyAds
                                                .removeWhere((element) =>
                                                    element.id ==
                                                    businessViewModel
                                                        .propertyBusinessAds[
                                                            index]
                                                        .id!);
                                            profileViewModel
                                                .changeMyFavProperty(
                                                    profileViewModel
                                                        .myFavPropertyAds);
                                            profileViewModel.myPropertiesAds
                                                .removeWhere((element) =>
                                                    element.id ==
                                                    businessViewModel
                                                        .propertyBusinessAds[
                                                            index]
                                                        .id!);
                                            profileViewModel
                                                .changeMyPropertiesAds(
                                                    profileViewModel
                                                        .myPropertiesAds);
                                            propertyViewModel.propertyAllAds!
                                                .removeWhere((element) =>
                                                    element.id ==
                                                    businessViewModel
                                                        .propertyBusinessAds[
                                                            index]
                                                        .id!);
                                            propertyViewModel
                                                .changePropertiesAllAds(
                                                    propertyViewModel
                                                        .propertyAllAds);
                                            propertyViewModel
                                                .propertyFeaturedAds!
                                                .removeWhere((element) =>
                                                    element.id ==
                                                    businessViewModel
                                                        .propertyBusinessAds[
                                                            index]
                                                        .id!);
                                            propertyViewModel
                                                .changePropertyFeaturedAds(
                                                    propertyViewModel
                                                        .propertyFeaturedAds!);
                                          },
                                          onEditTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UploadImagesVideosScreen(
                                                  categoryIndex: 1,
                                                  propertyEditProduct:
                                                      businessViewModel
                                                              .propertyBusinessAds[
                                                          index],
                                                  isEdit: true,
                                                ),
                                              ),
                                            );
                                          },
                                          onToggle: (value) {
                                            profileViewModel
                                                .propertyActiveInactive(
                                                    adId: businessViewModel
                                                        .propertyBusinessAds[
                                                            index]
                                                        .id!);
                                            businessViewModel
                                                .propertyBusinessAds[index]
                                                .isActive = value;
                                            businessViewModel
                                                .changePropertyBusinessAds(
                                                    businessViewModel
                                                        .propertyBusinessAds);
                                            for (int i = 0;
                                                i <
                                                    profileViewModel
                                                        .myPropertiesAds.length;
                                                i++) {
                                              if (profileViewModel
                                                      .myPropertiesAds[i].id ==
                                                  businessViewModel
                                                      .propertyBusinessAds[
                                                          index]
                                                      .id!) {
                                                profileViewModel
                                                    .myPropertiesAds[i]
                                                    .isActive = value;
                                                profileViewModel
                                                    .changeMyPropertiesAds(
                                                        profileViewModel
                                                            .myPropertiesAds);
                                              }
                                            }
                                          },
                                          categoryType: 'Property',
                                          propertyProduct: businessViewModel
                                              .propertyBusinessAds[index],
                                        ),
                                      )
                                    : selectedModule == 'Job'
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailScreen(
                                                    productType: 'Job',
                                                    jobProduct:
                                                        businessViewModel
                                                                .jobBusinessAds[
                                                            index],
                                                    isJobAd: true,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ManageAdWidget(
                                              onDeleteTap: () {
                                                profileViewModel.deleteProperty(
                                                    adId: businessViewModel
                                                        .jobBusinessAds[index]
                                                        .id!);
                                                businessViewModel.jobBusinessAds
                                                    .removeAt(index);
                                                businessViewModel
                                                    .changeJobBusinessAds(
                                                        businessViewModel
                                                            .jobBusinessAds);
                                                profileViewModel.myFavJobAds
                                                    .removeWhere((element) =>
                                                        element.id ==
                                                        businessViewModel
                                                            .jobBusinessAds[
                                                                index]
                                                            .id!);
                                                profileViewModel.changeMyFavJob(
                                                    profileViewModel
                                                        .myFavJobAds);
                                                profileViewModel.myJobAds
                                                    .removeWhere((element) =>
                                                        element.id ==
                                                        businessViewModel
                                                            .jobBusinessAds[
                                                                index]
                                                            .id!);
                                                profileViewModel.changeMyJobAds(
                                                    profileViewModel.myJobAds);
                                                jobViewModel.jobAllAds!
                                                    .removeWhere((element) =>
                                                        element.id ==
                                                        businessViewModel
                                                            .jobBusinessAds[
                                                                index]
                                                            .id!);
                                                jobViewModel.changeJobAllAds(
                                                    jobViewModel.jobAllAds!);
                                                jobViewModel.jobFeaturedAds!
                                                    .removeWhere((element) =>
                                                        element.id ==
                                                        businessViewModel
                                                            .jobBusinessAds[
                                                                index]
                                                            .id!);
                                                jobViewModel
                                                    .changeJobFeaturedAds(
                                                        jobViewModel
                                                            .jobFeaturedAds!);
                                              },
                                              onEditTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UploadImagesVideosScreen(
                                                      categoryIndex: 3,
                                                      jobEditModel:
                                                          businessViewModel
                                                                  .jobBusinessAds[
                                                              index],
                                                      isEdit: true,
                                                    ),
                                                  ),
                                                );
                                              },
                                              onToggle: (value) {
                                                profileViewModel
                                                    .jobActiveInactive(
                                                        adId: businessViewModel
                                                            .jobBusinessAds[
                                                                index]
                                                            .id!);
                                                businessViewModel
                                                    .jobBusinessAds[index]
                                                    .isActive = value;
                                                businessViewModel
                                                    .changeJobBusinessAds(
                                                        businessViewModel
                                                            .jobBusinessAds);
                                                for (int i = 0;
                                                    i <
                                                        profileViewModel
                                                            .myJobAds.length;
                                                    i++) {
                                                  if (profileViewModel
                                                          .myJobAds[i].id ==
                                                      businessViewModel
                                                          .jobBusinessAds[index]
                                                          .id!) {
                                                    profileViewModel.myJobAds[i]
                                                        .isActive = value;
                                                    profileViewModel
                                                        .changeMyJobAds(
                                                            profileViewModel
                                                                .myJobAds);
                                                  }
                                                }
                                              },
                                              categoryType: 'Job',
                                              jobProduct: businessViewModel
                                                  .jobBusinessAds[index],
                                            ),
                                          )
                                        : const SizedBox.shrink();
                      },
                    ),
              SizedBox(
                height: med.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> moduleList = <String>[];
  String? selectedModule;

  Widget headingText({required String title}) {
    return Text(
      title,
      style: CustomAppTheme()
          .normalText
          .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }

  Widget overViewCard(
      {required int value,
      required String text,
      required Color color,
      required String svgUrl}) {
    Size med = MediaQuery.of(context).size;
    return Container(
      height: med.height * 0.15,
      width: med.width * 0.29,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: med.height * 0.05,
              width: med.width * 0.1,
              decoration: const BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
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
            Text(
              value.toString(),
              style: CustomAppTheme().normalText.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: CustomAppTheme().backgroundColor),
            ),
            Text(
              text,
              style: CustomAppTheme().normalText.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: CustomAppTheme().backgroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
