import 'package:app/common/logger/log.dart';
import 'package:app/presentation/automotive/automotive_filters/automotive_filter_screen.dart';
import 'package:app/presentation/automotive/automotive_on_map_screen.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/categories/all_categories_screen.dart';
import 'package:app/presentation/home/mixins/home_mixin.dart';
import 'package:app/presentation/home/view_model/home_view_model.dart';
import 'package:app/presentation/profile/business_mode/create_business_profile.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
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

class AutomotiveScreen extends StatefulWidget {
  const AutomotiveScreen({Key? key}) : super(key: key);

  @override
  State<AutomotiveScreen> createState() => _AutomotiveScreenState();
}

class _AutomotiveScreenState extends State<AutomotiveScreen> with HomeMixin {
  int selectedSubMenuIndex = 0;
  int featuredAdsLength = 6;
  bool isAdFetching = false;
  bool isExploringMore = false;
  int currentPageAutomotive = 1;

  void getAllAutomotiveCategories() async {
    final result =
        await context.read<AutomotiveViewModel>().getAllAutomotiveCategories();
    result.fold((l) {}, (r) {
      d('***********************************');
      d(r.response.toString());
      context
          .read<AutomotiveViewModel>()
          .changeAutomotiveAllCategories(r.response!);
    });
  }

  getAutoFeaturedBrands() async {
    AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    final result = await automotiveViewModel.getAutoFeaturedBrands();
    result.fold((l) {}, (r) {
      automotiveViewModel.changeAutoFeaturedBrands(r.response!);
    });
  }

  getAutoFeaturedAds() async {
    AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    final result = await automotiveViewModel.getAutomotiveFeaturedProducts();
    result.fold((l) {}, (r) {
      automotiveViewModel.changeAutomotiveFeaturedAds(r.automotiveAdsList);
    });
  }

  getAutoAllAds({String? sortedBy}) async {
    AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    if (currentPageAutomotive == 1) {
      setState(() {
        isAdFetching = true;
      });
    }

    final result = await automotiveViewModel.getAutomotiveAllProducts(
        sortedBy: sortedBy, pageNo: sortedBy != null ? 1 : currentPageAutomotive);
    result.fold((l) {}, (r) {
      d('ALL AUTOMOTIVE :: $r');
      if (sortedBy == null) {
        double totalPagesInDouble = r.count! / 20;
        int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
            ? totalPagesInDouble.toInt() + 1
            : totalPagesInDouble.toInt();
        automotiveViewModel.autoAllAdsTotalPages = totalPagesInInt;
        if (currentPageAutomotive == 1) {
          automotiveViewModel.automotiveAllAds.clear();
          print("this is page no 1 =====");
          automotiveViewModel.changeAutomotiveAllAds(r.automotiveAdsList!);
        } else {
          automotiveViewModel.automotiveAllAds.addAll(r.automotiveAdsList!);
          automotiveViewModel
              .changeAutomotiveAllAds(automotiveViewModel.automotiveAllAds);
        }

      }
      else {
        automotiveViewModel.changeSortedAutomotiveAds(r.automotiveAdsList!);
      }
    });
    setState(() {
      isAdFetching = false;
      isExploringMore = false;
    });
  }

