import 'package:app/common/logger/log.dart';
import 'package:app/presentation/add_post/upload_images_videos.dart';
import 'package:app/presentation/add_post/view_model/create_ad_post_view_model.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/profile/business_mode/create_business_profile.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/profile/widgets/delete_dialog_box.dart';
import 'package:app/presentation/profile/widgets/manage_ad_widget.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/explore_more_button.dart';
import 'package:app/presentation/utils/widgets/sorted_by_dropdown.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageAdsScreen extends StatefulWidget {
  const ManageAdsScreen({Key? key}) : super(key: key);

  @override
  State<ManageAdsScreen> createState() => _ManageAdsScreenState();
}

class _ManageAdsScreenState extends State<ManageAdsScreen> {
  int selectedManageAdIndex = 0;
  int totalClassifiedAds = 0;
  int totalAutoAds = 0;
  int totalPropertyAds = 0;
  int totalJobAds = 0;
  bool isActive = false;
  bool isExploringMore = false;
  String selectedMenu = 'Classified';

  getMyClassifiedAds({String? sortedBy, int? pageNo = 1}) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();

    final result = await profileViewModel.getMyClassifiedAds(
        sortedBy: sortedBy, pageNo: pageNo);
    result.fold((l) {}, (r) {
      d('CLASSIFIED MY ADS : ${r.results}');
      double totalPagesInDouble = r.count! / 20;
      int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
          ? totalPagesInDouble.toInt() + 1
          : totalPagesInDouble.toInt();
      profileViewModel.allClassifiedTotalPages = totalPagesInInt;
      if (pageNo == 1) {
        profileViewModel.changeMyClassifiedAds(r.results!);
      }
      {
        profileViewModel.myClassifiedAds.addAll(r.results!);
        profileViewModel
            .changeMyClassifiedAds(profileViewModel.myClassifiedAds);
      }
      setState(() {
        totalClassifiedAds = profileViewModel.myClassifiedAds.length;
      });
    });
  }

  getMyAutomotiveAds({String? sortedBy, int? pageNo = 1}) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result = await profileViewModel.getMyAutomotiveAds(
        sortedBy: sortedBy, pageNo: pageNo);
    result.fold((l) {}, (r) {
      d('AUTOMOTIVE MY ADS : ${r.automotiveAdsList}');
      double totalPagesInDouble = r.count! / 20;
      int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
          ? totalPagesInDouble.toInt() + 1
          : totalPagesInDouble.toInt();
      profileViewModel.autoAllAdsTotalPages = totalPagesInInt;
      if (pageNo == 1) {
        profileViewModel.changeMyAutomotiveAds(r.automotiveAdsList!);
      }
      {
        profileViewModel.myAutomotiveAds.addAll(r.automotiveAdsList!);
        profileViewModel
            .changeMyAutomotiveAds(profileViewModel.myAutomotiveAds);
      }

      totalAutoAds = profileViewModel.myAutomotiveAds.length;
      setState(() {});
    });
  }

  getMyPropertyAds({String? sortedBy, int? pageNo = 1}) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result = await profileViewModel.getMyPropertiesAds(
        sortedBy: sortedBy, pageNo: pageNo);
    result.fold((l) {}, (r) {
      d('PROPERTIES MY ADS : ${r.propertyProductList}');
      d(r.count.toString());
      double totalPagesInDouble = r.count! / 20;
      int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
          ? totalPagesInDouble.toInt() + 1
          : totalPagesInDouble.toInt();
      profileViewModel.allPropertiesTotalPages = totalPagesInInt;
      if (pageNo == 1) {
        profileViewModel.changeMyPropertiesAds(r.propertyProductList!);
      }
      {
        profileViewModel.myPropertiesAds.addAll(r.propertyProductList!);
        profileViewModel
            .changeMyPropertiesAds(profileViewModel.myPropertiesAds);
      }

      totalPropertyAds = profileViewModel.myPropertiesAds.length;
      setState(() {});
    });
  }

  getMyJobAds({String? sortedBy, int? pageNo = 1}) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result =
        await profileViewModel.getMyJobAds(sortedBy: sortedBy, pageNo: pageNo);
    result.fold((l) {}, (r) {
      d('PROPERTIES MY ADS : ${r.jobAdsList}');
      double totalPagesInDouble = r.count! / 20;
      int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
          ? totalPagesInDouble.toInt() + 1
          : totalPagesInDouble.toInt();
      profileViewModel.allJobTotalPages = totalPagesInInt;
      if (pageNo == 1) {
        profileViewModel.changeMyJobAds(r.jobAdsList!);
      }
      {
        profileViewModel.myJobAds.addAll(r.jobAdsList!);
        profileViewModel.changeMyJobAds(profileViewModel.myJobAds);
      }

      totalJobAds = profileViewModel.myJobAds.length;
      setState(() {});
    });
  }

  @override
  void initState() {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    super.initState();

    if (profileViewModel.myClassifiedAds.isEmpty) {
      getMyClassifiedAds(pageNo: 1);
    }
    if (profileViewModel.myAutomotiveAds.isEmpty) {
      getMyAutomotiveAds(pageNo: 1);
    }
    if (profileViewModel.myPropertiesAds.isEmpty) {
      getMyPropertyAds(pageNo: 1);
    }
    if (profileViewModel.myJobAds.isEmpty) {
      getMyJobAds(pageNo: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    ClassifiedViewModel classifiedViewModel =
        context.watch<ClassifiedViewModel>();
    PropertiesViewModel propertyViewModel =
        context.watch<PropertiesViewModel>();
    AutomotiveViewModel automotiveViewModel =
        context.watch<AutomotiveViewModel>();
    JobViewModel jobViewModel = context.watch<JobViewModel>();
    final CreateAdPostViewModel createAdPostViewModel =
        context.watch<CreateAdPostViewModel>();

    setState(() {
      totalJobAds = profileViewModel.myJobAds.length;
      totalPropertyAds = profileViewModel.myPropertiesAds.length;
      totalAutoAds = profileViewModel.myAutomotiveAds.length;
      totalClassifiedAds = profileViewModel.myClassifiedAds.length;
    });
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Manage Ads', context: context, onTap: () {Navigator.of(context).pop();}),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: med.height * 0.035,
              child: ListView.builder(
                itemCount: manageAdsList.length,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedManageAdIndex = index;
                          selectedSort = null;
                          // totalAds = selectedManageAdIndex == 0
                          //     ? profileViewModel.myClassifiedAds.length
                          //     : selectedManageAdIndex == 1
                          //         ? profileViewModel.myAutomotiveAds.length
                          //         : selectedManageAdIndex == 2
                          //             ? profileViewModel.myPropertiesAds.length
                          //             : profileViewModel.myJobAds.length;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedManageAdIndex == index
                                ? CustomAppTheme().primaryColor
                                : CustomAppTheme().greyColor,
                          ),
                          color: selectedManageAdIndex == index
                              ? CustomAppTheme().lightGreenColor
                              : CustomAppTheme().lightGreyColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            child: Text(
                              manageAdsList[index],
                              style: CustomAppTheme().normalText.copyWith(
                                    letterSpacing: 0.5,
                                    color: selectedManageAdIndex == index
                                        ? CustomAppTheme().primaryColor
                                        : CustomAppTheme().darkGreyColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: med.height * 0.02,
            ),
            Expanded(
              child:
                  selectedManageAdIndex == 0 &&
                          profileViewModel.myClassifiedAds.isEmpty
                      ? Center(child: noDataFound())
                      : selectedManageAdIndex == 1 &&
                              profileViewModel.myAutomotiveAds.isEmpty
                          ? Center(child: noDataFound())
                          : selectedManageAdIndex == 2 &&
                                  profileViewModel.myPropertiesAds.isEmpty
                              ? Center(child: noDataFound())
                              : selectedManageAdIndex == 3 &&
                                      profileViewModel.myJobAds.isEmpty
                                  ? Center(child: noDataFound())
                                  : SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                selectedManageAdIndex == 0
                                                    ? '${totalClassifiedAds.toString()} ${manageAdsList[selectedManageAdIndex]} ${totalClassifiedAds == 0 || totalClassifiedAds == 1 ? 'Ad' : 'Ads'}'
                                                    : selectedManageAdIndex == 1
                                                        ? '${totalAutoAds.toString()} ${manageAdsList[selectedManageAdIndex]} ${totalAutoAds == 0 || totalAutoAds == 1 ? 'Ad' : 'Ads'}'
                                                        : selectedManageAdIndex ==
                                                                2
                                                            ? '${totalPropertyAds.toString()} ${manageAdsList[selectedManageAdIndex]} ${totalPropertyAds == 0 || totalPropertyAds == 1 ? 'Ad' : 'Ads'}'
                                                            : '${totalJobAds.toString()} ${manageAdsList[selectedManageAdIndex]} ${totalJobAds == 0 || totalJobAds == 1 ? 'Ad' : 'Ads'}',
                                                style: CustomAppTheme()
                                                    .headingText
                                                    .copyWith(
                                                        fontSize: 20,
                                                        color: CustomAppTheme()
                                                            .blackColor),
                                              ),
                                              SortedByDropDown(
                                                hint: 'Sort by',
                                                icon: null,
                                                buttonWidth: med.width * 0.3,
                                                buttonHeight: med.height * 0.04,
                                                dropdownItems: sortedByList,
                                                value: selectedSort,
                                                onChanged: (value) {
                                                  print(
                                                      "object : ${value!.replaceAll(' ', '').toLowerCase()}");
                                                  setState(() {
                                                    selectedSort = value;
                                                    if (selectedManageAdIndex ==
                                                        0) {
                                                      getMyClassifiedAds(
                                                          sortedBy: value
                                                              .replaceAll(
                                                                  ' ', '')
                                                              .toLowerCase());
                                                    } else if (selectedManageAdIndex ==
                                                        1) {
                                                      getMyAutomotiveAds(
                                                          sortedBy: value
                                                              .replaceAll(
                                                                  ' ', '')
                                                              .toLowerCase());
                                                    } else if (selectedManageAdIndex ==
                                                        2) {
                                                      getMyPropertyAds(
                                                          sortedBy: value
                                                              .replaceAll(
                                                                  ' ', '')
                                                              .toLowerCase());
                                                    } else {
                                                      getMyJobAds(
                                                          sortedBy: value
                                                              .replaceAll(
                                                                  ' ', '')
                                                              .toLowerCase());
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: med.height * 0.02,
                                          ),
                                          ListView.builder(
                                            itemCount: selectedManageAdIndex ==
                                                    0
                                                ? profileViewModel
                                                    .myClassifiedAds.length
                                                : selectedManageAdIndex == 1
                                                    ? profileViewModel
                                                        .myAutomotiveAds.length
                                                    : selectedManageAdIndex == 2
                                                        ? profileViewModel
                                                            .myPropertiesAds
                                                            .length
                                                        : profileViewModel
                                                            .myJobAds.length,
                                            shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              // print(
                                              //     "object : ${profileViewModel.myAutomotiveAds[index].rentalHours}");
                                              return selectedManageAdIndex == 0
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductDetailScreen(
                                                              productType:
                                                                  'Classified',
                                                              classifiedProduct:
                                                                  profileViewModel
                                                                          .myClassifiedAds[
                                                                      index],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: ManageAdWidget(
                                                        categoryType:
                                                            'Classified',
                                                        classifiedProduct:
                                                            profileViewModel
                                                                    .myClassifiedAds[
                                                                index],
                                                        onToggle: (value) {
                                                          setState(() {
                                                            profileViewModel
                                                                .myClassifiedAds[
                                                                    index]
                                                                .isActive = value;
                                                            classifiedViewModel
                                                                .classifiedActiveInactive(
                                                                    adId: profileViewModel
                                                                        .myClassifiedAds[
                                                                            index]
                                                                        .id!);
                                                            profileViewModel
                                                                .changeMyClassifiedAds(
                                                                    profileViewModel
                                                                        .myClassifiedAds);
                                                            if (value ==
                                                                false) {
                                                              classifiedViewModel
                                                                  .classifiedAllAds!
                                                                  .removeWhere((element) =>
                                                                      element
                                                                          .id ==
                                                                      profileViewModel
                                                                          .myClassifiedAds[
                                                                              index]
                                                                          .id!);
                                                              classifiedViewModel
                                                                  .changeClassifiedAllAds(
                                                                      classifiedViewModel
                                                                          .classifiedAllAds!);
                                                              classifiedViewModel
                                                                  .classifiedFeaturedAds!
                                                                  .removeWhere((element) =>
                                                                      element
                                                                          .id ==
                                                                      profileViewModel
                                                                          .myClassifiedAds[
                                                                              index]
                                                                          .id!);
                                                              classifiedViewModel
                                                                  .changeClassifiedFeaturedAds(
                                                                      classifiedViewModel
                                                                          .classifiedFeaturedAds!);
                                                              classifiedViewModel
                                                                  .classifiedDealAds!
                                                                  .removeWhere((element) =>
                                                                      element
                                                                          .id ==
                                                                      profileViewModel
                                                                          .myClassifiedAds[
                                                                              index]
                                                                          .id!);
                                                              classifiedViewModel
                                                                  .changeClassifiedDealAds(
                                                                      classifiedViewModel
                                                                          .classifiedDealAds!);
                                                            } else {
                                                              classifiedViewModel
                                                                  .classifiedAllAds!
                                                                  .insert(
                                                                      0,
                                                                      profileViewModel
                                                                              .myClassifiedAds[
                                                                          index]);
                                                              classifiedViewModel
                                                                  .changeClassifiedAllAds(
                                                                      classifiedViewModel
                                                                          .classifiedAllAds!);
                                                            }
                                                          });
                                                        },
                                                        onEditTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UploadImagesVideosScreen(
                                                                categoryIndex:
                                                                    0,
                                                                classifiedEditProduct:
                                                                    profileViewModel
                                                                            .myClassifiedAds[
                                                                        index],
                                                                isEdit: true,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        onDeleteTap: () {
                                                          showAlertDialog(
                                                            context: context,
                                                            onDelete: () {
                                                              Navigator.pop(
                                                                  context);
                                                              profileViewModel.deleteClassified(
                                                                  adId: profileViewModel
                                                                      .myClassifiedAds[
                                                                          index]
                                                                      .id!);
                                                              profileViewModel
                                                                  .myClassifiedAds
                                                                  .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    profileViewModel
                                                                        .myClassifiedAds[
                                                                            index]
                                                                        .id!,
                                                              );
                                                              // profileViewModel
                                                              //     .changeMyClassifiedAds(
                                                              //         profileViewModel
                                                              //             .myClassifiedAds);
                                                              // classifiedViewModel
                                                              //     .classifiedAllAds!
                                                              //     .removeWhere((element) =>
                                                              //         element.id ==
                                                              //         profileViewModel
                                                              //             .myClassifiedAds[
                                                              //                 index]
                                                              //             .id!);
                                                              // classifiedViewModel
                                                              //     .changeClassifiedAllAds(
                                                              //         classifiedViewModel
                                                              //             .classifiedAllAds!);
                                                              // classifiedViewModel
                                                              //     .classifiedFeaturedAds!
                                                              //     .removeWhere((element) =>
                                                              //         element.id ==
                                                              //         profileViewModel
                                                              //             .myClassifiedAds[
                                                              //                 index]
                                                              //             .id!);
                                                              // classifiedViewModel
                                                              //     .changeClassifiedFeaturedAds(
                                                              //         classifiedViewModel
                                                              //             .classifiedFeaturedAds!);
                                                              // classifiedViewModel
                                                              //     .classifiedDealAds!
                                                              //     .removeWhere((element) =>
                                                              //         element.id ==
                                                              //         profileViewModel
                                                              //             .myClassifiedAds[
                                                              //                 index]
                                                              //             .id!);
                                                              classifiedViewModel
                                                                  .changeClassifiedDealAds(
                                                                      classifiedViewModel
                                                                          .classifiedDealAds!);
                                                              setState(() {
                                                                totalClassifiedAds--;
                                                              });
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : selectedManageAdIndex == 1
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProductDetailScreen(
                                                                  productType:
                                                                      'Automotive',
                                                                  automotiveProduct:
                                                                      profileViewModel
                                                                              .myAutomotiveAds[
                                                                          index],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: ManageAdWidget(
                                                            categoryType:
                                                                'Automotive',
                                                            automotiveProduct:
                                                                profileViewModel
                                                                        .myAutomotiveAds[
                                                                    index],
                                                            onToggle: (value) {
                                                              setState(() {
                                                                isActive =
                                                                    value;
                                                                profileViewModel
                                                                    .myAutomotiveAds[
                                                                        index]
                                                                    .isActive = value;
                                                                profileViewModel.automotiveActiveInactive(
                                                                    adId: profileViewModel
                                                                        .myAutomotiveAds[
                                                                            index]
                                                                        .id!);
                                                                profileViewModel
                                                                    .changeMyAutomotiveAds(
                                                                        profileViewModel
                                                                            .myAutomotiveAds);
                                                                if (value) {
                                                                  automotiveViewModel
                                                                      .automotiveAllAds
                                                                      .insert(
                                                                          0,
                                                                          profileViewModel
                                                                              .myAutomotiveAds[index]);
                                                                  automotiveViewModel
                                                                      .changeAutomotiveAllAds(
                                                                          automotiveViewModel
                                                                              .automotiveAllAds);
                                                                } else {
                                                                  automotiveViewModel
                                                                      .automotiveAllAds
                                                                      .removeWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          profileViewModel
                                                                              .myAutomotiveAds[index]
                                                                              .id!);
                                                                  automotiveViewModel
                                                                      .changeAutomotiveAllAds(
                                                                          automotiveViewModel
                                                                              .automotiveAllAds);
                                                                  automotiveViewModel
                                                                      .automotiveFeaturedAds!
                                                                      .removeWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          profileViewModel
                                                                              .myAutomotiveAds[index]
                                                                              .id!);
                                                                  automotiveViewModel
                                                                      .changeAutomotiveFeaturedAds(
                                                                          automotiveViewModel
                                                                              .automotiveFeaturedAds);
                                                                }
                                                              });
                                                            },
                                                            onDeleteTap: () {
                                                              showAlertDialog(
                                                                context:
                                                                    context,
                                                                onDelete: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  profileViewModel.deleteAutomotive(
                                                                      adId: profileViewModel
                                                                          .myAutomotiveAds[
                                                                              index]
                                                                          .id!);
                                                                  profileViewModel
                                                                      .myAutomotiveAds
                                                                      .removeWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          profileViewModel
                                                                              .myAutomotiveAds[index]
                                                                              .id!);
                                                                  // profileViewModel
                                                                  //     .changeMyAutomotiveAds(
                                                                  //         profileViewModel
                                                                  //             .myAutomotiveAds);
                                                                  // automotiveViewModel
                                                                  //     .automotiveAllAds
                                                                  //     .removeWhere((element) =>
                                                                  //         element
                                                                  //             .id ==
                                                                  //         profileViewModel
                                                                  //             .myAutomotiveAds[
                                                                  //                 index]
                                                                  // //             .id!);
                                                                  // automotiveViewModel
                                                                  //     .changeAutomotiveAllAds(
                                                                  //         automotiveViewModel
                                                                  //             .automotiveAllAds);
                                                                  // automotiveViewModel
                                                                  //     .automotiveFeaturedAds!
                                                                  //     .removeWhere((element) =>
                                                                  //         element
                                                                  //             .id ==
                                                                  //         profileViewModel
                                                                  //             .myAutomotiveAds[
                                                                  //                 index]
                                                                  //             .id!);
                                                                  automotiveViewModel
                                                                      .changeAutomotiveFeaturedAds(
                                                                          automotiveViewModel
                                                                              .automotiveFeaturedAds);
                                                                  setState(() {
                                                                    totalAutoAds--;
                                                                  });
                                                                },
                                                              );
                                                            },
                                                            onEditTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          UploadImagesVideosScreen(
                                                                    categoryIndex:
                                                                        2,
                                                                    automotiveEditProduct:
                                                                        profileViewModel
                                                                            .myAutomotiveAds[index],
                                                                    isEdit:
                                                                        true,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      : selectedManageAdIndex ==
                                                              2
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProductDetailScreen(
                                                                      productType:
                                                                          'Property',
                                                                      propertyProduct:
                                                                          profileViewModel
                                                                              .myPropertiesAds[index],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child:
                                                                  ManageAdWidget(
                                                                categoryType:
                                                                    'Property',
                                                                propertyProduct:
                                                                    profileViewModel
                                                                            .myPropertiesAds[
                                                                        index],
                                                                onToggle:
                                                                    (value) {
                                                                  setState(() {
                                                                    profileViewModel
                                                                        .myPropertiesAds[
                                                                            index]
                                                                        .isActive = value;
                                                                    profileViewModel.propertyActiveInactive(
                                                                        adId: profileViewModel
                                                                            .myPropertiesAds[index]
                                                                            .id!);
                                                                    profileViewModel
                                                                        .changeMyPropertiesAds(
                                                                            profileViewModel.myPropertiesAds);
                                                                    if (value) {
                                                                      propertyViewModel
                                                                          .propertyAllAds
                                                                          ?.insert(
                                                                              0,
                                                                              profileViewModel.myPropertiesAds[index]);
                                                                      propertyViewModel
                                                                          .changePropertiesAllAds(
                                                                              propertyViewModel.propertyAllAds!);
                                                                    } else {
                                                                      propertyViewModel.propertyAllAds!.removeWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          profileViewModel
                                                                              .myPropertiesAds[index]
                                                                              .id!);
                                                                      propertyViewModel
                                                                          .changePropertiesAllAds(
                                                                              propertyViewModel.propertyAllAds!);
                                                                      propertyViewModel.propertyFeaturedAds!.removeWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          profileViewModel
                                                                              .myPropertiesAds[index]
                                                                              .id!);
                                                                      propertyViewModel
                                                                          .changePropertyFeaturedAds(
                                                                              propertyViewModel.propertyFeaturedAds!);
                                                                    }
                                                                  });
                                                                },
                                                                onEditTap: () {
                                                                  print(
                                                                      "object:: City ID: ${profileViewModel.myPropertiesAds[index].cityId}");
                                                                  print(
                                                                      "object:: Located ID: ${profileViewModel.myPropertiesAds[index].located?.id}");
                                                                  print(
                                                                      "object:: Located Name: ${profileViewModel.myPropertiesAds[index].located?.name}");

                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              UploadImagesVideosScreen(
                                                                        categoryIndex:
                                                                            1,
                                                                        propertyEditProduct:
                                                                            profileViewModel.myPropertiesAds[index],
                                                                        isEdit:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                onDeleteTap:
                                                                    () {
                                                                  showAlertDialog(
                                                                    context:
                                                                        context,
                                                                    onDelete:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      profileViewModel.deleteProperty(
                                                                          adId: profileViewModel
                                                                              .myPropertiesAds[index]
                                                                              .id!);
                                                                      profileViewModel.myPropertiesAds.removeWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          profileViewModel
                                                                              .myPropertiesAds[index]
                                                                              .id!);
                                                                      profileViewModel
                                                                          .changeMyPropertiesAds(
                                                                              profileViewModel.myPropertiesAds);
                                                                      setState(
                                                                          () {
                                                                        totalPropertyAds--;
                                                                      });
                                                                      // propertyViewModel
                                                                      //     .propertyAllAds!
                                                                      //     .removeWhere((element) =>
                                                                      //         element
                                                                      //             .id ==
                                                                      //         profileViewModel
                                                                      //             .myPropertiesAds[index]
                                                                      //             .id!);
                                                                      // propertyViewModel
                                                                      //     .changePropertiesAllAds(
                                                                      //         propertyViewModel
                                                                      //             .propertyAllAds!);
                                                                      // propertyViewModel
                                                                      //     .propertyFeaturedAds!
                                                                      //     .removeWhere((element) =>
                                                                      //         element
                                                                      //             .id ==
                                                                      //         profileViewModel
                                                                      //             .myPropertiesAds[index]
                                                                      //             .id!);
                                                                      // propertyViewModel
                                                                      //     .changePropertyFeaturedAds(
                                                                      //         propertyViewModel
                                                                      //             .propertyFeaturedAds!);
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProductDetailScreen(
                                                                      productType:
                                                                          'Job',
                                                                      jobProduct:
                                                                          profileViewModel
                                                                              .myJobAds[index],
                                                                      isJobAd:
                                                                          true,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child:
                                                                  ManageAdWidget(
                                                                categoryType:
                                                                    'Job',
                                                                jobProduct:
                                                                    profileViewModel
                                                                            .myJobAds[
                                                                        index],
                                                                onToggle:
                                                                    (value) {
                                                                  setState(() {
                                                                    profileViewModel
                                                                        .myJobAds[
                                                                            index]
                                                                        .isActive = value;
                                                                    profileViewModel.jobActiveInactive(
                                                                        adId: profileViewModel
                                                                            .myJobAds[index]
                                                                            .id!);
                                                                    profileViewModel
                                                                        .changeMyJobAds(
                                                                            profileViewModel.myJobAds);
                                                                    if (value) {
                                                                      jobViewModel
                                                                          .jobAllAds!
                                                                          .insert(
                                                                              0,
                                                                              profileViewModel.myJobAds[index]);
                                                                      jobViewModel
                                                                          .changeJobAllAds(
                                                                              jobViewModel.jobAllAds!);
                                                                    } else {
                                                                      jobViewModel.jobAllAds!.removeWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          profileViewModel
                                                                              .myJobAds[index]
                                                                              .id!);
                                                                      jobViewModel
                                                                          .changeJobAllAds(
                                                                              jobViewModel.jobAllAds!);
                                                                      jobViewModel.jobFeaturedAds!.removeWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          profileViewModel
                                                                              .myJobAds[index]
                                                                              .id!);
                                                                      jobViewModel
                                                                          .changeJobFeaturedAds(
                                                                              jobViewModel.jobFeaturedAds!);
                                                                    }
                                                                  });
                                                                },
                                                                onDeleteTap:
                                                                    () {
                                                                  showAlertDialog(
                                                                    context:
                                                                        context,
                                                                    onDelete:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      profileViewModel.deleteJob(
                                                                          adId: profileViewModel
                                                                              .myJobAds[index]
                                                                              .id!);
                                                                      profileViewModel.myJobAds.removeWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          profileViewModel
                                                                              .myJobAds[index]
                                                                              .id!);
                                                                      profileViewModel
                                                                          .changeMyJobAds(
                                                                              profileViewModel.myJobAds);
                                                                      setState(
                                                                          () {
                                                                        totalJobAds--;
                                                                      });
                                                                      // jobViewModel
                                                                      //     .jobAllAds!
                                                                      //     .removeWhere((element) =>
                                                                      //         element
                                                                      //             .id ==
                                                                      //         profileViewModel
                                                                      //             .myJobAds[index]
                                                                      //             .id!);
                                                                      // jobViewModel.changeJobAllAds(
                                                                      //     jobViewModel
                                                                      //         .jobAllAds!);
                                                                      // jobViewModel
                                                                      //     .jobFeaturedAds!
                                                                      //     .removeWhere((element) =>
                                                                      //         element
                                                                      //             .id ==
                                                                      //         profileViewModel
                                                                      //             .myJobAds[index]
                                                                      //             .id!);
                                                                      // jobViewModel.changeJobFeaturedAds(
                                                                      //     jobViewModel
                                                                      //         .jobFeaturedAds!);
                                                                    },
                                                                  );
                                                                },
                                                                onEditTap: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              UploadImagesVideosScreen(
                                                                        categoryIndex:
                                                                            3,
                                                                        jobEditModel:
                                                                            profileViewModel.myJobAds[index],
                                                                        isEdit:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            );
                                            },
                                          ),
                                          isExploringMore
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: CustomAppTheme()
                                                              .primaryColor),
                                                )
                                              : selectedManageAdIndex == 0
                                                  ? profileViewModel
                                                          .myClassifiedAds
                                                          .isEmpty
                                                      ? Container()
                                                      : Center(
                                                          child: profileViewModel
                                                                      .allClassifiedPageNo !=
                                                                  profileViewModel
                                                                      .allClassifiedTotalPages
                                                              ? ExploreMoreButton(
                                                                  onTab:
                                                                      () async {
                                                                    if (selectedManageAdIndex ==
                                                                        0) {
                                                                      profileViewModel
                                                                              .allClassifiedPageNo =
                                                                          profileViewModel.allClassifiedPageNo +
                                                                              1;
                                                                      setState(
                                                                          () {
                                                                        isExploringMore =
                                                                            true;
                                                                      });
                                                                      await getMyClassifiedAds(
                                                                          pageNo:
                                                                              profileViewModel.allClassifiedPageNo);
                                                                      setState(
                                                                          () {
                                                                        isExploringMore =
                                                                            false;
                                                                      });
                                                                    }
                                                                  },
                                                                )
                                                              : const SizedBox
                                                                  .shrink(),
                                                        )
                                                  : selectedManageAdIndex == 1
                                                      ? profileViewModel
                                                              .myAutomotiveAds
                                                              .isEmpty
                                                          ? Container()
                                                          : Center(
                                                              child: profileViewModel
                                                                          .autoAllAdsPageNo !=
                                                                      profileViewModel
                                                                          .autoAllAdsTotalPages
                                                                  ? ExploreMoreButton(
                                                                      onTab:
                                                                          () async {
                                                                        if (selectedManageAdIndex ==
                                                                            1) {
                                                                          profileViewModel.autoAllAdsPageNo =
                                                                              profileViewModel.autoAllAdsPageNo + 1;
                                                                          setState(
                                                                              () {
                                                                            isExploringMore =
                                                                                true;
                                                                          });
                                                                          await getMyAutomotiveAds(
                                                                              pageNo: profileViewModel.autoAllAdsPageNo);
                                                                          setState(
                                                                              () {
                                                                            isExploringMore =
                                                                                false;
                                                                          });
                                                                        }
                                                                      },
                                                                    )
                                                                  : const SizedBox
                                                                      .shrink(),
                                                            )
                                                      : selectedManageAdIndex ==
                                                              2
                                                          ? profileViewModel
                                                                  .myPropertiesAds
                                                                  .isEmpty
                                                              ? Container()
                                                              : Center(
                                                                  child: profileViewModel
                                                                              .allPropertiesPageNo !=
                                                                          profileViewModel
                                                                              .allPropertiesTotalPages
                                                                      ? ExploreMoreButton(
                                                                          onTab:
                                                                              () async {
                                                                            if (selectedManageAdIndex ==
                                                                                2) {
                                                                              profileViewModel.allPropertiesPageNo = profileViewModel.allPropertiesPageNo + 1;
                                                                              setState(() {
                                                                                isExploringMore = true;
                                                                              });
                                                                              await getMyPropertyAds(pageNo: profileViewModel.allPropertiesPageNo);
                                                                              setState(() {
                                                                                isExploringMore = false;
                                                                              });
                                                                            }
                                                                          },
                                                                        )
                                                                      : const SizedBox
                                                                          .shrink(),
                                                                )
                                                          : selectedManageAdIndex ==
                                                                  3
                                                              ? profileViewModel
                                                                      .myJobAds
                                                                      .isEmpty
                                                                  ? Container()
                                                                  : Center(
                                                                      child: profileViewModel.allJobPageNo !=
                                                                              profileViewModel.allJobTotalPages
                                                                          ? ExploreMoreButton(
                                                                              onTab: () async {
                                                                                if (selectedManageAdIndex == 3) {
                                                                                  profileViewModel.allJobPageNo = profileViewModel.allJobPageNo + 1;
                                                                                  setState(() {
                                                                                    isExploringMore = true;
                                                                                  });
                                                                                  await getMyJobAds(pageNo: profileViewModel.allJobPageNo);
                                                                                  setState(() {
                                                                                    isExploringMore = false;
                                                                                  });
                                                                                }
                                                                              },
                                                                            )
                                                                          : const SizedBox.shrink(),
                                                                    )
                                                              : const SizedBox
                                                                  .shrink(),
                                        ],
                                      ),
                                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> manageAdsList = [
    'Classified',
    'Automotive',
    'Property',
    'Job',
  ];

  String? selectedSort;
  final List<String> sortedByList = [
    'Low to high',
    'High to low',
  ];
}
