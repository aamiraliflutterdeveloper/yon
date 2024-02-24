import 'package:app/application/core/exceptions/exception.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/business_module_models/get_business_profiles_models.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/ad_type_screen.dart';
import 'package:app/presentation/add_post/view_model/create_ad_post_view_model.dart';
import 'package:app/presentation/categories/all_categories_screen.dart';
import 'package:app/presentation/categories/mixins/category_screens_mixin.dart';
import 'package:app/presentation/profile/business_mode/view_model/business_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/shimmers/product_card_shimmer.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  final bool? isAddPost;

  const CategoriesScreen({Key? key, this.isAddPost = false}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with CategoriesScreenMixin, BaseMixin {


  String jobStatus = '';
  String classifiedStatus = '';
  String propertyStatus = '';
  String automotiveStatus = '';


  getBusinessProfile() async {
    BusinessViewModel businessViewModel = context.read<BusinessViewModel>();
    final result = await businessViewModel.getMyBusinessProfiles();
    result.fold((l) {}, (r) {
      d('My Business Profiles : $r');
      for (int i = 0; i < r.response!.length; i++) {
        if (r.response![i].companyType == 'Classified') {
          businessViewModel.classifiedBusinessProfile = r.response![i];
          setState(() {
            classifiedStatus = r.response![i].verificationStatus!;
            iPrefHelper.saveClassifiedProfile(
                businessViewModel.classifiedBusinessProfile);

          });
        } else if (r.response![i].companyType == 'Automotive') {
          setState(() {
            automotiveStatus = r.response![i].verificationStatus!;
            businessViewModel.automotiveBusinessProfile = r.response![i];
            iPrefHelper.saveAutomotiveProfile(
                businessViewModel.automotiveBusinessProfile);
          });
        } else if (r.response![i].companyType == 'Property') {
          setState(() {
            propertyStatus = r.response![i].verificationStatus!;
            businessViewModel.propertyBusinessProfile = r.response![i];
            iPrefHelper
                .savePropertyProfile(businessViewModel.propertyBusinessProfile);
          });
        } else if (r.response![i].companyType == 'Job') {
          setState(() {
            jobStatus = r.response![i].verificationStatus!;
            businessViewModel.jobBusinessProfile = r.response![i];

            iPrefHelper.saveJobProfile(businessViewModel.jobBusinessProfile);
          });
        }
      }
    });
  }

  // Dio dio = Dio();
  //   Future<void> getMyBusinessProfile() async {
  //     try {
  //       String? token = iPrefHelper.retrieveToken();
  //       final responseData = await dio.get("https://services-dev.youonline.online/api/get_business_profile/", options: Options(headers: {"Authorization": "token $token"}));
  //       GetBusinessResModel data = GetBusinessResModel.fromJson(responseData.data);
  //       print("hahahahahha");
  //       print(data.response);
  //       // BusinessViewModel response =
  //       print("hahahahahha");
  //       // return GetBusinessResModel.fromJson(responseData.data);
  //     } on DioError catch (e) {
  //       d(e);
  //       final exception = getException(e);
  //       throw exception;
  //     } catch (e, t) {
  //       d(t);
  //       throw ResponseException(msg: e.toString());
  //     }
  // }


  @override
  void initState() {
    super.initState();
    // getMyBusinessProfile();
    getBusinessProfile();

  }


  @override
  Widget build(BuildContext context) {
    BusinessViewModel businessViewModel = context.watch<BusinessViewModel>();
    final CreateAdPostViewModel createAdPostViewModel =
        context.watch<CreateAdPostViewModel>();
    // print(businessViewModel.automotiveBusinessProfile.verificationStatus);
    // print(businessViewModel.automotiveBusinessProfile.verificationStatus);
    // print(businessViewModel.automotiveBusinessProfile.verificationStatus);
    // print(businessViewModel.automotiveBusinessProfile.verificationStatus);
    print("=================== :: =================");
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: widget.isAddPost == true
          ? customAppBar(title: 'Add Post', context: context, onTap: () {Navigator.of(context).pop();})
          : null,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.isAddPost == true
                ? SizedBox(
                    height: med.height * 0.035,
                  )
                : SizedBox(
                    height: med.height * 0.15,
                  ),
            widget.isAddPost == true
                ? Text(
                    'What are you offering?',
                    style: CustomAppTheme().headingText,
                  )
                : Center(
                    child: Text(
                      'Explore By Categories',
                      style: CustomAppTheme().headingText,
                    ),
                  ),
            SizedBox(
              height: med.height * 0.015,
            ),
            /*widget.isAddPost == true
                ? Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                    textAlign: TextAlign.start,
                    style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
                  )
                : Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                    textAlign: TextAlign.center,
                    style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
                  ),*/
            SizedBox(
              height: med.height * 0.04,
            ),
            jobStatus == '' ? GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 4,
              physics:
              const NeverScrollableScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1/1,
                crossAxisCount: 2,
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 5.0,
              ),
              itemBuilder: (context, index) {
                return const ProductCardShimmer();
              },
            )  :
            GridView.builder(
              itemCount: categoryList.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.9,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: widget.isAddPost == true
                      ? () {

                    print("hahahahhaha ====================");
                    print(businessViewModel
                        .classifiedBusinessProfile
                        .isBusinessActive);
                          print(businessViewModel
                              .classifiedBusinessProfile.isBusinessActive);
                    print(businessViewModel
                        .classifiedBusinessProfile.verificationStatus);
                          print("============================");
                          print("============================");
                          createAdPostViewModel
                              .changeAdPostCategoryIndex(index);
                          if (index == 0) {
                            if (businessIndex == 1 &&
                                businessViewModel.classifiedBusinessProfile
                                        .verificationStatus !=
                                    "Verified") {
                              helper.showToast(
                                  'You don\'t have business account, please go to profile and create it.');
                            } else if (businessIndex == 1 && businessViewModel
                                    .classifiedBusinessProfile
                                    .isBusinessActive ==
                                false) {
                              helper.showToast(
                                  'You have business account, Please enable your active mode.');
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllCategoriesScreen(
                                    categoryIndex: index,
                                    categoryTitle:
                                        categoryList[index].categoryTitle,
                                    isAddPost: widget.isAddPost,
                                  ),
                                ),
                              );
                            }
                          } else if (index == 1) {
                            if (businessIndex == 1 &&
                                businessViewModel.propertyBusinessProfile
                                        .verificationStatus !=
                                    "Verified") {
                              helper.showToast(
                                  'You don\'t have business account, please go to profile and create it.');
                            } else if (businessIndex == 1 && businessViewModel
                                .classifiedBusinessProfile
                                .isBusinessActive ==
                                false) {
                              helper.showToast(
                                  'You have business account, Please enable your active mode.');
                            }
                            // else if (businessViewModel
                            //         .classifiedBusinessProfile
                            //         .isBusinessActive ==
                            //     false) {
                            //   helper.showToast(
                            //       'You have business account, Please enable your active mode.');
                            // }
                            else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllCategoriesScreen(
                                    categoryIndex: index,
                                    categoryTitle:
                                        categoryList[index].categoryTitle,
                                    isAddPost: true,
                                  ),
                                ),
                              );
                            }
                          } else if (index == 2) {
                            if (businessIndex == 1 &&
                                businessViewModel.automotiveBusinessProfile
                                        .verificationStatus !=
                                    "Verified") {
                              helper.showToast(
                                  'You don\'t have business account, please go to profile and create it.');
                            }  else if (businessIndex == 1 && businessViewModel
                                .classifiedBusinessProfile
                                .isBusinessActive ==
                                false) {
                              helper.showToast(
                                  'You have business account, Please enable your active mode.');
                            }
                            // else if (businessViewModel
                            //         .classifiedBusinessProfile
                            //         .isBusinessActive ==
                            //     false) {
                            //   helper.showToast(
                            //       'You have business account, Please enable your active mode.');
                            // }
                            else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllCategoriesScreen(
                                            categoryIndex: index,
                                            categoryTitle: categoryList[index]
                                                .categoryTitle,
                                            isAddPost: true,
                                          )));
                            }
                          } else if (index == 3) {
                            if (businessIndex == 1 &&
                                businessViewModel.jobBusinessProfile
                                        .verificationStatus !=
                                    "Verified") {
                              helper.showToast(
                                  'You don\'t have business account, please go to profile and create it.');
                            } else if (businessIndex == 1 && businessViewModel
                                .classifiedBusinessProfile
                                .isBusinessActive ==
                                false) {
                              helper.showToast(
                                  'You have business account, Please enable your active mode.');
                            }
                            // else if (businessViewModel
                            //         .classifiedBusinessProfile
                            //         .isBusinessActive ==
                            //     false) {
                            //   helper.showToast(
                            //       'You have business account, Please enable your active mode.');
                            // }
                            else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllCategoriesScreen(
                                          categoryIndex: index,
                                          categoryTitle:
                                              categoryList[index].categoryTitle,
                                          isAddPost: widget.isAddPost)));
                            }
                          }
                        }
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllCategoriesScreen(
                                      categoryIndex: index,
                                      categoryTitle:
                                          categoryList[index].categoryTitle,
                                      isAddPost: widget.isAddPost)));
                        },
                  child: Card(
                    elevation: 2,
                    shadowColor: CustomAppTheme().lightGreyColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        Center(
                          child: SvgPicture.asset(
                            categoryList[index].svgIconUrl,
                            height: med.height * 0.08,
                            width: med.width * 0.2,
                          ),
                        ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: AutoSizeText(
                            categoryList[index].categoryTitle,
                            maxLines: 1,
                            minFontSize: 18,
                            overflow: TextOverflow.ellipsis,
                            style: CustomAppTheme()
                                .boldNormalText
                                .copyWith(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: med.height * 0.01,
                        ),
                        businessIndex == 0
                            ? Container()
                            : index == 0
                                ? Text(
                                    classifiedStatus ??
                                        "No Account",
                                    style: TextStyle(
                                        color: classifiedStatus ==
                                                "Pending"
                                            ? Colors.orange
                                            : businessViewModel
                                                        .classifiedBusinessProfile
                                                        .verificationStatus ==
                                                    "Rejected"
                                                ? Colors.red
                                                : classifiedStatus  ==
                                                        "Verified"
                                                    ? Colors.green
                                                    : CustomAppTheme()
                                                        .greyColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  )
                                : index == 1
                                    ? Text(
                                        businessViewModel
                                                .propertyBusinessProfile
                                                .verificationStatus ??
                                            "No Account",
                                        style: TextStyle(
                                            color: businessViewModel
                                                        .propertyBusinessProfile
                                                        .verificationStatus ==
                                                    "Pending"
                                                ? Colors.orange
                                                : businessViewModel
                                                            .propertyBusinessProfile
                                                            .verificationStatus ==
                                                        "Rejected"
                                                    ? Colors.red
                                                    : businessViewModel
                                                                .propertyBusinessProfile
                                                                .verificationStatus ==
                                                            "Verified"
                                                        ? Colors.green
                                                        : CustomAppTheme()
                                                            .greyColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : index == 1
                                        ? Text(
                                            businessViewModel
                                                    .automotiveBusinessProfile
                                                    .verificationStatus ??
                                                "No Account",
                                            style: TextStyle(
                                                color: businessViewModel
                                                            .automotiveBusinessProfile
                                                            .verificationStatus ==
                                                        "Pending"
                                                    ? Colors.orange
                                                    : businessViewModel
                                                                .automotiveBusinessProfile
                                                                .verificationStatus ==
                                                            "Rejected"
                                                        ? Colors.red
                                                        : businessViewModel
                                                                    .automotiveBusinessProfile
                                                                    .verificationStatus ==
                                                                "Verified"
                                                            ? Colors.green
                                                            : CustomAppTheme()
                                                                .greyColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                          )
                                        : Text(
                                            businessViewModel.jobBusinessProfile
                                                    .verificationStatus ??
                                                "No Account",
                                            style: TextStyle(
                                                color: businessViewModel
                                                            .jobBusinessProfile
                                                            .verificationStatus ==
                                                        "Pending"
                                                    ? Colors.orange
                                                    : businessViewModel
                                                                .jobBusinessProfile
                                                                .verificationStatus ==
                                                            "Rejected"
                                                        ? Colors.red
                                                        : businessViewModel
                                                                    .jobBusinessProfile
                                                                    .verificationStatus ==
                                                                "Verified"
                                                            ? Colors.green
                                                            : CustomAppTheme()
                                                                .greyColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                          )
                        // Text(
                        //   businessViewModel
                        //           .jobBusinessProfile.verificationStatus ??
                        //       "No Account",
                        //   style: TextStyle(
                        //                           color: businessViewModel
                        //                                       .classifiedBusinessProfile
                        //                                       .verificationStatus ==
                        //                                   "Pending"
                        //                               ? Colors.orange
                        //                               : businessViewModel
                        //                                           .classifiedBusinessProfile
                        //                                           .verificationStatus ==
                        //                                       "Rejected"
                        //                                   ? Colors.red
                        //                                   : businessViewModel
                        //                                               .classifiedBusinessProfile
                        //                                               .verificationStatus ==
                        //                                           "Verified"
                        //                                       ? Colors.green
                        //                                       : CustomAppTheme()
                        //                                           .blackColor,
                        //                           fontSize: 15,
                        //                           fontWeight: FontWeight.w700): CustomAppTheme().normalGreyText.copyWith(
                        //       fontSize: 13, fontWeight: FontWeight.w500),
                        // ),
                        /*SizedBox(
                          height: med.height * 0.02,
                        ),*/
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
