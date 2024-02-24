import 'dart:convert';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/classified_res_models/classified_brands_res_model.dart';
import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/data/models/general_res_models/country_code_res_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/add_location_screen.dart';
import 'package:app/presentation/add_post/featured_ad.dart';
import 'package:app/presentation/add_post/job_include_detail_screen.dart';
import 'package:app/presentation/add_post/mixins/add_post_mixin.dart';
import 'package:app/presentation/add_post/review_your_ad_screen.dart';
import 'package:app/presentation/add_post/upload_images_videos.dart';
import 'package:app/presentation/add_post/view_model/create_ad_post_view_model.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/add_post/widgets/custom_ad_post_widgets.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/on_boarding/widgets/custom_page_route.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/drop_downs_widgets.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ClassifiedIncludeDetailScreen extends StatefulWidget {
  final int categoryIndex;
  final bool? isEdit;

  const ClassifiedIncludeDetailScreen(
      {Key? key, required this.categoryIndex, this.isEdit = false})
      : super(key: key);

  @override
  State<ClassifiedIncludeDetailScreen> createState() =>
      _ClassifiedIncludeDetailScreenState();
}

class _ClassifiedIncludeDetailScreenState
    extends State<ClassifiedIncludeDetailScreen> with AddPostMixin, BaseMixin {
  final borderSide = BorderSide(color: CustomAppTheme().greyColor, width: 1);
  List<String>? brandsList = [];
  List<String>? conditionList = ['Used', 'New'];
  String? currencyDropDownValue;
  String? dialCodeDropDownValue;
  String? brandValue;
  String? conditionValue;
  List<CountriesModel> countriesCodeList = [];
  List<AllCurrenciesModel> currenciesList = [];

  void getAllCountriesCode() async {
    final result = await context.read<GeneralViewModel>().getAllCountryCode();
    result.fold((l) {}, (r) {
      d('COUNTRIES CODE ***********************************');
      countriesCodeList = r.response!;
      d(countriesCodeList.toString());
      context.read<GeneralViewModel>().changeCountriesCode(r.response!);
      dialCodeDropDownValue = context.read<GeneralViewModel>().countriesCode[0];
      if (widget.isEdit == true) {
        currencyDropDownValue = context
                .read<CreateAdPostViewModel>()
                .classifiedAdData!
                .currencyCode!
                .isEmpty
            ? null
            : context
                .read<CreateAdPostViewModel>()
                .classifiedAdData!
                .currencyCode;
        selectedCurrency = currencyDropDownValue!;
      }
      setState(() {});
    });
  }

  void getAllCurrencies() async {
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    ClassifiedObject classifiedData = createAdPostViewModel.classifiedAdData!;
    final result = await context.read<GeneralViewModel>().getAllCurrencies();
    result.fold((l) {}, (r) {
      d('CURRENCIES ***********************************');
      currenciesList = r.response!;
      d(currenciesList.toString());
      context.read<GeneralViewModel>().changeCurrencies(r.response!);
      classifiedData.currencyId = r.response![0].id;
      currencyDropDownValue =
          context.read<GeneralViewModel>().currenciesList[0];
      if (widget.isEdit == true) {
        currencyDropDownValue = context
            .read<CreateAdPostViewModel>()
            .classifiedAdData!
            .currencyCode;
      }
      setState(() {});
    });
  }

  ClassifiedBrandsResModel? classifiedBrandsResModel;

  void getBrandsBySubCategory({required String subCategoryId}) async {
    try {
      var response = await http.get(
        Uri.parse(
            "https://services-dev.youonline.online/api/get_brands_by_subcategory"),
      );
      d('Brand List : ' + response.body.toString());
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        classifiedBrandsResModel = ClassifiedBrandsResModel.fromJson(jsonData);
        for (int i = 0; i < classifiedBrandsResModel!.response!.length; i++) {
          brandsList!
              .add(classifiedBrandsResModel!.response![i].title.toString());
        }
      } else {
        throw Exception();
      }
    } catch (e) {}
    setState(() {});
    // final result = await context
    //     .read<ClassifiedViewModel>()
    //     .getBrandsBySubCategory(subCategoryId: subCategoryId);
    // result.fold((l) {}, (r) {
    //   d('***********************************');
    //   context
    //       .read<ClassifiedViewModel>()
    //       .changeBrandsBySubCategory(r.response!);
    //   for (int i = 0; i < r.response!.length; i++) {
    //     brandsList!.add(r.response![i].title.toString());
    //   }
    //   d(brandsList.toString());
    //   if (widget.isEdit == true) {
    //     brandValue =
    //         context.read<CreateAdPostViewModel>().classifiedAdData!.brandName;
    //   }
    //   setState(() {});
    // });
  }

  setClassifiedValues() {
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    ClassifiedObject classifiedData = createAdPostViewModel.classifiedAdData!;
    addTitleController.text = classifiedData.title!;
    priceController.text = classifiedData.price.toString();
    isProductNew = classifiedData.conditionType! == 'New' ? true : false;
    descriptionController.text = classifiedData.description!;

    phoneController.text = classifiedData.phoneNumber!;
    d('Brand Value : ' + classifiedData.brandName.toString());
    d('DIAL CODE : ${classifiedData.dialCode}');
    brandValue = brandsList!.isEmpty ? null : classifiedData.brandName!;
    if (widget.isEdit!) {
      brandValue = classifiedData.brandName!;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isProductNew = conditionValue == '' ? true : false;
    final generalViewModel = context.read<GeneralViewModel>();
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    ClassifiedObject classifiedData = createAdPostViewModel.classifiedAdData!;
    getBrandsBySubCategory(
        subCategoryId:
            createAdPostViewModel.classifiedAdData!.subCategoryId.toString());
    if (generalViewModel.countriesCodeList.isEmpty) {
      getAllCountriesCode();
    } else {
      d('COUNTRIES LIST : ' + generalViewModel.countriesCodeList.toString());
      if (classifiedData.adType == 'Company') {
        dialCodeDropDownValue =
            iPrefHelper.retrieveClassifiedProfile()!.dialCode.toString();
        classifiedData.dialCode =
            iPrefHelper.retrieveClassifiedProfile()!.dialCode.toString();
      } else {
        dialCodeDropDownValue = null;
        dialCodeDropDownValue =
            context.read<GeneralViewModel>().countriesCodeList[0].dialCode;
        classifiedData.dialCode =
            context.read<GeneralViewModel>().countriesCodeList[0].name;
      }
    }
    if (generalViewModel.allCurrenciesList.isEmpty) {
      getAllCurrencies();
    } else {
      d('CURRENCIES LIST : ' + generalViewModel.allCurrenciesList.toString());
      currencyDropDownValue =
          context.read<GeneralViewModel>().currenciesList[0];
      classifiedData.currencyId = generalViewModel.allCurrenciesList[0].id;
    }

    if (widget.isEdit == true) {
      if (widget.categoryIndex == 0) {
        setClassifiedValues();
      }
    }

    if (classifiedData.adType == 'Company') {
      phoneController.text =
          iPrefHelper.retrieveClassifiedProfile()!.phone.toString();
      classifiedData.streetAddress =
          iPrefHelper.retrieveClassifiedProfile()!.streetAddress.toString();
      classifiedData.latitude =
          iPrefHelper.retrieveClassifiedProfile()!.latitude.toString();
      classifiedData.longitude =
          iPrefHelper.retrieveClassifiedProfile()!.longitude.toString();
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    final CreateAdPostViewModel createAdPostViewModel =
        context.watch<CreateAdPostViewModel>();
    final ClassifiedViewModel classifiedViewModel =
        context.watch<ClassifiedViewModel>();
    final GeneralViewModel generalViewModel = context.watch<GeneralViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Step 2 of 4', context: context, onTap: () {Navigator.of(context).pop();}),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                titleWithText(
                    title: 'Include Some Details',
                    text: 'Add basic information about your ad'),
                SizedBox(
                  height: med.height * 0.03,
                ),
                YouOnlineTextField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please enter title';
                      } else {
                        return null;
                      }
                    },
                    headingText: 'Ad Title*',
                    hintText: 'Type ad title to post',
                    controller: addTitleController),
                SizedBox(
                  height: med.height * 0.025,
                ),
                Text(
                  'Set Price*',
                  style: CustomAppTheme().textFieldHeading,
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Container(
                    color: Colors.transparent,
                    // height: med.height * 0.047,
                    height: 58,
                    width: med.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /*currencyDropDown(),*/
                        Container(
                          height: 35,
                          child: currencyDropDown(
                              onChange: (value) {
                                setState(
                                  () {
                                    currencyDropDownValue = value!;
                                    ClassifiedObject classifiedData =
                                        createAdPostViewModel.classifiedAdData!;
                                    for (int i = 0;
                                        i <
                                            generalViewModel
                                                .allCurrenciesList.length;
                                        i++) {
                                      if (generalViewModel
                                              .allCurrenciesList[i].code ==
                                          value) {
                                        classifiedData.currencyId =
                                            generalViewModel
                                                .allCurrenciesList[i].id;
                                        classifiedData.currencyCode =
                                            generalViewModel
                                                .allCurrenciesList[i].code;
                                        selectedCurrency = generalViewModel
                                            .allCurrenciesList[i].code!;
                                      }
                                    }
                                  },
                                );
                              },
                              currencyDropDownValue: currencyDropDownValue,
                              context: context),
                        ),
                        SizedBox(
                          width: med.width * 0.01,
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 58,
                            child: YouOnlineNumberField(
                                keyboardType: TextInputType.number,
                                hasHeading: false,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'please enter price';
                                  } else {
                                    return null;
                                  }
                                },
                                headingText: '',
                                hintText: 'Enter price',
                                controller: priceController),
                          ),
                        ),
                        // Expanded(
                        //   child: TextFormField(
                        //     validator: (val) {
                        //       if(val!.isEmpty) {
                        //         return 'please enter price';
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //     controller: priceController,
                        //     autocorrect: true,
                        //     maxLines: 1,
                        //     keyboardType: TextInputType.number,
                        //     cursorColor: CustomAppTheme().blackColor,
                        //     decoration: const InputDecoration(
                        //       errorBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(6.0)),
                        //         borderSide: BorderSide(color: Color(0xffa3a8b6)),
                        //       ),
                        //       focusedErrorBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(6.0)),
                        //         borderSide: BorderSide(color: Color(0xffa3a8b6)),
                        //       ),
                        //       isDense: true,
                        //       contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        //       hintText: 'Enter price',
                        //       hintStyle:
                        //           TextStyle(color: Colors.grey, fontSize: 14),
                        //       filled: true,
                        //       fillColor: Colors.white70,
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(6.0)),
                        //         borderSide: BorderSide(color: Color(0xffa3a8b6)),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(6.0)),
                        //         borderSide: BorderSide(color: Colors.grey),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   height: med.height * 0.02,
                // ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Brands',
                      style: CustomAppTheme().textFieldHeading,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        height: med.height * 0.047,
                        width: med.width,
                        child: PopupMenuButton(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          offset: const Offset(0, 40),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 1, color: const Color(0xffa3a8b6)),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 14.0, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(brandValue == null ? "Select Brand*" : brandValue!, style: brandValue == null ? const TextStyle(color: Colors.grey, fontSize: 14) : const TextStyle(color: Colors.black, fontSize: 14)),
                                    Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onSelected: (value) {
                            // your logic

                                        setState(
                                          () {
                                            brandValue = value;
                                            ClassifiedObject classifiedAdData =
                                                createAdPostViewModel.classifiedAdData!;
                                            for (int i = 0;
                                                i <
                                                    classifiedBrandsResModel!
                                                        .response!.length;
                                                i++) {
                                              if (value ==
                                                  classifiedBrandsResModel!
                                                      .response![i].title) {
                                                d('VALUE: $value AND TITLE: ${classifiedBrandsResModel!.response![i].title}');
                                                classifiedAdData.brandId =
                                                    classifiedBrandsResModel!
                                                        .response![i].id;
                                                d('VALUE: $value AND ID: ${classifiedBrandsResModel!.response![i].id}');
                                              }
                                            }
                                          },
                                        );



                            // setState(() {
                            //
                            //   brandValue = value;
                            //   for (int i = 0;
                            //   i < generalViewModel.userCities.length;
                            //   i++) {
                            //     print("hhahahahahahahahah");
                            //     print(generalViewModel.userCities[i].name);
                            //     if (value ==
                            //         generalViewModel.userCities[i].name) {
                            //       print(generalViewModel.userCities[i].id);
                            //       // getLocatedByCityID(
                            //       //     cityID: generalViewModel
                            //       //         .userCities[i].id
                            //       //         .toString());
                            //       print("above id id");
                            //       print(generalViewModel.userCities[i].name);
                            //       print("above id name");
                            //       print("this is city id :: :: ===");
                            //       print("this is value :: $value");
                            //       d('VALUE: $value AND TITLE: ${generalViewModel.userCities[i]}');
                            //       createAdPostViewModel
                            //           .propertyAdData!.cityId =
                            //           generalViewModel.userCities[i].id;
                            //       d('VALUE: $value AND ID: ${generalViewModel.userCities[i].id}');
                            //     }
                            //   }
                            //
                            // });
                          },
                          constraints: BoxConstraints(
                              minWidth: med.width - 30,
                              maxWidth: MediaQuery.of(context).size.width - 30,
                              maxHeight: 350
                          ),
                          itemBuilder: (BuildContext bc) {
                            return List.generate(brandsList!.length, (index) {
                              return PopupMenuItem(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: SizedBox(
                                  width: med.width - 30,
                                  child: Text(
                                    brandsList![index],
                                    style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                                  ),
                                ),
                                value: brandsList![index],
                              );
                            }

                            );

                          },
                        ),
                      ),
                    ),
                  ],
                ),


                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     Text(
                //       'Brands',
                //       style: CustomAppTheme().textFieldHeading,
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 5),
                //       child: SizedBox(
                //         height: med.height * 0.047,
                //         width: med.width,
                //         child: brandDropDown(
                //           itemsList: brandsList!,
                //           brandDropDownValue: brandValue,
                //           onChange: (value) {
                //             setState(
                //               () {
                //                 brandValue = value;
                //                 ClassifiedObject classifiedAdData =
                //                     createAdPostViewModel.classifiedAdData!;
                //                 for (int i = 0;
                //                     i <
                //                         classifiedBrandsResModel!
                //                             .response!.length;
                //                     i++) {
                //                   if (value ==
                //                       classifiedBrandsResModel!
                //                           .response![i].title) {
                //                     d('VALUE: $value AND TITLE: ${classifiedBrandsResModel!.response![i].title}');
                //                     classifiedAdData.brandId =
                //                         classifiedBrandsResModel!
                //                             .response![i].id;
                //                     d('VALUE: $value AND ID: ${classifiedBrandsResModel!.response![i].id}');
                //                   }
                //                 }
                //               },
                //             );
                //           },
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: med.height * 0.025,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Condition',
                      style: CustomAppTheme().textFieldHeading,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        height: med.height * 0.047,
                        width: med.width,
                        child: PopupMenuButton(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          offset: const Offset(0, 40),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 1, color: const Color(0xffa3a8b6)),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 14.0, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(conditionValue == null ? "Select value" : conditionValue!, style: conditionValue == null ? const TextStyle(color: Colors.grey, fontSize: 14) : const TextStyle(color: Colors.black, fontSize: 14)),
                                    Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onSelected: (value) {
                            // your logic
                            setState(() {
                              // conditionValue = value;
                              conditionValue = value;
                              isProductNew = conditionValue == 'New' ? true : false;
                            });
                          },
                          constraints: BoxConstraints(
                            minWidth: med.width - 30,
                            maxWidth: MediaQuery.of(context).size.width - 30,
                          ),
                          itemBuilder: (BuildContext bc) {
                            return List.generate(2, (index) {
                              return    PopupMenuItem(
                                child: SizedBox(
                                  width: med.width - 30,
                                  child: Text(
                                    conditionList![index],
                                    style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                                  ),
                                ),
                                value: '${conditionList![index]}',
                              );
                            }

                            );

                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     Text(
                //       'Condition',
                //       style: CustomAppTheme().textFieldHeading,
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 5),
                //       child: SizedBox(
                //         height: med.height * 0.047,
                //         width: med.width,
                //         child: conditionDropdown(
                //           itemsList: conditionList!,
                //           brandDropDownValue: conditionValue,
                //           onChange: (value) {
                //             setState(
                //                   () {
                //                     conditionValue = value;
                //                     isProductNew = conditionValue == 'New' ? true : false;
                //                 // ClassifiedObject classifiedAdData =
                //                 // createAdPostViewModel.classifiedAdData!;
                //                 // for (int i = 0;
                //                 // i <
                //                 //     classifiedBrandsResModel!
                //                 //         .response!.length;
                //                 // i++) {
                //                 //   if (value ==
                //                 //       classifiedBrandsResModel!
                //                 //           .response![i].title) {
                //                 //     d('VALUE: $value AND TITLE: ${classifiedBrandsResModel!.response![i].title}');
                //                 //     classifiedAdData.brandId =
                //                 //         classifiedBrandsResModel!
                //                 //             .response![i].id;
                //                 //     d('VALUE: $value AND ID: ${classifiedBrandsResModel!.response![i].id}');
                //                 //   }
                //                 // }
                //               },
                //             );
                //           },
                //         ),
                //       ),
                //     ),
                //   ],
                // ),




                // Text(
                //   'Condition*',
                //   style: CustomAppTheme().textFieldHeading,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10),
                //   child: Row(
                //     children: <Widget>[
                //       GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             isProductNew = false;
                //           });
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: isProductNew == false
                //                 ? CustomAppTheme().lightGreenColor
                //                 : CustomAppTheme().lightGreyColor,
                //             border: Border.all(
                //                 color: isProductNew == false
                //                     ? CustomAppTheme().primaryColor
                //                     : CustomAppTheme().greyColor),
                //             borderRadius: BorderRadius.circular(20),
                //           ),
                //           child: Padding(
                //             padding: const EdgeInsets.symmetric(
                //                 vertical: 5, horizontal: 15),
                //             child: Text(
                //               'Used',
                //               style: CustomAppTheme().normalText.copyWith(
                //                   fontWeight: isProductNew == false
                //                       ? FontWeight.w600
                //                       : FontWeight.w500,
                //                   color: isProductNew == false
                //                       ? CustomAppTheme().blackColor
                //                       : CustomAppTheme().greyColor),
                //             ),
                //           ),
                //         ),
                //       ),
                //       SizedBox(
                //         width: med.width * 0.02,
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             isProductNew = true;
                //           });
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: isProductNew
                //                 ? CustomAppTheme().lightGreenColor
                //                 : CustomAppTheme().lightGreyColor,
                //             border: Border.all(
                //                 color: isProductNew
                //                     ? CustomAppTheme().primaryColor
                //                     : CustomAppTheme().greyColor),
                //             borderRadius: BorderRadius.circular(20),
                //           ),
                //           child: Padding(
                //             padding: const EdgeInsets.symmetric(
                //                 vertical: 5, horizontal: 15),
                //             child: Text(
                //               'New',
                //               style: CustomAppTheme().normalText.copyWith(
                //                   fontWeight: isProductNew
                //                       ? FontWeight.w600
                //                       : FontWeight.w500,
                //                   color: isProductNew
                //                       ? CustomAppTheme().blackColor
                //                       : CustomAppTheme().greyColor),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: med.height * 0.025,
                ),
                YouOnlineTextField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please enter description';
                      } else {
                        return null;
                      }
                    },
                    headingText: 'Description*',
                    hintText: 'Describe what you are selling',
                    controller: descriptionController,
                    maxLine: 6),
                SizedBox(
                  height: med.height * 0.025,
                ),
                Text(
                  'Phone Number*',
                  style: CustomAppTheme().textFieldHeading,
                ),

                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Container(
                    color: Colors.transparent,
                    // height: med.height * 0.047,
                    height: 55,
                    width: med.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /*currencyDropDown(),*/
                        SizedBox(
                          height: 33,
                          child: countryCodeDropDown(
                            countryCodeDropDownValue: dialCodeDropDownValue,
                            onChange: (value) {
                              setState(() {
                                dialCodeDropDownValue = value!;
                                createAdPostViewModel.classifiedAdData!
                                    .dialCode = dialCodeDropDownValue;
                              });
                            },
                            context: context,
                          ),
                        ),

                        // currencyDropDown(
                        //     onChange: (value) {
                        //       setState(
                        //             () {
                        //           currencyDropDownValue = value!;
                        //           ClassifiedObject classifiedData =
                        //           createAdPostViewModel.classifiedAdData!;
                        //           for (int i = 0;
                        //           i <
                        //               generalViewModel
                        //                   .allCurrenciesList.length;
                        //           i++) {
                        //             if (generalViewModel
                        //                 .allCurrenciesList[i].code ==
                        //                 value) {
                        //               classifiedData.currencyId = generalViewModel
                        //                   .allCurrenciesList[i].id;
                        //               classifiedData.currencyCode =
                        //                   generalViewModel
                        //                       .allCurrenciesList[i].code;
                        //               selectedCurency = generalViewModel
                        //                   .allCurrenciesList[i].code!;
                        //             }
                        //           }
                        //         },
                        //       );
                        //     },
                        //     currencyDropDownValue: currencyDropDownValue,
                        //     context: context),
                        SizedBox(
                          width: med.width * 0.01,
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 55,
                            child: YouOnlineNumberField(
                                keyboardType: TextInputType.number,
                                hasHeading: false,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'please enter phone number';
                                  } else {
                                    return null;
                                  }
                                },
                                headingText: '',
                                hintText: 'Enter mobile number',
                                controller: phoneController),
                          ),
                        ),
                        // Expanded(
                        //   child: TextFormField(
                        //     validator: (val) {
                        //       if(val!.isEmpty) {
                        //         return 'please enter price';
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //     controller: priceController,
                        //     autocorrect: true,
                        //     maxLines: 1,
                        //     keyboardType: TextInputType.number,
                        //     cursorColor: CustomAppTheme().blackColor,
                        //     decoration: const InputDecoration(
                        //       errorBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(6.0)),
                        //         borderSide: BorderSide(color: Color(0xffa3a8b6)),
                        //       ),
                        //       focusedErrorBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(6.0)),
                        //         borderSide: BorderSide(color: Color(0xffa3a8b6)),
                        //       ),
                        //       isDense: true,
                        //       contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        //       hintText: 'Enter price',
                        //       hintStyle:
                        //           TextStyle(color: Colors.grey, fontSize: 14),
                        //       filled: true,
                        //       fillColor: Colors.white70,
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(6.0)),
                        //         borderSide: BorderSide(color: Color(0xffa3a8b6)),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(6.0)),
                        //         borderSide: BorderSide(color: Colors.grey),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

                // ListTile(
                //   dense: true,
                //   contentPadding: EdgeInsets.zero,
                //   title: Container(
                //     color: Colors.transparent,
                //     // height: med.height * 0.047,
                //     height: 30,
                //     width: med.width,
                //     child: Row(
                //       children: <Widget>[
                //         countryCodeDropDown(
                //           countryCodeDropDownValue: dialCodeDropDownValue,
                //           onChange: (value) {
                //             setState(() {
                //               dialCodeDropDownValue = value!;
                //               createAdPostViewModel.classifiedAdData!.dialCode =
                //                   dialCodeDropDownValue;
                //             });
                //           },
                //           context: context,
                //         ),
                //         SizedBox(
                //           width: med.width * 0.01,
                //         ),
                //         // Expanded(
                //         //   child: TextFormField(
                //         //     validator: (val) {
                //         //       if(val!.isEmpty) {
                //         //         return 'please enter phone number';
                //         //       } else {
                //         //         return null;
                //         //       }
                //         //     },
                //         //     controller: phoneController,
                //         //     autocorrect: true,
                //         //     maxLines: 1,
                //         //     keyboardType: TextInputType.number,
                //         //     cursorColor: CustomAppTheme().blackColor,
                //         //     decoration: const InputDecoration(
                //         //       errorBorder: OutlineInputBorder(
                //         //         borderRadius:
                //         //             BorderRadius.all(Radius.circular(6.0)),
                //         //         borderSide: BorderSide(color: Color(0xffa3a8b6)),
                //         //       ),
                //         //       focusedErrorBorder: OutlineInputBorder(
                //         //         borderRadius:
                //         //             BorderRadius.all(Radius.circular(6.0)),
                //         //         borderSide: BorderSide(color: Color(0xffa3a8b6)),
                //         //       ),
                //         //       isDense: true,
                //         //       contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                //         //       hintText: 'Enter mobile number',
                //         //       hintStyle:
                //         //           TextStyle(color: Colors.grey, fontSize: 14),
                //         //       filled: true,
                //         //       fillColor: Colors.white70,
                //         //       enabledBorder: OutlineInputBorder(
                //         //         borderRadius:
                //         //             BorderRadius.all(Radius.circular(6.0)),
                //         //         borderSide: BorderSide(color: Color(0xffa3a8b6)),
                //         //       ),
                //         //       focusedBorder: OutlineInputBorder(
                //         //         borderRadius:
                //         //             BorderRadius.all(Radius.circular(6.0)),
                //         //         borderSide: BorderSide(color: Colors.grey),
                //         //       ),
                //         //     ),
                //         //   ),
                //         // ),
                //         Flexible(
                //           child: SizedBox(
                //             height: 55,
                //             child: YouOnlineNumberField(
                //                 keyboardType: TextInputType.number,
                //                 hasHeading: false,
                //                 validator: (val) {
                //                   if(val!.isEmpty) {
                //                     return 'please enter price';
                //                   } else {
                //                     return null;
                //                   }
                //                 },
                //                 headingText: '',
                //                 hintText: 'Enter price',
                //                 controller: priceController),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: med.height * 0.025,
                ),
                Text(
                  'Where\'s your placed located*',
                  style: CustomAppTheme().textFieldHeading,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CustomPageRoute(
                              child: AddLocationScreen(
                                categoryIndex: widget.categoryIndex,
                                location: createAdPostViewModel
                                        .classifiedAdData!.streetAddress ??
                                    "",
                              ),
                              direction: AxisDirection.left));
                    },
                    child: Container(
                      height: med.height * 0.047,
                      width: med.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: CustomAppTheme().greyColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 18),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: med.width * 0.7,
                              child: Text(
                                createAdPostViewModel.classifiedAdData ==
                                            null ||
                                        createAdPostViewModel.classifiedAdData
                                                ?.streetAddress ==
                                            null
                                    ? 'Set Location'
                                    : createAdPostViewModel
                                        .classifiedAdData!.streetAddress
                                        .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.keyboard_arrow_right,
                                color: CustomAppTheme().blackColor, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: med.height * 0.05,
                ),
                SizedBox(
                  width: med.width,
                  child: YouOnlineButton(
                    text: 'Next',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // if (addTitleController.text.isEmpty ||
                        //     priceController.text.isEmpty ||
                        //     descriptionController.text.isEmpty ||
                        //     phoneController.text.isEmpty ||
                        //     createAdPostViewModel.classifiedAdData == null ||
                        //     createAdPostViewMode l.classifiedAdData?.streetAddress ==
                        //         null)
                       //  if (brandValue == null) {
                       //    helper.showToast('Please select brands');
                       //  }
                       // else
                         if (createAdPostViewModel
                                .classifiedAdData?.streetAddress ==
                            null) {
                          helper.showToast('Please select your place');
                        } else {
                          ClassifiedObject classifiedData =
                              createAdPostViewModel.classifiedAdData!;
                          classifiedData.title = addTitleController.text;
                          classifiedData.price =
                              double.parse(priceController.text);
                          classifiedData.conditionType =
                              isProductNew ? 'New' : 'Used';
                          classifiedData.description =
                              descriptionController.text;
                          classifiedData.phoneNumber = phoneController.text;
                          classifiedData.brandName = brandValue.toString();
                          Navigator.push(context, CustomPageRoute(child: ReviewYourAd(categoryIndex: widget.categoryIndex), direction: AxisDirection.left));

                          // Navigator.push(
                          //     context,
                          //     CustomPageRoute(
                          //         child: FeaturedYourAd(
                          //             categoryIndex: widget.categoryIndex),
                          //         direction: AxisDirection.left));
                        }
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: med.height * 0.03,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
