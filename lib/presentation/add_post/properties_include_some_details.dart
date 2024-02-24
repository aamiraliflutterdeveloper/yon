import 'dart:convert';

import 'package:app/common/logger/log.dart';
import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/data/models/general_res_models/country_code_res_model.dart';
import 'package:app/data/models/properties_res_models/get_city_area_model.dart';
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
import 'package:app/presentation/on_boarding/widgets/custom_page_route.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/drop_downs_widgets.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PropertiesIncludeDetail extends StatefulWidget {
  final int categoryIndex;
  final bool? isEdit;

  const PropertiesIncludeDetail(
      {Key? key, required this.categoryIndex, this.isEdit = false})
      : super(key: key);

  @override
  State<PropertiesIncludeDetail> createState() =>
      _PropertiesIncludeDetailState();
}

class _PropertiesIncludeDetailState extends State<PropertiesIncludeDetail>
    with AddPostMixin, BaseMixin {
  int? furnishedIndex;
  int? bedroomIndex;
  int? bathroomsIndex;
  int areaIndex = 0;

  String? priceDropDownValue;
  String? countryCodeDropDownValue;
  String? cityCodeDropDownValue;
  String? locatorDropDownValue;

  List<CountriesModel> countriesCodeList = [];
  List<AllCurrenciesModel> currenciesList = [];
  List<String> getCityAeraList = [];
  List<String> getCityList = [];
  String furnishedValue = '';


  void getAllCountriesCode() async {
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    PropertiesObject propertyData = createAdPostViewModel.propertyAdData!;
    final result = await context.read<GeneralViewModel>().getAllCountryCode();
    result.fold((l) {}, (r) {
      d('COUNTRIES CODE ***********************************');
      countriesCodeList = r.response!;
      d(countriesCodeList.toString());
      context.read<GeneralViewModel>().changeCountriesCode(r.response!);
      countryCodeDropDownValue =
          context.read<GeneralViewModel>().countriesCode[0];
      propertyData.dialCode = r.response![0].dialCode;
      setState(() {});
    });
  }

  GetCityAreaModel? getCityAreaModel;

  Future<void> getLocatedByCityID({required String cityID}) async {
    setState(() {
      getCityAeraList = [];
      locatorDropDownValue = null;
    });
    try {
      var response = await http.get(
        Uri.parse(
            "https://services-dev.youonline.online/api/get_city_area?city=$cityID"),
      );
      d('Located Area List : ' + response.body.toString());
      // print(getCityAreaModel!.results!.length);
      print("this is inside get located by city id");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        print("success");
        getCityAreaModel = GetCityAreaModel.fromJson(jsonData);
        print(getCityAreaModel);
        print("this is inside get located by city id");
        for (int i = 0; i < getCityAreaModel!.results!.length; i++) {
          setState(() {
            getCityAeraList.add(getCityAreaModel!.results![i].name.toString());
          });
        }
        print(getCityAeraList.length);
        print("length of the arrayu");
      } else {
        print("this is inside get located by city id is :: ");
        throw Exception();
      }
    } catch (e) {}
    setState(() {});
  }

  void getAllCurrencies() async {
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    PropertiesObject propertyData = createAdPostViewModel.propertyAdData!;
    final result = await context.read<GeneralViewModel>().getAllCurrencies();
    result.fold((l) {}, (r) {
      d('CURRENCIES ***********************************');
      currenciesList = r.response!;
      d(currenciesList.toString());
      context.read<GeneralViewModel>().changeCurrencies(r.response!);
      priceDropDownValue = context.read<GeneralViewModel>().currenciesList[0];
      propertyData.currencyId = r.response![0].id;
      selectedCurrency = priceDropDownValue!;
      setState(() {});
    });
  }

  setPropertyValues(BuildContext context) {
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();

    PropertiesObject propertiesObject = createAdPostViewModel.propertyAdData!;
    addTitleController.text = propertiesObject.title!;
    priceController.text = propertiesObject.price.toString();
    descriptionController.text = propertiesObject.description!;
    phoneController.text = propertiesObject.phoneNumber!;
    areaController.text = propertiesObject.area!;

    locatorDropDownValue = propertiesObject.locatedName;

    for (int i = 0; i < areaList.length; i++) {
      if (propertiesObject.areaUnit == areaList[i]) {
        areaIndex = i;
      }
    }
    for (int i = 0; i < furnishedList.length; i++) {
      if (propertiesObject.furnished == furnishedList[i]) {
        furnishedIndex = i;
      }
    }
    for (int i = 0; i < bedroomsList.length; i++) {
      if (propertiesObject.bedrooms == bedroomsList[i]) {
        bedroomIndex = i;
      }
    }
    for (int i = 0; i < bathroomsList.length; i++) {
      if (propertiesObject.bathrooms == bathroomsList[i]) {
        bathroomsIndex = i;
      }
    }
    setState(() {});
    print("object::: $locatorDropDownValue");
  }

  PropertiesObject? propertyData;
  @override
  void initState() {
    super.initState();
    // furnishedValue = furnishedIndex;
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    propertyData = createAdPostViewModel.propertyAdData!;

    final generalViewModel = context.read<GeneralViewModel>();
    if (generalViewModel.countriesCodeList.isEmpty) {
      d('COUNTRY CODE EMPTY LIST :');
      getAllCountriesCode();
    } else {
      d('COUNTRIES LIST : ' + generalViewModel.countriesCodeList.toString());
      countryCodeDropDownValue =
          context.read<GeneralViewModel>().countriesCode[0];
      propertyData!.dialCode =
          context.read<GeneralViewModel>().countriesCode[0];
    }

    if (generalViewModel.userCities.isNotEmpty) {
      for (int i = 0; i < generalViewModel.userCities.length; i++) {
        getCityList.add(generalViewModel.userCities[i].name.toString());
      }
      setState(() {});
    }

    if (generalViewModel.allCurrenciesList.isEmpty) {
      d('CURRENCIES EMPTY LIST :');
      getAllCurrencies();
    } else {
      d('CURRENCIES LIST : ' + generalViewModel.allCurrenciesList.toString());
      priceDropDownValue = context.read<GeneralViewModel>().currenciesList[0];
      propertyData!.currencyId =
          context.read<GeneralViewModel>().allCurrenciesList[0].id;
    }
    if (widget.isEdit!) {
      print("object:: ${propertyData!.cityId}");

      for (int i = 0; i < generalViewModel.userCities.length; i++) {
        if (propertyData!.cityId == generalViewModel.userCities[i].id) {
          cityCodeDropDownValue = generalViewModel.userCities[i].name;
          print("object::: ${generalViewModel.userCities[i].name}");
          getLocatedByCityID(cityID: propertyData!.cityId!);
        }
      }
      setPropertyValues(context);
      setState(() {});
    }
  }

  @override
  void dispose() {
    addTitleController.dispose();
    priceController.dispose();
    brandController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(getCityAeraList.length);
    print(propertyData!.cityId);
    print("this is length of the required list");
    Size med = MediaQuery.of(context).size;
    final CreateAdPostViewModel createAdPostViewModel =
        context.watch<CreateAdPostViewModel>();
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
                Container(
                  width: med.width,
                  height: med.height * 0.05,
                  decoration: BoxDecoration(
                    color: CustomAppTheme().lightGreyColor,
                    border: Border.all(color: CustomAppTheme().greyColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPropertyForSale = true;
                              });
                            },
                            child: Container(
                              height: med.height,
                              decoration: isPropertyForSale
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: CustomAppTheme().primaryColor,
                                    )
                                  : const BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                              child: Center(
                                child: Text(
                                  'For Sale',
                                  style: CustomAppTheme().normalText.copyWith(
                                      color: isPropertyForSale
                                          ? CustomAppTheme().backgroundColor
                                          : CustomAppTheme().darkGreyColor,
                                      fontSize: 14,
                                      fontWeight: isPropertyForSale
                                          ? FontWeight.w600
                                          : FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPropertyForSale = false;
                              });
                            },
                            child: Container(
                              height: med.height,
                              decoration: isPropertyForSale
                                  ? const BoxDecoration(
                                      color: Colors.transparent,
                                    )
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: CustomAppTheme().primaryColor,
                                    ),
                              child: Center(
                                child: Text(
                                  'For Rent',
                                  style: CustomAppTheme().normalText.copyWith(
                                      color: isPropertyForSale
                                          ? CustomAppTheme().darkGreyColor
                                          : CustomAppTheme().backgroundColor,
                                      fontSize: 14,
                                      fontWeight: isPropertyForSale
                                          ? FontWeight.w500
                                          : FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: med.height * 0.03,
                ),
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
                  dense: false,
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
                          // height: 33,
                          child: currencyDropDown(
                              onChange: (value) {
                                setState(() {
                                  priceDropDownValue = value!;
                                  for (int i = 0;
                                      i <
                                          generalViewModel
                                              .allCurrenciesList.length;
                                      i++) {
                                    if (value ==
                                        generalViewModel
                                            .allCurrenciesList[i].code) {
                                      createAdPostViewModel
                                              .propertyAdData!.currencyId =
                                          generalViewModel
                                              .allCurrenciesList[i].id;
                                      selectedCurrency = generalViewModel
                                          .allCurrenciesList[i].code!;
                                    }
                                  }
                                });
                              },
                              currencyDropDownValue: priceDropDownValue,
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
                      'Select City*',
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
                                    Text(cityCodeDropDownValue == null ? "Select City*" : cityCodeDropDownValue!, style: cityCodeDropDownValue == null ? const TextStyle(color: Colors.grey, fontSize: 14) : const TextStyle(color: Colors.black, fontSize: 14)),
                                    Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onSelected: (value) {
                            // your logic
                            setState(() {

                              cityCodeDropDownValue = value;
                                              for (int i = 0;
                                                  i < generalViewModel.userCities.length;
                                                  i++) {
                                                print("hhahahahahahahahah");
                                                print(generalViewModel.userCities[i].name);
                                                if (value ==
                                                    generalViewModel.userCities[i].name) {
                                                  print(generalViewModel.userCities[i].id);
                                                  getLocatedByCityID(
                                                      cityID: generalViewModel
                                                          .userCities[i].id
                                                          .toString());
                                                  print("above id id");
                                                  print(generalViewModel.userCities[i].name);
                                                  print("above id name");
                                                  print("this is city id :: :: ===");
                                                  print("this is value :: $value");
                                                  d('VALUE: $value AND TITLE: ${generalViewModel.userCities[i]}');
                                                  createAdPostViewModel
                                                          .propertyAdData!.cityId =
                                                      generalViewModel.userCities[i].id;
                                                  d('VALUE: $value AND ID: ${generalViewModel.userCities[i].id}');
                                                }
                                              }

                            });
                          },
                          constraints: BoxConstraints(
                            minWidth: med.width - 30,
                            maxWidth: MediaQuery.of(context).size.width - 30,
                            maxHeight: 350
                          ),
                          itemBuilder: (BuildContext bc) {
                            return List.generate(getCityList.length, (index) {
                              return PopupMenuItem(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: SizedBox(
                                  width: med.width - 30,
                                  child: Text(
                                    getCityList[index],
                                    style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                                  ),
                                ),
                                value: getCityList[index],
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
                //       'Select City*',
                //       style: CustomAppTheme().textFieldHeading,
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 5),
                //       child: SizedBox(
                //         height: med.height * 0.047,
                //         width: med.width,
                //         child: brandDropDown(
                //           hint: "Select City",
                //           itemsList: getCityList,
                //           brandDropDownValue: cityCodeDropDownValue,
                //           onChange: (value) {
                //             setState(
                //               () {
                //                 cityCodeDropDownValue = value;
                //
                //                 for (int i = 0;
                //                     i < generalViewModel.userCities.length;
                //                     i++) {
                //                   print("hhahahahahahahahah");
                //                   print(generalViewModel.userCities[i].name);
                //                   if (value ==
                //                       generalViewModel.userCities[i].name) {
                //                     print(generalViewModel.userCities[i].id);
                //                     getLocatedByCityID(
                //                         cityID: generalViewModel
                //                             .userCities[i].id
                //                             .toString());
                //                     print("above id id");
                //                     print(generalViewModel.userCities[i].name);
                //                     print("above id name");
                //                     print("this is city id :: :: ===");
                //                     print("this is value :: $value");
                //                     d('VALUE: $value AND TITLE: ${generalViewModel.userCities[i]}');
                //                     createAdPostViewModel
                //                             .propertyAdData!.cityId =
                //                         generalViewModel.userCities[i].id;
                //                     d('VALUE: $value AND ID: ${generalViewModel.userCities[i].id}');
                //                   }
                //                 }
                //                 setState(() {});
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
                      'Where You Located*',
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
                                    Text(locatorDropDownValue == null ? "Select your Located" : locatorDropDownValue!, style: locatorDropDownValue == null ? const TextStyle(color: Colors.grey, fontSize: 14) : const TextStyle(color: Colors.black, fontSize: 14)),
                                    Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onSelected: (value) {
                            // your logic
                            // setState(() {
                            //
                            //   cityCodeDropDownValue = value;
                            //   for (int i = 0;
                            //   i < generalViewModel.userCities.length;
                            //   i++) {
                            //     print("hhahahahahahahahah");
                            //     print(generalViewModel.userCities[i].name);
                            //     if (value ==
                            //         generalViewModel.userCities[i].name) {
                            //       print(generalViewModel.userCities[i].id);
                            //       getLocatedByCityID(
                            //           cityID: generalViewModel
                            //               .userCities[i].id
                            //               .toString());
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


                                        setState(
                                          () {
                                            locatorDropDownValue = value;
                                            for (int i = 0;
                                                i < getCityAreaModel!.results!.length;
                                                i++) {
                                              if (value ==
                                                  getCityAreaModel!.results![i].name) {
                                                d('VALUE: $value AND TITLE: ${getCityAreaModel!.results![i].name}');
                                                createAdPostViewModel
                                                        .propertyAdData!.locatedId =
                                                    getCityAreaModel!.results![i].id;
                                                d('VALUE: $value AND ID: ${getCityAreaModel!.results![i].id}');
                                              }
                                            }
                                          },
                                        );

                          },
                          constraints: BoxConstraints(
                              minWidth: med.width - 30,
                              maxWidth: MediaQuery.of(context).size.width - 30,
                              maxHeight: 350
                          ),
                          itemBuilder: (BuildContext bc) {
                            return List.generate(getCityAeraList.length, (index) {
                              return PopupMenuItem(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: SizedBox(
                                  width: med.width - 30,
                                  child: Text(
                                    getCityAeraList[index],
                                    style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                                  ),
                                ),
                                value: getCityAeraList[index],
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
                //       'Where You Located*',
                //       style: CustomAppTheme().textFieldHeading,
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 5),
                //       child: SizedBox(
                //         height: med.height * 0.047,
                //         width: med.width,
                //         child: brandDropDown(
                //           itemsList: getCityAeraList,
                //           hint: "Select your Located",
                //           brandDropDownValue: locatorDropDownValue,
                //           onChange: (value) {
                //             setState(
                //               () {
                //                 locatorDropDownValue = value;
                //                 for (int i = 0;
                //                     i < getCityAreaModel!.results!.length;
                //                     i++) {
                //                   if (value ==
                //                       getCityAreaModel!.results![i].name) {
                //                     d('VALUE: $value AND TITLE: ${getCityAreaModel!.results![i].name}');
                //                     createAdPostViewModel
                //                             .propertyAdData!.locatedId =
                //                         getCityAreaModel!.results![i].id;
                //                     d('VALUE: $value AND ID: ${getCityAreaModel!.results![i].id}');
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
                      'Furnished',
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
                                    Text(furnishedIndex == null ? "Select value" : furnishedList[furnishedIndex!], style: furnishedIndex == null ? const TextStyle(color: Colors.grey, fontSize: 14) : const TextStyle(color: Colors.black, fontSize: 14)),
                                    Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onSelected: (value) {
                            // your logic
                            setState(() {
                              furnishedIndex = int.parse(value);
                              furnishedIndex = int.parse(value);
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
                                      furnishedList[index],
                                      style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                                    ),
                                  ),
                                  value: '$index',
                                );
                            }

                            );

                          },
                        ),
                      ),
                    ),
                  ],
                ),




                // Text(
                //   'Furnished*',
                //   style: CustomAppTheme().textFieldHeading,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10),
                //   child: Wrap(
                //     spacing: 10.0,
                //     runSpacing: 8.0,
                //     children: <Widget>[
                //       for (int index = 0; index < 2; index++)
                //         GestureDetector(
                //           onTap: () {
                //             setState(() {
                //               furnishedIndex = index;
                //             });
                //           },
                //           child: Container(
                //             decoration: BoxDecoration(
                //               color: furnishedIndex == index
                //                   ? CustomAppTheme().lightGreenColor
                //                   : CustomAppTheme().lightGreyColor,
                //               border: Border.all(
                //                   color: furnishedIndex == index
                //                       ? CustomAppTheme().primaryColor
                //                       : CustomAppTheme().greyColor),
                //               borderRadius: BorderRadius.circular(20),
                //             ),
                //             child: Padding(
                //               padding: const EdgeInsets.symmetric(
                //                   vertical: 5, horizontal: 15),
                //               child: Text(
                //                 furnishedList[index],
                //                 style: furnishedIndex == index
                //                     ? CustomAppTheme().normalText.copyWith(
                //                         fontWeight: FontWeight.w600,
                //                         color: CustomAppTheme().blackColor)
                //                     : CustomAppTheme().normalText.copyWith(
                //                         fontWeight: FontWeight.w500,
                //                         color: CustomAppTheme().greyColor),
                //               ),
                //             ),
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: med.height * 0.025,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Bedrooms',
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
                                    Text(bedroomIndex == null ? "Select Bedroom" : bedroomsList[bedroomIndex!], style: bedroomIndex == null ? const TextStyle(color: Colors.grey, fontSize: 14) : const TextStyle(color: Colors.black, fontSize: 14)),
                                    Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onSelected: (value) {
                            // your logic
                            setState(() {
                              bedroomIndex = int.parse(value);
                              // furnishedIndex = int.parse(value);
                            });
                          },
                          constraints: BoxConstraints(
                            minWidth: med.width - 30,
                            maxWidth: MediaQuery.of(context).size.width - 30,
                          ),
                          itemBuilder: (BuildContext bc) {
                            return List.generate(bedroomsList.length, (index) {
                              return    PopupMenuItem(
                                child: SizedBox(
                                  width: med.width - 30,
                                  child: Text(
                                    bedroomsList[index],
                                    style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                                  ),
                                ),
                                value: '$index',
                              );
                            }

                            );

                          },
                        ),
                      ),
                    ),
                  ],
                ),


                // Text(
                //   'Bedrooms*',
                //   style: CustomAppTheme().textFieldHeading,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10),
                //   child: Wrap(
                //     spacing: 10.0,
                //     runSpacing: 8.0,
                //     children: <Widget>[
                //       for (int index = 0; index < bedroomsList.length; index++)
                //         GestureDetector(
                //           onTap: () {
                //             setState(() {
                //               bedroomIndex = index;
                //             });
                //           },
                //           child: Container(
                //             decoration: BoxDecoration(
                //               color: bedroomIndex == index
                //                   ? CustomAppTheme().lightGreenColor
                //                   : CustomAppTheme().lightGreyColor,
                //               border: Border.all(
                //                   color: bedroomIndex == index
                //                       ? CustomAppTheme().primaryColor
                //                       : CustomAppTheme().greyColor),
                //               borderRadius: BorderRadius.circular(20),
                //             ),
                //             child: Padding(
                //               padding: const EdgeInsets.symmetric(
                //                   vertical: 5, horizontal: 15),
                //               child: Text(
                //                 bedroomsList[index],
                //                 style: bedroomIndex == index
                //                     ? CustomAppTheme().normalText.copyWith(
                //                         fontWeight: FontWeight.w600,
                //                         color: CustomAppTheme().blackColor)
                //                     : CustomAppTheme().normalText.copyWith(
                //                         fontWeight: FontWeight.w500,
                //                         color: CustomAppTheme().greyColor),
                //               ),
                //             ),
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: med.height * 0.025,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Bathrooms',
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
                                    Text(bathroomsIndex == null ? "Select Bedroom" : bathroomsList[bathroomsIndex!], style: bathroomsIndex == null ? const TextStyle(color: Colors.grey, fontSize: 14) : const TextStyle(color: Colors.black, fontSize: 14)),
                                    Icon(Icons.keyboard_arrow_down_sharp, color: CustomAppTheme().blackColor, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onSelected: (value) {
                            // your logic
                            setState(() {
                              bathroomsIndex = int.parse(value);
                              // furnishedIndex = int.parse(value);
                            });
                          },
                          constraints: BoxConstraints(
                            minWidth: med.width - 30,
                            maxWidth: MediaQuery.of(context).size.width - 30,
                          ),
                          itemBuilder: (BuildContext bc) {
                            return List.generate(bathroomsList.length, (index) {
                              return    PopupMenuItem(
                                child: SizedBox(
                                  width: med.width - 30,
                                  child: Text(
                                    bathroomsList[index],
                                    style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                                  ),
                                ),
                                value: '$index',
                              );
                            }

                            );

                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // Text(
                //   'Bathrooms',
                //   style: CustomAppTheme().textFieldHeading,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10),
                //   child: Wrap(
                //     spacing: 10.0,
                //     runSpacing: 8.0,
                //     children: <Widget>[
                //       for (int index = 0; index < bathroomsList.length; index++)
                //         GestureDetector(
                //           onTap: () {
                //             setState(() {
                //               bathroomsIndex = index;
                //             });
                //           },
                //           child: Container(
                //             decoration: BoxDecoration(
                //               color: bathroomsIndex == index
                //                   ? CustomAppTheme().lightGreenColor
                //                   : CustomAppTheme().lightGreyColor,
                //               border: Border.all(
                //                   color: bathroomsIndex == index
                //                       ? CustomAppTheme().primaryColor
                //                       : CustomAppTheme().greyColor),
                //               borderRadius: BorderRadius.circular(20),
                //             ),
                //             child: Padding(
                //               padding: const EdgeInsets.symmetric(
                //                   vertical: 5, horizontal: 15),
                //               child: Text(
                //                 bathroomsList[index],
                //                 style: bathroomsIndex == index
                //                     ? CustomAppTheme().normalText.copyWith(
                //                         fontWeight: FontWeight.w600,
                //                         color: CustomAppTheme().blackColor)
                //                     : CustomAppTheme().normalText.copyWith(
                //                         fontWeight: FontWeight.w500,
                //                         color: CustomAppTheme().greyColor),
                //               ),
                //             ),
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: med.height * 0.025,
                ),
                Text(
                  'Area*',
                  style: CustomAppTheme().textFieldHeading,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 8.0,
                    children: <Widget>[
                      for (int index = 0; index < areaList.length; index++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              areaIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: areaIndex == index
                                  ? CustomAppTheme().lightGreenColor
                                  : CustomAppTheme().lightGreyColor,
                              border: Border.all(
                                  color: areaIndex == index
                                      ? CustomAppTheme().primaryColor
                                      : CustomAppTheme().greyColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Text(
                                areaList[index],
                                style: areaIndex == index
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
                    if(val!.isEmpty) {
                      return 'please enter area';
                    } else {
                      return null;
                    }
                  },
                    headingText: 'Area*',
                    hintText: 'Enter Area',
                    controller: areaController,
                    keyboardType: TextInputType.number),
                SizedBox(
                  height: med.height * 0.025,
                ),
                YouOnlineTextField(
                  validator: (val) {
                    if(val!.isEmpty) {
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
                        Container(
                          height: 33,
                          child: countryCodeDropDown(
                            countryCodeDropDownValue: countryCodeDropDownValue,
                            onChange: (value) {
                              setState(() {
                                countryCodeDropDownValue = value!;
                                createAdPostViewModel.propertyAdData!.dialCode =
                                    value;
                              });
                            },
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
                        //     controller: phoneController,
                        //     autocorrect: true,
                        //     maxLines: 1,
                        //     keyboardType: TextInputType.number,
                        //     cursorColor: CustomAppTheme().blackColor,
                        //     decoration: const InputDecoration(
                        //       errorBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(6.0)),
                        //         borderSide:
                        //             BorderSide(color: Color(0xffa3a8b6)),
                        //       ),
                        //       focusedErrorBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(6.0)),
                        //         borderSide:
                        //             BorderSide(color: Color(0xffa3a8b6)),
                        //       ),
                        //       isDense: true,
                        //       contentPadding:
                        //           EdgeInsets.fromLTRB(20, 10, 20, 10),
                        //       hintText: 'Enter mobile number',
                        //       hintStyle:
                        //           TextStyle(color: Colors.grey, fontSize: 14),
                        //       filled: true,
                        //       fillColor: Colors.white70,
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(6.0)),
                        //         borderSide:
                        //             BorderSide(color: Color(0xffa3a8b6)),
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
                SizedBox(
                  height: med.height * 0.025,
                ),
                Text(
                  'Location*',
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
                                createAdPostViewModel.propertyAdData == null ||
                                        createAdPostViewModel.propertyAdData
                                                ?.streetAddress ==
                                            null
                                    ? 'Set Location'
                                    : createAdPostViewModel
                                        .propertyAdData!.streetAddress
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

                          // d('This is bedrooms list ::: ' +
                          //     bedroomsList[bedroomIndex!].toString());
                          FocusScope.of(context).unfocus();
                          // if (addTitleController.text.isEmpty ||
                          //     priceController.text.isEmpty ||
                          //     cityCodeDropDownValue == null ||
                          //     locatorDropDownValue == null ||
                          //     descriptionController.text.isEmpty ||
                          //     phoneController.text.isEmpty ||
                          //     areaController.text.isEmpty ||
                          //     createAdPostViewModel.propertyAdData == null ||
                          //     createAdPostViewModel
                          //             .propertyAdData?.streetAddress ==
                          //         null)
                          if(cityCodeDropDownValue == null) {
                            helper.showToast('Please select city');
                          }

                         else if(locatorDropDownValue == null) {
                            helper.showToast('Please select, where you located.');
                          }
                         else if (createAdPostViewModel.propertyAdData?.streetAddress == null) {
                            helper.showToast('Please enter address');
                          } else {
                            PropertiesObject propertyData =
                                createAdPostViewModel.propertyAdData!;
                            propertyData.title = addTitleController.text;
                            propertyData.price =
                                double.parse(priceController.text);
                            propertyData.description =
                                descriptionController.text;
                            propertyData.phoneNumber = phoneController.text;
                            propertyData.furnished =
                                furnishedIndex != null ? furnishedList[furnishedIndex!] : '';
                            propertyData.bedrooms = bedroomIndex != null ? bedroomsList[bedroomIndex!] : '';
                            propertyData.bathrooms =
                            bathroomsIndex != null ? bathroomsList[bathroomsIndex!] : '';
                            propertyData.areaUnit =
                                areaList[areaIndex].replaceAll(' ', '');
                            propertyData.area = areaController.text;
                            propertyData.propertyType =
                                isPropertyForSale ? 'Sale' : 'Rent';
                            createAdPostViewModel
                                .changePropertyAdData(propertyData);

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

  List<String> furnishedList = [
    'Furnished',
    'Unfurnished',
  ];

  List<String> bedroomsList = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06+',
    'Studio',
  ];

  List<String> bathroomsList = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07+',
  ];

  List<String> areaList = [
    'Kanal',
    'Marla',
    'Square Feet',
    'Square Meter',
    'Square Yard',
  ];
}
