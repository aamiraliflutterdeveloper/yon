import 'package:app/common/logger/log.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutomotiveByBrands extends StatefulWidget {
  const AutomotiveByBrands({Key? key}) : super(key: key);

  @override
  State<AutomotiveByBrands> createState() => _AutomotiveByBrandsState();
}

class _AutomotiveByBrandsState extends State<AutomotiveByBrands> {
  int modelIndex = -1;
  int popularBrandIndex = -1;
  int allBrandIndex = -1;
  bool isPopularBrandOpen = true;
  bool isAllBrandOpen = true;
  bool isModelsOpen = true;
  int allBrandLength = 0;

  getAutoFeaturedBrands() async {
    AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    final result = await automotiveViewModel.getAutoFeaturedBrands();
    result.fold((l) {}, (r) {
      automotiveViewModel.changeAutoFeaturedBrands(r.response!);
    });
  }

  getAutoAllBrands() async {
    AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    final result = await automotiveViewModel.getAutoAllBrands();
    result.fold((l) {}, (r) {
      automotiveViewModel.changeAutoAllBrands(r.response!);
    });
  }

  @override
  void initState() {
    super.initState();
    AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    if (automotiveViewModel.automotiveFeaturedBrands!.isEmpty) {
      getAutoFeaturedBrands();
    }
    if (automotiveViewModel.automotiveAllBrands!.isEmpty) {
      getAutoAllBrands();
    }
    if (automotiveViewModel.automotiveFilterMap!.containsKey('Brand')) {
      for (int i = 0;
          i < automotiveViewModel.automotiveAllBrands!.length;
          i++) {
        if (automotiveViewModel.automotiveFilterMap!['Brand'] ==
            automotiveViewModel.automotiveAllBrands![i].title) {
          d('${automotiveViewModel.automotiveFilterMap!['Brand']} == ${automotiveViewModel.automotiveAllBrands![i].title}');
          allBrandIndex = i;
          d('allBrandIndex : $allBrandIndex');
        }
      }
    }
  }

  bool isShowAll = false;

