import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/domain/use_case/classified_useCases/get_all_classified_cate_usecase.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/automotive/automotive_screen.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/categories/all_categories_screen.dart';
import 'package:app/presentation/classified/classified_filers/classified_filter_screen.dart';
import 'package:app/presentation/classified/mixins/classifiied_screen_mixin.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/home/view_model/home_view_model.dart';
import 'package:app/presentation/jobs/jobs_screen.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/notification/notification_screen.dart';
import 'package:app/presentation/notification/view_model/notification_view_model.dart';
import 'package:app/presentation/profile/business_mode/create_business_profile.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/properties/property_screen.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/searchs/searchScreen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/shimmers/product_card_shimmer.dart';
import 'package:app/presentation/utils/widgets/brand_circular_widget.dart';
import 'package:app/presentation/utils/widgets/category_card.dart';
import 'package:app/presentation/utils/widgets/explore_more_button.dart';
import 'package:app/presentation/utils/widgets/filter_widget.dart';
import 'package:app/presentation/utils/widgets/home_screen_headings_widget.dart';
import 'package:app/presentation/utils/widgets/jobAds_widget.dart';
import 'package:app/presentation/utils/widgets/product_card.dart';
import 'package:app/presentation/utils/widgets/searched_textfield.dart';
import 'package:app/presentation/utils/widgets/simpleDropDown.dart';
import 'package:app/presentation/widgets_screens/all_products_screen.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ClassifiedScreen extends StatefulWidget {
  const ClassifiedScreen({Key? key}) : super(key: key);

  @override
  State<ClassifiedScreen> createState() => _ClassifiedScreenState();
}

