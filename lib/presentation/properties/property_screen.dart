// ignore_for_file: dead_code

import 'package:app/common/logger/log.dart';
import 'package:app/presentation/categories/all_categories_screen.dart';
import 'package:app/presentation/profile/business_mode/create_business_profile.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/properties/property_filters/property_filter_screen.dart';
import 'package:app/presentation/properties/search_properties_on_map_screen.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/searchs/searchScreen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/shimmers/categoryCardShimmer.dart';
import 'package:app/presentation/utils/shimmers/product_card_shimmer.dart';
import 'package:app/presentation/utils/widgets/category_card.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/explore_more_button.dart';
import 'package:app/presentation/utils/widgets/filter_widget.dart';
import 'package:app/presentation/utils/widgets/home_screen_headings_widget.dart';
import 'package:app/presentation/utils/widgets/location_and_notif_widget.dart';
import 'package:app/presentation/utils/widgets/menu_with_icon_widget.dart';
import 'package:app/presentation/utils/widgets/product_card.dart';
import 'package:app/presentation/utils/widgets/searched_textfield.dart';
import 'package:app/presentation/widgets_screens/all_products_screen.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PropertyScreen extends StatefulWidget {
  const PropertyScreen({Key? key}) : super(key: key);

  @override
  State<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  int selectedSubMenuIndex = 0;
  int featuredAdsLength = 6;
  bool isAdFetching = false;
  int currentPageProperty = 1;

  void getAllPropertiesCategories() async {
    final result =
        await context.read<PropertiesViewModel>().getAllPropertiesCategories();
    result.fold((l) {}, (r) {
      d('***********************************');
      d(r.response.toString());
      context
          .read<PropertiesViewModel>()
          .changeClassifiedAllCategories(r.response!);
    });
  }

  void getPropertyFeaturedAds() async {
    final result =
        await context.read<PropertiesViewModel>().getPropertyFeaturedProducts();
    result.fold((l) {}, (r) {
      d('***********************************');
      d(r.propertyProductList.toString());
      context
          .read<PropertiesViewModel>()
          .changePropertyFeaturedAds(r.propertyProductList!);
    });
  }

  void getPropertyAllAds({String? sortedBy}) async {
    if (currentPageProperty == 1) {
      setState(() {
        isAdFetching = true;
      });
    }

    final result = await context
        .read<PropertiesViewModel>()
        .getPropertyAllProducts(sortedBy: sortedBy, pageNo: sortedBy != null ? 1 : currentPageProperty);
    result.fold((l) {}, (r) {
      d('***********************************');
      d(r.propertyProductList.toString());
      if (sortedBy == null) {
        if (currentPageProperty == 1) {
          context
              .read<PropertiesViewModel>()
              .propertyAllAds!.clear();
          print("this is page no 1 =====");
          // automotiveViewModel.changeAutomotiveAllAds(r.automotiveAdsList!);
          context
              .read<PropertiesViewModel>()
              .propertyAllAds!
              .addAll((r.propertyProductList!));
        } else {
          context
              .read<PropertiesViewModel>()
              .propertyAllAds!
              .addAll((r.propertyProductList!));
          context.read<PropertiesViewModel>().changePropertiesAllAds(
              context.read<PropertiesViewModel>().propertyAllAds!);
        }

      } else {
        context
            .read<PropertiesViewModel>()
            .changePropertiesSortedAds(r.propertyProductList!);
      }
    });
    setState(() {
      isAdFetching = false;
      isExploringMore = false;
    });
  }

  @override
  void initState() {
    PropertiesViewModel propertiesViewModel =
        context.read<PropertiesViewModel>();
    propertiesViewModel.propertyAllAds!.clear();
    propertiesViewModel.propertiesAllCategories!.clear();
    propertiesViewModel.propertyFeaturedAds!.clear();
    super.initState();
    if (propertiesViewModel.propertyAllAds!.isEmpty) {
      getPropertyAllAds();
    }
    if (propertiesViewModel.propertiesAllCategories!.isEmpty) {
      getAllPropertiesCategories();
    }
    if (propertiesViewModel.propertyFeaturedAds!.isEmpty) {
      getPropertyFeaturedAds();
    }
  }

  bool isExploringMore = false;
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    final PropertiesViewModel propertiesViewModel =
        context.watch<PropertiesViewModel>();
    final ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Property', context: context, onTap: () {Navigator.of(context).pop();}),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const LocationAndNotificationWidget(),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: med.width * 0.8,
                      height: med.height * 0.048,
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchScreen()));
                        },
                        child: const RoundedTextField(isEnabled: false),
                      ),
                    ),
                    const Spacer(),
                    FilterWidget(onTab: () {
                      propertiesViewModel.propertyFilterData =
                          PropertyFilterModel();
                      propertiesViewModel.propertyFilterMap = {};
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PropertyFiltersScreen()));
                    }),
                  ],
                ),
              ),

              // SizedBox(
              //   height: med.height * 0.05,
              // ),

              // SizedBox(
              //   height: med.height * 0.18,
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: propertyBannerImages.length,
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (context, index) {
              //       return Row(
              //         children: <Widget>[
              //           Container(
              //             height: med.height * 0.18,
              //             width: med.width * 0.7,
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10),
              //                 color: CustomAppTheme().greyColor,
              //                 image: DecorationImage(
              //                   image: AssetImage(propertyBannerImages[index]),
              //                   fit: BoxFit.cover,
              //                 )),
              //           ),
              //           index != propertyBannerImages.length - 1
              //               ? SizedBox(
              //                   width: med.width * 0.025,
              //                 )
              //               : const SizedBox.shrink(),
              //         ],
              //       );
              //     },
              //   ),
              // ),

              SizedBox(
                height: med.height * 0.04,
              ),

              HomeScreenHeadingWidget(
                headingText: 'Browse By Categories',
                viewAllCallBack: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllCategoriesScreen(
                        categoryTitle: 'Properties',
                        categoryIndex: 1,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(
                height: med.height * 0.02,
              ),

              //Category cards
              propertiesViewModel.propertiesAllCategories!.isNotEmpty
                  ? SizedBox(
                      height: med.height * 0.15,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount:
                            propertiesViewModel.propertiesAllCategories!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          String colorCode = propertiesViewModel
                                      .propertiesAllCategories![index]
                                      .backgroundColor ==
                                  null
                              ? 'FFF8D1'
                              : propertiesViewModel
                                  .propertiesAllCategories![index]
                                  .backgroundColor
                                  .toString();
                          int bgColor = int.parse('0XFF' + colorCode);
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllProductScreen(
                                      title: propertiesViewModel
                                          .propertiesAllCategories![index].title
                                          .toString(),
                                      moduleIndex: 1,
                                      categoryId: propertiesViewModel
                                          .propertiesAllCategories![index].id
                                          .toString(),
                                    ),
                                  ),
                                );
                              },
                              child: CategoryCard(
                                imagePath: propertiesViewModel
                                        .propertiesAllCategories![index]
                                        .image ??
                                    'https://user-images.githubusercontent.com/10515204/56117400-9a911800-5f85-11e9-878b-3f998609a6c8.jpg',
                                title: propertiesViewModel
                                    .propertiesAllCategories![index].title,
                                totalAds: propertiesViewModel
                                    .propertiesAllCategories![index].totalCount
                                    .toString(),
                                bgColorCode: bgColor,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : SizedBox(
                      height: med.height * 0.15,
                      child: ListView.builder(
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(right: 10),
                        itemBuilder: (context, index) {
                          return const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: CategoryCardShimmer(),
                          );
                        },
                      ),
                    ),

              SizedBox(
                height: med.height * 0.04,
              ),

              HomeScreenHeadingWidget(
                headingText: 'All Ads',
                isSuffix: false,
                viewAllCallBack: () {},
              ),

              SizedBox(
                height: med.height * 0.02,
              ),

              //Featured Categories
              SizedBox(
                height: med.height * 0.035,
                child: ListView.builder(
                  itemCount: propertyCategoryMenu.length,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSubMenuIndex = index;
                          if (index == 1) {
                            getPropertyAllAds(sortedBy: 'Rent');
                          } else if (index == 2) {
                            getPropertyAllAds(sortedBy: 'Sale');
                          } /* else if (index == 3) {
                            getPropertyAllAds(sortedBy: 'Commercial');
                          } else if (index == 4) {
                            getPropertyAllAds(sortedBy: 'Residential');
                          }*/
                        });
                      },
                      child: MenuWithIconWidget(
                        index: index,
                        selectedSubMenuIndex: selectedSubMenuIndex,
                        menuText: propertyCategoryMenu[index],
                        iconUrl: index == 0
                            ? 'assets/temp/allIcon.svg'
                            : index == 1
                                ? 'assets/svgs/Rent.svg'
                                : 'assets/svgs/Buy.svg',
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                height: med.height * 0.02,
              ),

              isAdFetching
                  ? GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: featuredAdsLength,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.29),
                        crossAxisCount: 2,
                        mainAxisSpacing: 15.0,
                        crossAxisSpacing: 5.0,
                        //   const SliverGridDelegateWithMaxCrossAxisExtent(
                        // maxCrossAxisExtent: 200,
                        // childAspectRatio: 1 / 1.32,
                        // crossAxisSpacing: 5,
                        // mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        return const ProductCardShimmer();
                      },
                    )
                  : selectedSubMenuIndex == 0
                      ? propertiesViewModel.propertyAllAds!.isEmpty
                          ? SizedBox(
                              height: 250, child: Center(child: noDataFound()))
                          : GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount:
                                  propertiesViewModel.propertyAllAds!.length,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.29),
                                crossAxisCount: 2,
                                mainAxisSpacing: 15.0,
                                crossAxisSpacing: 5.0,
                                //   SliverGridDelegateWithMaxCrossAxisExtent(
                                // maxCrossAxisExtent: 200,
                                // childAspectRatio: med.height * 0.00072,
                                // crossAxisSpacing: 5,
                                // mainAxisSpacing: 15,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                          propertyProduct: propertiesViewModel
                                              .propertyAllAds![index],
                                          productType: 'Property',
                                        ),
                                      ),
                                    );
                                  },
                                  child: ProductCard(
                                    isFav: propertiesViewModel
                                        .propertyAllAds![index].isFavourite,
                                    onFavTap: () {
                                      if (propertiesViewModel
                                              .propertyAllAds![index]
                                              .isFavourite ==
                                          false) {
                                        setState(() {
                                          propertiesViewModel.addFavProperty(
                                              adId: propertiesViewModel
                                                  .propertyAllAds![index].id!);
                                          for (int i = 0;
                                              i <
                                                  propertiesViewModel
                                                      .propertyAllAds!.length;
                                              i++) {
                                            if (propertiesViewModel
                                                    .propertyAllAds![index]
                                                    .id! ==
                                                propertiesViewModel
                                                    .propertyAllAds![i].id) {
                                              propertiesViewModel
                                                  .propertyAllAds![index]
                                                  .isFavourite = true;
                                              propertiesViewModel
                                                  .changePropertiesAllAds(
                                                      propertiesViewModel
                                                          .propertyAllAds);
                                            }
                                          }
                                          for (int i = 0;
                                              i <
                                                  profileViewModel
                                                      .myPropertiesAds.length;
                                              i++) {
                                            if (profileViewModel
                                                    .myPropertiesAds[index]
                                                    .id! ==
                                                profileViewModel
                                                    .myPropertiesAds[i].id) {
                                              profileViewModel
                                                  .myPropertiesAds[index]
                                                  .isFavourite = true;
                                              profileViewModel
                                                  .changeMyPropertiesAds(
                                                      profileViewModel
                                                          .myPropertiesAds);
                                            }
                                          }
                                        });
                                        profileViewModel.myFavPropertyAds.add(
                                            propertiesViewModel
                                                .propertyAllAds![index]);
                                        profileViewModel.changeMyFavProperty(
                                            profileViewModel.myFavPropertyAds);
                                      } else {
                                        setState(() {
                                          propertiesViewModel.addFavProperty(
                                              adId: propertiesViewModel
                                                  .propertyAllAds![index].id!);
                                          for (int i = 0;
                                              i <
                                                  propertiesViewModel
                                                      .propertyAllAds!.length;
                                              i++) {
                                            if (propertiesViewModel
                                                    .propertyAllAds![index]
                                                    .id! ==
                                                propertiesViewModel
                                                    .propertyAllAds![i].id) {
                                              propertiesViewModel
                                                  .propertyAllAds![index]
                                                  .isFavourite = false;
                                              propertiesViewModel
                                                  .changePropertiesAllAds(
                                                      propertiesViewModel
                                                          .propertyAllAds);
                                            }
                                          }
                                          for (int i = 0;
                                              i <
                                                  profileViewModel
                                                      .myPropertiesAds.length;
                                              i++) {
                                            if (profileViewModel
                                                    .myPropertiesAds[index]
                                                    .id! ==
                                                profileViewModel
                                                    .myPropertiesAds[i].id) {
                                              profileViewModel
                                                  .myPropertiesAds[index]
                                                  .isFavourite = false;
                                              profileViewModel
                                                  .changeMyPropertiesAds(
                                                      profileViewModel
                                                          .myPropertiesAds);
                                            }
                                          }
                                        });
                                        profileViewModel.myFavPropertyAds
                                            .removeWhere((element) =>
                                                element.id ==
                                                propertiesViewModel
                                                    .propertyAllAds![index].id);
                                        profileViewModel.changeMyFavProperty(
                                            profileViewModel.myFavPropertyAds);
                                      }
                                    },
                                    isFeatured: propertiesViewModel
                                        .propertyAllAds![index].isPromoted,
                                    isVerified: propertiesViewModel
                                                .propertyAllAds![index]
                                                .verificationStatus ==
                                            "Verified"
                                        ? true
                                        : false,
                                    isOff: propertiesViewModel
                                        .propertyAllAds![index].isDeal,
                                    title: propertiesViewModel
                                        .propertyAllAds![index].name,
                                    currencyCode: propertiesViewModel
                                        .propertyAllAds![index].currency!.code,
                                    price: propertiesViewModel
                                        .propertyAllAds![index].price,
                                    address: propertiesViewModel
                                        .propertyAllAds![index].streetAddress,
                                    imageUrl: propertiesViewModel
                                            .propertyAllAds![index]
                                            .imageMedia!
                                            .isEmpty
                                        ? null
                                        : propertiesViewModel
                                            .propertyAllAds![index]
                                            .imageMedia![0]
                                            .image,
                                    logo: propertiesViewModel
                                                .propertyAllAds![index]
                                                .businessType ==
                                            "Company"
                                        ? propertiesViewModel
                                            .propertyAllAds![index]
                                            .company
                                            ?.profilePicture
                                        : propertiesViewModel
                                            .propertyAllAds![index]
                                            .profile
                                            ?.profilePicture,
                                    categories: 'property',
                                    beds:
                                        "${propertiesViewModel.propertyAllAds![index].bedrooms} Bedrooms",
                                    baths:
                                        "${propertiesViewModel.propertyAllAds![index].area}",
                                  ),
                                );
                              },
                            )
                      : propertiesViewModel.propertySortedAds!.isEmpty
                          ? SizedBox(
                              height: 250, child: Center(child: noDataFound()))
                          : GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount:
                                  propertiesViewModel.propertySortedAds!.length,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.29),
                                crossAxisCount: 2,
                                mainAxisSpacing: 15.0,
                                crossAxisSpacing: 5.0,
                                //   SliverGridDelegateWithMaxCrossAxisExtent(
                                // maxCrossAxisExtent: 200,
                                // childAspectRatio: med.height * 0.00072,
                                // crossAxisSpacing: 5,
                                // mainAxisSpacing: 15,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                          propertyProduct: propertiesViewModel
                                              .propertySortedAds![index],
                                          productType: 'Property',
                                        ),
                                      ),
                                    );
                                  },
                                  child: ProductCard(
                                    isFav: propertiesViewModel
                                        .propertySortedAds![index].isFavourite,
                                    onFavTap: () {},
                                    isFeatured: propertiesViewModel
                                        .propertySortedAds![index].isPromoted,
                                    isOff: propertiesViewModel
                                        .propertySortedAds![index].isDeal,
                                    title: propertiesViewModel
                                        .propertySortedAds![index].name,
                                    currencyCode: propertiesViewModel
                                        .propertySortedAds![index]
                                        .currency!
                                        .code,
                                    price: propertiesViewModel
                                        .propertySortedAds![index].price,
                                    address: propertiesViewModel
                                        .propertySortedAds![index]
                                        .streetAddress,
                                    imageUrl: propertiesViewModel
                                            .propertySortedAds![index]
                                            .imageMedia!
                                            .isEmpty
                                        ? null
                                        : propertiesViewModel
                                            .propertySortedAds![index]
                                            .imageMedia![0]
                                            .image,
                                    logo: propertiesViewModel
                                                .propertySortedAds![index]
                                                .businessType ==
                                            "Company"
                                        ? propertiesViewModel
                                            .propertySortedAds![index]
                                            .company
                                            ?.profilePicture
                                        : propertiesViewModel
                                            .propertySortedAds![index]
                                            .profile
                                            ?.profilePicture,
                                    categories: 'property',
                                    beds:
                                        "${propertiesViewModel.propertySortedAds![index].bedrooms} Bedrooms",
                                    baths:
                                        "${propertiesViewModel.propertySortedAds![index].area} ",
                                  ),
                                );
                              },
                            ),

              SizedBox(
                height: med.height * 0.02,
              ),

              propertiesViewModel.propertySortedAds!.isEmpty
                  ? Container()
                  : isExploringMore
                      ? Center(
                          child: CircularProgressIndicator(
                              color: CustomAppTheme().primaryColor),
                        )
                      : currentPageProperty !=
                              propertiesViewModel.allPropertiesTotalPages
                          ? Center(
                              child: ExploreMoreButton(
                                onTab: () {
                                  setState(() {
                                    currentPageProperty = currentPageProperty + 1;
                                    isExploringMore = true;
                                  });
                                  propertiesViewModel.allPropertiesPageNo =
                                      propertiesViewModel.allPropertiesPageNo +
                                          1;

                                  getPropertyAllAds();
                                },
                              ),
                            )
                          : const SizedBox.shrink(),

              SizedBox(
                height: med.height * 0.04,
              ),

              Container(
                height: med.height * 0.03,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(10),
                //   color: CustomAppTheme().greyColor,
                //   image: DecorationImage(
                //     image: AssetImage(propertyBannerImages[0]),
                //     fit: BoxFit.cover,
                //   ),
                // ),
              ),

              SizedBox(
                height: med.height * 0.04,
              ),
              //
              // HomeScreenHeadingWidget(
              //   headingText: 'Featured Companies',
              //   viewAllCallBack: () {},
              //   isSuffix: false,
              // ),
              //
              // SizedBox(
              //   height: med.height * 0.02,
              // ),
              //
              // SizedBox(
              //   height: med.height * 0.15,
              //   child: ListView.builder(
              //     itemCount: 6,
              //     shrinkWrap: true,
              //     scrollDirection: Axis.horizontal,
              //     physics: const BouncingScrollPhysics(),
              //     itemBuilder: (context, index) {
              //       return BrandCircularWidget(
              //         index: index,
              //       );
              //     },
              //   ),
              // ),

              /*SizedBox(
                height: med.height * 0.04,
              ),

              HomeScreenHeadingWidget(
                headingText: 'Recommended For You',
                viewAllCallBack: () {},
              ),

              SizedBox(
                height: med.height * 0.02,
              ),

              SizedBox(
                height: med.height * 0.35,
                child: Center(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: med.height * 0.01),
                    itemCount: 5,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductDetailScreen()));
                          },
                          child: const ProductCard(isFeatured: true),
                        ),
                      );
                    },
                  ),
                ),
              ),*/

              SizedBox(
                height: med.height * 0.06,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          height: med.height * 0.05,
          width: med.width,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchPropertiesOnMap()));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  CustomAppTheme().primaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/svgs/locationIcon.svg',
                  height: med.height * 0.022,
                  // width: med.width*0.15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Show On Map',
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          color: CustomAppTheme().backgroundColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> propertyBannerImages = [
    'assets/images/propertyBanner1.png',
    'assets/images/Property banner 2.png',
  ];

  List<String> propertyCategoryMenu = [
    'All',
    'For Rent',
    'For Buy', /* 'Commercial', 'Residential'*/
  ];
}
