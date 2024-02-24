// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'package:app/presentation/utils/widgets/explore_more_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/automotive/automotive_filters/automotive_filter_screen.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/classified/classified_filers/classified_filter_screen.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/jobs/job_filters/job_filters_screen.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/properties/property_filters/property_filter_screen.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/searchs/view_model/search_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/shimmers/product_card_shimmer.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/filter_widget.dart';
import 'package:app/presentation/utils/widgets/jobAds_widget.dart';
import 'package:app/presentation/utils/widgets/product_card.dart';
import 'package:app/presentation/utils/widgets/searched_textfield.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final bool? isFilter;
  final String? module;
  final bool? isResearch;
  final String? researchTitle;

  const SearchScreen(
      {Key? key,
      this.isFilter = false,
      this.module,
      this.isResearch = false,
      this.researchTitle})
      : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with BaseMixin {
  bool isDataAvailable = false;
  String resultsFor = '';
  bool isDataFetched = false;
  bool isSearchDataFetching = false;
  int selectedModuleAdIndex = 0;
  int totalAds = 0;
  TextEditingController searchController = TextEditingController();
  List<ClassifiedProductModel>? classifiedFilteredAds = [];
  List<AutomotiveProductModel>? automotiveFilteredAds = [];
  List<PropertyProductModel>? propertyFilteredAds = [];
  List<JobProductModel>? jobFilteredAds = [];

  int currentJobPage = 1;

  List<String> searchSuggestion = <String>[];
  getFilterData() async {

    if (widget.module == 'Classified') {
      getClassifiedFilteredAds();
    } else if (widget.module == 'Automotive') {
      getAutomotiveFilteredAds();
    } else if (widget.module == 'Property') {
      getPropertyFilteredJobs();
    } else if (widget.module == 'Job') {
      getFilteredJobs();
    }
  }

  getSearchSuggetions({required String key}) async {
    searchSuggestion.clear();
    try {
      var response = await http.get(
        Uri.parse(
            "https://services-dev.youonline.online/api/suggested_search?search=$key"),
      );
      d('Brand List : ' + response.body.toString());
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        for (int i = 0; i < jsonData["results"]["keyword"].length; i++) {
          setState(() {
            searchSuggestion.add(jsonData["results"]["keyword"][i]["name"]);
          });
        }

        print("Api Response: ${searchSuggestion.length}");
      } else {
        throw Exception();
      }
    } catch (e) {}
    setState(() {});
  }

  getSearchedData(String title) async {
    SearchViewModel searchViewModel = context.read<SearchViewModel>();
    setState(() {
      isSearchDataFetching = true;
    });
    final result = await searchViewModel.getSearchedAds(title: title);
    result.fold((l) {}, (r) {
      searchViewModel.searchedClassifiedAds = r.results!.classifiedAds!;
      searchViewModel.searchedAutomotiveAds = r.results!.automotiveAds!;
      searchViewModel.searchedPropertyAds = r.results!.propertyAds!;
      searchViewModel.searchedJobAds = r.results!.jobAds!;
      searchViewModel
          .changeSearchedClassifiedAds(searchViewModel.searchedClassifiedAds);
      searchViewModel
          .changeSearchedAutomotiveAds(searchViewModel.searchedAutomotiveAds);
      searchViewModel
          .changeSearchedPropertyAds(searchViewModel.searchedPropertyAds);
      searchViewModel.changeSearchedJobAds(searchViewModel.searchedJobAds);
      if (selectedModuleAdIndex == 0) {
        totalAds = r.results!.classifiedAds!.length;
      } else if (selectedModuleAdIndex == 1) {
        totalAds = r.results!.automotiveAds!.length;
      } else if (selectedModuleAdIndex == 2) {
        totalAds = r.results!.propertyAds!.length;
      } else {
        totalAds = r.results!.jobAds!.length;
      }
    });
    setState(() {
      isSearchDataFetching = false;
    });
  }

  getPropertyFilteredJobs() async {
    print("hhahahahahahhahahahahahah =========");
    PropertiesViewModel propertiesViewModel =
    context.read<PropertiesViewModel>();
    setState(() {
      isDataFetched = false;
    });
    var result = await propertiesViewModel.getPropertyFilteredAds();
    result.fold((l) {
      if(currentPageProperty == 1) {
        setState(() {
          isDataFetched = true;
        });
      }

    }, (r) {
      print(r.propertyProductList);
      print("====== ===== ====== ===== ===== ");
      double totalPagesInDouble = r.count! / 20;
      int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
          ? totalPagesInDouble.toInt() + 1
          : totalPagesInDouble.toInt();
      context.read<PropertiesViewModel>().allPropertiesTotalPages =
          totalPagesInInt;
      propertyFilteredAds = r.propertyProductList;
      // propertiesViewModel.propertyFilterData = PropertyFilterModel();
      // propertiesViewModel.propertyFilterMap = {};
      setState(() {
        isDataFetched = true;
        totalAds = r.propertyProductList!.length;
        d("hahahahah ${totalAds}");
      });
    });
  }

  getAutomotiveFilteredAds() async {
    AutomotiveViewModel automotiveViewModel =
    context.read<AutomotiveViewModel>();
    d('BrandId : ${automotiveViewModel.automotiveFilterData!.brandId}');
    if(currentPageAutomotive == 1) {
      setState(() {
        isDataFetched = false;
      });
    }

    var result = await automotiveViewModel.getAutomotiveFilteredAds();
    result.fold((l) {

      setState(() {
        isDataFetched = true;
      });
    }, (r) {
      double totalPagesInDouble = r.count! / 20;
      int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
          ? totalPagesInDouble.toInt() + 1
          : totalPagesInDouble.toInt();
      automotiveViewModel.autoAllAdsTotalPages = totalPagesInInt;
      automotiveFilteredAds = r.automotiveAdsList;
      // automotiveViewModel.automotiveFilterData = AutomotiveFilterModel();
      // automotiveViewModel.automotiveFilterMap = {};
      setState(() {
        isDataFetched = true;
        totalAds = r.automotiveAdsList!.length;
      });
    });
  }

  getClassifiedFilteredAds() async {
    ClassifiedViewModel classifiedViewModel =
    context.read<ClassifiedViewModel>();
    d('Category : ${classifiedViewModel.classifiedFilterData!.category}');
    d('Classified title : ${classifiedViewModel.classifiedFilterData!.title}');
    if (classifiedViewModel.classifiedFilterData!.title != null) {
      searchController.text =
          classifiedViewModel.classifiedFilterData!.title.toString();
    }
   if(currentPageClassified == 1) {
     setState(() {
       isDataFetched = false;
     });
   }
    var result = await classifiedViewModel.getClassifiedFilteredAds();
    result.fold((l) {
      setState(() {
        isDataFetched = true;
      });
    }, (r) {
      double totalPagesInDouble = r.count! / 20;
      int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
          ? totalPagesInDouble.toInt() + 1
          : totalPagesInDouble.toInt();
      classifiedViewModel.allClassifiedTotalPages = totalPagesInInt;
      classifiedFilteredAds = r.results;
      // classifiedViewModel.classifiedFilterData = ClassifiedFilterModel();
      // classifiedViewModel.classifiedFilterMap = {};
      setState(() {
        isDataFetched = true;
        totalAds = r.results!.length;
      });
    });
  }

  getFilteredJobs() async {
    JobViewModel jobViewModel = context.read<JobViewModel>();
    if(currentPageJob == 1) {
      setState(() {
        isDataFetched = false;
      });
    }

    // print(jobViewModel.jobFilterMap!);
    print("this is what i need");
    var result = await jobViewModel.getJobFilteredProducts();
    result.fold((l) {
      setState(() {
        isDataFetched = true;
      });
    }, (r) {
      setState((){
        double totalPagesInDouble = r.count! / 20;
        int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
            ? totalPagesInDouble.toInt() + 1
            : totalPagesInDouble.toInt();
        jobViewModel
            .allJobTotalPages = totalPagesInInt;
      });
      jobFilteredAds = r.jobAdsList;
      // jobViewModel.jobFilterData = JobFilterModel();
      // jobViewModel.jobFilterMap = {};
      setState(() {
        isDataFetched = true;
        totalAds = r.jobAdsList!.length;
      });
    });
  }


  // exploreMoreFilteredJobs() async {
  //
  //   JobViewModel jobViewModel = context.read<JobViewModel>();
  //
  //   // setState(() {
  //   //   isDataFetched = false;
  //   // });
  //
  //   // print(jobViewModel.jobFilterMap!);
  //   print("this is what i need");
  //   var result = await jobViewModel.getJobFilteredProducts();
  //   result.fold((l) {
  //     // setState(() {
  //     //   isDataFetched = true;
  //     // });
  //   }, (r) {
  //     setState((){
  //       double totalPagesInDouble = r.count! / 20;
  //       int totalPagesInInt = totalPagesInDouble > totalPagesInDouble.toInt()
  //           ? totalPagesInDouble.toInt() + 1
  //           : totalPagesInDouble.toInt();
  //       jobViewModel
  //           .allJobTotalPages = totalPagesInInt;
  //     });
  //     jobFilteredAds!.addAll(r.jobAdsList!);
  //     // jobViewModel.jobFilterData = JobFilterModel();
  //     // jobViewModel.jobFilterMap = {};
  //     setState(() {
  //       // isDataFetched = true;
  //       totalAds = r.jobAdsList!.length;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    if (widget.isFilter == true) {
      getFilterData();
    }
    if (widget.isResearch == true) {
      isDataAvailable = true;
      getSearchedData(widget.researchTitle!);
    }
  }

  // start pagination
  bool isExploringMore = false;
  int currentPageClassified = 1;
  int currentPageAutomotive = 1;
  int currentPageProperty = 1;
  int currentPageJob = 1;

  @override
  Widget build(BuildContext context) {

    Size med = MediaQuery.of(context).size;
    SearchViewModel searchViewModel = context.watch<SearchViewModel>();
    final ClassifiedViewModel classifiedViewModel =
        context.watch<ClassifiedViewModel>();
    final AutomotiveViewModel automotiveViewModel =
        context.watch<AutomotiveViewModel>();
    final PropertiesViewModel propertiesViewModel =
        context.watch<PropertiesViewModel>();
    final JobViewModel jobViewModel = context.watch<JobViewModel>();

    // jobViewModel.jobFilterMap!.addEntries({MapEntry('page', currentJobPage.toString())});
    // jobViewModel.changeJobFilterMap(jobViewModel.jobFilterMap!);

    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(
        onTap: () {
          Navigator.of(context).pop();
        },
          title: widget.isFilter == true ? 'Filtered' : 'Search',
          context: context),
      body: GestureDetector(
        onTap: () {
          print(jobViewModel.jobFilterMap);
          // print(jobViewModel.jobFilterData!.createdAt);
          print(jobViewModel.jobFilterData!.jobType);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: widget.isFilter == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width:
                                //  widget.isFilter == true
                                //     ? med.width * 0.8
                                //     :
                                med.width * 0.8,
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
                              child: RoundedTextField(
                                controller: searchController,
                                onFieldSubmitted: (value) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchScreen(
                                                isResearch: true,
                                                researchTitle: value,
                                              )));
                                },
                              ),
                            ),
                          ),
                          const Spacer(),
                          // widget.isFilter == true
                          //     ? Container()
                          //     :
                          FilterWidget(
                            onTab: () {
                              if (widget.module == 'Classified') {
                                classifiedViewModel.classifiedFilterData = ClassifiedFilterModel();
                                classifiedViewModel.classifiedFilterMap = {};
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ClassifiedFilterScreen()));
                              } else if (widget.module == 'Automotive') {
                                automotiveViewModel.automotiveFilterData = AutomotiveFilterModel();
                                automotiveViewModel.automotiveFilterMap = {};
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AutomotiveFiltersScreen()));
                              } else if (widget.module == 'Property') {
                                propertiesViewModel.propertyFilterData = PropertyFilterModel();
                                propertiesViewModel.propertyFilterMap = {};
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PropertyFiltersScreen()));
                              } else {
                                jobViewModel.jobFilterData = JobFilterModel();
                                jobViewModel.jobFilterMap = {};
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const JobFiltersScreen()));
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: med.height * 0.03,
                      ),
                      isDataFetched == false
                          ? Column(
                              children: <Widget>[
                                SizedBox(
                                  height: med.height * 0.02,
                                ),
                                GridView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: 6,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: med.height * 0.00072,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 15,
                                  ),
                                  itemBuilder: (context, index) {
                                    return const ProductCardShimmer();
                                  },
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Results for ${widget.module == 'Classified' ? 'classified' : widget.module == 'Automotive' ? 'automotive' : widget.module == 'Property' ? 'property' : widget.module == 'Job' ? 'job' : ''}',
                                  style: CustomAppTheme().normalText.copyWith(
                                      fontSize: 17, fontWeight: FontWeight.w700),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Showing $totalAds products',
                                    style: CustomAppTheme()
                                        .normalGreyText
                                        .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(height: med.height * 0.02),
                                widget.module == 'Classified'
                                    ? GridView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: classifiedFilteredAds!.length,
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
                                                    classifiedProduct:
                                                        classifiedFilteredAds![
                                                            index],
                                                    productType: 'Classified',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ProductCard(
                                              isFeatured:
                                                  classifiedFilteredAds![index]
                                                      .isPromoted,
                                              isOff: classifiedFilteredAds![index]
                                                  .isDeal,
                                              address:
                                                  classifiedFilteredAds![index]
                                                      .streetAdress,
                                              title: classifiedFilteredAds![index]
                                                  .name,
                                              isFav: classifiedFilteredAds![index]
                                                  .isFavourite,
                                              logo: classifiedFilteredAds![index]
                                                          .businessType ==
                                                      "Company"
                                                  ? classifiedFilteredAds![index]
                                                      .company
                                                      ?.profilePicture
                                                  : classifiedFilteredAds![index]
                                                      .profile
                                                      ?.profilePicture,
                                              beds:
                                                  "${classifiedFilteredAds![index].category?.title}",
                                              baths:
                                                  "${classifiedFilteredAds![index].type}",
                                              imageUrl: classifiedFilteredAds![
                                                          index]
                                                      .imageMedia!
                                                      .isEmpty
                                                  ? null
                                                  : classifiedFilteredAds![index]
                                                      .imageMedia![0]
                                                      .image,
                                              currencyCode:
                                                  classifiedFilteredAds![index]
                                                      .currency!
                                                      .code,
                                              price: classifiedFilteredAds![index]
                                                  .price,
                                              onFavTap: () {
                                                if (classifiedFilteredAds![index]
                                                        .isFavourite ==
                                                    false) {
                                                  setState(() {
                                                    d(':::::::::::: before ::::::::::::: ${classifiedFilteredAds![index].isFavourite}');
                                                    classifiedFilteredAds![index]
                                                        .isFavourite = true;
                                                    classifiedViewModel
                                                        .addFavClassified(
                                                            adId:
                                                                classifiedFilteredAds![
                                                                        index]
                                                                    .id!);
                                                    d(':::::::::::: after ::::::::::::: ${classifiedFilteredAds![index].isFavourite}');
                                                  });
                                                } else {
                                                  setState(() {
                                                    classifiedFilteredAds![index]
                                                        .isFavourite = false;
                                                    classifiedViewModel
                                                        .addFavClassified(
                                                            adId:
                                                                classifiedFilteredAds![
                                                                        index]
                                                                    .id!);
                                                  });
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      )
                                    : widget.module == 'Automotive'
                                        ? GridView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount:
                                                automotiveFilteredAds!.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 200,
                                              childAspectRatio:
                                                  med.height * 0.00072,
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
                                                            automotiveFilteredAds![
                                                                index],
                                                        productType: 'Automotive',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: ProductCard(
                                                  isFeatured:
                                                      automotiveFilteredAds![
                                                              index]
                                                          .isPromoted,
                                                  isOff: automotiveFilteredAds![
                                                          index]
                                                      .isDeal,
                                                  address: automotiveFilteredAds![
                                                          index]
                                                      .streetAddress,
                                                  isFav: automotiveFilteredAds![
                                                          index]
                                                      .isFavourite,
                                                  logo: automotiveFilteredAds![
                                                                  index]
                                                              .businessType ==
                                                          "Company"
                                                      ? automotiveFilteredAds![
                                                              index]
                                                          .company
                                                          ?.profilePicture
                                                      : automotiveFilteredAds![
                                                              index]
                                                          .profile
                                                          ?.profilePicture,
                                                  beds:
                                                      "${automotiveFilteredAds![index].category?.title}",
                                                  baths:
                                                      "${automotiveFilteredAds![index].carType}",
                                                  imageUrl: automotiveFilteredAds![
                                                              index]
                                                          .imageMedia!
                                                          .isEmpty
                                                      ? null
                                                      : automotiveFilteredAds![
                                                              index]
                                                          .imageMedia![0]
                                                          .image,
                                                  currencyCode:
                                                      automotiveFilteredAds![
                                                              index]
                                                          .currency!
                                                          .code,
                                                  title: automotiveFilteredAds![
                                                          index]
                                                      .name,
                                                  price: automotiveFilteredAds![
                                                          index]
                                                      .price,
                                                  onFavTap: () {
                                                    if (automotiveFilteredAds![
                                                                index]
                                                            .isFavourite ==
                                                        false) {
                                                      setState(() {
                                                        automotiveViewModel
                                                            .addFavAutomotive(
                                                                adId:
                                                                    automotiveFilteredAds![
                                                                            index]
                                                                        .id!);
                                                        automotiveFilteredAds![
                                                                index]
                                                            .isFavourite = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        classifiedViewModel
                                                            .addFavClassified(
                                                                adId:
                                                                    automotiveFilteredAds![
                                                                            index]
                                                                        .id!);
                                                        automotiveFilteredAds![
                                                                index]
                                                            .isFavourite = false;
                                                      });
                                                    }
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        : widget.module == 'Property'
                                            ? GridView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount:
                                                    propertyFilteredAds!.length,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 200,
                                                  childAspectRatio: Platform.isIOS
                                                      ? med.height * 0.00071
                                                      : med.height * 0.00075,
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
                                                                propertyFilteredAds![
                                                                    index],
                                                            productType:
                                                                'Property',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: ProductCard(
                                                      isFeatured:
                                                          propertyFilteredAds![
                                                                  index]
                                                              .isPromoted,
                                                      isOff: propertyFilteredAds![
                                                              index]
                                                          .isDeal,
                                                      address:
                                                          propertyFilteredAds![
                                                                  index]
                                                              .streetAddress,
                                                      isFav: propertyFilteredAds![
                                                              index]
                                                          .isFavourite,
                                                      logo: propertyFilteredAds![
                                                                      index]
                                                                  .businessType ==
                                                              "Company"
                                                          ? propertyFilteredAds![
                                                                  index]
                                                              .company
                                                              ?.profilePicture
                                                          : propertyFilteredAds![
                                                                  index]
                                                              .profile
                                                              ?.profilePicture,
                                                      categories: 'property',
                                                      beds:
                                                          "${propertyFilteredAds![index].bedrooms} Bedrooms",
                                                      baths:
                                                          "${propertyFilteredAds![index].baths} Baths",
                                                      imageUrl: propertyFilteredAds![
                                                                  index]
                                                              .imageMedia!
                                                              .isEmpty
                                                          ? null
                                                          : propertyFilteredAds![
                                                                  index]
                                                              .imageMedia![0]
                                                              .image,
                                                      currencyCode:
                                                          propertyFilteredAds![
                                                                  index]
                                                              .currency!
                                                              .code,
                                                      title: propertyFilteredAds![
                                                              index]
                                                          .name,
                                                      price: propertyFilteredAds![
                                                              index]
                                                          .price,
                                                      onFavTap: () {
                                                        if (propertyFilteredAds![
                                                                    index]
                                                                .isFavourite ==
                                                            false) {
                                                          setState(() {
                                                            propertiesViewModel
                                                                .addFavProperty(
                                                                    adId: propertyFilteredAds![
                                                                            index]
                                                                        .id!);
                                                            propertyFilteredAds![
                                                                        index]
                                                                    .isFavourite =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            classifiedViewModel
                                                                .addFavClassified(
                                                                    adId: propertyFilteredAds![
                                                                            index]
                                                                        .id!);
                                                            propertyFilteredAds![
                                                                        index]
                                                                    .isFavourite =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  );
                                                },
                                              )
                                            : widget.module == 'Job'
                                                ? GridView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        jobFilteredAds!.length,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    gridDelegate:
                                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent:
                                                          med.height * 0.26,
                                                      childAspectRatio: 1 / 1.32,
                                                      crossAxisSpacing: 5,
                                                      mainAxisSpacing: 15,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProductDetailScreen(
                                                                jobProduct:
                                                                    jobFilteredAds![
                                                                        index],
                                                                productType:
                                                                    'Job',
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: JobAdsWidget(
                                                          onFavTap: () {
                                                            if (jobFilteredAds![
                                                                        index]
                                                                    .isFavourite ==
                                                                false) {
                                                              setState(() {
                                                                propertiesViewModel
                                                                    .addFavProperty(
                                                                        adId: jobFilteredAds![
                                                                                index]
                                                                            .id!);
                                                                jobFilteredAds![
                                                                            index]
                                                                        .isFavourite =
                                                                    true;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                jobViewModel.addFavJob(
                                                                    adId: jobFilteredAds![
                                                                            index]
                                                                        .id!);
                                                                jobFilteredAds![
                                                                            index]
                                                                        .isFavourite =
                                                                    false;
                                                              });
                                                            }
                                                          },
                                                          isFav: jobFilteredAds![
                                                                  index]
                                                              .isFavourite,
                                                          isFeatured:
                                                              jobFilteredAds![
                                                                      index]
                                                                  .isPromoted,
                                                          isOff: false,
                                                          title: jobFilteredAds![
                                                                  index]
                                                              .title,
                                                          currencyCode:
                                                              jobFilteredAds![
                                                                      index]
                                                                  .salaryCurrency!
                                                                  .code,
                                                          startingSalary:
                                                              jobFilteredAds![
                                                                      index]
                                                                  .salaryStart,
                                                          endingSalary:
                                                              jobFilteredAds![
                                                                      index]
                                                                  .salaryEnd,
                                                          description:
                                                              jobFilteredAds![
                                                                      index]
                                                                  .description,
                                                          beds:
                                                              "${jobFilteredAds![index].positionType}",
                                                          baths:
                                                              "${jobFilteredAds![index].jobType}",
                                                          address:
                                                              jobFilteredAds![
                                                                      index]
                                                                  .location,
                                                          imageUrl: jobFilteredAds![
                                                                      index]
                                                                  .imageMedia!
                                                                  .isEmpty
                                                              ? null
                                                              : jobFilteredAds![
                                                                      index]
                                                                  .imageMedia![0]
                                                                  .image,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : const SizedBox.shrink(),

                                /// Exploring Button For Filter Here
                                isExploringMore
                                    ? Center(
                                  child: CircularProgressIndicator(
                                      color: CustomAppTheme().primaryColor),
                                )
                                    : widget.module == 'Classified'
                                    ? classifiedViewModel.classifiedAllAds!.isEmpty
                                    ? Container()
                                    : Center(
                                  child:
                                  currentPageClassified !=
                                      classifiedViewModel
                                          .allClassifiedTotalPages
                                      ? ExploreMoreButton(
                                    onTab: () async {
                                      classifiedViewModel.classifiedFilterData!.page = currentPageClassified +1;
                                      currentPageClassified = currentPageClassified + 1;
                                      setState(() {});
                                      if (widget.module == 'Classified') {
                                        classifiedViewModel
                                            .allClassifiedPageNo =
                                            classifiedViewModel
                                                .allClassifiedPageNo +
                                                1;
                                        setState(() {
                                          isExploringMore = true;
                                        });
                                        // final res = await getClassifiedAllAds();
                                        final res = await getClassifiedFilteredAds();
                                        print(res);
                                        print("hahahhhahah ======== ::: ");
                                        setState(() {
                                          isExploringMore = false;
                                        });
                                      }
                                    },
                                  )
                                      : const SizedBox.shrink(),
                                )
                                    : widget.module == 'Automotive'
                                    ? automotiveViewModel.automotiveAllAds.isEmpty
                                    ? Container()
                                    : Center(
                                  child: currentPageAutomotive !=
                                      automotiveViewModel
                                          .autoAllAdsTotalPages
                                      ? ExploreMoreButton(
                                    onTab: () async {
                                      setState(() {
                                        automotiveViewModel
                                            .automotiveFilterData!.page = currentPageAutomotive + 1;
                                        currentPageAutomotive = currentPageAutomotive + 1;
                                      });
                                      if (widget.module == 'Automotive') {
                                        automotiveViewModel
                                            .autoAllAdsPageNo =
                                            automotiveViewModel
                                                .autoAllAdsPageNo +
                                                1;
                                        setState(() {
                                          isExploringMore = true;
                                        });
                                        await getAutomotiveFilteredAds();
                                        setState(() {
                                          isExploringMore = false;
                                        });
                                      }
                                    },
                                  )
                                      : const SizedBox.shrink(),
                                )
                                    : widget.module == 'Property'
                                    ? propertiesViewModel.propertyAllAds!.isEmpty
                                    ? Container()
                                    : Center(
                                  child: currentPageProperty !=
                                      propertiesViewModel
                                          .allPropertiesTotalPages
                                      ? ExploreMoreButton(
                                    onTab: () async {
                                      propertiesViewModel
                                          .propertyFilterData!.page = currentPageProperty + 1;
                                      currentPageProperty = currentPageProperty + 1;
                                      setState(() {});
                                      if (widget.module == 'Property') {
                                        propertiesViewModel
                                            .allPropertiesPageNo =
                                            propertiesViewModel
                                                .allPropertiesPageNo +
                                                1;
                                        setState(() {
                                          isExploringMore = true;
                                        });
                                        await getPropertyFilteredJobs();
                                        setState(() {
                                          isExploringMore = false;
                                        });
                                      }
                                    },
                                  )
                                      : const SizedBox.shrink(),
                                )
                                    : widget.module == 'Job'
                                    ? jobFilteredAds!.isEmpty
                                    ? Container()
                                    : Center(
                                  child:
                                  currentPageJob !=
                                      jobViewModel
                                          .allJobTotalPages
                                      ? ExploreMoreButton(
                                    onTab: () async {
                                      // currentPageJob = currentPageJob + 1;
                                      jobViewModel.jobFilterData!.page = currentPageJob + 1;
                                      currentPageJob = currentPageJob + 1;
                                      print(jobViewModel.jobFilterData!.page);
                                      print(jobViewModel.jobFilterData!.jobType);
                                      print("================================ :: ");
                                      print("================================");
                                      print("================================");
                                      setState(() {});
                                      if (widget.module == 'Job') {
                                        jobViewModel
                                            .allJobPageNo =
                                            jobViewModel
                                                .allJobPageNo +
                                                1;
                                        setState(() {
                                          isExploringMore =
                                          true;
                                        });
                                        await getFilteredJobs();
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
                              ],
                            ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      isDataAvailable
                          ? Row(
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
                                    child: RoundedTextField(
                                      controller: searchController,
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          resultsFor = value;
                                          isDataAvailable = true;
                                          List<String> tempList = iPrefHelper
                                              .retrieveResentSearches()!;
                                          tempList.removeWhere(
                                              (element) => element == value);
                                          tempList.insert(0, value);
                                          iPrefHelper
                                              .saveResentSearches(tempList);
                                          getSearchedData(value);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                FilterWidget(
                                  onTab: () {
                                    if (selectedModuleAdIndex == 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClassifiedFilterScreen(
                                                      title: resultsFor)));
                                    } else if (selectedModuleAdIndex == 1) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AutomotiveFiltersScreen()));
                                    } else if (selectedModuleAdIndex == 2) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PropertyFiltersScreen()));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const JobFiltersScreen()));
                                    }
                                  },
                                ),
                              ],
                            )
                          : RoundedTextField(
                              controller: searchController,
                              onChanged: (value) {
                                d('VALUE ##### $value');
                                getSearchSuggetions(key: value);
                                if (searchController.text.isEmpty) {
                                  searchSuggestion.clear();
                                }
                                setState(() {});
                                // Autocomplete(
                                //   optionsBuilder:
                                //       (TextEditingValue textEditingValue) {
                                //     if (textEditingValue.text == '') {
                                //       return const Iterable<String>.empty();
                                //     }
                                //     return ['Apple', 'Banana', 'Mango', 'Orange']
                                //         .where((String option) {
                                //       return option.toLowerCase().contains(
                                //           textEditingValue.text.toLowerCase());
                                //     });
                                //   },
                                //   onSelected: (String selection) {
                                //     debugPrint('You just selected $selection');
                                //   },
                                // );
                              },
                              onFieldSubmitted: (value) {
                                setState(() {
                                  resultsFor = value;
                                  isDataAvailable = true;
                                  List<String> tempList =
                                      iPrefHelper.retrieveResentSearches()!;
                                  tempList
                                      .removeWhere((element) => element == value);
                                  tempList.insert(0, value);
                                  iPrefHelper.saveResentSearches(tempList);
                                  getSearchedData(value);
                                  searchController.text = value;
                                });
                              },
                            ),
                      SizedBox(
                        height: med.height * 0.03,
                      ),
                      searchSuggestion.isEmpty
                          ? Container()
                          : SizedBox(
                              height: 245,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: ListView.builder(
                                  itemCount: searchSuggestion.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            resultsFor = searchSuggestion[index];
                                            isDataAvailable = true;
                                            List<String> tempList = iPrefHelper
                                                .retrieveResentSearches()!;
                                            tempList.removeWhere((element) =>
                                                element ==
                                                searchSuggestion[index]);
                                            tempList.insert(
                                                0, searchSuggestion[index]);
                                            iPrefHelper
                                                .saveResentSearches(tempList);
                                            getSearchedData(
                                                searchSuggestion[index]);
                                            searchController.text =
                                                searchSuggestion[index];
                                            searchSuggestion.clear();
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: Get.width / 1.3,
                                              child: Text(
                                                searchSuggestion[index],
                                                overflow: TextOverflow.ellipsis,
                                                style: CustomAppTheme()
                                                    .normalText
                                                    .copyWith(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                            ),
                                            const Spacer(),
                                            SvgPicture.asset(
                                              'assets/svgs/arrowIcon.svg',
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                      isDataAvailable == false
                          ? Column(
                              children: <Widget>[
                                iPrefHelper.retrieveResentSearches()!.isNotEmpty
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Resent Searches',
                                            style: CustomAppTheme()
                                                .normalText
                                                .copyWith(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                iPrefHelper.saveResentSearches(
                                                    <String>[]);
                                              });
                                            },
                                            child: Text(
                                              'Clear All',
                                              style: CustomAppTheme()
                                                  .normalGreyText
                                                  .copyWith(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                iPrefHelper.retrieveResentSearches()!.isNotEmpty
                                    ? SizedBox(
                                        height: med.height * 0.02,
                                      )
                                    : const SizedBox.shrink(),
                                ListView.builder(
                                  itemCount: iPrefHelper
                                      .retrieveResentSearches()!
                                      .length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            resultsFor = iPrefHelper
                                                .retrieveResentSearches()![index];
                                            isDataAvailable = true;
                                            List<String> tempList = iPrefHelper
                                                .retrieveResentSearches()!;
                                            tempList.removeAt(index);
                                            tempList.insert(
                                                0,
                                                iPrefHelper
                                                        .retrieveResentSearches()![
                                                    index]);
                                            iPrefHelper
                                                .saveResentSearches(tempList);
                                            getSearchedData(iPrefHelper
                                                    .retrieveResentSearches()![
                                                index]);
                                          });
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.history_outlined,
                                                color: CustomAppTheme().greyColor,
                                                size: 15),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 15),
                                              child: SizedBox(
                                                width: Get.width / 1.3,
                                                child: Text(
                                                  iPrefHelper
                                                          .retrieveResentSearches()![
                                                      index],
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: CustomAppTheme()
                                                      .normalGreyText
                                                      .copyWith(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            SvgPicture.asset(
                                              'assets/svgs/arrowIcon.svg',
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                iPrefHelper.retrieveResentSearches()!.isNotEmpty
                                    ? SizedBox(
                                        height: med.height * 0.05,
                                      )
                                    : const SizedBox.shrink(),
                                /*Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Popular Searches',
                                      style: CustomAppTheme().normalText.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'View All',
                                      style: CustomAppTheme().normalGreyText.copyWith(fontSize: 11, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: med.height * 0.04,
                                ),
                                GridView.builder(
                                  itemCount: 6,
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 100,
                                    childAspectRatio: 0.8,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: const CategoryCard(
                                        imagePath: 'assets/svgs/classifiedIcon.svg',
                                        title: 'Electronic',
                                        titleFontSize: 10,
                                      ),
                                    );
                                  },
                                ),*/
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Results for $resultsFor',
                                  style: CustomAppTheme().normalText.copyWith(
                                      fontSize: 17, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: med.height * 0.02,
                                ),
                                SizedBox(
                                  height: med.height * 0.035,
                                  child: ListView.builder(
                                    itemCount: moduleList.length,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedModuleAdIndex = index;
                                              totalAds = selectedModuleAdIndex ==
                                                      0
                                                  ? searchViewModel
                                                      .searchedClassifiedAds
                                                      .length
                                                  : selectedModuleAdIndex == 1
                                                      ? searchViewModel
                                                          .searchedAutomotiveAds
                                                          .length
                                                      : selectedModuleAdIndex == 2
                                                          ? searchViewModel
                                                              .searchedPropertyAds
                                                              .length
                                                          : searchViewModel
                                                              .searchedJobAds
                                                              .length;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: selectedModuleAdIndex ==
                                                        index
                                                    ? CustomAppTheme()
                                                        .primaryColor
                                                    : CustomAppTheme().greyColor,
                                              ),
                                              color:
                                                  selectedModuleAdIndex == index
                                                      ? CustomAppTheme()
                                                          .lightGreenColor
                                                      : CustomAppTheme()
                                                          .lightGreyColor,
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 6),
                                                child: Text(
                                                  moduleList[index],
                                                  style: CustomAppTheme()
                                                      .normalText
                                                      .copyWith(
                                                        letterSpacing: 0.5,
                                                        color:
                                                            selectedModuleAdIndex ==
                                                                    index
                                                                ? CustomAppTheme()
                                                                    .primaryColor
                                                                : CustomAppTheme()
                                                                    .darkGreyColor,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                SizedBox(height: med.height * 0.02),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Showing $totalAds products',
                                    style: CustomAppTheme()
                                        .normalGreyText
                                        .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  height: med.height * 0.02,
                                ),
                                isSearchDataFetching
                                    ? GridView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: 6,
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
                                          return const ProductCardShimmer();
                                        },
                                      )
                                    : Container(
                                        child: selectedModuleAdIndex == 0
                                            ? GridView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount: searchViewModel
                                                    .searchedClassifiedAds.length,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 200,
                                                  childAspectRatio:
                                                      med.height * 0.00072,
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
                                                                    productType:
                                                                        'Classified',
                                                                    classifiedProduct:
                                                                        searchViewModel
                                                                                .searchedClassifiedAds[
                                                                            index],
                                                                  )));
                                                    },
                                                    child: ProductCard(
                                                      isFeatured: searchViewModel
                                                          .searchedClassifiedAds[
                                                              index]
                                                          .isPromoted,
                                                      isFav: searchViewModel
                                                          .searchedClassifiedAds[
                                                              index]
                                                          .isFavourite,
                                                      isOff: searchViewModel
                                                          .searchedClassifiedAds[
                                                              index]
                                                          .isDeal,
                                                      price: searchViewModel
                                                          .searchedClassifiedAds[
                                                              index]
                                                          .price,
                                                      title: searchViewModel
                                                          .searchedClassifiedAds[
                                                              index]
                                                          .name,
                                                      address: searchViewModel
                                                          .searchedClassifiedAds[
                                                              index]
                                                          .streetAdress,
                                                      currencyCode: searchViewModel
                                                          .searchedClassifiedAds[
                                                              index]
                                                          .currency!
                                                          .code,
                                                      logo: searchViewModel
                                                                  .searchedClassifiedAds[
                                                                      index]
                                                                  .businessType ==
                                                              "Company"
                                                          ? searchViewModel
                                                              .searchedClassifiedAds[
                                                                  index]
                                                              .company
                                                              ?.profilePicture
                                                          : searchViewModel
                                                              .searchedClassifiedAds[
                                                                  index]
                                                              .profile
                                                              ?.profilePicture,
                                                      imageUrl: searchViewModel
                                                              .searchedClassifiedAds[
                                                                  index]
                                                              .imageMedia!
                                                              .isEmpty
                                                          ? ''
                                                          : searchViewModel
                                                              .searchedClassifiedAds[
                                                                  index]
                                                              .imageMedia![0]
                                                              .image,
                                                      onFavTap: () {
                                                        if (searchViewModel
                                                                .searchedClassifiedAds[
                                                                    index]
                                                                .isFavourite ==
                                                            false) {
                                                          setState(() {
                                                            classifiedViewModel
                                                                .addFavClassified(
                                                                    adId: searchViewModel
                                                                        .searchedClassifiedAds[
                                                                            index]
                                                                        .id!);
                                                            searchViewModel
                                                                .searchedClassifiedAds[
                                                                    index]
                                                                .isFavourite = true;
                                                            searchViewModel
                                                                .changeSearchedClassifiedAds(
                                                                    searchViewModel
                                                                        .searchedClassifiedAds);

                                                            for (int i = 0;
                                                                i <
                                                                    classifiedViewModel
                                                                        .classifiedAllAds!
                                                                        .length;
                                                                i++) {
                                                              if (searchViewModel
                                                                      .searchedClassifiedAds[
                                                                          index]
                                                                      .id ==
                                                                  classifiedViewModel
                                                                      .classifiedAllAds![
                                                                          i]
                                                                      .id) {
                                                                classifiedViewModel
                                                                    .classifiedAllAds![
                                                                        i]
                                                                    .isFavourite = true;
                                                                classifiedViewModel
                                                                    .changeClassifiedAllAds(
                                                                        classifiedViewModel
                                                                            .classifiedAllAds!);
                                                              }
                                                            }
                                                          });
                                                        } else {
                                                          setState(() {
                                                            classifiedViewModel
                                                                .addFavClassified(
                                                                    adId: searchViewModel
                                                                        .searchedClassifiedAds[
                                                                            index]
                                                                        .id!);
                                                            searchViewModel
                                                                .searchedClassifiedAds[
                                                                    index]
                                                                .isFavourite = false;
                                                            searchViewModel
                                                                .changeSearchedClassifiedAds(
                                                                    searchViewModel
                                                                        .searchedClassifiedAds);
                                                          });
                                                          for (int i = 0;
                                                              i <
                                                                  classifiedViewModel
                                                                      .classifiedAllAds!
                                                                      .length;
                                                              i++) {
                                                            if (searchViewModel
                                                                    .searchedClassifiedAds[
                                                                        index]
                                                                    .id ==
                                                                classifiedViewModel
                                                                    .classifiedAllAds![
                                                                        i]
                                                                    .id) {
                                                              classifiedViewModel
                                                                  .classifiedAllAds![
                                                                      i]
                                                                  .isFavourite = false;
                                                              classifiedViewModel
                                                                  .changeClassifiedAllAds(
                                                                      classifiedViewModel
                                                                          .classifiedAllAds!);
                                                            }
                                                          }
                                                        }
                                                      },
                                                      beds:
                                                          "${searchViewModel.searchedClassifiedAds[index].category?.title}",
                                                      baths:
                                                          "${searchViewModel.searchedClassifiedAds[index].type}",
                                                    ),
                                                  );
                                                },
                                              )
                                            : selectedModuleAdIndex == 1
                                                ? GridView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    itemCount: searchViewModel
                                                        .searchedAutomotiveAds
                                                        .length,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    gridDelegate:
                                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 200,
                                                      childAspectRatio:
                                                          med.height * 0.00072,
                                                      crossAxisSpacing: 5,
                                                      mainAxisSpacing: 15,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
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
                                                                                searchViewModel.searchedAutomotiveAds[index],
                                                                          )));
                                                        },
                                                        child: ProductCard(
                                                          isFeatured: searchViewModel
                                                              .searchedAutomotiveAds[
                                                                  index]
                                                              .isPromoted,
                                                          isFav: searchViewModel
                                                              .searchedAutomotiveAds[
                                                                  index]
                                                              .isFavourite,
                                                          isOff: searchViewModel
                                                              .searchedAutomotiveAds[
                                                                  index]
                                                              .isDeal,
                                                          price: searchViewModel
                                                              .searchedAutomotiveAds[
                                                                  index]
                                                              .price,
                                                          title: searchViewModel
                                                              .searchedAutomotiveAds[
                                                                  index]
                                                              .name,
                                                          logo: searchViewModel
                                                                      .searchedAutomotiveAds[
                                                                          index]
                                                                      .businessType ==
                                                                  "Company"
                                                              ? searchViewModel
                                                                  .searchedAutomotiveAds[
                                                                      index]
                                                                  .company
                                                                  ?.profilePicture
                                                              : searchViewModel
                                                                  .searchedAutomotiveAds[
                                                                      index]
                                                                  .profile
                                                                  ?.profilePicture,
                                                          address: searchViewModel
                                                              .searchedAutomotiveAds[
                                                                  index]
                                                              .streetAddress,
                                                          currencyCode:
                                                              searchViewModel
                                                                  .searchedAutomotiveAds[
                                                                      index]
                                                                  .currency!
                                                                  .code,
                                                          imageUrl: searchViewModel
                                                                  .searchedAutomotiveAds[
                                                                      index]
                                                                  .imageMedia!
                                                                  .isEmpty
                                                              ? ''
                                                              : searchViewModel
                                                                  .searchedAutomotiveAds[
                                                                      index]
                                                                  .imageMedia![0]
                                                                  .image,
                                                          onFavTap: () {
                                                            if (searchViewModel
                                                                    .searchedAutomotiveAds[
                                                                        index]
                                                                    .isFavourite ==
                                                                false) {
                                                              setState(() {
                                                                automotiveViewModel
                                                                    .addFavAutomotive(
                                                                        adId: searchViewModel
                                                                            .searchedAutomotiveAds[
                                                                                index]
                                                                            .id!);
                                                                searchViewModel
                                                                    .searchedAutomotiveAds[
                                                                        index]
                                                                    .isFavourite = true;
                                                                searchViewModel
                                                                    .changeSearchedAutomotiveAds(
                                                                        searchViewModel
                                                                            .searchedAutomotiveAds);

                                                                for (int i = 0;
                                                                    i <
                                                                        automotiveViewModel
                                                                            .automotiveAllAds
                                                                            .length;
                                                                    i++) {
                                                                  if (searchViewModel
                                                                          .searchedAutomotiveAds[
                                                                              index]
                                                                          .id ==
                                                                      automotiveViewModel
                                                                          .automotiveAllAds[
                                                                              i]
                                                                          .id) {
                                                                    automotiveViewModel
                                                                        .automotiveAllAds[
                                                                            i]
                                                                        .isFavourite = true;
                                                                    automotiveViewModel
                                                                        .changeAutomotiveAllAds(
                                                                            automotiveViewModel
                                                                                .automotiveAllAds);
                                                                  }
                                                                }
                                                              });
                                                            } else {
                                                              setState(() {
                                                                automotiveViewModel
                                                                    .addFavAutomotive(
                                                                        adId: searchViewModel
                                                                            .searchedAutomotiveAds[
                                                                                index]
                                                                            .id!);
                                                                searchViewModel
                                                                    .searchedAutomotiveAds[
                                                                        index]
                                                                    .isFavourite = false;
                                                                searchViewModel
                                                                    .changeSearchedAutomotiveAds(
                                                                        searchViewModel
                                                                            .searchedAutomotiveAds);
                                                                for (int i = 0;
                                                                    i <
                                                                        automotiveViewModel
                                                                            .automotiveAllAds
                                                                            .length;
                                                                    i++) {
                                                                  if (searchViewModel
                                                                          .searchedAutomotiveAds[
                                                                              index]
                                                                          .id ==
                                                                      automotiveViewModel
                                                                          .automotiveAllAds[
                                                                              i]
                                                                          .id) {
                                                                    automotiveViewModel
                                                                        .automotiveAllAds[
                                                                            i]
                                                                        .isFavourite = false;
                                                                    automotiveViewModel
                                                                        .changeAutomotiveAllAds(
                                                                            automotiveViewModel
                                                                                .automotiveAllAds);
                                                                  }
                                                                }
                                                              });
                                                            }
                                                          },
                                                          beds:
                                                              "${searchViewModel.searchedAutomotiveAds[index].category?.title}",
                                                          baths:
                                                              "${searchViewModel.searchedAutomotiveAds[index].carType}",
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : selectedModuleAdIndex == 2
                                                    ? GridView.builder(
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        itemCount: searchViewModel
                                                            .searchedPropertyAds
                                                            .length,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        gridDelegate:
                                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent: 200,
                                                          childAspectRatio:
                                                              med.height *
                                                                  0.00072,
                                                          crossAxisSpacing: 5,
                                                          mainAxisSpacing: 15,
                                                        ),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              ProductDetailScreen(
                                                                                productType: 'Property',
                                                                                propertyProduct: searchViewModel.searchedPropertyAds[index],
                                                                              )));
                                                            },
                                                            child: ProductCard(
                                                              isFeatured:
                                                                  searchViewModel
                                                                      .searchedPropertyAds[
                                                                          index]
                                                                      .isPromoted,
                                                              isFav: searchViewModel
                                                                  .searchedPropertyAds[
                                                                      index]
                                                                  .isFavourite,
                                                              isOff: searchViewModel
                                                                  .searchedPropertyAds[
                                                                      index]
                                                                  .isDeal,
                                                              price: searchViewModel
                                                                  .searchedPropertyAds[
                                                                      index]
                                                                  .price,
                                                              title: searchViewModel
                                                                  .searchedPropertyAds[
                                                                      index]
                                                                  .name,
                                                              address: searchViewModel
                                                                  .searchedPropertyAds[
                                                                      index]
                                                                  .streetAddress,
                                                              currencyCode:
                                                                  searchViewModel
                                                                      .searchedPropertyAds[
                                                                          index]
                                                                      .currency!
                                                                      .code,
                                                              logo: searchViewModel
                                                                          .searchedPropertyAds[
                                                                              index]
                                                                          .businessType ==
                                                                      "Company"
                                                                  ? searchViewModel
                                                                      .searchedPropertyAds[
                                                                          index]
                                                                      .company
                                                                      ?.profilePicture
                                                                  : searchViewModel
                                                                      .searchedPropertyAds[
                                                                          index]
                                                                      .profile
                                                                      ?.profilePicture,
                                                              imageUrl: searchViewModel
                                                                      .searchedPropertyAds[
                                                                          index]
                                                                      .imageMedia!
                                                                      .isEmpty
                                                                  ? ''
                                                                  : searchViewModel
                                                                      .searchedPropertyAds[
                                                                          index]
                                                                      .imageMedia![
                                                                          0]
                                                                      .image,
                                                              onFavTap: () {
                                                                if (searchViewModel
                                                                        .searchedPropertyAds[
                                                                            index]
                                                                        .isFavourite ==
                                                                    false) {
                                                                  setState(() {
                                                                    propertiesViewModel.addFavProperty(
                                                                        adId: searchViewModel
                                                                            .searchedPropertyAds[
                                                                                index]
                                                                            .id!);
                                                                    searchViewModel
                                                                        .searchedPropertyAds[
                                                                            index]
                                                                        .isFavourite = true;
                                                                    searchViewModel
                                                                        .changeSearchedPropertyAds(
                                                                            searchViewModel
                                                                                .searchedPropertyAds);
                                                                    for (int i =
                                                                            0;
                                                                        i <
                                                                            propertiesViewModel
                                                                                .propertyAllAds!
                                                                                .length;
                                                                        i++) {
                                                                      if (searchViewModel
                                                                              .searchedPropertyAds[
                                                                                  index]
                                                                              .id ==
                                                                          propertiesViewModel
                                                                              .propertyAllAds![i]
                                                                              .id) {
                                                                        propertiesViewModel
                                                                            .propertyAllAds![
                                                                                i]
                                                                            .isFavourite = true;
                                                                        propertiesViewModel
                                                                            .changePropertiesAllAds(
                                                                                propertiesViewModel.propertyAllAds!);
                                                                      }
                                                                    }
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    propertiesViewModel.addFavProperty(
                                                                        adId: searchViewModel
                                                                            .searchedPropertyAds[
                                                                                index]
                                                                            .id!);
                                                                    searchViewModel
                                                                        .searchedPropertyAds[
                                                                            index]
                                                                        .isFavourite = false;
                                                                    searchViewModel
                                                                        .changeSearchedPropertyAds(
                                                                            searchViewModel
                                                                                .searchedPropertyAds);
                                                                    for (int i =
                                                                            0;
                                                                        i <
                                                                            propertiesViewModel
                                                                                .propertyAllAds!
                                                                                .length;
                                                                        i++) {
                                                                      if (searchViewModel
                                                                              .searchedPropertyAds[
                                                                                  index]
                                                                              .id ==
                                                                          propertiesViewModel
                                                                              .propertyAllAds![i]
                                                                              .id) {
                                                                        propertiesViewModel
                                                                            .propertyAllAds![
                                                                                i]
                                                                            .isFavourite = false;
                                                                        propertiesViewModel
                                                                            .changePropertiesAllAds(
                                                                                propertiesViewModel.propertyAllAds!);
                                                                      }
                                                                    }
                                                                  });
                                                                }
                                                              },
                                                              categories:
                                                                  'property',
                                                              beds:
                                                                  "${searchViewModel.searchedPropertyAds[index].bedrooms} Bedrooms",
                                                              baths:
                                                                  "${searchViewModel.searchedPropertyAds[index].baths} Baths",
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : selectedModuleAdIndex == 3
                                                        ? GridView.builder(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                searchViewModel
                                                                    .searchedJobAds
                                                                    .length,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            gridDelegate:
                                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                                              maxCrossAxisExtent:
                                                                  200,
                                                              childAspectRatio:
                                                                  1 / 1.32,
                                                              crossAxisSpacing: 5,
                                                              mainAxisSpacing: 15,
                                                            ),
                                                            itemBuilder:
                                                                (context, index) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ProductDetailScreen(
                                                                                isJobAd: true,
                                                                                productType: 'Job',
                                                                                jobProduct: searchViewModel.searchedJobAds[index],
                                                                              )));
                                                                },
                                                                child:
                                                                    JobAdsWidget(
                                                                  onFavTap: () {
                                                                    if (searchViewModel
                                                                            .searchedJobAds[
                                                                                index]
                                                                            .isFavourite ==
                                                                        false) {
                                                                      setState(
                                                                          () {
                                                                        jobViewModel.addFavJob(
                                                                            adId: searchViewModel
                                                                                .searchedJobAds[index]
                                                                                .id!);
                                                                        searchViewModel
                                                                            .searchedJobAds[
                                                                                index]
                                                                            .isFavourite = true;
                                                                        searchViewModel
                                                                            .changeSearchedJobAds(
                                                                                searchViewModel.searchedJobAds);
                                                                        for (int i =
                                                                                0;
                                                                            i < jobViewModel.jobAllAds!.length;
                                                                            i++) {
                                                                          if (searchViewModel.searchedJobAds[index].id ==
                                                                              jobViewModel.jobAllAds![i].id) {
                                                                            jobViewModel
                                                                                .jobAllAds![i]
                                                                                .isFavourite = true;
                                                                            jobViewModel
                                                                                .changeJobAllAds(jobViewModel.jobAllAds!);
                                                                          }
                                                                        }
                                                                      });
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        jobViewModel.addFavJob(
                                                                            adId: searchViewModel
                                                                                .searchedJobAds[index]
                                                                                .id!);
                                                                        searchViewModel
                                                                            .searchedJobAds[
                                                                                index]
                                                                            .isFavourite = false;
                                                                        searchViewModel
                                                                            .changeSearchedJobAds(
                                                                                searchViewModel.searchedJobAds);
                                                                        for (int i =
                                                                                0;
                                                                            i < jobViewModel.jobAllAds!.length;
                                                                            i++) {
                                                                          if (searchViewModel.searchedJobAds[index].id ==
                                                                              jobViewModel.jobAllAds![i].id) {
                                                                            jobViewModel
                                                                                .jobAllAds![i]
                                                                                .isFavourite = false;
                                                                            jobViewModel
                                                                                .changeJobAllAds(jobViewModel.jobAllAds!);
                                                                          }
                                                                        }
                                                                      });
                                                                    }
                                                                  },
                                                                  isFav: searchViewModel
                                                                      .searchedJobAds[
                                                                          index]
                                                                      .isFavourite,
                                                                  isFeatured: searchViewModel
                                                                      .searchedJobAds[
                                                                          index]
                                                                      .isPromoted,
                                                                  isOff: false,
                                                                  title: searchViewModel
                                                                      .searchedJobAds[
                                                                          index]
                                                                      .title,
                                                                  currencyCode: searchViewModel
                                                                      .searchedJobAds[
                                                                          index]
                                                                      .salaryCurrency!
                                                                      .code,
                                                                  startingSalary:
                                                                      searchViewModel
                                                                          .searchedJobAds[
                                                                              index]
                                                                          .salaryStart,
                                                                  endingSalary:
                                                                      searchViewModel
                                                                          .searchedJobAds[
                                                                              index]
                                                                          .salaryEnd,
                                                                  description: searchViewModel
                                                                      .searchedJobAds[
                                                                          index]
                                                                      .description,
                                                                  address: searchViewModel
                                                                      .searchedJobAds[
                                                                          index]
                                                                      .location,
                                                                  imageUrl: searchViewModel
                                                                          .searchedJobAds[
                                                                              index]
                                                                          .imageMedia!
                                                                          .isEmpty
                                                                      ? null
                                                                      : searchViewModel
                                                                          .searchedJobAds[
                                                                              index]
                                                                          .imageMedia![
                                                                              0]
                                                                          .image,
                                                                  beds:
                                                                      "${searchViewModel.searchedJobAds[index].positionType}",
                                                                  baths:
                                                                      "${searchViewModel.searchedJobAds[index].jobType}",
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : GridView.builder(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            shrinkWrap: true,
                                                            itemCount: 6,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            gridDelegate:
                                                                SliverGridDelegateWithMaxCrossAxisExtent(
                                                              maxCrossAxisExtent:
                                                                  200,
                                                              childAspectRatio:
                                                                  med.height *
                                                                      0.00072,
                                                              crossAxisSpacing: 5,
                                                              mainAxisSpacing: 15,
                                                            ),
                                                            itemBuilder:
                                                                (context, index) {
                                                              return const ProductCardShimmer();
                                                            },
                                                          ),
                                      ),



                                /// Exploring Button For Filter Here
                                isExploringMore
                                    ? Center(
                                  child: CircularProgressIndicator(
                                      color: CustomAppTheme().primaryColor),
                                )
                                    : widget.module == 'Classified'
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
                                      if (widget.module == 'Classified') {
                                        classifiedViewModel
                                            .allClassifiedPageNo =
                                            classifiedViewModel
                                                .allClassifiedPageNo +
                                                1;
                                        setState(() {
                                          isExploringMore = true;
                                        });
                                        // final res = await getClassifiedAllAds();
                                        final res = await getClassifiedFilteredAds();
                                        print(res);
                                        print("hahahhhahah ======== ::: ");
                                        setState(() {
                                          isExploringMore = false;
                                        });
                                      }
                                    },
                                  )
                                      : const SizedBox.shrink(),
                                )
                                    : widget.module == 'Automotive'
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
                                      if (widget.module == 'Automotive') {
                                        automotiveViewModel
                                            .autoAllAdsPageNo =
                                            automotiveViewModel
                                                .autoAllAdsPageNo +
                                                1;
                                        setState(() {
                                          isExploringMore = true;
                                        });
                                        await getAutomotiveFilteredAds();
                                        setState(() {
                                          isExploringMore = false;
                                        });
                                      }
                                    },
                                  )
                                      : const SizedBox.shrink(),
                                )
                                    : widget.module == 'Property'
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
                                      if (widget.module == 'Property') {
                                        propertiesViewModel
                                            .allPropertiesPageNo =
                                            propertiesViewModel
                                                .allPropertiesPageNo +
                                                1;
                                        setState(() {
                                          isExploringMore = true;
                                        });
                                        await getPropertyFilteredJobs();
                                        setState(() {
                                          isExploringMore = false;
                                        });
                                      }
                                    },
                                  )
                                      : const SizedBox.shrink(),
                                )
                                    : widget.module == 'Job'
                                    ? jobFilteredAds!.isEmpty
                                    ? Container()
                                    : Center(
                                  child:
                                  currentPageJob !=
                                      jobViewModel
                                          .allJobTotalPages
                                      ? ExploreMoreButton(
                                    onTab: () async {
                                      // currentPageJob = currentPageJob + 1;
                                      jobViewModel.jobFilterData!.page = currentPageJob + 1;
                                      currentPageJob = currentPageJob + 1;
                                      print(jobViewModel.jobFilterData!.page);
                                      print(jobViewModel.jobFilterData!.jobType);
                                      print("================================ :: ");
                                      print("================================");
                                      print("================================");
                                      setState(() {});
                                      if (widget.module == 'Job') {
                                        jobViewModel
                                            .allJobPageNo =
                                            jobViewModel
                                                .allJobPageNo +
                                                1;
                                        setState(() {
                                          isExploringMore =
                                          true;
                                        });
                                        // await exploreMoreFilteredJobs();
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

                              ],
                            ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;

    var size = renderBox.size;
    return OverlayEntry(
        builder: (context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: LayerLink(),
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 5.0,
                  child: Column(
                    children: const [
                      ListTile(
                        title: Text('India'),
                      ),
                      ListTile(
                        title: Text('Australia'),
                      ),
                      ListTile(
                        title: Text('USA'),
                      ),
                      ListTile(
                        title: Text('Canada'),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  final List<String> sortedByList = [
    'Low to high',
    'High to low',
  ];

  List<String> moduleList = [
    'Classified',
    'Automotive',
    'Property',
    'Job',
  ];
}

class SearchSuggestion {
  String? id;
  String? title;
  Null? category;
  String? dataType;
  String? image;

  SearchSuggestion(
      {this.id, this.title, this.category, this.dataType, this.image});

  SearchSuggestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    category = json['category'];
    dataType = json['data_type'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['category'] = category;
    data['data_type'] = dataType;
    data['image'] = image;
    return data;
  }
}