  @override
  Widget build(BuildContext context) {
    AutomotiveViewModel automotiveViewModel =
        context.watch<AutomotiveViewModel>();
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // const FilterSearchTextField(),
              // SizedBox(
              //   height: med.height * 0.04,
              // ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Text(
              //       'Popular Brands',
              //       style: CustomAppTheme().textFieldHeading,
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         setState(() {
              //           isPopularBrandOpen = !isPopularBrandOpen;
              //         });
              //       },
              //       child: Icon(
              //         isPopularBrandOpen ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_up_outlined,
              //         color: CustomAppTheme().darkGreyColor,
              //       ),
              //     ),
              //   ],
              // ),
              // isPopularBrandOpen
              //     ? Column(
              //         children: <Widget>[
              //           SizedBox(
              //             height: med.height * 0.02,
              //           ),
              //           GridView.builder(
              //             itemCount: automotiveViewModel.automotiveFeaturedBrands!.length,
              //             padding: const EdgeInsets.only(bottom: 1),
              //             shrinkWrap: true,
              //             physics: const NeverScrollableScrollPhysics(),
              //             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              //               maxCrossAxisExtent: med.width * 0.15,
              //               mainAxisExtent: med.height * 0.065,
              //               childAspectRatio: 4.0,
              //               crossAxisSpacing: 15,
              //               mainAxisSpacing: 15,
              //             ),
              //             itemBuilder: (context, index) {
              //               return GestureDetector(
              //                 onTap: () {
              //                   setState(() {
              //                     if (popularBrandIndex == index) {
              //                       popularBrandIndex = -1;
              //                       automotiveViewModel.automotiveFilterMap!.removeWhere((key, value) => key == 'Brand');
              //                       automotiveViewModel.changeAutoFilterMap(automotiveViewModel.automotiveFilterMap!);
              //                       automotiveViewModel.automotiveFilterData!.brandId = null;
              //                     } else {
              //                       popularBrandIndex = index;
              //                       allBrandIndex = -1;
              //                       automotiveViewModel.automotiveFilterMap!.addEntries({MapEntry('Brand', automotiveViewModel.automotiveFeaturedBrands![index].title!)});
              //                       automotiveViewModel.changeAutoFilterMap(automotiveViewModel.automotiveFilterMap!);
              //                       automotiveViewModel.automotiveFilterData!.brandId = automotiveViewModel.automotiveFeaturedBrands![index].id;
              //                     }
              //                   });
              //                 },
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                     color: popularBrandIndex == index ? CustomAppTheme().lightGreenColor : CustomAppTheme().lightGreyColor,
              //                     border: Border.all(color: popularBrandIndex == index ? CustomAppTheme().primaryColor : CustomAppTheme().greyColor),
              //                     borderRadius: BorderRadius.circular(6),
              //                   ),
              //                   child: Center(
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: Image.network(automotiveViewModel.automotiveFeaturedBrands![index].image.toString()),
              //                       /*SvgPicture.asset(
              //                         'assets/svgs/categoriesIcon.svg',
              //                       ),*/
              //                     ),
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         ],
              //       )
              //     : const SizedBox.shrink(),
              SizedBox(
                height: med.height * 0.04,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'All Brands',
                    style: CustomAppTheme().textFieldHeading,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isAllBrandOpen = !isAllBrandOpen;
                      });
                    },
                    child: Icon(
                      isAllBrandOpen
                          ? Icons.keyboard_arrow_down_outlined
                          : Icons.keyboard_arrow_up_outlined,
                      color: CustomAppTheme().darkGreyColor,
                    ),
                  ),
                ],
              ),
              automotiveViewModel.automotiveAllBrands!.isEmpty
                  ? SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: CustomAppTheme().primaryColor,
                        ),
                      ),
                    )
                  : isAllBrandOpen
                      ? Column(
                          children: <Widget>[
                            SizedBox(
                              height: med.height * 0.02,
                            ),
                            GridView.builder(
                              itemCount:
                                  // automotiveViewModel.automotiveAllBrands!.length,
                                  // automotiveViewModel.automotiveAllBrands!.isEmpty
                                  isShowAll
                                      ? automotiveViewModel
                                          .automotiveAllBrands!.length
                                      : 15,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: med.width * 0.15,
                                mainAxisExtent: med.height * 0.1,
                                childAspectRatio: 4.0,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (allBrandIndex == index) {
                                        allBrandIndex = -1;
                                        automotiveViewModel.automotiveFilterMap!
                                            .removeWhere(
                                                (key, value) => key == 'Brand');
                                        automotiveViewModel.changeAutoFilterMap(
                                            automotiveViewModel
                                                .automotiveFilterMap!);
                                        automotiveViewModel
                                            .automotiveFilterData!
                                            .brandId = null;
                                      } else {
                                        allBrandIndex = index;
                                        popularBrandIndex = -1;
                                        automotiveViewModel.automotiveFilterMap!
                                            .addEntries({
                                          MapEntry(
                                              'Brand',
                                              automotiveViewModel
                                                  .automotiveAllBrands![index]
                                                  .title!)
                                        });
                                        automotiveViewModel.changeAutoFilterMap(
                                            automotiveViewModel
                                                .automotiveFilterMap!);
                                        automotiveViewModel
                                                .automotiveFilterData!.brandId =
                                            automotiveViewModel
                                                .automotiveAllBrands![index].id;
                                      }
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: med.width * 0.15,
                                        height: med.height * 0.065,
                                        decoration: BoxDecoration(
                                          color: allBrandIndex == index
                                              ? CustomAppTheme().lightGreenColor
                                              : CustomAppTheme().lightGreyColor,
                                          border: Border.all(
                                              color: allBrandIndex == index
                                                  ? CustomAppTheme()
                                                      .primaryColor
                                                  : CustomAppTheme().greyColor),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(automotiveViewModel
                                                .automotiveAllBrands![index]
                                                .image
                                                .toString()), /*SvgPicture.asset(
                                          'assets/svgs/categoriesIcon.svg',
                                        ),*/
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          automotiveViewModel
                                              .automotiveAllBrands![index].title
                                              .toString(),
                                          style: CustomAppTheme()
                                              .boldNormalText
                                              .copyWith(fontSize: 6),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          automotiveViewModel
                                                  .automotiveAllBrands![index]
                                                  .totalCounts ??
                                              "",
                                          style: CustomAppTheme()
                                              .normalGreyText
                                              .copyWith(fontSize: 6),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: med.height * 0.01,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isShowAll = !isShowAll;
                                  });
                                },
                                child: Text(
                                  isShowAll ? 'View Less' : 'View More',
                                  style: CustomAppTheme()
                                      .normalGreyText
                                      .copyWith(
                                          fontSize: 12,
                                          decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
              SizedBox(
                height: med.height * 0.1,
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Text(
              //       'Toyota Cars',
              //       style: CustomAppTheme().textFieldHeading,
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         setState(() {
              //           isModelsOpen = !isModelsOpen;
              //         });
              //       },
              //       child: Icon(
              //         isModelsOpen
              //             ? Icons.keyboard_arrow_down_outlined
              //             : Icons.keyboard_arrow_up_outlined,
              //         color: CustomAppTheme().darkGreyColor,
              //       ),
              //     ),
              //   ],
              // ),
              // isModelsOpen
              //     ? Column(
              //         children: [
              //           SizedBox(
              //             height: med.height * 0.02,
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(top: 10),
              //             child: Wrap(
              //               spacing: 10.0,
              //               runSpacing: 8.0,
              //               children: <Widget>[
              //                 for (int index = 0;
              //                     index < modelsList.length;
              //                     index++)
              //                   GestureDetector(
              //                     onTap: () {
              //                       setState(() {
              //                         modelIndex = index;
              //                       });
              //                     },
              //                     child: Container(
              //                       decoration: BoxDecoration(
              //                         color: modelIndex == index
              //                             ? CustomAppTheme().lightGreenColor
              //                             : CustomAppTheme().lightGreyColor,
              //                         border: Border.all(
              //                             color: modelIndex == index
              //                                 ? CustomAppTheme().primaryColor
              //                                 : CustomAppTheme().greyColor),
              //                         borderRadius: BorderRadius.circular(5),
              //                       ),
              //                       child: Padding(
              //                         padding: const EdgeInsets.symmetric(
              //                             vertical: 5, horizontal: 10),
              //                         child: Row(
              //                           mainAxisSize: MainAxisSize.min,
              //                           children: <Widget>[
              //                             Text(
              //                               modelsList[index],
              //                               style: CustomAppTheme()
              //                                   .normalText
              //                                   .copyWith(
              //                                       fontWeight: FontWeight.w600,
              //                                       color: CustomAppTheme()
              //                                           .blackColor,
              //                                       fontSize: 12),
              //                             ),
              //                             Padding(
              //                               padding:
              //                                   const EdgeInsets.only(left: 5),
              //                               child: Text(
              //                                 '(10,500)',
              //                                 style: CustomAppTheme()
              //                                     .normalGreyText
              //                                     .copyWith(
              //                                         fontWeight:
              //                                             FontWeight.w500,
              //                                         color: CustomAppTheme()
              //                                             .greyColor,
              //                                         fontSize: 10),
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       )
              //     : const SizedBox.shrink(),
              // SizedBox(
              //   height: med.height * 0.1,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> modelsList = [
    'Avaion',
    'Camry',
    'V4',
    'Carolla',
    'Prius',
    'Yasir',
    'Sienna',
    'C-HR',
    '4Runner',
  ];
}
