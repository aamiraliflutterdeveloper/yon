import 'package:app/common/logger/log.dart';
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
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/on_boarding/widgets/custom_page_route.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/drop_downs_widgets.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AutomotiveIncludeDetails extends StatefulWidget {
  final int categoryIndex;
  final bool? isEdit;

  const AutomotiveIncludeDetails(
      {Key? key, required this.categoryIndex, this.isEdit = false})
      : super(key: key);

  @override
  State<AutomotiveIncludeDetails> createState() =>
      _AutomotiveIncludeDetailsState();
}

class _AutomotiveIncludeDetailsState extends State<AutomotiveIncludeDetails>
    with AddPostMixin, BaseMixin {
  String? makeDropDownValue;
  String? modelDropDownValue;
  int fuelTypeIndex = 0;
  int transmissionIndex = 0;
  int conditionIndex = 0;
  String? priceDropDownValue;
  String? countryCodeDropDownValue;
  String? colorDropDownValue;
  String? automaticTypeDropDownValue;
  String? rentHourDropDownValue;
  List<CountriesModel> countriesCodeList = [];
  List<AllCurrenciesModel> currenciesList = [];
  List<String> colorList = [
    "Black",
    "White",
    "Red",
    "Green",
    "Yellow",
    "Blue",
    "Pink",
    "Gray",
    "Brown",
    "Orange",
    "Purple",
    "Other"
  ];

  List<String> rentHoursList = [
    "12Hours",
    "24Hours",
    "36Hours",
    "48Hours",
  ];

  void getAllCountriesCode() async {
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    final result = await context.read<GeneralViewModel>().getAllCountryCode();
    result.fold((l) {}, (r) {
      d('COUNTRIES CODE ***********************************');
      countriesCodeList = r.response!;
      d(countriesCodeList.toString());
      context.read<GeneralViewModel>().changeCountriesCode(r.response!);
      countryCodeDropDownValue =
          context.read<GeneralViewModel>().countriesCode[0];
      createAdPostViewModel.automotiveAdData!.dialCode =
          context.read<GeneralViewModel>().countriesCode[0];
      setState(() {});
    });
  }

  void getAllCurrencies() async {
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    final result = await context.read<GeneralViewModel>().getAllCurrencies();
    result.fold((l) {}, (r) {
      d('CURRENCIES ***********************************');
      currenciesList = r.response!;
      d(currenciesList.toString());
      context.read<GeneralViewModel>().changeCurrencies(r.response!);
      priceDropDownValue = context.read<GeneralViewModel>().currenciesList[0];
      createAdPostViewModel.automotiveAdData!.currencyId = r.response![0].id;
      setState(() {});
    });
  }

  void getBrandsById({String? subCategoryId}) async {
    d('SUB CAT ID : $subCategoryId');
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    final result = await context
        .read<AutomotiveViewModel>()
        .getAutomotiveBrandsById(subCategoryId: subCategoryId ,categoryId: createAdPostViewModel.automotiveAdData?.categoryId.toString() );
    print("google");
    result.fold((l) {}, (r) {
      d('BRANDS BY ID ***********************************');
      context
          .read<AutomotiveViewModel>()
          .changeAutomotiveBrandsById(r.response!);
      print("yahooooo");
      if (widget.isEdit!) {
        makeDropDownValue = createAdPostViewModel.automotiveAdData!.makeName;
        d('MAKE ID ::: ${createAdPostViewModel.automotiveAdData!.makeId!}');
        getModelsByBrand(
            brandId: createAdPostViewModel.automotiveAdData!.makeId!);
      } else {
        makeDropDownValue = r.response![0].title;
        print(r.response![0].title);
        print("this is title inside ");
        createAdPostViewModel.automotiveAdData!.makeId = r.response![0].id;
        createAdPostViewModel.automotiveAdData!.makeName = r.response![0].title;
        getModelsByBrand(brandId: r.response![0].id!);
      }
      setState(() {});
    });
  }

  void getModelsByBrand({required String brandId}) async {
    d('BRAND ID : $brandId');
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    final AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    final result = await context
        .read<AutomotiveViewModel>()
        .getAutomotiveModelsByBrand(brandId: brandId);
    result.fold((l) {}, (r) {
      d('MODELS BY BRAND *********************************** ${r.response![0].title}');
      context
          .read<AutomotiveViewModel>()
          .changeAutomotiveModelsByBrand(r.response!);
      // modelDropDownValue = r.response![0].title;
      if (widget.isEdit!) {
        modelDropDownValue = createAdPostViewModel.automotiveAdData!.modelName;
        d('MODEL : ${createAdPostViewModel.automotiveAdData!.modelName}');
      } else {
        createAdPostViewModel.automotiveAdData!.modelId = r.response![0].id;
        createAdPostViewModel.automotiveAdData!.modelName =
            r.response![0].title;
        d('modelDropDownValue: ' + modelDropDownValue.toString());
      }
      setState(() {});
    });
  }

  setAutomotiveValues() {
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    AutomotiveObject automotiveObject = createAdPostViewModel.automotiveAdData!;
    addTitleController.text = automotiveObject.title!;
    priceController.text = automotiveObject.price.toString();
    mileageController.text = automotiveObject.mileage.toString();
    yearController.text = automotiveObject.year.toString();
    descriptionController.text = automotiveObject.description!;
    phoneController.text = automotiveObject.phoneNumber!;
    colorDropDownValue = automotiveObject.color;
    automaticTypeDropDownValue = automotiveObject.automaticType;
    rentHourDropDownValue = automotiveObject.rentHours;

    print("***************************");
    print(automotiveObject.color);
    print(automotiveObject.automaticType);
    print(automotiveObject.rentHours);
    print("***************************");

    for (int i = 0; i < fuelTypeList.length; i++) {
      if (automotiveObject.fuelType == fuelTypeList[i]) {
        fuelTypeIndex = i;
      }
    }
    for (int i = 0; i < transmissionList.length; i++) {
      if (automotiveObject.transmissionType == transmissionList[i]) {
        transmissionIndex = i;
      }
    }
    for (int i = 0; i < conditionList.length; i++) {
      if (automotiveObject.conditionType == conditionList[i]) {
        conditionIndex = i;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    final generalViewModel = context.read<GeneralViewModel>();
    if (generalViewModel.countriesCodeList.isEmpty) {
      getAllCountriesCode();
    } else {
      d('COUNTRIES LIST : ' + generalViewModel.countriesCodeList.toString());
      countryCodeDropDownValue =
          context.read<GeneralViewModel>().countriesCode[0];
      createAdPostViewModel.automotiveAdData!.dialCode =
          context.read<GeneralViewModel>().countriesCode[0];
    }
    if (generalViewModel.allCurrenciesList.isEmpty) {
      getAllCurrencies();
    } else {
      d('CURRENCIES LIST : ' + generalViewModel.allCurrenciesList.toString());
      priceDropDownValue = context.read<GeneralViewModel>().currenciesList[0];
      createAdPostViewModel.automotiveAdData!.currencyId =
          context.read<GeneralViewModel>().allCurrenciesList[0].id;
      selectedCurrency = priceDropDownValue!;
    }
    print(createAdPostViewModel.automotiveAdData!.currencyId);
    print("hahahahaha");
    getBrandsById(
      subCategoryId:
          context.read<CreateAdPostViewModel>().automotiveAdData!.subCategoryId,
    );
    if (widget.isEdit == true) {
      if (widget.categoryIndex == 2) {
        setAutomotiveValues();
      }
    }
  }

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final CreateAdPostViewModel createAdPostViewModel =
        context.watch<CreateAdPostViewModel>();
    final AutomotiveViewModel automotiveViewModel =
        context.watch<AutomotiveViewModel>();
    final GeneralViewModel generalViewModel = context.watch<GeneralViewModel>();
    Size med = MediaQuery.of(context).size;
    print(automotiveViewModel.automotiveBrands!.length);
    print(context.read<AutomotiveViewModel>().automotiveBrandsList!.length);
    print("this is length of the array :: :: :: === === === == === == ");
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
                    height: 55,
                    width: med.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: currencyDropDown(
                            onChange: (value) {
                              setState(() {
                                priceDropDownValue = value!;
                                AutomotiveObject automotiveData =
                                    createAdPostViewModel.automotiveAdData!;
                                for (int i = 0;
                                    i <
                                        generalViewModel
                                            .allCurrenciesList.length;
                                    i++) {
                                  if (generalViewModel
                                          .allCurrenciesList[i].code ==
                                      value) {
                                    selectedCurrency = generalViewModel
                                        .allCurrenciesList[i].code!;
                                    automotiveData.currencyId = generalViewModel
                                        .allCurrenciesList[i].id;
                                  }
                                }
                              });
                            },
                            currencyDropDownValue: priceDropDownValue,
                            context: context,
                          ),
                        ),
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
                //   height: med.height * 0.025,
                // ),




                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Make*',
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
                                    Text(makeDropDownValue == null ? "Select Make" : makeDropDownValue!, style: makeDropDownValue == null ? const TextStyle(color: Colors.grey, fontSize: 14) : const TextStyle(color: Colors.black, fontSize: 14)),
                                    Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onSelected: (value) {
                            // your logic
                            // setState(() {

                                        setState(() {
                                          makeDropDownValue = value;
                                          for (int i = 0;
                                              i <
                                                  automotiveViewModel
                                                      .automotiveBrands!.length;
                                              i++) {
                                            d('VALUE : $value AND LIST VALUE : ${automotiveViewModel.automotiveBrands![i].title}');
                                            if (value ==
                                                automotiveViewModel
                                                    .automotiveBrands![i].title) {
                                              createAdPostViewModel
                                                      .automotiveAdData!.makeId =
                                                  automotiveViewModel
                                                      .automotiveBrands![i].id;
                                              getModelsByBrand(
                                                  brandId: automotiveViewModel
                                                      .automotiveBrands![i].id!);
                                            }
                                          }
                                        });

                              // makeDropDownValue = value;
                              // for (int i = 0;
                              // i < generalViewModel.userCities.length;
                              // i++) {
                              //   print("hhahahahahahahahah");
                              //   print(generalViewModel.userCities[i].name);
                              //   if (value ==
                              //       generalViewModel.userCities[i].name) {
                              //     print(generalViewModel.userCities[i].id);
                              //     // getLocatedByCityID(
                              //     //     cityID: generalViewModel
                              //     //         .userCities[i].id
                              //     //         .toString());
                              //     print("above id id");
                              //     print(generalViewModel.userCities[i].name);
                              //     print("above id name");
                              //     print("this is city id :: :: ===");
                              //     print("this is value :: $value");
                              //     d('VALUE: $value AND TITLE: ${generalViewModel.userCities[i]}');
                              //     createAdPostViewModel
                              //         .propertyAdData!.cityId =
                              //         generalViewModel.userCities[i].id;
                              //     d('VALUE: $value AND ID: ${generalViewModel.userCities[i].id}');
                              //   }
                              // }

                            // });
                          },
                          constraints: BoxConstraints(
                              minWidth: med.width - 30,
                              maxWidth: MediaQuery.of(context).size.width - 30,
                              maxHeight: 350
                          ),
                          itemBuilder: (BuildContext bc) {
                            return List.generate(context
                                .read<AutomotiveViewModel>()
                                .automotiveBrandsList!.length, (index) {
                              return PopupMenuItem(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: SizedBox(
                                  width: med.width - 30,
                                  child: Text(
                                    context
                                        .read<AutomotiveViewModel>()
                                        .automotiveBrandsList![index],
                                    style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                                  ),
                                ),
                                value: context
                                    .read<AutomotiveViewModel>()
                                    .automotiveBrandsList![index],
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
                //       'Make*',
                //       style: CustomAppTheme().textFieldHeading,
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 5),
                //       child: SizedBox(
                //         height: med.height * 0.047,
                //         width: med.width,
                //         child: makeDropDown(
                //           itemsList: [],
                //           makeDropDownValue: makeDropDownValue,
                //           onChange: (value) {
                //             setState(() {
                //               makeDropDownValue = value!;
                //               for (int i = 0;
                //                   i <
                //                       automotiveViewModel
                //                           .automotiveBrands!.length;
                //                   i++) {
                //                 d('VALUE : $value AND LIST VALUE : ${automotiveViewModel.automotiveBrands![i].title}');
                //                 if (value ==
                //                     automotiveViewModel
                //                         .automotiveBrands![i].title) {
                //                   createAdPostViewModel
                //                           .automotiveAdData!.makeId =
                //                       automotiveViewModel
                //                           .automotiveBrands![i].id;
                //                   getModelsByBrand(
                //                       brandId: automotiveViewModel
                //                           .automotiveBrands![i].id!);
                //                 }
                //               }
                //             });
                //           },
                //           context: context,
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
                      'Model*',
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
                                    Text(modelDropDownValue == null ? "Select Model" : modelDropDownValue!, style: modelDropDownValue == null ? const TextStyle(color: Colors.grey, fontSize: 14) : const TextStyle(color: Colors.black, fontSize: 14)),
                                    Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onSelected: (value) {
                            // your logic
                            // setState(() {

                          setState(() {
                            modelDropDownValue = value;
                          });

                            // makeDropDownValue = value;
                            // for (int i = 0;
                            // i < generalViewModel.userCities.length;
                            // i++) {
                            //   print("hhahahahahahahahah");
                            //   print(generalViewModel.userCities[i].name);
                            //   if (value ==
                            //       generalViewModel.userCities[i].name) {
                            //     print(generalViewModel.userCities[i].id);
                            //     // getLocatedByCityID(
                            //     //     cityID: generalViewModel
                            //     //         .userCities[i].id
                            //     //         .toString());
                            //     print("above id id");
                            //     print(generalViewModel.userCities[i].name);
                            //     print("above id name");
                            //     print("this is city id :: :: ===");
                            //     print("this is value :: $value");
                            //     d('VALUE: $value AND TITLE: ${generalViewModel.userCities[i]}');
                            //     createAdPostViewModel
                            //         .propertyAdData!.cityId =
                            //         generalViewModel.userCities[i].id;
                            //     d('VALUE: $value AND ID: ${generalViewModel.userCities[i].id}');
                            //   }
                            // }

                            // });
                          },
                          constraints: BoxConstraints(
                              minWidth: med.width - 30,
                              maxWidth: MediaQuery.of(context).size.width - 30,
                              maxHeight: 350
                          ),
                          itemBuilder: (BuildContext bc) {
                            return List.generate(context
                                .read<AutomotiveViewModel>()
                                .automotiveModelsByBrandList!.length, (index) {
                              return PopupMenuItem(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: SizedBox(
                                  width: med.width - 30,
                                  child: Text(
                                    context
                                        .read<AutomotiveViewModel>()
                                        .automotiveModelsByBrandList![index],
                                    style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                                  ),
                                ),
                                value: context
                                    .read<AutomotiveViewModel>()
                                    .automotiveModelsByBrandList![index],
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
                //       'Model*',
                //       style: CustomAppTheme().textFieldHeading,
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 5),
                //       child: SizedBox(
                //         height: med.height * 0.047,
                //         width: med.width,
                //         child: modelDropDown(
                //           modelDropDownValue: modelDropDownValue,
                //           onChange: (value) {
                //             setState(() {
                //               modelDropDownValue = value!;
                //             });
                //           },
                //           context: context,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: med.height * 0.025,
                ),
                YouOnlineTextField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please enter year';
                      } else {
                        return null;
                      }
                    },
                    headingText: 'Year*',
                    hintText: 'Enter year',
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                SizedBox(
                  height: med.height * 0.025,
                ),
                YouOnlineTextField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please enter KM\'s driven';
                      } else {
                        return null;
                      }
                    },
                    headingText: 'Mileage (KM)*',
                    hintText: 'Enter KM\'s driven',
                    controller: mileageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                SizedBox(
                  height: med.height * 0.025,
                ),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Color*',
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
                                    Text(colorDropDownValue == null ? "Select Color" : colorDropDownValue!, style: colorDropDownValue == null ? const TextStyle(color: Colors.grey, fontSize: 14) : const TextStyle(color: Colors.black, fontSize: 14)),
                                    Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onSelected: (value) {
                            // your logic
                           setState(() {
                             colorDropDownValue = value;
                             createAdPostViewModel.automotiveAdData!.color =
                                 value;
                           });

                            // makeDropDownValue = value;
                            // for (int i = 0;
                            // i < generalViewModel.userCities.length;
                            // i++) {
                            //   print("hhahahahahahahahah");
                            //   print(generalViewModel.userCities[i].name);
                            //   if (value ==
                            //       generalViewModel.userCities[i].name) {
                            //     print(generalViewModel.userCities[i].id);
                            //     // getLocatedByCityID(
                            //     //     cityID: generalViewModel
                            //     //         .userCities[i].id
                            //     //         .toString());
                            //     print("above id id");
                            //     print(generalViewModel.userCities[i].name);
                            //     print("above id name");
                            //     print("this is city id :: :: ===");
                            //     print("this is value :: $value");
                            //     d('VALUE: $value AND TITLE: ${generalViewModel.userCities[i]}');
                            //     createAdPostViewModel
                            //         .propertyAdData!.cityId =
                            //         generalViewModel.userCities[i].id;
                            //     d('VALUE: $value AND ID: ${generalViewModel.userCities[i].id}');
                            //   }
                            // }

                            // });
                          },
                          constraints: BoxConstraints(
                              minWidth: med.width - 30,
                              maxWidth: MediaQuery.of(context).size.width - 30,
                              maxHeight: 350
                          ),
                          itemBuilder: (BuildContext bc) {
                            return List.generate(colorList.length, (index) {
                              return PopupMenuItem(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: SizedBox(
                                  width: med.width - 30,
                                  child: Text(
                                    colorList[index],
                                    style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                                  ),
                                ),
                                value: colorList[index],
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
                //       'Color*',
                //       style: CustomAppTheme().textFieldHeading,
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 5),
                //       child: SizedBox(
                //         height: med.height * 0.047,
                //         width: med.width,
                //         child: brandDropDown(
                //           hint: "Select Color",
                //           itemsList: colorList,
                //           brandDropDownValue: colorDropDownValue,
                //           onChange: (value) {
                //             setState(
                //               () {
                //                 colorDropDownValue = value;
                //                 createAdPostViewModel.automotiveAdData!.color =
                //                     value;
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
                      'Automotive Type*',
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
                                    Text(automaticTypeDropDownValue == null ? "Select Automotive Type" : automaticTypeDropDownValue!, style: automaticTypeDropDownValue == null ? const TextStyle(color: Colors.grey, fontSize: 14) : const TextStyle(color: Colors.black, fontSize: 14)),
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
                                            automaticTypeDropDownValue = value;
                                            createAdPostViewModel
                                                .automotiveAdData!.automaticType = value;
                                          },
                                        );
                            // setState(() {
                            //   colorDropDownValue = value;
                            //   createAdPostViewModel.automotiveAdData!.color =
                            //       value;
                            // });

                            // makeDropDownValue = value;
                            // for (int i = 0;
                            // i < generalViewModel.userCities.length;
                            // i++) {
                            //   print("hhahahahahahahahah");
                            //   print(generalViewModel.userCities[i].name);
                            //   if (value ==
                            //       generalViewModel.userCities[i].name) {
                            //     print(generalViewModel.userCities[i].id);
                            //     // getLocatedByCityID(
                            //     //     cityID: generalViewModel
                            //     //         .userCities[i].id
                            //     //         .toString());
                            //     print("above id id");
                            //     print(generalViewModel.userCities[i].name);
                            //     print("above id name");
                            //     print("this is city id :: :: ===");
                            //     print("this is value :: $value");
                            //     d('VALUE: $value AND TITLE: ${generalViewModel.userCities[i]}');
                            //     createAdPostViewModel
                            //         .propertyAdData!.cityId =
                            //         generalViewModel.userCities[i].id;
                            //     d('VALUE: $value AND ID: ${generalViewModel.userCities[i].id}');
                            //   }
                            // }

                            // });
                          },
                          constraints: BoxConstraints(
                              minWidth: med.width - 30,
                              maxWidth: MediaQuery.of(context).size.width - 30,
                              maxHeight: 350
                          ),
                          itemBuilder: (BuildContext bc) {
                           List<String> rentList = ["Rent", "Sale"];
                            return List.generate(rentList.length, (index) {
                              return PopupMenuItem(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: SizedBox(
                                  width: med.width - 30,
                                  child: Text(
                                    rentList[index],
                                    style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                                  ),
                                ),
                                value: rentList[index],
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
                //       'Automotive Type*',
                //       style: CustomAppTheme().textFieldHeading,
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 5),
                //       child: SizedBox(
                //         height: med.height * 0.047,
                //         width: med.width,
                //         child: brandDropDown(
                //           hint: "Select Automotive Type",
                //           itemsList: ["Rent", "Sale"],
                //           brandDropDownValue: automaticTypeDropDownValue,
                //           onChange: (value) {
                //             setState(
                //               () {
                //                 automaticTypeDropDownValue = value;
                //                 createAdPostViewModel
                //                     .automotiveAdData!.automaticType = value;
                //               },
                //             );
                //           },
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                automaticTypeDropDownValue == "Rent"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: med.height * 0.025,
                          ),
                          Text(
                            'Rent Hours*',
                            style: CustomAppTheme().textFieldHeading,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: SizedBox(
                              height: med.height * 0.047,
                              width: med.width,
                              child: brandDropDown(
                                itemsList: rentHoursList,
                                hint: "Select Rent Hours",
                                brandDropDownValue: rentHourDropDownValue,
                                onChange: (value) {
                                  setState(
                                    () {
                                      rentHourDropDownValue = value;
                                      createAdPostViewModel
                                          .automotiveAdData!.rentHours = value;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: med.height * 0.025,
                ),
                Text(
                  'Fuel*',
                  style: CustomAppTheme().textFieldHeading,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 8.0,
                    children: <Widget>[
                      for (int index = 0; index < fuelTypeList.length; index++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              fuelTypeIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: fuelTypeIndex == index
                                  ? CustomAppTheme().lightGreenColor
                                  : CustomAppTheme().lightGreyColor,
                              border: Border.all(
                                  color: fuelTypeIndex == index
                                      ? CustomAppTheme().primaryColor
                                      : CustomAppTheme().greyColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Text(
                                fuelTypeList[index],
                                style: fuelTypeIndex == index
                                    ? CustomAppTheme().normalText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: CustomAppTheme().blackColor)
                                    : CustomAppTheme().normalText.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: CustomAppTheme().greyColor),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: med.height * 0.025,
                ),
                Text(
                  'Transmission*',
                  style: CustomAppTheme().textFieldHeading,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 8.0,
                    children: <Widget>[
                      for (int index = 0;
                          index < transmissionList.length;
                          index++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              transmissionIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: transmissionIndex == index
                                  ? CustomAppTheme().lightGreenColor
                                  : CustomAppTheme().lightGreyColor,
                              border: Border.all(
                                  color: transmissionIndex == index
                                      ? CustomAppTheme().primaryColor
                                      : CustomAppTheme().greyColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Text(
                                transmissionList[index],
                                style: transmissionIndex == index
                                    ? CustomAppTheme().normalText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: CustomAppTheme().blackColor)
                                    : CustomAppTheme().normalText.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: CustomAppTheme().greyColor),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: med.height * 0.025,
                ),
                Text(
                  'Condition*',
                  style: CustomAppTheme().textFieldHeading,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 8.0,
                    children: <Widget>[
                      for (int index = 0; index < conditionList.length; index++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              conditionIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: conditionIndex == index
                                  ? CustomAppTheme().lightGreenColor
                                  : CustomAppTheme().lightGreyColor,
                              border: Border.all(
                                  color: conditionIndex == index
                                      ? CustomAppTheme().primaryColor
                                      : CustomAppTheme().greyColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Text(
                                conditionList[index],
                                style: conditionIndex == index
                                    ? CustomAppTheme().normalText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: CustomAppTheme().blackColor)
                                    : CustomAppTheme().normalText.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: CustomAppTheme().greyColor),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
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
                    hintText: isPropertyForSale
                        ? 'Describe what you are selling'
                        : 'Describe what you are renting',
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
                        SizedBox(
                          height: 33,
                          child: countryCodeDropDown(
                              countryCodeDropDownValue:
                                  countryCodeDropDownValue,
                              onChange: (value) {
                                setState(() {
                                  countryCodeDropDownValue = value!;
                                  createAdPostViewModel.automotiveAdData!
                                      .dialCode = countryCodeDropDownValue;
                                });
                              },
                              context: context),
                        ),
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
                      ],
                    ),
                  ),
                ),
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
                                location: "",
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
                                createAdPostViewModel.automotiveAdData ==
                                            null ||
                                        createAdPostViewModel.automotiveAdData
                                                ?.streetAddress ==
                                            null
                                    ? 'Set Location'
                                    : createAdPostViewModel
                                        .automotiveAdData!.streetAddress
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
                          FocusScope.of(context).unfocus();
                          // if (addTitleController.text.isEmpty ||
                          //     priceController.text.isEmpty ||
                          //     descriptionController.text.isEmpty ||
                          //     phoneController.text.isEmpty ||
                          //     yearController.text.isEmpty ||
                          //     colorDropDownValue == null ||
                          //     automaticTypeDropDownValue == null ||
                          //     (automaticTypeDropDownValue == "Rent"
                          //         ? rentHourDropDownValue == null
                          //         : automaticTypeDropDownValue == null) ||
                          //     mileageController.text.isEmpty ||
                          //     createAdPostViewModel.automotiveAdData == null ||
                          //     createAdPostViewModel
                          //         .automotiveAdData?.streetAddress ==
                          //         null) {

                          if (makeDropDownValue == null) {
                            helper.showToast('Please select make');
                          }
                         // else if (modelDropDownValue == null) {
                         //    helper.showToast('Please select model');
                         //  }
                         else if (colorDropDownValue == null) {
                            helper.showToast('Please select color');
                          }
                         else if (automaticTypeDropDownValue == null) {
                            helper.showToast('Please select Automotive Type');
                          }
                         else if (createAdPostViewModel
                                  .automotiveAdData?.streetAddress ==
                              null) {
                            helper.showToast('Please Enter Address');
                          } else {
                            AutomotiveObject automotiveData =
                                createAdPostViewModel.automotiveAdData!;
                            automotiveData.title = addTitleController.text;
                            automotiveData.price =
                                double.parse(priceController.text);
                            automotiveData.conditionType =
                                conditionList[conditionIndex];
                            automotiveData.description =
                                descriptionController.text;
                            automotiveData.phoneNumber = phoneController.text;
                            automotiveData.makeName =
                                makeDropDownValue.toString();
                            automotiveData.modelName =
                                modelDropDownValue == null ?  modelDropDownValue.toString() : '';
                            automotiveData.fuelType =
                                fuelTypeList[fuelTypeIndex];
                            automotiveData.conditionType =
                                conditionList[conditionIndex];
                            automotiveData.transmissionType =
                                transmissionList[transmissionIndex];
                            automotiveData.year =
                                int.parse(yearController.text);
                            automotiveData.mileage = mileageController.text;

                            Navigator.push(context, CustomPageRoute(child: ReviewYourAd(categoryIndex: widget.categoryIndex), direction: AxisDirection.left));

                            // Navigator.push(
                            //     context,
                            //     CustomPageRoute(
                            //         child: FeaturedYourAd(
                            //             categoryIndex: widget.categoryIndex),
                            //         direction: AxisDirection.left));
                          }
                        }
                      }),
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

  List<String> fuelTypeList = [
    'Petrol',
    'Diesel',
    'LPG',
    'CNG',
    'Hybrid',
    'Electric'
  ];

  List<String> transmissionList = ['Automatic', 'Manual'];

  List<String> conditionList = ['Used', 'New'];
}
