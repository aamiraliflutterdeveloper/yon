import 'package:app/common/logger/log.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/profile/business_mode/create_business_profile.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/shimmers/product_card_shimmer.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/jobAds_widget.dart';
import 'package:app/presentation/utils/widgets/product_card.dart';
import 'package:app/presentation/utils/widgets/sorted_by_dropdown.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedAdsScreen extends StatefulWidget {
  const SavedAdsScreen({Key? key}) : super(key: key);

  @override
  State<SavedAdsScreen> createState() => _SavedAdsScreenState();
}

class _SavedAdsScreenState extends State<SavedAdsScreen> {
  int selectedAllMenuIndex = 0;
  int totalAds = 0;
  String selectedMenu = 'Classified';

  getMyFavClassifiedAds(String sortedBy) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result =
        await profileViewModel.getMyFavClassifiedAds(sortedBy: sortedBy);
    result.fold((l) {}, (r) {
      d('CLASSIFIED MY FAV ADS : ${r.results}');
      profileViewModel.changeMyFavClassified(r.results!);
    });
    totalAds = profileViewModel.myFavClassifiedAds.length;
  }

  getMyFavAutomotiveAds(String sortedBy) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result =
        await profileViewModel.getMyFavAutomotiveAds(sortedBy: sortedBy);
    result.fold((l) {}, (r) {
      d('AUTOMOTIVE MY FAV ADS : ${r.automotiveAdsList}');
      profileViewModel.changeMyFavAutomotive(r.automotiveAdsList!);
    });
  }

  getMyFavPropertyAds(String sortedBy) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result =
        await profileViewModel.getMyFavPropertyAds(sortedBy: sortedBy);
    result.fold((l) {}, (r) {
      d('PROPERTIES MY FAV ADS : ${r.propertyProductList}');
      profileViewModel.changeMyFavProperty(r.propertyProductList!);
    });
  }

  getMyFavJobAds(String sortedBy) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result = await profileViewModel.getMyFavJobAds(sortedBy: sortedBy);
    result.fold((l) {}, (r) {
      d('PROPERTIES MY FAV ADS : ${r.jobAdsList}');
      profileViewModel.changeMyFavJob(r.jobAdsList!);
    });
  }

  @override
  void initState() {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    super.initState();
    getMyFavClassifiedAds('lowtohigh');
    getMyFavAutomotiveAds('lowtohigh');
    getMyFavPropertyAds('lowtohigh');
    getMyFavJobAds('lowtohigh');
    /*if (profileViewModel.myFavClassifiedAds.isEmpty) {
      getMyFavClassifiedAds('lowtohigh');
    }
    if (profileViewModel.myFavAutomotiveAds.isEmpty) {
      getMyFavAutomotiveAds('lowtohigh');
    }
    if (profileViewModel.myFavPropertyAds.isEmpty) {
      getMyFavPropertyAds('lowtohigh');
    }
    if (profileViewModel.myFavJobAds.isEmpty) {
      getMyFavJobAds('lowtohigh');
    }*/
    totalAds = profileViewModel.myFavClassifiedAds.length;
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    ClassifiedViewModel classifiedViewModel =
        context.watch<ClassifiedViewModel>();
    PropertiesViewModel propertiesViewModel =
        context.watch<PropertiesViewModel>();
    AutomotiveViewModel automotiveViewModel =
        context.watch<AutomotiveViewModel>();
    JobViewModel jobViewModel = context.watch<JobViewModel>();
    setState(
      () {
        totalAds = selectedAllMenuIndex == 0
            ? profileViewModel.myFavClassifiedAds.length
            : selectedAllMenuIndex == 1
                ? profileViewModel.myFavAutomotiveAds.length
                : selectedAllMenuIndex == 2
                    ? profileViewModel.myFavPropertyAds.length
                    : profileViewModel.myFavJobAds.length;
      },
    );
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Saved Ads', context: context, onTap: () {Navigator.of(context).pop();}),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
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
                          setState(
                            () {
                              selectedSort = null;
                              selectedAllMenuIndex = index;
                              totalAds = selectedAllMenuIndex == 0
                                  ? profileViewModel.myFavClassifiedAds.length
                                  : selectedAllMenuIndex == 1
                                      ? profileViewModel
                                          .myFavAutomotiveAds.length
                                      : selectedAllMenuIndex == 2
                                          ? profileViewModel
                                              .myFavPropertyAds.length
                                          : profileViewModel.myFavJobAds.length;
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedAllMenuIndex == index
                                  ? CustomAppTheme().primaryColor
                                  : CustomAppTheme().greyColor,
                            ),
                            color: selectedAllMenuIndex == index
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
                                      color: selectedAllMenuIndex == index
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${totalAds.toString()} ${manageAdsList[selectedAllMenuIndex]} ${totalAds == 0 || totalAds == 1 ? 'Ad' : 'Ads'}',
                    style: CustomAppTheme().headingText.copyWith(
                        fontSize: 20, color: CustomAppTheme().blackColor),
                  ),
                  SortedByDropDown(
                    hint: 'Sort by',
                    icon: null,
                    buttonWidth: med.width * 0.3,
                    buttonHeight: med.height * 0.04,
                    dropdownItems: sortedByList,
                    value: selectedSort,
                    onChanged: (value) {
                      setState(() {
                        selectedSort = value;
                        if (selectedAllMenuIndex == 0) {
                          getMyFavClassifiedAds(
                              value!.replaceAll(' ', '').toLowerCase());
                        } else if (selectedAllMenuIndex == 1) {
                          getMyFavAutomotiveAds(
                              value!.replaceAll(' ', '').toLowerCase());
                        } else if (selectedAllMenuIndex == 2) {
                          getMyFavPropertyAds(
                              value!.replaceAll(' ', '').toLowerCase());
                        } else {
                          getMyFavJobAds(
                              value!.replaceAll(' ', '').toLowerCase());
                        }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              profileViewModel.myFavClassifiedAds == null
                  ? GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: 6,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 1 / 1.32,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        return const ProductCardShimmer();
                      },
                    )
                  : selectedAllMenuIndex == 0
                      ? profileViewModel.myFavClassifiedAds.isEmpty
                          ? SizedBox(
                              height: 450, child: Center(child: noDataFound()))
                          : GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount:
                                  profileViewModel.myFavClassifiedAds.length,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: med.height * 0.00072,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 15,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                          classifiedProduct: profileViewModel
                                              .myFavClassifiedAds[index],
                                          productType: 'Classified',
                                        ),
                                      ),
                                    );
                                  },
                                  child: ProductCard(
                                    onFavTap: () {
                                      setState(() {
                                        for (int i = 0;
                                            i <
                                                classifiedViewModel
                                                    .classifiedAllAds!.length;
                                            i++) {
                                          if (classifiedViewModel
                                                  .classifiedAllAds![i].id ==
                                              profileViewModel
                                                  .myFavClassifiedAds[index]
                                                  .id!) {
                                            d('${classifiedViewModel.classifiedAllAds![i].id} == ${profileViewModel.myFavClassifiedAds[index].id!}');
                                            classifiedViewModel
                                                .classifiedAllAds![i]
                                                .isFavourite = false;
                                            classifiedViewModel
                                                .changeClassifiedAllAds(
                                                    classifiedViewModel
                                                        .classifiedAllAds!);
                                          }
                                        }
                                        classifiedViewModel.addFavClassified(
                                            adId: profileViewModel
                                                .myFavClassifiedAds[index].id!);
                                        profileViewModel.myFavClassifiedAds
                                            .removeWhere((element) =>
                                                element.id ==
                                                profileViewModel
                                                    .myFavClassifiedAds[index]
                                                    .id!);
                                        profileViewModel.changeMyClassifiedAds(
                                            profileViewModel
                                                .myFavClassifiedAds);
                                        // setState(() {
                                        //   totalAds = totalAds - 1;
                                        // });
                                      });
                                    },
                                    isFav: profileViewModel
                                        .myFavClassifiedAds[index].isFavourite,
                                    isOff: profileViewModel
                                        .myFavClassifiedAds[index].isDeal,
                                    isFeatured: profileViewModel
                                        .myFavClassifiedAds[index].isPromoted,
                                    title: profileViewModel
                                        .myFavClassifiedAds[index].name,
                                    address: profileViewModel
                                        .myFavClassifiedAds[index].streetAdress,
                                    currencyCode: profileViewModel
                                        .myFavClassifiedAds[index]
                                        .currency!
                                        .code,
                                    price: profileViewModel
                                        .myFavClassifiedAds[index].price,
                                    imageUrl: profileViewModel
                                            .myFavClassifiedAds[index]
                                            .imageMedia!
                                            .isEmpty
                                        ? null
                                        : profileViewModel
                                            .myFavClassifiedAds[index]
                                            .imageMedia![0]
                                            .image,
                                    beds:
                                        "${profileViewModel.myFavClassifiedAds[index].category?.title}",
                                    baths:
                                        "${profileViewModel.myFavClassifiedAds[index].type}",
                                    logo: profileViewModel
                                                .myFavClassifiedAds[index]
                                                .businessType ==
                                            "Company"
                                        ? profileViewModel
                                            .myFavClassifiedAds[index]
                                            .company
                                            ?.profilePicture
                                        : profileViewModel
                                            .myFavClassifiedAds[index]
                                            .profile
                                            ?.profilePicture,
                                  ),
                                );
                              },
                            )
                      : selectedAllMenuIndex == 1
                          ? profileViewModel.myFavAutomotiveAds.isEmpty
                              ? SizedBox(
                                  height: 450,
                                  child: Center(child: noDataFound()))
                              : GridView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: profileViewModel
                                      .myFavAutomotiveAds.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: med.height * 0.00072,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 15,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailScreen(
                                              automotiveProduct:
                                                  profileViewModel
                                                          .myFavAutomotiveAds[
                                                      index],
                                              productType: 'Automotive',
                                            ),
                                          ),
                                        );
                                      },
                                      child: ProductCard(
                                        onFavTap: () {
                                          for (int i = 0;
                                              i <
                                                  automotiveViewModel
                                                      .automotiveAllAds.length;
                                              i++) {
                                            if (automotiveViewModel
                                                    .automotiveAllAds[i].id ==
                                                profileViewModel
                                                    .myFavAutomotiveAds[index]
                                                    .id!) {
                                              d('${automotiveViewModel.automotiveAllAds[i].id} == ${profileViewModel.myFavAutomotiveAds[index].id!}');
                                              automotiveViewModel
                                                  .automotiveAllAds[i]
                                                  .isFavourite = false;
                                              automotiveViewModel
                                                  .changeAutomotiveAllAds(
                                                      automotiveViewModel
                                                          .automotiveAllAds);
                                            }
                                          }
                                          automotiveViewModel.addFavAutomotive(
                                              adId: profileViewModel
                                                  .myFavAutomotiveAds[index]
                                                  .id!);
                                          profileViewModel.myFavAutomotiveAds
                                              .removeWhere((element) =>
                                                  element.id ==
                                                  profileViewModel
                                                      .myFavAutomotiveAds[index]
                                                      .id!);
                                          profileViewModel
                                              .changeMyFavAutomotive(
                                                  profileViewModel
                                                      .myFavAutomotiveAds);
                                          // setState(() {
                                          //   totalAds = totalAds - 1;
                                          // });
                                        },
                                        isFav: profileViewModel
                                            .myFavAutomotiveAds[index]
                                            .isFavourite,
                                        isFeatured: profileViewModel
                                            .myFavAutomotiveAds[index]
                                            .isPromoted,
                                        isOff: profileViewModel
                                            .myFavAutomotiveAds[index].isDeal,
                                        address: profileViewModel
                                            .myFavAutomotiveAds[index]
                                            .streetAddress,
                                        price: profileViewModel
                                            .myFavAutomotiveAds[index].price,
                                        currencyCode: profileViewModel
                                            .myFavAutomotiveAds[index]
                                            .currency!
                                            .code,
                                        title: profileViewModel
                                            .myFavAutomotiveAds[index].name,
                                        imageUrl: profileViewModel
                                                .myFavAutomotiveAds[index]
                                                .imageMedia!
                                                .isEmpty
                                            ? null
                                            : profileViewModel
                                                .myFavAutomotiveAds[index]
                                                .imageMedia![0]
                                                .image,
                                        beds:
                                            "${profileViewModel.myFavAutomotiveAds[index].category?.title}",
                                        baths:
                                            "${profileViewModel.myFavAutomotiveAds[index].carType}",
                                        logo: profileViewModel
                                                    .myFavAutomotiveAds[index]
                                                    .businessType ==
                                                "Company"
                                            ? profileViewModel
                                                .myFavAutomotiveAds[index]
                                                .company
                                                ?.profilePicture
                                            : profileViewModel
                                                .myFavAutomotiveAds[index]
                                                .profile
                                                ?.profilePicture,
                                      ),
                                    );
                                  },
                                )
                          : selectedAllMenuIndex == 2
                              ? profileViewModel.myFavPropertyAds.isEmpty
                                  ? SizedBox(
                                      height: 450,
                                      child: Center(child: noDataFound()))
                                  : GridView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: profileViewModel
                                          .myFavPropertyAds.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: med.height * 0.00072,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 15,
                                      ),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailScreen(
                                                  propertyProduct:
                                                      profileViewModel
                                                              .myFavPropertyAds[
                                                          index],
                                                  productType: 'Property',
                                                ),
                                              ),
                                            );
                                          },
                                          child: ProductCard(
                                            onFavTap: () {
                                              for (int i = 0;
                                                  i <
                                                      propertiesViewModel
                                                          .propertyAllAds!
                                                          .length;
                                                  i++) {
                                                if (propertiesViewModel
                                                        .propertyAllAds![i]
                                                        .id ==
                                                    profileViewModel
                                                        .myFavPropertyAds[index]
                                                        .id!) {
                                                  d('${propertiesViewModel.propertyAllAds![i].id} == ${profileViewModel.myFavPropertyAds[index].id!}');
                                                  propertiesViewModel
                                                      .propertyAllAds![i]
                                                      .isFavourite = false;
                                                  propertiesViewModel
                                                      .changePropertiesAllAds(
                                                          propertiesViewModel
                                                              .propertyAllAds);
                                                }
                                              }
                                              propertiesViewModel
                                                  .addFavProperty(
                                                      adId: profileViewModel
                                                          .myFavPropertyAds[
                                                              index]
                                                          .id!);
                                              profileViewModel.myFavPropertyAds
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      profileViewModel
                                                          .myFavPropertyAds[
                                                              index]
                                                          .id!);
                                              profileViewModel
                                                  .changeMyFavProperty(
                                                      profileViewModel
                                                          .myFavPropertyAds);
                                              // setState(() {
                                              //   totalAds = totalAds - 1;
                                              // });
                                            },
                                            isFav: profileViewModel
                                                .myFavPropertyAds[index]
                                                .isFavourite,
                                            isFeatured: profileViewModel
                                                .myFavPropertyAds[index]
                                                .isPromoted,
                                            isOff: profileViewModel
                                                .myFavPropertyAds[index].isDeal,
                                            title: profileViewModel
                                                .myFavPropertyAds[index].name,
                                            currencyCode: profileViewModel
                                                .myFavPropertyAds[index]
                                                .currency!
                                                .code,
                                            price: profileViewModel
                                                .myFavPropertyAds[index].price,
                                            address: profileViewModel
                                                .myFavPropertyAds[index]
                                                .streetAddress,
                                            imageUrl: profileViewModel
                                                    .myFavPropertyAds[index]
                                                    .imageMedia!
                                                    .isEmpty
                                                ? null
                                                : profileViewModel
                                                    .myFavPropertyAds[index]
                                                    .imageMedia![0]
                                                    .image,
                                            categories: 'property',
                                            beds:
                                                "${profileViewModel.myFavPropertyAds[index].bedrooms} Bedrooms",
                                            baths:
                                                "${profileViewModel.myFavPropertyAds[index].baths} Baths",
                                            logo: profileViewModel
                                                        .myFavPropertyAds[index]
                                                        .businessType ==
                                                    "Company"
                                                ? profileViewModel
                                                    .myFavPropertyAds[index]
                                                    .company
                                                    ?.profilePicture
                                                : profileViewModel
                                                    .myFavPropertyAds[index]
                                                    .profile
                                                    ?.profilePicture,
                                          ),
                                        );
                                      },
                                    )
                              : profileViewModel.myFavJobAds.isEmpty
                                  ? SizedBox(
                                      height: 450,
                                      child: Center(child: noDataFound()))
                                  : GridView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount:
                                          profileViewModel.myFavJobAds.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 1 / 1.32,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 15,
                                      ),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailScreen(
                                                  isJobAd: true,
                                                  jobProduct: profileViewModel
                                                      .myFavJobAds[index],
                                                  productType: 'Job',
                                                ),
                                              ),
                                            );
                                          },
                                          child: JobAdsWidget(
                                            onFavTap: () {
                                              for (int i = 0;
                                                  i <
                                                      jobViewModel
                                                          .jobAllAds!.length;
                                                  i++) {
                                                if (jobViewModel
                                                        .jobAllAds![i].id ==
                                                    profileViewModel
                                                        .myFavJobAds[index]
                                                        .id!) {
                                                  d('${jobViewModel.jobAllAds![i].id} == ${profileViewModel.myFavJobAds[index].id!}');
                                                  jobViewModel.jobAllAds![i]
                                                      .isFavourite = false;
                                                  jobViewModel.changeJobAllAds(
                                                      jobViewModel.jobAllAds!);
                                                }
                                              }
                                              jobViewModel.addFavJob(
                                                  adId: profileViewModel
                                                      .myFavJobAds[index].id!);
                                              profileViewModel.myFavJobAds
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      profileViewModel
                                                          .myFavJobAds[index]
                                                          .id!);
                                              profileViewModel.changeMyFavJob(
                                                  profileViewModel.myFavJobAds);
                                              // setState(() {
                                              //   totalAds = totalAds - 1;
                                              // });
                                            },
                                            isFav: profileViewModel
                                                .myFavJobAds[index].isFavourite,
                                            isFeatured: profileViewModel
                                                .myFavJobAds[index].isPromoted,
                                            isOff: false,
                                            title: profileViewModel
                                                .myFavJobAds[index].title,
                                            currencyCode: profileViewModel
                                                .myFavJobAds[index]
                                                .salaryCurrency!
                                                .code,
                                            startingSalary: profileViewModel
                                                .myFavJobAds[index].salaryStart,
                                            endingSalary: profileViewModel
                                                .myFavJobAds[index].salaryEnd,
                                            description: profileViewModel
                                                .myFavJobAds[index].description,
                                            address: profileViewModel
                                                .myFavJobAds[index].location,
                                            imageUrl: profileViewModel
                                                    .myFavJobAds[index]
                                                    .imageMedia!
                                                    .isEmpty
                                                ? null
                                                : profileViewModel
                                                    .myFavJobAds[index]
                                                    .imageMedia![0]
                                                    .image,
                                            beds:
                                                "${profileViewModel.myFavJobAds[index].positionType}",
                                            baths:
                                                "${profileViewModel.myFavJobAds[index].jobType}",
                                          ),
                                        );
                                      },
                                    )
            ],
          ),
        ),
      ),
    );
  }

  String? selectedSort;
  final List<String> sortedByList = [
    'Low to high',
    'High to low',
  ];

  List<String> manageAdsList = [
    'Classified',
    'Automotive',
    'Properties',
    'Jobs',
  ];
}
