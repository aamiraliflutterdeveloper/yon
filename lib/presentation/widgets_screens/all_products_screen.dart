import 'package:app/common/logger/log.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/shimmers/product_card_shimmer.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/jobAds_widget.dart';
import 'package:app/presentation/utils/widgets/product_card.dart';
import 'package:app/presentation/utils/widgets/sorted_by_dropdown.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AllProductScreen extends StatefulWidget {
  final String title;
  final int moduleIndex;
  final String categoryId;
  final List<ClassifiedProductModel>? classifiedProducts;
  const AllProductScreen(
      {Key? key,
      required this.title,
      required this.moduleIndex,
      this.classifiedProducts,
      required this.categoryId})
      : super(key: key);

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> with BaseMixin {
  String? selectedSort;
  bool isDataFetching = false;
  int totalAdsCount = 0;

  getClassifiedByCategory(
      {required String categoryId, String? sortedBy}) async {
    ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result = await classifiedViewModel.getClassifiedByCategory(
        categoryId: categoryId, sortedBy: sortedBy);
    result.fold((l) {
      helper.showToast('Something went wrong');
    }, (r) {
      d('R : ${r.results!.length}');
      totalAdsCount = r.results!.length;
      classifiedViewModel.changeClassifiedByCategory(r.results!);
      d('CLASSIFIED BY CATEGORY ::: ${classifiedViewModel.classifiedByCategory.length}');
      print(classifiedViewModel.classifiedByCategory.map((e) => e.isFavourite));
      print("hahahahaahhahahhhahah ==== == = == == === = === === == = = = == === = == = == ==");
    });
    setState(() {
      isDataFetching = false;
    });
  }

  getAutomotiveByCategory(
      {required String categoryId, String? sortedBy}) async {
    final AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result = await automotiveViewModel.getAutomotiveByCategory(
        categoryId: categoryId, sortedBy: sortedBy);
    result.fold((l) {}, (r) {
      totalAdsCount = r.automotiveAdsList!.length;
      automotiveViewModel.changeAutomotiveByCategory(r.automotiveAdsList!);
    });
    setState(() {
      isDataFetching = false;
    });
  }

  getPropertiesByCategory(
      {required String categoryId, String? sortedBy}) async {
    final PropertiesViewModel propertiesViewModel =
        context.read<PropertiesViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result = await propertiesViewModel.getPropertiesByCategory(
        categoryId: categoryId, sortedBy: sortedBy);
    result.fold((l) {}, (r) {
      totalAdsCount = r.propertyProductList!.length;
      propertiesViewModel.changePropertiesByCategory(r.propertyProductList!);
    });
    setState(() {
      isDataFetching = false;
    });
  }

  getJobByCategory({required String categoryId, String? sortedBy}) async {
    final JobViewModel jobViewModel = context.read<JobViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result = await jobViewModel.getJobsByCategory(
        categoryId: categoryId, sortedBy: sortedBy);
    result.fold((l) {}, (r) {
      totalAdsCount = r.jobAdsList!.length;
      jobViewModel.changeJobByCategory(r.jobAdsList!);
    });
    setState(() {
      isDataFetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.moduleIndex == 0) {
      getClassifiedByCategory(categoryId: widget.categoryId);
    }
    if (widget.moduleIndex == 2) {
      getAutomotiveByCategory(categoryId: widget.categoryId);
    }
    if (widget.moduleIndex == 1) {
      getPropertiesByCategory(categoryId: widget.categoryId);
    }
    if (widget.moduleIndex == 3) {
      getJobByCategory(categoryId: widget.categoryId);
    }
  }

  String catFav = '';
  String? activeIndex;
  List<String> pressedListData = [];

  @override
  Widget build(BuildContext context) {

    print(widget.categoryId);
    print("==== ==== ===== ===== ===== ");
    Size med = MediaQuery.of(context).size;
    ClassifiedViewModel classifiedViewModel =
        context.watch<ClassifiedViewModel>();
    final AutomotiveViewModel automotiveViewModel =
        context.watch<AutomotiveViewModel>();
    final PropertiesViewModel propertiesViewModel =
        context.watch<PropertiesViewModel>();
    final JobViewModel jobViewModel = context.watch<JobViewModel>();
    // print(classifiedViewModel.classifiedByCategory[0].isFavourite);
    // print(classifiedViewModel.classifiedByCategory[1].isFavourite);
    //
    // d('isDataFetching : $isDataFetching');
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: widget.title, context: context, onTap: () {
        // Navigator.of(context, 'pressedListData').pop();
        Navigator.pop(context, pressedListData);
      }),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: med.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  // isDataFetching ? 'Ads' : '$totalAdsCount Ads',
                  'All Ads',
                  style: CustomAppTheme().headingText.copyWith(
                      fontSize: 20, color: CustomAppTheme().blackColor),
                ),
                isDataFetching || totalAdsCount == 0
                    ? const SizedBox.shrink()
                    : SortedByDropDown(
                        hint: 'Sort by',
                        icon: null,
                        buttonWidth: med.width * 0.3,
                        buttonHeight: med.height * 0.04,
                        dropdownItems: sortedByList,
                        value: selectedSort,
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value;
                            if (widget.moduleIndex == 0) {
                              getClassifiedByCategory(
                                  categoryId: widget.categoryId,
                                  sortedBy:
                                      value!.replaceAll(' ', '').toLowerCase());
                            }
                            if (widget.moduleIndex == 2) {
                              getAutomotiveByCategory(
                                  categoryId: widget.categoryId,
                                  sortedBy:
                                      value!.replaceAll(' ', '').toLowerCase());
                            }
                            if (widget.moduleIndex == 1) {
                              getPropertiesByCategory(
                                  categoryId: widget.categoryId,
                                  sortedBy:
                                      value!.replaceAll(' ', '').toLowerCase());
                            }
                            if (widget.moduleIndex == 3) {
                              getJobByCategory(
                                  categoryId: widget.categoryId,
                                  sortedBy:
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
            Expanded(
              child: isDataFetching
                  ? GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: 6,
                      physics: const BouncingScrollPhysics(),
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
                  : totalAdsCount == 0
                      ? Column(
                          children: <Widget>[
                            SizedBox(
                              height: med.height * 0.1,
                            ),
                            SvgPicture.asset(
                              'assets/svgs/notFound.svg',
                              height: med.height * 0.1,
                            ),
                            SizedBox(
                              height: med.height * 0.05,
                            ),
                            Text(
                              'No product of ${widget.title}',
                              style: CustomAppTheme().normalGreyText.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      : widget.moduleIndex == 0
                          ? GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: classifiedViewModel
                                  .classifiedByCategory.length,
                              physics: const BouncingScrollPhysics(),
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
                                          productType: 'Classified',
                                          classifiedProduct: classifiedViewModel
                                              .classifiedByCategory[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ProductCard(
                                    onFavTap: () {
                                      catFav = 'pressed';
                                      activeIndex = widget.moduleIndex.toString();
                                      pressedListData.add(catFav);
                                      pressedListData.add(activeIndex!);
                                      setState(() {

                                      });
                                      if (classifiedViewModel
                                              .classifiedByCategory[index]
                                              .isFavourite ==
                                          true) {
                                        setState(() {
                                          classifiedViewModel.addFavClassified(
                                              adId: classifiedViewModel
                                                  .classifiedByCategory[index]
                                                  .id!);
                                          classifiedViewModel
                                              .classifiedByCategory[index]
                                              .isFavourite = false;
                                          classifiedViewModel
                                              .changeClassifiedByCategory(
                                                  classifiedViewModel
                                                      .classifiedByCategory);
                                        });
                                      } else {
                                        setState(() {
                                          classifiedViewModel.addFavClassified(
                                              adId: classifiedViewModel
                                                  .classifiedByCategory[index]
                                                  .id!);
                                          classifiedViewModel
                                              .classifiedByCategory[index]
                                              .isFavourite = true;
                                          classifiedViewModel
                                              .changeClassifiedByCategory(
                                                  classifiedViewModel
                                                      .classifiedByCategory);
                                        });
                                      }
                                    },
                                    isFav: classifiedViewModel
                                        .classifiedByCategory[index]
                                        .isFavourite,
                                    isOff: classifiedViewModel
                                        .classifiedByCategory[index].isDeal,
                                    isFeatured: classifiedViewModel
                                        .classifiedByCategory[index].isPromoted,
                                    title: classifiedViewModel
                                        .classifiedByCategory[index].name,
                                    address: classifiedViewModel
                                        .classifiedByCategory[index]
                                        .streetAdress,
                                    currencyCode: classifiedViewModel
                                        .classifiedByCategory[index]
                                        .currency!
                                        .code,
                                    logo: classifiedViewModel
                                                .classifiedByCategory[index]
                                                .businessType ==
                                            "Company"
                                        ? classifiedViewModel
                                            .classifiedByCategory[index]
                                            .company
                                            ?.profilePicture
                                        : classifiedViewModel
                                            .classifiedByCategory[index]
                                            .profile
                                            ?.profilePicture,
                                    price: classifiedViewModel
                                        .classifiedByCategory[index].price,
                                    imageUrl: classifiedViewModel
                                            .classifiedByCategory[index]
                                            .imageMedia!
                                            .isEmpty
                                        ? null
                                        : classifiedViewModel
                                            .classifiedByCategory[index]
                                            .imageMedia![0]
                                            .image,
                                    beds:
                                        "${classifiedViewModel.classifiedByCategory[index].category?.title}",
                                    baths:
                                        "${classifiedViewModel.classifiedByCategory[index].type}",
                                  ),
                                );
                              },
                            )
                          : widget.moduleIndex == 1
                              ? GridView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: automotiveViewModel
                                      .automotiveByCategory.length,
                                  physics: const BouncingScrollPhysics(),
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
                                                          .automotiveByCategory[
                                                      index],
                                              productType: 'Automotive',
                                            ),
                                          ),
                                        );
                                      },
                                      child: ProductCard(
                                        onFavTap: () {
                                          catFav = 'pressed';
                                          activeIndex = widget.moduleIndex.toString();
                                          pressedListData.add(catFav);
                                          pressedListData.add(activeIndex!);
                                          setState(() {

                                          });
                                          if (automotiveViewModel
                                                  .automotiveByCategory[index]
                                                  .isFavourite ==
                                              false) {
                                            setState(() {
                                              automotiveViewModel
                                                  .addFavAutomotive(
                                                      adId: automotiveViewModel
                                                          .automotiveByCategory[
                                                              index]
                                                          .id!);
                                              automotiveViewModel
                                                  .automotiveByCategory[index]
                                                  .isFavourite = true;
                                              automotiveViewModel
                                                  .changeAutomotiveByCategory(
                                                      automotiveViewModel
                                                          .automotiveByCategory);
                                            });
                                          } else {
                                            setState(() {
                                              automotiveViewModel
                                                  .addFavAutomotive(
                                                      adId: automotiveViewModel
                                                          .automotiveByCategory[
                                                              index]
                                                          .id!);
                                              automotiveViewModel
                                                  .automotiveByCategory[index]
                                                  .isFavourite = false;
                                              automotiveViewModel
                                                  .changeAutomotiveByCategory(
                                                      automotiveViewModel
                                                          .automotiveByCategory);
                                            });
                                          }
                                        },
                                        isFav: automotiveViewModel
                                            .automotiveByCategory[index]
                                            .isFavourite,
                                        isOff: automotiveViewModel
                                            .automotiveByCategory[index].isDeal,
                                        isFeatured: automotiveViewModel
                                            .automotiveByCategory[index]
                                            .isPromoted,
                                        title: automotiveViewModel
                                            .automotiveByCategory[index].name,
                                        address: automotiveViewModel
                                            .automotiveByCategory[index]
                                            .streetAddress,
                                        currencyCode: automotiveViewModel
                                            .automotiveByCategory[index]
                                            .currency!
                                            .code,
                                        price: automotiveViewModel
                                            .automotiveByCategory[index].price,
                                        logo: automotiveViewModel
                                                    .automotiveByCategory[index]
                                                    .businessType ==
                                                "Company"
                                            ? automotiveViewModel
                                                .automotiveByCategory[index]
                                                .company
                                                ?.profilePicture
                                            : automotiveViewModel
                                                .automotiveByCategory[index]
                                                .profile
                                                ?.profilePicture,
                                        imageUrl: automotiveViewModel
                                                .automotiveByCategory[index]
                                                .imageMedia!
                                                .isEmpty
                                            ? null
                                            : automotiveViewModel
                                                .automotiveByCategory[index]
                                                .imageMedia![0]
                                                .image,
                                        beds:
                                            "${automotiveViewModel.automotiveByCategory[index].category?.title}",
                                        baths:
                                            "${automotiveViewModel.automotiveByCategory[index].carType}",
                                      ),
                                    );
                                  },
                                )
                              : widget.moduleIndex == 2
                                  ? GridView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: propertiesViewModel
                                          .propertiesByCategory.length,
                                      physics: const BouncingScrollPhysics(),
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
                                                      propertiesViewModel
                                                              .propertiesByCategory[
                                                          index],
                                                  productType: 'Property',
                                                ),
                                              ),
                                            );
                                          },
                                          child: ProductCard(
                                            onFavTap: () {
                                              catFav = 'pressed';
                                              activeIndex = widget.moduleIndex.toString();
                                              pressedListData.add(catFav);
                                              pressedListData.add(activeIndex!);
                                              setState(() {

                                              });
                                              if (propertiesViewModel
                                                      .propertiesByCategory[
                                                          index]
                                                      .isFavourite ==
                                                  true) {
                                                setState(() {
                                                  propertiesViewModel.addFavProperty(
                                                      adId: propertiesViewModel
                                                          .propertiesByCategory[
                                                              index]
                                                          .id!);
                                                  propertiesViewModel
                                                      .propertiesByCategory[
                                                          index]
                                                      .isFavourite = false;
                                                  propertiesViewModel
                                                      .changePropertiesByCategory(
                                                          propertiesViewModel
                                                              .propertiesByCategory);
                                                });
                                              } else {
                                                setState(() {
                                                  propertiesViewModel.addFavProperty(
                                                      adId: propertiesViewModel
                                                          .propertiesByCategory[
                                                              index]
                                                          .id!);
                                                  propertiesViewModel
                                                      .propertiesByCategory[
                                                          index]
                                                      .isFavourite = true;
                                                  propertiesViewModel
                                                      .changePropertiesByCategory(
                                                          propertiesViewModel
                                                              .propertiesByCategory);
                                                });
                                              }
                                            },
                                            isFav: propertiesViewModel
                                                .propertiesByCategory[index]
                                                .isFavourite,
                                            isOff: propertiesViewModel
                                                .propertiesByCategory[index]
                                                .isDeal,
                                            isFeatured: propertiesViewModel
                                                .propertiesByCategory[index]
                                                .isPromoted,
                                            title: propertiesViewModel
                                                .propertiesByCategory[index]
                                                .name,
                                            address: propertiesViewModel
                                                .propertiesByCategory[index]
                                                .streetAddress,
                                            currencyCode: propertiesViewModel
                                                .propertiesByCategory[index]
                                                .currency!
                                                .code,
                                            price: propertiesViewModel
                                                .propertiesByCategory[index]
                                                .price,
                                            logo: propertiesViewModel
                                                        .propertiesByCategory[
                                                            index]
                                                        .businessType ==
                                                    "Company"
                                                ? propertiesViewModel
                                                    .propertiesByCategory[index]
                                                    .company
                                                    ?.profilePicture
                                                : propertiesViewModel
                                                    .propertiesByCategory[index]
                                                    .profile
                                                    ?.profilePicture,
                                            imageUrl: propertiesViewModel
                                                    .propertiesByCategory[index]
                                                    .imageMedia!
                                                    .isEmpty
                                                ? null
                                                : propertiesViewModel
                                                    .propertiesByCategory[index]
                                                    .imageMedia![0]
                                                    .image,
                                            beds:
                                                "${propertiesViewModel.propertiesByCategory[index].bedrooms} Bedrooms",
                                            baths:
                                                "${propertiesViewModel.propertiesByCategory[index].baths} Baths",
                                          ),
                                        );
                                      },
                                    )
                                  : widget.moduleIndex == 3
                                      ? GridView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: jobViewModel
                                              .jobsByCategory.length,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent:
                                                med.height * 0.26,
                                            childAspectRatio:
                                                med.height * 0.00088,
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
                                                      jobProduct: jobViewModel
                                                              .jobsByCategory[
                                                          index],
                                                      productType: 'Job',
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: JobAdsWidget(
                                                onFavTap: () {
                                                  catFav = 'pressed';
                                                  activeIndex = widget.moduleIndex.toString();
                                                  pressedListData.add(catFav);
                                                  pressedListData.add(activeIndex!);
                                                  setState(() {

                                                  });
                                                  if (jobViewModel
                                                          .jobsByCategory[index]
                                                          .isFavourite ==
                                                      false) {
                                                    setState(() {
                                                      jobViewModel.addFavJob(
                                                          adId: jobViewModel
                                                              .jobAllAds![index]
                                                              .id!);
                                                      jobViewModel
                                                          .jobsByCategory[index]
                                                          .isFavourite = true;
                                                      jobViewModel
                                                          .changeJobByCategory(
                                                              jobViewModel
                                                                  .jobsByCategory);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      jobViewModel.addFavJob(
                                                          adId: jobViewModel
                                                              .jobAllAds![index]
                                                              .id!);
                                                      jobViewModel
                                                          .jobsByCategory[index]
                                                          .isFavourite = false;
                                                      jobViewModel
                                                          .changeJobByCategory(
                                                              jobViewModel
                                                                  .jobsByCategory);
                                                    });
                                                  }
                                                },
                                                isFav: jobViewModel
                                                    .jobsByCategory[index]
                                                    .isFavourite,
                                                isFeatured: jobViewModel
                                                    .jobsByCategory[index]
                                                    .isPromoted,
                                                isOff: false,
                                                title: jobViewModel
                                                    .jobsByCategory[index]
                                                    .title,
                                                currencyCode: jobViewModel
                                                    .jobsByCategory[index]
                                                    .salaryCurrency!
                                                    .code,
                                                startingSalary: jobViewModel
                                                    .jobsByCategory[index]
                                                    .salaryStart,
                                                endingSalary: jobViewModel
                                                    .jobsByCategory[index]
                                                    .salaryEnd,
                                                description: jobViewModel
                                                    .jobsByCategory[index]
                                                    .description,
                                                address: jobViewModel
                                                    .jobsByCategory[index]
                                                    .location,
                                                imageUrl: jobViewModel
                                                        .jobsByCategory[index]
                                                        .imageMedia!
                                                        .isEmpty
                                                    ? null
                                                    : jobViewModel
                                                        .jobsByCategory[index]
                                                        .imageMedia![0]
                                                        .image,
                                                beds:
                                                    "${jobViewModel.jobsByCategory[index].positionType}",
                                                baths:
                                                    "${jobViewModel.jobsByCategory[index].jobType}",
                                              ),
                                            );
                                          },
                                        )
                                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  final List<String> sortedByList = [
    'Low to high',
    'High to low',
  ];
}
