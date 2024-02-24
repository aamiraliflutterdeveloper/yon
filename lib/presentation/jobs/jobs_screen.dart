import 'package:app/common/logger/log.dart';
import 'package:app/presentation/categories/all_categories_screen.dart';
import 'package:app/presentation/jobs/jobs_on_map_screen.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
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
import 'package:app/presentation/utils/widgets/jobAds_widget.dart';
import 'package:app/presentation/utils/widgets/location_and_notif_widget.dart';
import 'package:app/presentation/utils/widgets/menu_with_icon_widget.dart';
import 'package:app/presentation/utils/widgets/searched_textfield.dart';
import 'package:app/presentation/widgets_screens/all_products_screen.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'job_filters/job_filters_screen.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  int featuredAdsLength = 6;
  int selectedSubMenuIndex = 0;
  int currentPageJob = 1;

  void getAllJobCategories() async {
    final result = await context.read<JobViewModel>().getAllJobCategories();
    result.fold((l) {}, (r) {
      d('***********************************');
      d(r.response.toString());
      context.read<JobViewModel>().changeJobAllCategories(r.response!);
    });
  }

  void getFeaturedAds() async {
    final result = await context.read<JobViewModel>().getJobFeaturedProducts();
    result.fold((l) {}, (r) {
      d('***********************************');
      d(r.jobAdsList.toString());
      context.read<JobViewModel>().changeJobFeaturedAds(r.jobAdsList!);
    });
  }

  bool isExploringMore = false;
  void getAllAds() async {
    JobViewModel jobViewModel = context.read<JobViewModel>();
    final result = await context
        .read<JobViewModel>()
        .getJobAllProducts(pageNo: currentPageJob);
    result.fold((l) {}, (r) {
      d('JOB COUNTS ***********************************');
      d(r.count.toString());
      double totalPagesInDouble = r.count! / 20;
      int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
          ? totalPagesInDouble.toInt() + 1
          : totalPagesInDouble.toInt();
      jobViewModel.allJobTotalPages = totalPagesInInt;
      d('Job total pages : $totalPagesInInt');
      if(currentPageJob == 1) {
        jobViewModel.jobAllAds!.clear();
        jobViewModel.jobAllAds!.addAll(r.jobAdsList!);
        jobViewModel.changeJobAllAds(jobViewModel.jobAllAds!);
      } else {
        jobViewModel.jobAllAds!.addAll(r.jobAdsList!);
        jobViewModel.changeJobAllAds(jobViewModel.jobAllAds!);
      }

    });
    // final result = await context.read<JobViewModel>().getJobAllProducts();
    // result.fold((l) {}, (r) {
    //   d('***********************************');
    //   d(r.jobAdsList.toString());
    //   context.read<JobViewModel>().changeJobAllAds(r.jobAdsList!);
    // });
    setState(() {
      isExploringMore = false;
    });
  }

  @override
  void initState() {
    JobViewModel jobViewModel = context.read<JobViewModel>();
    jobViewModel.jobAllCategories!.clear();
    jobViewModel.jobFeaturedAds!.clear();
    super.initState();
    if (jobViewModel.jobAllCategories!.isEmpty) {
      getAllJobCategories();
    }
    if (jobViewModel.jobAllAds!.isEmpty) {
      getAllAds();
    }
    if (jobViewModel.jobFeaturedAds!.isEmpty) {
      getFeaturedAds();
    }
  }

  @override
  Widget build(BuildContext context) {
    final JobViewModel jobViewModel = context.watch<JobViewModel>();
    final ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    Size med = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: CustomAppTheme().backgroundColor,
        appBar: customAppBar(title: 'Jobs', context: context, onTap: () {Navigator.of(context).pop();}),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                        print("ahhahahhahahahhahahhahahahh");
                        jobViewModel.jobFilterData = JobFilterModel();
                        jobViewModel.jobFilterMap = {};
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const JobFiltersScreen()));
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
                //     itemCount: jobsBannerImages.length,
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
                //                   image: AssetImage(jobsBannerImages[index]),
                //                   fit: BoxFit.cover,
                //                 )),
                //           ),
                //           index != 1
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
                                  categoryTitle: 'Job',
                                  categoryIndex: 3,
                                )));
                  },
                ),

                SizedBox(
                  height: med.height * 0.02,
                ),

                //Category cards
                jobViewModel.jobAllCategories!.isNotEmpty
                    ? SizedBox(
                        height: med.height * 0.15,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: jobViewModel.jobAllCategories!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            String colorCode = jobViewModel
                                        .jobAllCategories![index]
                                        .backgroundColor ==
                                    null
                                ? 'FFF8D1'
                                : jobViewModel
                                    .jobAllCategories![index].backgroundColor
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
                                        title: jobViewModel
                                            .jobAllCategories![index].title
                                            .toString(),
                                        moduleIndex: 3,
                                        categoryId: jobViewModel
                                            .jobAllCategories![index].id
                                            .toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryCard(
                                  imagePath: jobViewModel
                                          .jobAllCategories![index].image ??
                                      'https://user-images.githubusercontent.com/10515204/56117400-9a911800-5f85-11e9-878b-3f998609a6c8.jpg',
                                  title: jobViewModel
                                      .jobAllCategories![index].title,
                                  totalAds: jobViewModel
                                      .jobAllCategories![index].totalCount
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
                    itemCount: featuredCategoriesMenu.length,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSubMenuIndex = index;
                          });
                        },
                        child: MenuWithIconWidget(
                          index: index,
                          selectedSubMenuIndex: selectedSubMenuIndex,
                          menuText: featuredCategoriesMenu[index],
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(
                  height: med.height * 0.02,
                ),

                //Featured Ads
                jobViewModel.jobAllAds == null
                    ? GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: featuredAdsLength,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: med.height * 0.00072,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 15,
                        ),
                        itemBuilder: (context, index) {
                          return const ProductCardShimmer();
                        },
                      )
                    : jobViewModel.jobAllAds!.isEmpty
                        ? SizedBox(
                            height: 250, child: Center(child: noDataFound()))
                        : GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: jobViewModel.jobAllAds!.length,
                            physics: const NeverScrollableScrollPhysics(),
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
                                      builder: (context) => ProductDetailScreen(
                                        isJobAd: true,
                                        jobProduct:
                                            jobViewModel.jobAllAds![index],
                                        productType: 'Job',
                                      ),
                                    ),
                                  );
                                },
                                child: JobAdsWidget(
                                  onFavTap: () {
                                    if (jobViewModel
                                            .jobAllAds![index].isFavourite ==
                                        false) {
                                      setState(() {
                                        jobViewModel.addFavJob(
                                            adId: jobViewModel
                                                .jobAllAds![index].id!);
                                        for (int i = 0;
                                            i < jobViewModel.jobAllAds!.length;
                                            i++) {
                                          if (jobViewModel
                                                  .jobAllAds![index].id! ==
                                              jobViewModel.jobAllAds![i].id) {
                                            jobViewModel.jobAllAds![index]
                                                .isFavourite = true;
                                            jobViewModel.changeJobAllAds(
                                                jobViewModel.jobAllAds!);
                                          }
                                        }
                                        for (int i = 0;
                                            i <
                                                profileViewModel
                                                    .myJobAds.length;
                                            i++) {
                                          if (profileViewModel
                                                  .myJobAds[index].id! ==
                                              profileViewModel.myJobAds[i].id) {
                                            profileViewModel.myJobAds[index]
                                                .isFavourite = true;
                                            profileViewModel.changeMyJobAds(
                                                profileViewModel.myJobAds);
                                          }
                                        }
                                      });
                                      profileViewModel.myFavJobAds
                                          .add(jobViewModel.jobAllAds![index]);
                                      profileViewModel.changeMyFavJob(
                                          profileViewModel.myFavJobAds);
                                    } else {
                                      setState(() {
                                        jobViewModel.addFavJob(
                                            adId: jobViewModel
                                                .jobAllAds![index].id!);
                                        for (int i = 0;
                                            i < jobViewModel.jobAllAds!.length;
                                            i++) {
                                          if (jobViewModel
                                                  .jobAllAds![index].id! ==
                                              jobViewModel.jobAllAds![i].id) {
                                            jobViewModel.jobAllAds![index]
                                                .isFavourite = false;
                                            jobViewModel.changeJobAllAds(
                                                jobViewModel.jobAllAds!);
                                          }
                                        }
                                        for (int i = 0;
                                            i <
                                                profileViewModel
                                                    .myJobAds.length;
                                            i++) {
                                          if (profileViewModel
                                                  .myJobAds[index].id! ==
                                              profileViewModel.myJobAds[i].id) {
                                            profileViewModel.myJobAds[index]
                                                .isFavourite = false;
                                            profileViewModel.changeMyJobAds(
                                                profileViewModel.myJobAds);
                                          }
                                        }
                                      });
                                      profileViewModel.myFavJobAds.retainWhere(
                                          (element) =>
                                              element.id ==
                                              jobViewModel
                                                  .jobAllAds![index].id);
                                      profileViewModel.changeMyFavJob(
                                          profileViewModel.myFavJobAds);
                                    }
                                  },
                                  isFeatured:
                                      jobViewModel.jobAllAds![index].isPromoted,
                                  isOff: false,
                                  isFav: jobViewModel
                                      .jobAllAds![index].isFavourite,
                                  title: jobViewModel.jobAllAds![index].title,
                                  currencyCode: jobViewModel
                                      .jobAllAds![index].salaryCurrency!.code,
                                  startingSalary: jobViewModel
                                      .jobAllAds![index].salaryStart,
                                  endingSalary:
                                      jobViewModel.jobAllAds![index].salaryEnd,
                                  description: jobViewModel
                                      .jobAllAds![index].description,
                                  address:
                                      jobViewModel.jobAllAds![index].location,
                                  beds:
                                      "${jobViewModel.jobAllAds![index].positionType}",
                                  baths:
                                      "${jobViewModel.jobAllAds![index].jobType}",
                                  imageUrl: jobViewModel
                                          .jobAllAds![index].imageMedia!.isEmpty
                                      ? null
                                      : jobViewModel.jobAllAds![index]
                                          .imageMedia![0].image,
                                ),
                              );
                            },
                          ),

                SizedBox(
                  height: med.height * 0.02,
                ),

                jobViewModel.jobAllAds!.isEmpty
                    ? Container()
                    : isExploringMore
                        ? Center(
                            child: CircularProgressIndicator(
                                color: CustomAppTheme().primaryColor),
                          )
                        : Center(
                            child: currentPageJob !=
                                    jobViewModel.allJobTotalPages
                                ? ExploreMoreButton(
                                    onTab: () async {
                                      setState(() {
                                        currentPageJob = currentPageJob + 1;
                                        isExploringMore = true;
                                      });
                                      jobViewModel.allJobPageNo =
                                          jobViewModel.allJobPageNo + 1;
                                      getAllAds();
                                    },
                                  )
                                : const SizedBox.shrink(),
                          ),

                SizedBox(
                  height: med.height * 0.04,
                ),

                Container(
                  height: med.height * 0.03,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(10),
                  //   color: CustomAppTheme().greyColor,
                  //   image: DecorationImage(
                  //     image: AssetImage(jobsBannerImages[0]),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                ),

                SizedBox(
                  height: med.height * 0.04,
                ),

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
                  height: med.height * 0.26,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProductDetailScreen(
                                      isJobAd: true,
                                    ),
                                  ),
                                );
                              },
                              child: const JobAdsWidget()),
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
                        builder: (context) => const JobsOnMapScreen()));
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

  List<String> jobsBannerImages = [
    'assets/images/jobBanner1.png',
    'assets/images/Job banner 2.png'
  ];

  List<String> jobsCategoriesSvgs = [
    'assets/temp/UIDesignIcon.svg',
    'assets/temp/world-wide-web 1.svg',
    'assets/temp/app-development.svg',
    'assets/temp/web-administrator.svg',
    'assets/temp/data-scientist.svg'
  ];

  List<String> featuredCategoriesMenu = [
    'All', /*'Software & IT', 'Engineering', 'Health Care'*/
  ];
}