  @override
  void initState() {
    AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    automotiveViewModel.automotiveAllAds.clear();
    automotiveViewModel.automotiveAllCategories?.clear();
    automotiveViewModel.automotiveFeaturedBrands!.clear();
    automotiveViewModel.automotiveFeaturedAds!.clear();
    super.initState();
    if (automotiveViewModel.automotiveAllAds.isEmpty) {
      getAutoAllAds();
    }
    if (automotiveViewModel.automotiveAllCategories!.isEmpty) {
      getAllAutomotiveCategories();
    }
    if (automotiveViewModel.automotiveFeaturedBrands!.isEmpty) {
      getAutoFeaturedBrands();
    }
    if (automotiveViewModel.automotiveFeaturedAds!.isEmpty) {
      getAutoFeaturedAds();
    }
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel userViewModel = context.watch<HomeViewModel>();
    final AutomotiveViewModel automotiveViewModel =
        context.watch<AutomotiveViewModel>();
    final ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    Size med = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        userViewModel.changeCurrentMainMenuIndex(0);
        return true;
      },
      child: Scaffold(
        backgroundColor: CustomAppTheme().backgroundColor,
        appBar: customAppBar(title: 'Automotive', context: context, onTap: () {Navigator.of(context).pop();}),
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
                                    builder: (context) =>
                                        const SearchScreen()));
                          },
                          child: const RoundedTextField(isEnabled: false),
                        ),
                      ),
                      const Spacer(),
                      FilterWidget(onTab: () {
                        automotiveViewModel.automotiveFilterData =
                            AutomotiveFilterModel();
                        automotiveViewModel.automotiveFilterMap = {};
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AutomotiveFiltersScreen()));
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
                //     itemCount: automotiveBannerImages.length,
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
                //                   image:
                //                       AssetImage(automotiveBannerImages[index]),
                //                   fit: BoxFit.cover,
                //                 )),
                //           ),
                //           index != automotiveBannerImages.length - 1
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
                                categoryTitle: 'Automotive',
                                categoryIndex: 2)));
                  },
                ),

                SizedBox(
                  height: med.height * 0.02,
                ),

                //Category cards
                automotiveViewModel.automotiveAllCategories!.isNotEmpty
                    ? SizedBox(
                        height: med.height * 0.15,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: automotiveViewModel
                              .automotiveAllCategories!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            String colorCode = automotiveViewModel
                                        .automotiveAllCategories![index]
                                        .backgroundColor ==
                                    null
                                ? 'FFF8D1'
                                : automotiveViewModel
                                    .automotiveAllCategories![index]
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
                                        title: automotiveViewModel
                                            .automotiveAllCategories![index]
                                            .title
                                            .toString(),
                                        moduleIndex: 2,
                                        categoryId: automotiveViewModel
                                            .automotiveAllCategories![index].id
                                            .toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryCard(
                                  imagePath: automotiveViewModel
                                          .automotiveAllCategories![index]
                                          .image ??
                                      'https://user-images.githubusercontent.com/10515204/56117400-9a911800-5f85-11e9-878b-3f998609a6c8.jpg',
                                  title: automotiveViewModel
                                      .automotiveAllCategories![index].title,
                                  totalAds: automotiveViewModel
                                      .automotiveAllCategories![index]
                                      .totalCount
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
                    itemCount: automotiveCategoryMenu.length,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSubMenuIndex = index;
                            if (index == 1) {
                              getAutoAllAds(sortedBy: 'Used');
                            } else if (index == 2) {
                              getAutoAllAds(sortedBy: 'New');
                            }
                          });
                        },
                        child: MenuWithIconWidget(
                          index: index,
                          selectedSubMenuIndex: selectedSubMenuIndex,
                          menuText: automotiveCategoryMenu[index],
                          iconUrl: index == 0
                              ? 'assets/temp/allIcon.svg'
                              : index == 1
                                  ? 'assets/svgs/usedIcon.svg'
                                  : 'assets/svgs/newIcon.svg',
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
                    : selectedSubMenuIndex == 0
                        ? automotiveViewModel.automotiveAllAds.isEmpty
                            ? SizedBox(
                                height: 250,
                                child: Center(child: noDataFound()))
                            : GridView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount:
                                    automotiveViewModel.automotiveAllAds.length,
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
                                                automotiveViewModel
                                                    .automotiveAllAds[index],
                                            productType: 'Automotive',
                                          ),
                                        ),
                                      );
                                    },
                                    child: ProductCard(
                                      isFav: automotiveViewModel
                                          .automotiveAllAds[index].isFavourite,
                                      onFavTap: () {
                                        if (automotiveViewModel
                                                .automotiveAllAds[index]
                                                .isFavourite ==
                                            false) {
                                          setState(() {
                                            automotiveViewModel
                                                .addFavAutomotive(
                                                    adId: automotiveViewModel
                                                        .automotiveAllAds[index]
                                                        .id!);
                                            for (int i = 0;
                                                i <
                                                    automotiveViewModel
                                                        .automotiveAllAds
                                                        .length;
                                                i++) {
                                              if (automotiveViewModel
                                                      .automotiveAllAds[index]
                                                      .id! ==
                                                  automotiveViewModel
                                                      .automotiveAllAds[i].id) {
                                                automotiveViewModel
                                                    .automotiveAllAds[index]
                                                    .isFavourite = true;
                                                automotiveViewModel
                                                    .changeAutomotiveAllAds(
                                                        automotiveViewModel
                                                            .automotiveAllAds);
                                              }
                                            }
                                            for (int i = 0;
                                                i <
                                                    profileViewModel
                                                        .myAutomotiveAds.length;
                                                i++) {
                                              if (automotiveViewModel
                                                      .automotiveAllAds[index]
                                                      .id! ==
                                                  profileViewModel
                                                      .myAutomotiveAds[i].id) {
                                                profileViewModel
                                                    .myAutomotiveAds[index]
                                                    .isFavourite = true;
                                                profileViewModel
                                                    .changeMyAutomotiveAds(
                                                        profileViewModel
                                                            .myAutomotiveAds);
                                              }
                                            }
                                          });
                                          profileViewModel.myFavAutomotiveAds
                                              .add(automotiveViewModel
                                                  .automotiveAllAds[index]);
                                          profileViewModel
                                              .changeMyFavAutomotive(
                                                  profileViewModel
                                                      .myFavAutomotiveAds);
                                        } else {
                                          setState(() {
                                            automotiveViewModel
                                                .addFavAutomotive(
                                                    adId: automotiveViewModel
                                                        .automotiveAllAds[index]
                                                        .id!);
                                            for (int i = 0;
                                                i <
                                                    automotiveViewModel
                                                        .automotiveAllAds
                                                        .length;
                                                i++) {
                                              if (automotiveViewModel
                                                      .automotiveAllAds[index]
                                                      .id! ==
                                                  automotiveViewModel
                                                      .automotiveAllAds[i].id) {
                                                automotiveViewModel
                                                    .automotiveAllAds[index]
                                                    .isFavourite = false;
                                                automotiveViewModel
                                                    .changeAutomotiveAllAds(
                                                        automotiveViewModel
                                                            .automotiveAllAds);
                                              }
                                            }
                                            for (int i = 0;
                                                i <
                                                    profileViewModel
                                                        .myAutomotiveAds.length;
                                                i++) {
                                              if (profileViewModel
                                                      .myAutomotiveAds[index]
                                                      .id! ==
                                                  profileViewModel
                                                      .myAutomotiveAds[i].id) {
                                                profileViewModel
                                                    .myAutomotiveAds[index]
                                                    .isFavourite = false;
                                                profileViewModel
                                                    .changeMyAutomotiveAds(
                                                        profileViewModel
                                                            .myAutomotiveAds);
                                              }
                                            }
                                          });
                                          profileViewModel.myFavAutomotiveAds
                                              .removeWhere((element) =>
                                                  element.id ==
                                                  automotiveViewModel
                                                      .automotiveAllAds[index]
                                                      .id!);
                                          profileViewModel
                                              .changeMyFavAutomotive(
                                                  profileViewModel
                                                      .myFavAutomotiveAds);
                                        }
                                      },
                                      isFeatured: automotiveViewModel
                                          .automotiveAllAds[index].isPromoted,
                                      isOff: automotiveViewModel
                                          .automotiveAllAds[index].isDeal,
                                      address: automotiveViewModel
                                          .automotiveAllAds[index]
                                          .streetAddress,
                                      price:
                                          "${automotiveViewModel.automotiveAllAds[index].price} ${automotiveViewModel.automotiveAllAds[index].rentalHours != null ? "/ ${automotiveViewModel.automotiveAllAds[index].rentalHours}" : ""}",
                                      currencyCode: automotiveViewModel
                                          .automotiveAllAds[index]
                                          .currency!
                                          .code,
                                      title: automotiveViewModel
                                          .automotiveAllAds[index].name,
                                      imageUrl: automotiveViewModel
                                              .automotiveAllAds[index]
                                              .imageMedia!
                                              .isEmpty
                                          ? null
                                          : automotiveViewModel
                                              .automotiveAllAds[index]
                                              .imageMedia![0]
                                              .image,
                                      logo: automotiveViewModel
                                                  .automotiveAllAds[index]
                                                  .businessType ==
                                              "Company"
                                          ? automotiveViewModel
                                              .automotiveAllAds[index]
                                              .company
                                              ?.profilePicture
                                          : automotiveViewModel
                                              .automotiveAllAds[index]
                                              .profile
                                              ?.profilePicture,
                                      categories: "auto",
                                      beds:
                                          "${automotiveViewModel.automotiveAllAds[index].kilometers} KM",
                                      baths:
                                          "${automotiveViewModel.automotiveAllAds[index].transmissionType}",
                                      baths1:
                                          "${automotiveViewModel.automotiveAllAds[index].fuelType}",
                                    ),
                                  );
                                },
                              )
                        : automotiveViewModel.automotiveSortedAds.isEmpty
                            ? SizedBox(
                                height: 250,
                                child: Center(child: noDataFound()))
                            : GridView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: automotiveViewModel
                                    .automotiveSortedAds.length,
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
                                                automotiveViewModel
                                                    .automotiveSortedAds[index],
                                            productType: 'Automotive',
                                          ),
                                        ),
                                      );
                                    },
                                    child: ProductCard(
                                      isFav: automotiveViewModel
                                          .automotiveSortedAds[index]
                                          .isFavourite,
                                      onFavTap: () {
                                        if (automotiveViewModel
                                                .automotiveSortedAds[index]
                                                .isFavourite ==
                                            false) {
                                          setState(() {
                                            automotiveViewModel
                                                .addFavAutomotive(
                                                    adId: automotiveViewModel
                                                        .automotiveSortedAds[
                                                            index]
                                                        .id!);
                                            for (int i = 0;
                                                i <
                                                    automotiveViewModel
                                                        .automotiveSortedAds
                                                        .length;
                                                i++) {
                                              if (automotiveViewModel
                                                      .automotiveSortedAds[
                                                          index]
                                                      .id! ==
                                                  automotiveViewModel
                                                      .automotiveSortedAds[i]
                                                      .id) {
                                                automotiveViewModel
                                                    .automotiveSortedAds[index]
                                                    .isFavourite = true;
                                                automotiveViewModel
                                                    .changeAutomotiveAllAds(
                                                        automotiveViewModel
                                                            .automotiveSortedAds);
                                              }
                                            }
                                            for (int i = 0;
                                                i <
                                                    profileViewModel
                                                        .myAutomotiveAds.length;
                                                i++) {
                                              if (automotiveViewModel
                                                      .automotiveSortedAds[
                                                          index]
                                                      .id! ==
                                                  profileViewModel
                                                      .myAutomotiveAds[i].id) {
                                                profileViewModel
                                                    .myAutomotiveAds[index]
                                                    .isFavourite = true;
                                                profileViewModel
                                                    .changeMyAutomotiveAds(
                                                        profileViewModel
                                                            .myAutomotiveAds);
                                              }
                                            }
                                          });
                                          profileViewModel.myFavAutomotiveAds
                                              .add(automotiveViewModel
                                                  .automotiveSortedAds[index]);
                                          profileViewModel
                                              .changeMyFavAutomotive(
                                                  profileViewModel
                                                      .myFavAutomotiveAds);
                                        } else {
                                          setState(() {
                                            automotiveViewModel
                                                .addFavAutomotive(
                                                    adId: automotiveViewModel
                                                        .automotiveSortedAds[
                                                            index]
                                                        .id!);
                                            for (int i = 0;
                                                i <
                                                    automotiveViewModel
                                                        .automotiveSortedAds
                                                        .length;
                                                i++) {
                                              if (automotiveViewModel
                                                      .automotiveSortedAds[
                                                          index]
                                                      .id! ==
                                                  automotiveViewModel
                                                      .automotiveSortedAds[i]
                                                      .id) {
                                                automotiveViewModel
                                                    .automotiveSortedAds[index]
                                                    .isFavourite = false;
                                                automotiveViewModel
                                                    .changeAutomotiveAllAds(
                                                        automotiveViewModel
                                                            .automotiveSortedAds);
                                              }
                                            }
                                            for (int i = 0;
                                                i <
                                                    profileViewModel
                                                        .myAutomotiveAds.length;
                                                i++) {
                                              if (profileViewModel
                                                      .myAutomotiveAds[index]
                                                      .id! ==
                                                  profileViewModel
                                                      .myAutomotiveAds[i].id) {
                                                profileViewModel
                                                    .myAutomotiveAds[index]
                                                    .isFavourite = false;
                                                profileViewModel
                                                    .changeMyAutomotiveAds(
                                                        profileViewModel
                                                            .myAutomotiveAds);
                                              }
                                            }
                                          });
                                          profileViewModel.myFavAutomotiveAds
                                              .removeWhere((element) =>
                                                  element.id ==
                                                  automotiveViewModel
                                                      .automotiveSortedAds[
                                                          index]
                                                      .id!);
                                          profileViewModel
                                              .changeMyFavAutomotive(
                                                  profileViewModel
                                                      .myFavAutomotiveAds);
                                        }
                                      },
                                      isFeatured: automotiveViewModel
                                          .automotiveSortedAds[index]
                                          .isPromoted,
                                      isOff: automotiveViewModel
                                          .automotiveSortedAds[index].isDeal,
                                      address: automotiveViewModel
                                          .automotiveSortedAds[index]
                                          .streetAddress,
                                      price: automotiveViewModel
                                          .automotiveSortedAds[index].price,
                                      currencyCode: automotiveViewModel
                                          .automotiveSortedAds[index]
                                          .currency!
                                          .code,
                                      title: automotiveViewModel
                                          .automotiveSortedAds[index].name,
                                      imageUrl: automotiveViewModel
                                              .automotiveSortedAds[index]
                                              .imageMedia!
                                              .isEmpty
                                          ? null
                                          : automotiveViewModel
                                              .automotiveSortedAds[index]
                                              .imageMedia![0]
                                              .image,
                                      logo: automotiveViewModel
                                                  .automotiveSortedAds[index]
                                                  .businessType ==
                                              "Company"
                                          ? automotiveViewModel
                                              .automotiveSortedAds[index]
                                              .company
                                              ?.profilePicture
                                          : automotiveViewModel
                                              .automotiveSortedAds[index]
                                              .profile
                                              ?.profilePicture,
                                      categories: "auto",
                                      beds:
                                          "${automotiveViewModel.automotiveSortedAds[index].kilometers} KM",
                                      baths:
                                          "${automotiveViewModel.automotiveSortedAds[index].transmissionType}",
                                      baths1:
                                          "${automotiveViewModel.automotiveSortedAds[index].fuelType}",
                                    ),
                                  );
                                },
                              ),

                SizedBox(
                  height: med.height * 0.02,
                ),

                automotiveViewModel.automotiveAllAds.isEmpty
                    ? Container()
                    : isExploringMore
                        ? Center(
                            child: CircularProgressIndicator(
                                color: CustomAppTheme().primaryColor),
                          )
                        : Center(
                            child: selectedSubMenuIndex == 0
                                ? currentPageAutomotive !=
                                        automotiveViewModel.autoAllAdsTotalPages
                                    ? ExploreMoreButton(onTab: () async {
                              currentPageAutomotive = currentPageAutomotive + 1;
                                        automotiveViewModel.autoAllAdsPageNo =
                                            automotiveViewModel
                                                    .autoAllAdsPageNo +
                                                1;
                                        setState(() {
                                          isExploringMore = true;
                                        });
                                        await getAutoAllAds();
                                      })
                                    : const SizedBox.shrink()
                                : const SizedBox.shrink(),
                          ),

                SizedBox(
                  height: med.height * 0.04,
                ),

                Container(
                  height: med.height * 0.02,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(10),
                  //   color: CustomAppTheme().greyColor,
                  //   image: DecorationImage(
                  //     image: AssetImage(automotiveBannerImages[0]),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                ),

                /*SizedBox(
                  height: med.height * 0.04,
                ),

                HomeScreenHeadingWidget(
                  headingText: 'Best Selling Car Makes',
                  viewAllCallBack: () {},
                  isSuffix: false,
                ),

                SizedBox(
                  height: med.height * 0.02,
                ),

                SizedBox(
                  height: med.height * 0.15,
                  child: ListView.builder(
                    itemCount: automotiveViewModel.automotiveFeaturedBrands!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return BrandCircularWidget(
                        brandName: automotiveViewModel.automotiveFeaturedBrands![index].title,
                        index: index,
                      );
                    },
                  ),
                ),*/

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
                            child: const ProductCard(isFeatured: true, imageUrl: 'assets/temp/car.jpg'),
                          ),
                        );
                      },
                    ),
                  ),
                ),*/

                SizedBox(
                  height: med.height * 0.02,
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
                        builder: (context) => const AutomotiveOnMapScreen()));
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
      ),
    );
  }

  List<String> automotiveBannerImages = [
    'assets/images/autoBanner1.png',
    'assets/images/Automotive banner 2.png',
  ];

  List<String> automotiveCategoryMenu = ['All', 'Used', 'New'];
}