class _ClassifiedScreenState extends State<ClassifiedScreen>
    with BaseMixin, ClassifiedScreenMixin {
  int selectedMenuIndex = 0;
  int selectedAllMenuIndex = 0;
  int currentAdIndex = 0;
  int pageIndex = 0;
  int featuredAdsLength = 6;

  bool isRecommendedAdAvailable = true;
  bool isDealsOfTheDayAvailable = true;
  bool isFeatureBrandsAvailable = true;
  bool isExploringMore = false;
  int currentPageClassified = 1;
  int currentPageAutomotive = 1;
  int currentPageProperty = 1;
  int currentPageJob = 1;

  getClassifiedAllAds() async {
    print("classified data");
    ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    final result =
        await classifiedViewModel.getClassifiedAllAds(pageNo: currentPageClassified);
    print(currentPageClassified);
    d(currentPageClassified);
    d("=============================================");
    d("=============================================");
    d("=============================================");
    print(" hahahahahhhhaha === === ==== === $result ");
    result.fold((l) {}, (r) {
      d('CLASSIFIED ALL ADS : ${r.results}');
      double totalPagesInDouble = r.count! / 20;
      int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
          ? totalPagesInDouble.toInt() + 1
          : totalPagesInDouble.toInt();
      classifiedViewModel.allClassifiedTotalPages = totalPagesInInt;
      if (currentPageClassified == 1) {
        classifiedViewModel.classifiedAllAds?.clear();
        print("this is page no 1 =====");
        classifiedViewModel.changeClassifiedAllAds(r.results!);
      } else {
        print("this is else page no 1 =====");
        classifiedViewModel.classifiedAllAds!.addAll(r.results!);
        classifiedViewModel
            .changeClassifiedAllAds(classifiedViewModel.classifiedAllAds!);
      }
    });
  }

  getClassifiedFeaturedAds() async {
    ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    final result = await classifiedViewModel.getClassifiedFeaturedAds();
    result.fold(
      (l) {
        setState(() {
          isFeatureBrandsAvailable = false;
        });
      },
      (r) {
        d('CLASSIFIED FEATURED ADS : ${r.results}');
        classifiedViewModel.changeClassifiedFeaturedAds(r.results!);
        if (r.results!.isEmpty) {
          setState(() {
            isFeatureBrandsAvailable = false;
          });
        }
      },
    );
  }

  getClassifiedRecommendedAds() async {
    ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    classifiedViewModel.classifiedRecommendedAds?.clear();
    final result = await classifiedViewModel.getClassifiedRecommendedAds();
    result.fold((l) {
      setState(() {
        isRecommendedAdAvailable = false;
      });
    }, (r) {
      d('CLASSIFIED RECOMMENDED ADS : ${r.results}');
      classifiedViewModel.changeClassifiedRecommendedAds(r.results!);
      if (r.results!.isEmpty) {
        setState(() {
          isRecommendedAdAvailable = false;
        });
      }
    });
  }

  getClassifiedDealAds() async {
    ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    final result = await classifiedViewModel.getClassifiedDealAds();
    result.fold((l) {
      setState(() {
        isDealsOfTheDayAvailable = false;
      });
    }, (r) {
      d('CLASSIFIED DEAL ADS : ${r.results}');
      if (r.results!.isEmpty) {
        setState(() {
          isDealsOfTheDayAvailable = false;
        });
      }
      classifiedViewModel.changeClassifiedDealAds(r.results!);
    });
  }

  getClassifiedFeaturedBrands() async {
    ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    final result = await classifiedViewModel.getClassifiedFeaturedBrands();
    result.fold((l) {}, (r) {
      d('CLASSIFIED DEAL ADS : ${r.brandsList}');
      classifiedViewModel.changeClassifiedFeaturedBrands(r.brandsList!);
    });
  }

  getAutoAllAds() async {
    AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    final result =
        await automotiveViewModel.getAutomotiveAllProducts(pageNo: currentPageAutomotive);

    /// this is changed
    // automotiveViewModel.automotiveAllAds.clear();

    result.fold((l) {}, (r) {
      d('AUTO TOTAL COUNTS : ${r.count}');
      d('AUTOMOTIVE ALL ADS : ${r.automotiveAdsList}');
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
    });
  }

  getPropertyAllAds() async {
    final result = await context
        .read<PropertiesViewModel>()
        .getPropertyAllProducts(pageNo: currentPageProperty);

    /// this is addition
    // context.read<PropertiesViewModel>().propertyAllAds!.clear();

    result.fold((l) {}, (r) {
      d('COUNTS ***********************************');
      d(r.count.toString());
      double totalPagesInDouble = r.count! / 20;
      int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
          ? totalPagesInDouble.toInt() + 1
          : totalPagesInDouble.toInt();
      context.read<PropertiesViewModel>().allPropertiesTotalPages =
          totalPagesInInt;
      d('Property total pages : $totalPagesInInt');

      if (currentPageProperty == 1) {
        context.read<PropertiesViewModel>().propertyAllAds!.clear();
        print("this is page no 1 =====");
        context.read<PropertiesViewModel>().changePropertiesAllAds(r.propertyProductList!);
      } else {
        context
            .read<PropertiesViewModel>()
            .propertyAllAds!
            .addAll((r.propertyProductList!));
        context.read<PropertiesViewModel>().changePropertiesAllAds(
            context.read<PropertiesViewModel>().propertyAllAds!);
      }
    });
  }

  getJobAllAds() async {
    JobViewModel jobViewModel = context.read<JobViewModel>();
    final result = await context
        .read<JobViewModel>()
        .getJobAllProducts(pageNo: currentPageJob);

    /// this is changed
    // jobViewModel.jobAllAds!.clear();

    result.fold((l) {}, (r) {
      d('JOB COUNTS ***********************************');
      d(r.count.toString());
      d("${r.jobAdsList!.map((e) => e.title)}");
      d("ohoooooooooooooooooooooooooooooooooooooooooooooo");
      double totalPagesInDouble = r.count! / 20;
      int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
          ? totalPagesInDouble.toInt() + 1
          : totalPagesInDouble.toInt();
      jobViewModel.allJobTotalPages = totalPagesInInt;
      d('Job total pages : $totalPagesInInt');

      if (currentPageJob == 1) {
        jobViewModel.jobAllAds!.clear();
        print("this is page no 1 =====");
        jobViewModel.changeJobAllAds(r.jobAdsList!);
      } else {
        jobViewModel.jobAllAds!.addAll(r.jobAdsList!);
        jobViewModel.changeJobAllAds(jobViewModel.jobAllAds!);
      }

    });
  }

  void getAllNotifications() async {
    NotificationViewModel notificationViewModel =
        context.read<NotificationViewModel>();

    final result = await notificationViewModel.getAllNotifications();
    result.fold((l) {}, (r) {
      d('This is result : $r');
      notificationViewModel.changeNotificationList(r.notificationList!);
      setState(() {});
    });
    setState(() {});
  }

  // changeData() {
  //   print("hahahahhahahhah ==== =");
  //   ClassifiedViewModel classifiedViewModel =
  //       context.read<ClassifiedViewModel>();
  //   print("hahahahhahahhah ==== ==");
  //   // if (classifiedViewModel.classifiedAllAds!.isEmpty) {
  //     print("hahahahhahahhah ==== ===");
  //   getClassifiedAllAds();
  //   // }
  //   if (classifiedViewModel.classifiedFeaturedAds!.isEmpty) {
  //     getClassifiedFeaturedAds();
  //   }
  //   if (classifiedViewModel.classifiedDealAds!.isEmpty) {
  //     getClassifiedDealAds();
  //   }
  //    if (classifiedViewModel.classifiedRecommendedAds!.isEmpty) {
  //   getClassifiedRecommendedAds();
  //    }
  //   if (classifiedViewModel.classifiedFeaturedBrands!.isEmpty) {
  //     getClassifiedFeaturedBrands();
  //   }
  //    if (context.read<AutomotiveViewModel>().automotiveAllAds.isEmpty) {
  //   getAutoAllAds();
  //    }
  //    if (context.read<PropertiesViewModel>().propertyAllAds!.isEmpty) {
  //   getPropertyAllAds();
  //    }
  //    if (context.read<JobViewModel>().jobAllAds!.isEmpty) {
  //   getJobAllAds();
  //    }
  //   getAllCategories();
  //
  // }

  changeData() {
    setState(() {
      currentPageClassified = 1;
      currentPageAutomotive = 1;
      currentPageProperty = 1;
      currentPageJob = 1;
    });
    getAllCategories();
    ClassifiedViewModel classifiedViewModel =
    context.read<ClassifiedViewModel>();
    // if (classifiedViewModel.classifiedAllAds!.isEmpty) {
    getClassifiedAllAds();
    // }
    if (classifiedViewModel.classifiedFeaturedAds!.isEmpty) {
      getClassifiedFeaturedAds();
    }
    if (classifiedViewModel.classifiedDealAds!.isEmpty) {
      getClassifiedDealAds();
    }
    // if (classifiedViewModel.classifiedRecommendedAds!.isEmpty) {
    getClassifiedRecommendedAds();
    // }
    if (classifiedViewModel.classifiedFeaturedBrands!.isEmpty) {
      getClassifiedFeaturedBrands();
    }
    // if (context.read<AutomotiveViewModel>().automotiveAllAds.isEmpty) {
    getAutoAllAds();
    // }
    // if (context.read<PropertiesViewModel>().propertyAllAds!.isEmpty) {
    getPropertyAllAds();
    // }
    // if (context.read<JobViewModel>().jobAllAds!.isEmpty) {
    getJobAllAds();
    // }
  }

  @override
  void initState() {
    super.initState();
    changeData();
    getAllNotifications();

  }

  String? countryValue;
  String? cityValue;

  @override
  Widget build(BuildContext context) {

    final HomeViewModel homeViewModel = context.watch<HomeViewModel>();
    final ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    final ClassifiedViewModel classifiedViewModel =
        context.watch<ClassifiedViewModel>();
    final AutomotiveViewModel automotiveViewModel =
        context.watch<AutomotiveViewModel>();
    final PropertiesViewModel propertiesViewModel =
        context.watch<PropertiesViewModel>();
    final JobViewModel jobViewModel = context.watch<JobViewModel>();
    NotificationViewModel notificationViewModel =
        context.read<NotificationViewModel>();
    GeneralViewModel generalViewModel = context.watch<GeneralViewModel>();
    d('LISTTTTTTT :::: : :: : : ${generalViewModel.userCities}');
    Size med = MediaQuery.of(context).size;
    print("Country Name: ${generalViewModel.userCurrentCountry}");
    print("Country Name List: ${generalViewModel.otherCountries}");

    print("this is classified adds length :: ${classifiedViewModel.classifiedAllAds?.length}");

    // if (generalViewModel.userCurrentCountry != null) {
    //   if (!(generalViewModel.otherCountries
    //       .contains(generalViewModel.userCurrentCountry))) {
    //     Get.defaultDialog();
    //   }
    // }

    print(classifiedViewModel
        .allClassifiedTotalPages);
    print("=====================================");
    print("=====================================");
    print("=====================================");

    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Top Widget
            Container(
              height: med.height * 0.275,
              width: med.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/home_bg.png'),
                fit: BoxFit.cover,
              )),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: med.height * 0.05,
                    ),
                    Center(
                      child: Text(
                        'You Online',
                        style: CustomAppTheme().headingText.copyWith(
                            color: CustomAppTheme().backgroundColor,
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.location_on_rounded,
                              color: CustomAppTheme().secondaryColor),
                          /*Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              iPrefHelper.userLocation().toString(),
                              style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().backgroundColor),
                            ),
                          ),*/
                          SimpleDropDown(
                            hint: 'Country',
                            icon: null,
                            // buttonWidth: med.width * 0.3,
                            buttonHeight: med.height * 0.04,
                            dropdownItems: generalViewModel.otherCountries,
                            value: generalViewModel.userCurrentCountry ==
                                    "Pakistan"
                                ? "United Arab Emirates"
                                : generalViewModel.userCurrentCountry,
                            onChanged: (value) {
                              generalViewModel.changeUserCurrentCountry(value);
                              iPrefHelper.saveUserCurrentCountry(value);
                              generalViewModel.changeUserCurrentCity(null);
                              generalViewModel.userCities = [];
                              iPrefHelper.saveUserCurrentCity('');
                              classifiedViewModel.changeClassifiedAllAds([]);
                              automotiveViewModel.changeAutomotiveAllAds([]);
                              propertiesViewModel.changePropertiesAllAds([]);
                              jobViewModel.changeJobAllAds([]);
                              classifiedViewModel
                                  .changeClassifiedRecommendedAds([]);
                              classifiedViewModel.allClassifiedPageNo = 0;
                              automotiveViewModel.autoAllAdsPageNo = 0;
                              generalViewModel.updateCurrentLocation(
                                  context: context, country: value);
                              changeData();
                              setState(() {});
                            },
                          ),
                          // SimpleDropDown(
                          //   hint: 'City',
                          //   icon: null,
                          //   buttonWidth: med.width * 0.3,
                          //   buttonHeight: med.height * 0.04,
                          //   dropdownItems: generalViewModel.userCities,
                          //   value: generalViewModel.userCurrentCity,
                          //   onChanged: (value) {
                          //     generalViewModel.changeUserCurrentCity(value);
                          //     iPrefHelper.saveUserCurrentCity(value);
                          //     classifiedViewModel.changeClassifiedAllAds([]);
                          //     automotiveViewModel.changeAutomotiveAllAds([]);
                          //     propertiesViewModel.changePropertiesAllAds([]);
                          //     jobViewModel.changeJobAllAds([]);
                          //     classifiedViewModel
                          //         .changeClassifiedRecommendedAds([]);
                          //     classifiedViewModel.allClassifiedPageNo = 0;
                          //     automotiveViewModel.autoAllAdsPageNo = 0;
                          //     changeData();
                          //   },
                          // ),

                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationScreen())).then((value) {
                                getAllNotifications();
                              });
                            },
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Icon(Icons.notifications,
                                      color: CustomAppTheme().backgroundColor),
                                ),
                                notificationViewModel.notificationList
                                        .where((element) =>
                                            element.isRead == false)
                                        .toList()
                                        .isEmpty
                                    ? Container()
                                    : Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  CustomAppTheme().primaryColor,
                                              shape: BoxShape.circle),
                                          padding: const EdgeInsets.all(3),
                                          child: Text(
                                            notificationViewModel
                                                .notificationList
                                                .where((element) =>
                                                    element.isRead == false)
                                                .toList()
                                                .length
                                                .toString(),
                                            style: CustomAppTheme()
                                                .normalText
                                                .copyWith(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                          ),
                                        ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
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
                          classifiedViewModel.classifiedFilterData =
                              ClassifiedFilterModel();
                          classifiedViewModel.classifiedFilterMap = {};
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ClassifiedFilterScreen()));
                        }),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: med.height * 0.035,
                      child: ListView.builder(
                        itemCount: 4,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                homeViewModel.changeCurrentMainMenuIndex(index);
                              });
                              if (homeViewModel.currentMainMenuIndex == 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AutomotiveScreen()));
                              }
                              if (homeViewModel.currentMainMenuIndex == 2) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PropertyScreen()));
                              }
                              if (homeViewModel.currentMainMenuIndex == 3) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const JobsScreen()));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    currentMainMenuIndex == index
                                        ? BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(2,
                                                3), // changes position of shadow
                                          )
                                        : const BoxShadow(
                                            color: Colors.transparent,
                                            blurRadius: 0,
                                            offset: Offset.zero),
                                  ],
                                  color: currentMainMenuIndex == index
                                      ? CustomAppTheme().secondaryColor
                                      : CustomAppTheme().backgroundColor,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    child: Text(
                                      menuOptions[index],
                                      style: CustomAppTheme()
                                          .normalText
                                          .copyWith(
                                              letterSpacing: 0.5,
                                              color: currentMainMenuIndex ==
                                                      index
                                                  ? CustomAppTheme()
                                                      .backgroundColor
                                                  : CustomAppTheme().blackColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  HomeScreenHeadingWidget(
                    headingText: 'Browse By Categories',
                    viewAllCallBack: () async{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllCategoriesScreen(
                            categoryTitle: 'Classified',
                            categoryIndex: 0,
                          ),
                        ),
                      ).then((value) => print("ahhhhhhhhhhhhhhhhhhhhhh"));
                    },
                  ),

                  SizedBox(
                    height: med.height * 0.02,
                  ),

                  //Category cards
                  classifiedViewModel.classifiedAllCategories!.isNotEmpty
                      ? SizedBox(
                          height: med.height * 0.15,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: classifiedViewModel
                                .classifiedAllCategories!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              String colorCode = classifiedViewModel
                                          .classifiedAllCategories![index]
                                          .backgroundColor ==
                                      null
                                  ? 'FFF8D1'
                                  : classifiedViewModel
                                      .classifiedAllCategories![index]
                                      .backgroundColor
                                      .toString();
                              int bgColor = int.parse('0XFF' + colorCode);
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () async{
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AllProductScreen(
                                          title: classifiedViewModel
                                              .classifiedAllCategories![index]
                                              .title
                                              .toString(),
                                          // moduleIndex: 0,
                                          moduleIndex: selectedAllMenuIndex,
                                          categoryId: classifiedViewModel
                                              .classifiedAllCategories![index]
                                              .id
                                              .toString(),
                                        ),
                                      ),
                                    ).then((value) {
                                      print("=========================================");
                                      print("=========================================");
                                      print("=========================================");
                            if(value[0] == 'pressed' && value[1] == '0') {

                              getClassifiedAllAds();
                            } else if(value[0] == 'pressed' && value[1] == '1') {
                              getAutoAllAds();
                            } else if(value[0] == 'pressed' && value[1] == '2') {
                              getPropertyAllAds();
                            } else if(value[0] == 'pressed' && value[1] == '3') {
                              getJobAllAds();
                            } else {}
                                    });
                                  },
                                  child: CategoryCard(
                                    bgColorCode: bgColor,
                                    totalAds: classifiedViewModel
                                        .classifiedAllCategories![index]
                                        .totalCount
                                        .toString(),
                                    imagePath: classifiedViewModel
                                            .classifiedAllCategories![index]
                                            .image ??
                                        'https://user-images.githubusercontent.com/10515204/56117400-9a911800-5f85-11e9-878b-3f998609a6c8.jpg',
                                    title: classifiedViewModel
                                        .classifiedAllCategories![index].title
                                        .toString(),
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
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  height: med.height * 0.15,
                                  width: med.width * 0.26,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.grey.shade50,
                                    child: Container(
                                      height: med.height * 0.15,
                                      width: med.width * 0.26,
                                      decoration: BoxDecoration(
                                        color: const Color(0xfffff8d1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                  SizedBox(
                    height: med.height * 0.03,
                  ),

                  //Ads
                  SizedBox(
                    height: med.height * 0.17,
                    child: Swiper(
                      itemWidth: med.width * 0.7,
                      itemHeight: med.height * 0.17,
                      itemCount: 3,
                      viewportFraction: 0.8,
                      scale: 0.9,
                      loop: false,
                      onIndexChanged: (value) {
                        setState(() {
                          currentAdIndex = value;
                        });
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AutomotiveScreen()));
                            }
                            if (index == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PropertyScreen()));
                            }
                            if (index == 2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const JobsScreen()));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(bannerImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  //Indicator
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: AnimatedSmoothIndicator(
                        activeIndex: currentAdIndex,
                        count: 3,
                        effect: SlideEffect(
                            dotWidth: 10,
                            dotHeight: 10,
                            spacing: 5.0,
                            paintStyle: PaintingStyle.stroke,
                            strokeWidth: 1.5,
                            dotColor: Colors.grey,
                            activeDotColor: CustomAppTheme().primaryColor),
                      ),
                    ),
                  ),

                  /*isDealsOfTheDayAvailable
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: med.height * 0.02,
                            ),

                            HomeScreenHeadingWidget(
                              headingText: 'Deals of the day',
                              viewAllCallBack: () {},
                              isSuffix: false,
                            ),

                            SizedBox(
                              height: med.height * 0.01,
                            ),

                            Row(
                              children: <Widget>[
                                Text(
                                  'Offer Ends:',
                                  style: CustomAppTheme().normalGreyText.copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffe73c17),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                      child: Text(
                                        '20h : 0m : 15s',
                                        style: CustomAppTheme().normalText.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: med.height * 0.02,
                            ),

                            //Deals of the day
                            SizedBox(
                              height: med.height * 0.35,
                              child: ListView.builder(
                                padding: EdgeInsets.only(bottom: med.height * 0.01),
                                itemCount: classifiedViewModel.classifiedDealAds!.isNotEmpty ? classifiedViewModel.classifiedDealAds!.length : 4,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: classifiedViewModel.classifiedDealAds!.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ProductDetailScreen(
                                                    productType: 'Classified',
                                                    classifiedProduct: classifiedViewModel.classifiedDealAds![index],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ProductCard(
                                              isOff: classifiedViewModel.classifiedDealAds![index].isDeal,
                                              isFeatured: classifiedViewModel.classifiedDealAds![index].isPromoted,
                                              title: classifiedViewModel.classifiedDealAds![index].name,
                                              address: classifiedViewModel.classifiedDealAds![index].streetAdress,
                                              currencyCode: classifiedViewModel.classifiedDealAds![index].currency!.code,
                                              price: classifiedViewModel.classifiedDealAds![index].price,
                                              logo: classifiedViewModel.classifiedDealAds![index].businessType == "Company"
                                                  ? classifiedViewModel.classifiedDealAds![index].company?.profilePicture
                                                  : classifiedViewModel.classifiedDealAds![index].profile?.profilePicture,
                                              imageUrl: classifiedViewModel.classifiedDealAds![index].imageMedia!.isEmpty
                                                  ? null
                                                  : classifiedViewModel.classifiedDealAds![index].imageMedia![0].image,
                                              beds: "${classifiedViewModel.classifiedDealAds![index].category?.title}",
                                              baths: "${classifiedViewModel.classifiedDealAds![index].type}",
                                            ),
                                          )
                                        : const ProductCardShimmer(),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),*/

                  SizedBox(
                    height: med.height * 0.02,
                  ),

                  HomeScreenHeadingWidget(
                    headingText: 'All Ads',
                    isSuffix: selectedAllMenuIndex == 0 ? false : true,
                    viewAllCallBack: () {
                      if (selectedAllMenuIndex == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AutomotiveScreen()));
                      } else if (selectedAllMenuIndex == 2) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PropertyScreen()));
                      } else if (selectedAllMenuIndex == 3) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const JobsScreen()));
                      }
                    },
                  ),

                  SizedBox(
                    height: med.height * 0.01,
                  ),

                  SizedBox(
                    height: med.height * 0.035,
                    child: ListView.builder(
                      itemCount: 4,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAllMenuIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  selectedAllMenuIndex == index
                                      ? BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: const Offset(2,
                                              3), // changes position of shadow
                                        )
                                      : const BoxShadow(
                                          color: Colors.transparent,
                                          blurRadius: 0,
                                          offset: Offset.zero),
                                ],
                                color: selectedAllMenuIndex == index
                                    ? CustomAppTheme().primaryColor
                                    : CustomAppTheme().backgroundColor,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  child: Text(
                                    menuOptions[index],
                                    style: CustomAppTheme().normalText.copyWith(
                                        letterSpacing: 0.5,
                                        color: selectedAllMenuIndex == index
                                            ? CustomAppTheme().backgroundColor
                                            : CustomAppTheme().blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
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

                  ///
                  //All ads
                  selectedAllMenuIndex == 0
                      ? classifiedViewModel.classifiedAllAds!.isEmpty
                          ? SizedBox(
                              height: 250, child: Center(child: noDataFound()))
                          : GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount:
                                  classifiedViewModel.classifiedAllAds!.length,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                // childAspectRatio: 2 / 3.25,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 1.29),
                                crossAxisCount: 2,
                                mainAxisSpacing: 15.0,
                                crossAxisSpacing: 5.0,
                                // maxCrossAxisExtent: 200,
                                // childAspectRatio: med.height * 0.00072,
                                // crossAxisSpacing: 5,
                                // mainAxisSpacing: 15,
                              ),
                              itemBuilder: (context, index) {
                                print(classifiedViewModel
                                    .classifiedAllAds![index]
                                    .isFavourite);
                                print("************************************");
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                          classifiedProduct: classifiedViewModel
                                              .classifiedAllAds![index],
                                          productType: 'Classified',
                                        ),
                                      ),
                                    );
                                  },
                                  child: ProductCard(
                                    onFavTap: () {
                                      if (classifiedViewModel
                                              .classifiedAllAds![index]
                                              .isFavourite ==
                                          false) {
                                        setState(() {
                                          classifiedViewModel.addFavClassified(
                                              adId: classifiedViewModel
                                                  .classifiedAllAds![index]
                                                  .id!);
                                          for (int i = 0;
                                              i <
                                                  classifiedViewModel
                                                      .classifiedAllAds!.length;
                                              i++) {
                                            if (classifiedViewModel
                                                    .classifiedAllAds![index]
                                                    .id! ==
                                                classifiedViewModel
                                                    .classifiedAllAds![i].id) {
                                              classifiedViewModel
                                                  .classifiedAllAds![index]
                                                  .isFavourite = true;
                                              classifiedViewModel
                                                  .changeClassifiedAllAds(
                                                      classifiedViewModel
                                                          .classifiedAllAds!);
                                            }
                                          }
                                          for (int i = 0;
                                              i <
                                                  classifiedViewModel
                                                      .classifiedFeaturedAds!
                                                      .length;
                                              i++) {
                                            if (classifiedViewModel
                                                    .classifiedFeaturedAds![
                                                        index]
                                                    .id! ==
                                                classifiedViewModel
                                                    .classifiedFeaturedAds![i]
                                                    .id) {
                                              classifiedViewModel
                                                  .classifiedFeaturedAds![index]
                                                  .isFavourite = true;
                                              classifiedViewModel
                                                  .changeClassifiedFeaturedAds(
                                                      classifiedViewModel
                                                          .classifiedFeaturedAds!);
                                            }
                                          }
                                          for (int i = 0;
                                              i <
                                                  profileViewModel
                                                      .myClassifiedAds.length;
                                              i++) {
                                            if (profileViewModel
                                                    .myClassifiedAds[index]
                                                    .id! ==
                                                profileViewModel
                                                    .myClassifiedAds[i].id) {
                                              profileViewModel
                                                  .myClassifiedAds[index]
                                                  .isFavourite = true;
                                              profileViewModel
                                                  .changeMyClassifiedAds(
                                                      profileViewModel
                                                          .myClassifiedAds);
                                            }
                                          }
                                        });
                                        profileViewModel.myFavClassifiedAds.add(
                                            classifiedViewModel
                                                .classifiedAllAds![index]);
                                        profileViewModel.changeMyFavClassified(
                                            profileViewModel
                                                .myFavClassifiedAds);
                                      }
                                      else {
                                        setState(() {
                                          classifiedViewModel.addFavClassified(
                                              adId: classifiedViewModel
                                                  .classifiedAllAds![index]
                                                  .id!);
                                          for (int i = 0;
                                              i <
                                                  classifiedViewModel
                                                      .classifiedAllAds!.length;
                                              i++) {
                                            if (classifiedViewModel
                                                    .classifiedAllAds![index]
                                                    .id! ==
                                                classifiedViewModel
                                                    .classifiedAllAds![i].id) {
                                              classifiedViewModel
                                                  .classifiedAllAds![index]
                                                  .isFavourite = false;
                                              classifiedViewModel
                                                  .changeClassifiedAllAds(
                                                      classifiedViewModel
                                                          .classifiedAllAds!);
                                            }
                                          }
                                          for (int i = 0;
                                              i <
                                                  classifiedViewModel
                                                      .classifiedFeaturedAds!
                                                      .length;
                                              i++) {
                                            if (classifiedViewModel
                                                    .classifiedFeaturedAds![
                                                        index]
                                                    .id! ==
                                                classifiedViewModel
                                                    .classifiedFeaturedAds![i]
                                                    .id) {
                                              classifiedViewModel
                                                  .classifiedFeaturedAds![index]
                                                  .isFavourite = false;
                                              classifiedViewModel
                                                  .changeClassifiedFeaturedAds(
                                                      classifiedViewModel
                                                          .classifiedFeaturedAds!);
                                            }
                                          }
                                          for (int i = 0;
                                              i <
                                                  profileViewModel
                                                      .myClassifiedAds.length;
                                              i++) {
                                            if (profileViewModel
                                                    .myClassifiedAds[index]
                                                    .id! ==
                                                profileViewModel
                                                    .myClassifiedAds[i].id) {
                                              profileViewModel
                                                  .myClassifiedAds[index]
                                                  .isFavourite = false;
                                              profileViewModel
                                                  .changeMyClassifiedAds(
                                                      profileViewModel
                                                          .myClassifiedAds);
                                            }
                                          }
                                        });
                                        profileViewModel.myFavClassifiedAds
                                            .removeWhere((element) =>
                                                element.id ==
                                                classifiedViewModel
                                                    .classifiedAllAds![index]
                                                    .id!);
                                        profileViewModel.changeMyFavClassified(
                                            profileViewModel
                                                .myFavClassifiedAds);
                                      }
                                    },
                                    isFav: classifiedViewModel
                                        .classifiedAllAds![index].isFavourite,
                                    isOff: classifiedViewModel
                                        .classifiedAllAds![index].isDeal,
                                    isFeatured: classifiedViewModel
                                        .classifiedAllAds![index].isPromoted,
                                    title: classifiedViewModel
                                        .classifiedAllAds![index].name,
                                    address: classifiedViewModel
                                        .classifiedAllAds![index].streetAdress,
                                    currencyCode: classifiedViewModel
                                        .classifiedAllAds![index]
                                        .currency!
                                        .code,
                                    price: classifiedViewModel
                                        .classifiedAllAds![index].price,
                                    imageUrl: classifiedViewModel
                                            .classifiedAllAds![index]
                                            .imageMedia!
                                            .isEmpty
                                        ? null
                                        : classifiedViewModel
                                            .classifiedAllAds![index]
                                            .imageMedia![0]
                                            .image,
                                    logo: classifiedViewModel
                                                .classifiedAllAds![index]
                                                .businessType ==
                                            "Company"
                                        ? classifiedViewModel
                                            .classifiedAllAds![index]
                                            .company
                                            ?.profilePicture
                                        : classifiedViewModel
                                            .classifiedAllAds![index]
                                            .profile
                                            ?.profilePicture,
                                    categories: "classified",
                                    beds:
                                        "${classifiedViewModel.classifiedAllAds![index].category?.title}",
                                    baths:
                                        "${classifiedViewModel.classifiedAllAds![index].type}",
                                  ),
                                );
                              },
                            )
                      : selectedAllMenuIndex == 1
                          ? automotiveViewModel.automotiveAllAds.isEmpty
                              ? SizedBox(
                                  height: 250,
                                  child: Center(child: noDataFound()))
                              : GridView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: automotiveViewModel
                                      .automotiveAllAds.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height /
                                            1.29),
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 15.0,
                                    crossAxisSpacing: 5.0,
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
                                              automotiveProduct:
                                                  automotiveViewModel
                                                      .automotiveAllAds[index],
                                              productType: 'Automotive',
                                            ),
                                          ),
                                        );
                                      },
                                      child: ProductCard(
                                        onFavTap: () {
                                          if (automotiveViewModel
                                                  .automotiveAllAds[index]
                                                  .isFavourite ==
                                              false) {
                                            setState(() {
                                              automotiveViewModel
                                                  .addFavAutomotive(
                                                      adId: automotiveViewModel
                                                          .automotiveAllAds[
                                                              index]
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
                                                        .automotiveAllAds[i]
                                                        .id) {
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
                                                          .myAutomotiveAds
                                                          .length;
                                                  i++) {
                                                if (automotiveViewModel
                                                        .automotiveAllAds[index]
                                                        .id! ==
                                                    profileViewModel
                                                        .myAutomotiveAds[i]
                                                        .id) {
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
                                                          .automotiveAllAds[
                                                              index]
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
                                                        .automotiveAllAds[i]
                                                        .id) {
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
                                                          .myAutomotiveAds
                                                          .length;
                                                  i++) {
                                                if (profileViewModel
                                                        .myAutomotiveAds[index]
                                                        .id! ==
                                                    profileViewModel
                                                        .myAutomotiveAds[i]
                                                        .id) {
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
                                        isFav: automotiveViewModel
                                            .automotiveAllAds[index]
                                            .isFavourite,
                                        isFeatured: automotiveViewModel
                                            .automotiveAllAds[index].isPromoted,
                                        isOff: automotiveViewModel
                                            .automotiveAllAds[index].isDeal,
                                        address: automotiveViewModel
                                            .automotiveAllAds[index]
                                            .streetAddress,
                                        price: automotiveViewModel
                                            .automotiveAllAds[index].price,
                                        currencyCode: automotiveViewModel
                                            .automotiveAllAds[index]
                                            .currency!
                                            .code,
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
                          : selectedAllMenuIndex == 2
                              ? propertiesViewModel.propertyAllAds!.isEmpty
                                  ? SizedBox(
                                      height: 250,
                                      child: Center(child: noDataFound()))
                                  : GridView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: propertiesViewModel
                                          .propertyAllAds!.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width /
                                                (MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.29),
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
                                                  propertyProduct:
                                                      propertiesViewModel
                                                              .propertyAllAds![
                                                          index],
                                                  productType: 'Property',
                                                ),
                                              ),
                                            );
                                          },
                                          child: ProductCard(
                                            onFavTap: () {
                                              if (propertiesViewModel
                                                      .propertyAllAds![index]
                                                      .isFavourite ==
                                                  false) {
                                                setState(() {
                                                  propertiesViewModel
                                                      .addFavProperty(
                                                          adId: propertiesViewModel
                                                              .propertyAllAds![
                                                                  index]
                                                              .id!);
                                                  for (int i = 0;
                                                      i <
                                                          propertiesViewModel
                                                              .propertyAllAds!
                                                              .length;
                                                      i++) {
                                                    if (propertiesViewModel
                                                            .propertyAllAds![
                                                                index]
                                                            .id! ==
                                                        propertiesViewModel
                                                            .propertyAllAds![i]
                                                            .id) {
                                                      propertiesViewModel
                                                          .propertyAllAds![
                                                              index]
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
                                                              .myPropertiesAds
                                                              .length;
                                                      i++) {
                                                    if (profileViewModel
                                                            .myPropertiesAds[
                                                                index]
                                                            .id! ==
                                                        profileViewModel
                                                            .myPropertiesAds[i]
                                                            .id) {
                                                      profileViewModel
                                                          .myPropertiesAds[
                                                              index]
                                                          .isFavourite = true;
                                                      profileViewModel
                                                          .changeMyPropertiesAds(
                                                              profileViewModel
                                                                  .myPropertiesAds);
                                                    }
                                                  }
                                                });
                                                profileViewModel
                                                    .myFavPropertyAds
                                                    .add(propertiesViewModel
                                                            .propertyAllAds![
                                                        index]);
                                                profileViewModel
                                                    .changeMyFavProperty(
                                                        profileViewModel
                                                            .myFavPropertyAds);
                                              } else {
                                                setState(() {
                                                  propertiesViewModel
                                                      .addFavProperty(
                                                          adId: propertiesViewModel
                                                              .propertyAllAds![
                                                                  index]
                                                              .id!);
                                                  for (int i = 0;
                                                      i <
                                                          propertiesViewModel
                                                              .propertyAllAds!
                                                              .length;
                                                      i++) {
                                                    if (propertiesViewModel
                                                            .propertyAllAds![
                                                                index]
                                                            .id! ==
                                                        propertiesViewModel
                                                            .propertyAllAds![i]
                                                            .id) {
                                                      propertiesViewModel
                                                          .propertyAllAds![
                                                              index]
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
                                                              .myPropertiesAds
                                                              .length;
                                                      i++) {
                                                    if (profileViewModel
                                                            .myPropertiesAds[
                                                                index]
                                                            .id! ==
                                                        profileViewModel
                                                            .myPropertiesAds[i]
                                                            .id) {
                                                      profileViewModel
                                                          .myPropertiesAds[
                                                              index]
                                                          .isFavourite = false;
                                                      profileViewModel
                                                          .changeMyPropertiesAds(
                                                              profileViewModel
                                                                  .myPropertiesAds);
                                                    }
                                                  }
                                                });
                                                profileViewModel
                                                    .myFavPropertyAds
                                                    .removeWhere((element) =>
                                                        element.id ==
                                                        propertiesViewModel
                                                            .propertyAllAds![
                                                                index]
                                                            .id);
                                                profileViewModel
                                                    .changeMyFavProperty(
                                                        profileViewModel
                                                            .myFavPropertyAds);
                                              }
                                            },
                                            isFav: propertiesViewModel
                                                .propertyAllAds![index]
                                                .isFavourite,
                                            isFeatured: propertiesViewModel
                                                .propertyAllAds![index]
                                                .isPromoted,
                                            isOff: propertiesViewModel
                                                .propertyAllAds![index].isDeal,
                                            title: propertiesViewModel
                                                .propertyAllAds![index].name,
                                            currencyCode: propertiesViewModel
                                                .propertyAllAds![index]
                                                .currency!
                                                .code,
                                            price: propertiesViewModel
                                                .propertyAllAds![index].price,
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
                                            address: propertiesViewModel
                                                .propertyAllAds![index]
                                                .streetAddress,
                                            imageUrl: propertiesViewModel
                                                    .propertyAllAds![index]
                                                    .imageMedia!
                                                    .isEmpty
                                                ? null
                                                : propertiesViewModel
                                                    .propertyAllAds![index]
                                                    .imageMedia![0]
                                                    .image,
                                            categories: 'property',
                                            beds:
                                                "${propertiesViewModel.propertyAllAds![index].bedrooms} Bedrooms",
                                            baths:
                                                "${propertiesViewModel.propertyAllAds![index].area}",
                                          ),
                                        );
                                      },
                                    )
                              : selectedAllMenuIndex == 3
                                  ? jobViewModel.jobAllAds!.isEmpty
                                      ? SizedBox(
                                          height: 250,
                                          child: Center(child: noDataFound()))
                                      : GridView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount:
                                              jobViewModel.jobAllAds!.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio:
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        1.62),
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 15.0,
                                            crossAxisSpacing: 5.0,
                                            //   SliverGridDelegateWithMaxCrossAxisExtent(
                                            // maxCrossAxisExtent:
                                            //     med.height * 0.26,
                                            // childAspectRatio:
                                            //     med.height * 0.00088,
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
                                                      isJobAd: true,
                                                      jobProduct: jobViewModel
                                                          .jobAllAds![index],
                                                      productType: 'Job',
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: JobAdsWidget(
                                                onFavTap: () {
                                                  if (jobViewModel
                                                          .jobAllAds![index]
                                                          .isFavourite ==
                                                      true) {
                                                    jobViewModel.addFavJob(
                                                        adId: jobViewModel
                                                            .jobAllAds![index]
                                                            .id!);
                                                    jobViewModel
                                                        .jobAllAds![index]
                                                        .isFavourite = false;
                                                    jobViewModel
                                                        .changeJobAllAds(
                                                            jobViewModel
                                                                .jobAllAds!);
                                                    for (int i = 0;
                                                        i <
                                                            jobViewModel
                                                                .jobFeaturedAds!
                                                                .length;
                                                        i++) {
                                                      if (jobViewModel
                                                              .jobFeaturedAds![
                                                                  i]
                                                              .id ==
                                                          jobViewModel
                                                              .jobAllAds![index]
                                                              .id) {
                                                        jobViewModel
                                                            .jobFeaturedAds![i]
                                                            .isFavourite = false;
                                                        jobViewModel
                                                            .changeJobFeaturedAds(
                                                                jobViewModel
                                                                    .jobFeaturedAds!);
                                                      }
                                                    }
                                                  } else {
                                                    jobViewModel.addFavJob(
                                                        adId: jobViewModel
                                                            .jobAllAds![index]
                                                            .id!);
                                                    jobViewModel
                                                        .jobAllAds![index]
                                                        .isFavourite = true;
                                                    jobViewModel
                                                        .changeJobAllAds(
                                                            jobViewModel
                                                                .jobAllAds!);
                                                    for (int i = 0;
                                                        i <
                                                            jobViewModel
                                                                .jobFeaturedAds!
                                                                .length;
                                                        i++) {
                                                      if (jobViewModel
                                                              .jobFeaturedAds![
                                                                  i]
                                                              .id ==
                                                          jobViewModel
                                                              .jobAllAds![index]
                                                              .id) {
                                                        jobViewModel
                                                            .jobFeaturedAds![i]
                                                            .isFavourite = true;
                                                        jobViewModel
                                                            .changeJobFeaturedAds(
                                                                jobViewModel
                                                                    .jobFeaturedAds!);
                                                      }
                                                    }
                                                  }
                                                },
                                                isFav: jobViewModel
                                                    .jobAllAds![index]
                                                    .isFavourite,
                                                isFeatured: jobViewModel
                                                    .jobAllAds![index]
                                                    .isPromoted,
                                                isOff: false,
                                                title: jobViewModel
                                                    .jobAllAds![index].title,
                                                currencyCode: jobViewModel
                                                    .jobAllAds![index]
                                                    .salaryCurrency!
                                                    .code,
                                                startingSalary: jobViewModel
                                                    .jobAllAds![index]
                                                    .salaryStart,
                                                endingSalary: jobViewModel
                                                    .jobAllAds![index]
                                                    .salaryEnd,
                                                description: jobViewModel
                                                    .jobAllAds![index]
                                                    .description,
                                                address: jobViewModel
                                                    .jobAllAds![index].location,
                                                imageUrl: jobViewModel
                                                        .jobAllAds![index]
                                                        .imageMedia!
                                                        .isEmpty
                                                    ? null
                                                    : jobViewModel
                                                        .jobAllAds![index]
                                                        .imageMedia![0]
                                                        .image,
                                                beds:
                                                    "${jobViewModel.jobAllAds![index].positionType}",
                                                baths:
                                                    "${jobViewModel.jobAllAds![index].jobType}",
                                              ),
                                            );
                                          },
                                        )
                                  : GridView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: featuredAdsLength,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width /
                                                (MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.29),
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
                                        return const ProductCardShimmer();
                                      },
                                    ),

                  ///

                  SizedBox(
                    height: med.height * 0.02,
                  ),

                  isExploringMore
                      ? Center(
                          child: CircularProgressIndicator(
                              color: CustomAppTheme().primaryColor),
                        )
                      : selectedAllMenuIndex == 0
                          ? classifiedViewModel.classifiedAllAds!.isEmpty
                              ? Container()
                              : Center(
                                  child:
                                      currentPageClassified !=
                                              classifiedViewModel
                                                  .allClassifiedTotalPages
                                          ? ExploreMoreButton(
                                              onTab: () async {
                                                currentPageClassified = currentPageClassified + 1;
                                                setState(() {});
                                                if (selectedAllMenuIndex == 0) {
                                                  classifiedViewModel
                                                          .allClassifiedPageNo =
                                                      classifiedViewModel
                                                              .allClassifiedPageNo +
                                                          1;
                                                  setState(() {
                                                    isExploringMore = true;
                                                  });
                                               final res = await getClassifiedAllAds();
                                               print(res);
                                               print("hahahhhahah ======== :::");
                                                  setState(() {
                                                    isExploringMore = false;
                                                  });
                                                }
                                              },
                                            )
                                          : const SizedBox.shrink(),
                                )
                          : selectedAllMenuIndex == 1
                              ? automotiveViewModel.automotiveAllAds.isEmpty
                                  ? Container()
                                  : Center(
                                      child: currentPageAutomotive !=
                                              automotiveViewModel
                                                  .autoAllAdsTotalPages
                                          ? ExploreMoreButton(
                                              onTab: () async {
                                                setState(() {
                                                  currentPageAutomotive = currentPageAutomotive + 1;
                                                });
                                                if (selectedAllMenuIndex == 1) {
                                                  automotiveViewModel
                                                          .autoAllAdsPageNo =
                                                      automotiveViewModel
                                                              .autoAllAdsPageNo +
                                                          1;
                                                  setState(() {
                                                    isExploringMore = true;
                                                  });
                                                  await getAutoAllAds();
                                                  setState(() {
                                                    isExploringMore = false;
                                                  });
                                                }
                                              },
                                            )
                                          : const SizedBox.shrink(),
                                    )
                              : selectedAllMenuIndex == 2
                                  ? propertiesViewModel.propertyAllAds!.isEmpty
                                      ? Container()
                                      : Center(
                                          child: currentPageProperty !=
                                                  propertiesViewModel
                                                      .allPropertiesTotalPages
                                              ? ExploreMoreButton(
                                                  onTab: () async {
                                                    currentPageProperty = currentPageProperty + 1;
                                                    setState(() {});
                                                    if (selectedAllMenuIndex ==
                                                        2) {
                                                      propertiesViewModel
                                                              .allPropertiesPageNo =
                                                          propertiesViewModel
                                                                  .allPropertiesPageNo +
                                                              1;
                                                      setState(() {
                                                        isExploringMore = true;
                                                      });
                                                      await getPropertyAllAds();
                                                      setState(() {
                                                        isExploringMore = false;
                                                      });
                                                    }
                                                  },
                                                )
                                              : const SizedBox.shrink(),
                                        )
                                  : selectedAllMenuIndex == 3
                                      ? jobViewModel.jobAllAds!.isEmpty
                                          ? Container()
                                          : Center(
                                              child:
                                              currentPageJob !=
                                                          jobViewModel
                                                              .allJobTotalPages
                                                      ? ExploreMoreButton(
                                                          onTab: () async {
                                                            currentPageJob = currentPageJob + 1;
                                                            setState(() {});
                                                            if (selectedAllMenuIndex ==
                                                                3) {
                                                              jobViewModel
                                                                      .allJobPageNo =
                                                                  jobViewModel
                                                                          .allJobPageNo +
                                                                      1;
                                                              setState(() {
                                                                isExploringMore =
                                                                    true;
                                                              });
                                                              await getJobAllAds();
                                                              setState(() {
                                                                isExploringMore =
                                                                    false;
                                                              });
                                                            }
                                                          },
                                                        )
                                                      : const SizedBox.shrink(),
                                            )
                                      : const SizedBox.shrink(),

                  isFeatureBrandsAvailable
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: med.height * 0.02,
                            ),
                            HomeScreenHeadingWidget(
                              headingText: 'Featured Brands',
                              viewAllCallBack: () {},
                              isSuffix: false,
                            ),
                            SizedBox(
                              height: med.height * 0.02,
                            ),
                            SizedBox(
                              height: med.height * 0.15,
                              child: ListView.builder(
                                itemCount: classifiedViewModel
                                        .classifiedFeaturedBrands!.isNotEmpty
                                    ? classifiedViewModel
                                        .classifiedFeaturedBrands!.length
                                    : 4,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return classifiedViewModel
                                          .classifiedFeaturedBrands!.isNotEmpty
                                      ? BrandCircularWidget(
                                          index: index,
                                          brandName: classifiedViewModel
                                              .classifiedFeaturedBrands![index]
                                              .title,
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Shimmer.fromColors(
                                            baseColor:
                                                CustomAppTheme().lightGreyColor,
                                            highlightColor: CustomAppTheme()
                                                .backgroundColor,
                                            child: Container(
                                              height: med.height * 0.06,
                                              width: med.width * 0.2,
                                              decoration: BoxDecoration(
                                                color: CustomAppTheme()
                                                    .lightGreyColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        );
                                },
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),

                  isRecommendedAdAvailable
                      ? Column(
                          children: <Widget>[
                            SizedBox(
                              height: med.height * 0.02,
                            ),

                            HomeScreenHeadingWidget(
                              headingText: 'Recommended For You',
                              isSuffix: false,
                              viewAllCallBack: () {},
                            ),

                            SizedBox(
                              height: med.height * 0.02,
                            ),

                            //Recommended Ads
                            classifiedViewModel
                                    .classifiedRecommendedAds!.isNotEmpty
                                ? SizedBox(
                                    height: med.height * 0.37,
                                    child: Center(
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(
                                            bottom: med.height * 0.01),
                                        itemCount: classifiedViewModel
                                            .classifiedRecommendedAds!.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailScreen(
                                                      classifiedProduct:
                                                          classifiedViewModel
                                                                  .classifiedRecommendedAds![
                                                              index],
                                                      productType: 'Classified',
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: ProductCard(
                                                onFavTap: () {
                                                  if (classifiedViewModel
                                                          .classifiedRecommendedAds![
                                                              index]
                                                          .isFavourite ==
                                                      false) {
                                                    setState(() {
                                                      classifiedViewModel
                                                          .addFavClassified(
                                                              adId: classifiedViewModel
                                                                  .classifiedRecommendedAds![
                                                                      index]
                                                                  .id!);
                                                      for (int i = 0;
                                                          i <
                                                              classifiedViewModel
                                                                  .classifiedAllAds!
                                                                  .length;
                                                          i++) {
                                                        if (classifiedViewModel
                                                                .classifiedAllAds![
                                                                    index]
                                                                .id! ==
                                                            classifiedViewModel
                                                                .classifiedAllAds![
                                                                    i]
                                                                .id) {
                                                          classifiedViewModel
                                                              .classifiedAllAds![
                                                                  index]
                                                              .isFavourite = true;
                                                          classifiedViewModel
                                                              .changeClassifiedAllAds(
                                                                  classifiedViewModel
                                                                      .classifiedAllAds!);
                                                        }
                                                      }

                                                      for (int i = 0;
                                                          i <
                                                              classifiedViewModel
                                                                  .classifiedRecommendedAds!
                                                                  .length;
                                                          i++) {
                                                        if (classifiedViewModel
                                                                .classifiedRecommendedAds![
                                                                    index]
                                                                .id! ==
                                                            classifiedViewModel
                                                                .classifiedRecommendedAds![
                                                                    i]
                                                                .id) {
                                                          classifiedViewModel
                                                              .classifiedRecommendedAds![
                                                                  index]
                                                              .isFavourite = true;
                                                          classifiedViewModel
                                                              .changeClassifiedRecommendedAds(
                                                                  classifiedViewModel
                                                                      .classifiedRecommendedAds!);
                                                        }
                                                      }
                                                      for (int i = 0;
                                                          i <
                                                              classifiedViewModel
                                                                  .classifiedFeaturedAds!
                                                                  .length;
                                                          i++) {
                                                        if (classifiedViewModel
                                                                .classifiedFeaturedAds![
                                                                    index]
                                                                .id! ==
                                                            classifiedViewModel
                                                                .classifiedFeaturedAds![
                                                                    i]
                                                                .id) {
                                                          classifiedViewModel
                                                              .classifiedFeaturedAds![
                                                                  index]
                                                              .isFavourite = true;
                                                          classifiedViewModel
                                                              .changeClassifiedFeaturedAds(
                                                                  classifiedViewModel
                                                                      .classifiedFeaturedAds!);
                                                        }
                                                      }
                                                      for (int i = 0;
                                                          i <
                                                              profileViewModel
                                                                  .myClassifiedAds
                                                                  .length;
                                                          i++) {
                                                        if (profileViewModel
                                                                .myClassifiedAds[
                                                                    index]
                                                                .id! ==
                                                            profileViewModel
                                                                .myClassifiedAds[
                                                                    i]
                                                                .id) {
                                                          profileViewModel
                                                              .myClassifiedAds[
                                                                  index]
                                                              .isFavourite = true;
                                                          profileViewModel
                                                              .changeMyClassifiedAds(
                                                                  profileViewModel
                                                                      .myClassifiedAds);
                                                        }
                                                      }
                                                    });
                                                    profileViewModel
                                                        .myFavClassifiedAds
                                                        .add(classifiedViewModel
                                                                .classifiedRecommendedAds![
                                                            index]);
                                                    profileViewModel
                                                        .changeMyFavClassified(
                                                            profileViewModel
                                                                .myFavClassifiedAds);
                                                  } else {
                                                    setState(() {
                                                      classifiedViewModel
                                                          .addFavClassified(
                                                              adId: classifiedViewModel
                                                                  .classifiedRecommendedAds![
                                                                      index]
                                                                  .id!);
                                                      for (int i = 0;
                                                          i <
                                                              classifiedViewModel
                                                                  .classifiedRecommendedAds!
                                                                  .length;
                                                          i++) {
                                                        if (classifiedViewModel
                                                                .classifiedRecommendedAds![
                                                                    index]
                                                                .id! ==
                                                            classifiedViewModel
                                                                .classifiedRecommendedAds![
                                                                    i]
                                                                .id) {
                                                          classifiedViewModel
                                                              .classifiedRecommendedAds![
                                                                  index]
                                                              .isFavourite = false;
                                                          classifiedViewModel
                                                              .changeClassifiedRecommendedAds(
                                                                  classifiedViewModel
                                                                      .classifiedRecommendedAds!);
                                                        }
                                                      }
                                                      for (int i = 0;
                                                          i <
                                                              classifiedViewModel
                                                                  .classifiedAllAds!
                                                                  .length;
                                                          i++) {
                                                        if (classifiedViewModel
                                                                .classifiedAllAds![
                                                                    index]
                                                                .id! ==
                                                            classifiedViewModel
                                                                .classifiedAllAds![
                                                                    i]
                                                                .id) {
                                                          classifiedViewModel
                                                              .classifiedAllAds![
                                                                  index]
                                                              .isFavourite = false;
                                                          classifiedViewModel
                                                              .changeClassifiedAllAds(
                                                                  classifiedViewModel
                                                                      .classifiedAllAds!);
                                                        }
                                                      }
                                                      for (int i = 0;
                                                          i <
                                                              classifiedViewModel
                                                                  .classifiedFeaturedAds!
                                                                  .length;
                                                          i++) {
                                                        if (classifiedViewModel
                                                                .classifiedFeaturedAds![
                                                                    index]
                                                                .id! ==
                                                            classifiedViewModel
                                                                .classifiedFeaturedAds![
                                                                    i]
                                                                .id) {
                                                          classifiedViewModel
                                                              .classifiedFeaturedAds![
                                                                  index]
                                                              .isFavourite = false;
                                                          classifiedViewModel
                                                              .changeClassifiedFeaturedAds(
                                                                  classifiedViewModel
                                                                      .classifiedFeaturedAds!);
                                                        }
                                                      }
                                                      for (int i = 0;
                                                          i <
                                                              profileViewModel
                                                                  .myClassifiedAds
                                                                  .length;
                                                          i++) {
                                                        if (profileViewModel
                                                                .myClassifiedAds[
                                                                    index]
                                                                .id! ==
                                                            profileViewModel
                                                                .myClassifiedAds[
                                                                    i]
                                                                .id) {
                                                          profileViewModel
                                                              .myClassifiedAds[
                                                                  index]
                                                              .isFavourite = false;
                                                          profileViewModel
                                                              .changeMyClassifiedAds(
                                                                  profileViewModel
                                                                      .myClassifiedAds);
                                                        }
                                                      }
                                                    });
                                                    profileViewModel
                                                        .myFavClassifiedAds
                                                        .removeWhere((element) =>
                                                            element.id ==
                                                            classifiedViewModel
                                                                .classifiedRecommendedAds![
                                                                    index]
                                                                .id!);
                                                    profileViewModel
                                                        .changeMyFavClassified(
                                                            profileViewModel
                                                                .myFavClassifiedAds);
                                                  }
                                                },
                                                isFeatured: classifiedViewModel
                                                    .classifiedRecommendedAds![
                                                        index]
                                                    .isPromoted,
                                                isFav: classifiedViewModel
                                                    .classifiedRecommendedAds![
                                                        index]
                                                    .isFavourite,
                                                address: classifiedViewModel
                                                    .classifiedRecommendedAds![
                                                        index]
                                                    .streetAdress,
                                                price: classifiedViewModel
                                                    .classifiedRecommendedAds![
                                                        index]
                                                    .price,
                                                currencyCode: classifiedViewModel
                                                    .classifiedRecommendedAds![
                                                        index]
                                                    .currency!
                                                    .code,
                                                title: classifiedViewModel
                                                    .classifiedRecommendedAds![
                                                        index]
                                                    .name,
                                                logo: classifiedViewModel
                                                            .classifiedRecommendedAds![
                                                                index]
                                                            .businessType ==
                                                        "Company"
                                                    ? classifiedViewModel
                                                        .classifiedRecommendedAds![
                                                            index]
                                                        .company
                                                        ?.profilePicture
                                                    : classifiedViewModel
                                                        .classifiedRecommendedAds![
                                                            index]
                                                        .profile
                                                        ?.profilePicture,
                                                imageUrl: classifiedViewModel
                                                        .classifiedRecommendedAds![
                                                            index]
                                                        .imageMedia!
                                                        .isEmpty
                                                    ? null
                                                    : classifiedViewModel
                                                        .classifiedRecommendedAds![
                                                            index]
                                                        .imageMedia![0]
                                                        .image,
                                                beds:
                                                    "${classifiedViewModel.classifiedRecommendedAds![index].category?.title}",
                                                baths:
                                                    "${classifiedViewModel.classifiedRecommendedAds![index].type}",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: med.height * 0.35,
                                    child: Center(
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(
                                            bottom: med.height * 0.01),
                                        itemCount: 3,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return const Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: ProductCardShimmer(),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                          ],
                        )
                      : const SizedBox.shrink(),

                  SizedBox(
                    height: med.height * 0.02,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getAllCategories() async {
    final getAllCat = GetAllClassifiedCategoryUseCase(repository: repo);
    final result = await getAllCat(NoParams());
    result.fold(
      (error) {
        String _error = ErrorMessage.fromError(error).message.toString();
        d('ON ERROR : $_error');
        showOverlay(_error);
      },
      (result) {
        d('ON SUCCESS : ${result.toString()}');
        context
            .read<ClassifiedViewModel>()
            .changeClassifiedAllCategories(result.response!);
      },
    );
  }

  List<String> bannerImages = [
    'assets/images/automotive_bnr.png',
    'assets/images/properties_bnr.png',
    'assets/images/job_bnr.png',
  ];

  List<String> menuOptions = [
    'Classified',
    'Automotive',
    'Property',
    'Jobs',
  ];
}
