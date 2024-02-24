import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/data/models/general_res_models/country_code_res_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/add_location_screen.dart';
import 'package:app/presentation/add_post/featured_ad.dart';
import 'package:app/presentation/add_post/mixins/add_post_mixin.dart';
import 'package:app/presentation/add_post/review_your_ad_screen.dart';
import 'package:app/presentation/add_post/upload_images_videos.dart';
import 'package:app/presentation/add_post/view_model/create_ad_post_view_model.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/add_post/widgets/custom_ad_post_widgets.dart';
import 'package:app/presentation/on_boarding/widgets/custom_page_route.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/logger/log.dart';

class JobIncludeDetail extends StatefulWidget {
  final int categoryIndex;
  final bool? isEdit;

  const JobIncludeDetail(
      {Key? key, required this.categoryIndex, this.isEdit = false})
      : super(key: key);

  @override
  State<JobIncludeDetail> createState() => _JobIncludeDetailState();
}

String selectedCurrency = "";

class _JobIncludeDetailState extends State<JobIncludeDetail>
    with AddPostMixin, BaseMixin {
  int jobTypeIndex = 0;
  int salaryPeriodIndex = 0;
  int positionTypeIndex = 0;

  String? currencyDropDownValue;
  String? countryCodeDropDownValue;

  List<CountriesModel> countriesCodeList = [];
  List<AllCurrenciesModel> currenciesList = [];

  void getAllCountriesCode() async {
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    JobObject jobData = createAdPostViewModel.jobAdData!;
    final result = await context.read<GeneralViewModel>().getAllCountryCode();
    result.fold((l) {}, (r) {
      d('COUNTRIES CODE ***********************************');
      countriesCodeList = r.response!;
      d(countriesCodeList.toString());
      context.read<GeneralViewModel>().changeCountriesCode(r.response!);
      if (widget.isEdit == true) {
        countryCodeDropDownValue = jobData.dialCode!.isEmpty
            ? context.read<GeneralViewModel>().countriesCode[0]
            : jobData.dialCode;
      } else {
        countryCodeDropDownValue =
            context.read<GeneralViewModel>().countriesCode[0];
        jobData.dialCode = context.read<GeneralViewModel>().countriesCode[0];
      }
      setState(() {});
    });
  }

  void getAllCurrencies() async {
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    JobObject jobData = createAdPostViewModel.jobAdData!;
    final result = await context.read<GeneralViewModel>().getAllCurrencies();
    result.fold((l) {}, (r) {
      d('CURRENCIES ***********************************');
      currenciesList = r.response!;
      d(currenciesList.toString());
      context.read<GeneralViewModel>().changeCurrencies(r.response!);
      if (widget.isEdit == true) {
        currencyDropDownValue =
            jobData.currencyCode!.isEmpty ? null : jobData.currencyCode;
        selectedCurrency = currencyDropDownValue!;
      } else {
        currencyDropDownValue =
            context.read<GeneralViewModel>().currenciesList[0];
        selectedCurrency = context.read<GeneralViewModel>().currenciesList[0];
        jobData.currencyId = r.response![0].id;
        print(jobData.currencyId);
        print("this is another point that i need");
      }

      setState(() {});
    });
  }

  setPropertyValues() {
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    JobObject jobObject = createAdPostViewModel.jobAdData!;
    addTitleController.text = jobObject.title!;
    streetAddressController.text = jobObject.streetAddress!;
    salaryFromController.text = jobObject.salaryFrom!;
    salaryToController.text = jobObject.salaryTo!;
    phoneController.text = jobObject.phoneNumber!;
    descriptionController.text = jobObject.description!;
    for (int i = 0; i < jobTypeList.length; i++) {
      if (jobObject.jobType == jobTypeList[i]) {
        jobTypeIndex = i;
      }
    }
    for (int i = 0; i < salaryPeriodList.length; i++) {
      if (jobObject.salaryPeriod == salaryPeriodList[i]) {
        salaryPeriodIndex = i;
      }
    }
    for (int i = 0; i < positionTypeList.length; i++) {
      if (jobObject.positionType == positionTypeList[i]) {
        positionTypeIndex = i;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final CreateAdPostViewModel createAdPostViewModel =
        context.read<CreateAdPostViewModel>();
    JobObject jobData = createAdPostViewModel.jobAdData!;
    final generalViewModel = context.read<GeneralViewModel>();
    if (generalViewModel.allCurrenciesList.isEmpty) {
      getAllCurrencies();
    } else {
      d('CURRENCIES LIST : ' + generalViewModel.allCurrenciesList.toString());
      jobData.dialCode = generalViewModel.allCurrenciesList[0].code;
      currencyDropDownValue =
          context.read<GeneralViewModel>().currenciesList[0];
    }
    if (generalViewModel.countriesCodeList.isEmpty) {
      getAllCountriesCode();
    } else {
      d('COUNTRIES LIST : ' + generalViewModel.countriesCodeList.toString());
      countryCodeDropDownValue =
          context.read<GeneralViewModel>().countriesCode[0];
      jobData.dialCode = context.read<GeneralViewModel>().countriesCode[0];
    }
    if (widget.isEdit!) {
      setPropertyValues();
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(currencyDropDownValue);
    print("this is what i need");
    Size med = MediaQuery.of(context).size;
    final CreateAdPostViewModel createAdPostViewModel =
        context.watch<CreateAdPostViewModel>();
    final GeneralViewModel generalViewModel = context.watch<GeneralViewModel>();
    d('JOB DATA : ${createAdPostViewModel.jobAdData?.currencyId}');
    d('countryCodeDropDownValue: $countryCodeDropDownValue');
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
                    if(val!.isEmpty) {
                      return 'please enter title';
                    } else {
                      return null;
                    }
                  },
                  headingText: 'Ad Title*',
                  hintText: 'Type ad title to post',
                  controller: addTitleController,
                ),
                SizedBox(
                  height: med.height * 0.025,
                ),
                Text(
                  'Job Type*',
                  style: CustomAppTheme().textFieldHeading,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 8.0,
                    children: <Widget>[
                      for (int index = 0; index < jobTypeList.length; index++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              jobTypeIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: jobTypeIndex == index
                                  ? CustomAppTheme().lightGreenColor
                                  : CustomAppTheme().lightGreyColor,
                              border: Border.all(
                                  color: jobTypeIndex == index
                                      ? CustomAppTheme().primaryColor
                                      : CustomAppTheme().greyColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Text(
                                jobTypeList[index],
                                style: jobTypeIndex == index
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
                  'Salary Period*',
                  style: CustomAppTheme().textFieldHeading,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 8.0,
                    children: <Widget>[
                      for (int index = 0;
                          index < salaryPeriodList.length;
                          index++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              salaryPeriodIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: salaryPeriodIndex == index
                                  ? CustomAppTheme().lightGreenColor
                                  : CustomAppTheme().lightGreyColor,
                              border: Border.all(
                                  color: salaryPeriodIndex == index
                                      ? CustomAppTheme().primaryColor
                                      : CustomAppTheme().greyColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Text(
                                salaryPeriodList[index],
                                style: salaryPeriodIndex == index
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
                  'Salary From*',
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
                        currencyDropDown(
                          onChange: (value) {
                            setState(() {
                              currencyDropDownValue = value!;
                              JobObject jobData =
                                  createAdPostViewModel.jobAdData!;
                              for (int i = 0;
                                  i < generalViewModel.allCurrenciesList.length;
                                  i++) {
                                if (generalViewModel.allCurrenciesList[i].code ==
                                    value) {
                                  selectedCurrency =
                                      generalViewModel.allCurrenciesList[i].code!;
                                  jobData.currencyId =
                                      generalViewModel.allCurrenciesList[i].id;
                                }
                              }
                            });
                          },
                          currencyDropDownValue: currencyDropDownValue,
                          context: context,
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
                                controller: salaryFromController),
                          ),
                        ),

                        // Expanded(
                        //   child: TextFormField(
                        //     controller: salaryFromController,
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
                Text(
                  'Salary To*',
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
                        currencyDropDown(
                          onChange: (value) {
                            setState(() {
                              currencyDropDownValue = value!;
                              JobObject jobData =
                                  createAdPostViewModel.jobAdData!;
                              for (int i = 0;
                                  i < generalViewModel.allCurrenciesList.length;
                                  i++) {
                                if (generalViewModel.allCurrenciesList[i].name ==
                                    value) {
                                  jobData.currencyId =
                                      generalViewModel.allCurrenciesList[i].id;
                                }
                              }
                            });
                          },
                          currencyDropDownValue: currencyDropDownValue,
                          context: context,
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
                                controller: salaryToController),
                          ),
                        ),

                        // Expanded(
                        //   child: TextFormField(
                        //     controller: salaryToController,
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
                Text(
                  'Position Type*',
                  style: CustomAppTheme().textFieldHeading,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 8.0,
                    children: <Widget>[
                      for (int index = 0;
                          index < positionTypeList.length;
                          index++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              positionTypeIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: positionTypeIndex == index
                                  ? CustomAppTheme().lightGreenColor
                                  : CustomAppTheme().lightGreyColor,
                              border: Border.all(
                                  color: positionTypeIndex == index
                                      ? CustomAppTheme().primaryColor
                                      : CustomAppTheme().greyColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Text(
                                positionTypeList[index],
                                style: positionTypeIndex == index
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
                      return 'please enter description';
                    } else {
                      return null;
                    }
                  },
                  headingText: 'Description*',
                  hintText: 'Describe what you are went',
                  controller: descriptionController,
                  maxLine: 6,
                ),
                SizedBox(
                  height: med.height * 0.025,
                ),
                /*YouOnlineTextField(
                  headingText: 'Company Name',
                  hintText: 'Enter Company',
                  controller: companyNameController,
                ),
                SizedBox(
                  height: med.height * 0.025,
                ),*/
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
                            countryCodeDropDownValue: countryCodeDropDownValue,
                            onChange: (value) {
                              setState(() {
                                countryCodeDropDownValue = value!;
                                createAdPostViewModel.jobAdData!.dialCode = value;
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
                        //         borderSide: BorderSide(color: Color(0xffa3a8b6)),
                        //       ),
                        //       focusedErrorBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(6.0)),
                        //         borderSide: BorderSide(color: Color(0xffa3a8b6)),
                        //       ),
                        //       isDense: true,
                        //       contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        //       hintText: 'Enter mobile number',
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
                SizedBox(
                  height: med.height * 0.025,
                ),
                Text(
                  'Company Address*',
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
                                createAdPostViewModel.jobAdData == null ||
                                        createAdPostViewModel
                                                .jobAdData?.streetAddress ==
                                            null
                                    ? 'Set Location'
                                    : createAdPostViewModel
                                        .jobAdData!.streetAddress
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
                /*SizedBox(
                  height: med.height * 0.025,
                ),
                YouOnlineTextField(
                  headingText: 'Company License Number',
                  hintText: 'Enter Company License Number',
                  controller: companyNameController,
                ),
                SizedBox(
                  height: med.height * 0.025,
                ),

                Row(
                  children: <Widget>[
                    Container(
                      height: med.height*0.12,
                      width: med.width*0.24,
                      decoration: BoxDecoration(
                        color: CustomAppTheme().lightGreyColor,
                        shape: BoxShape.circle,
                      ),
                    ),

                    SizedBox(
                      width: med.width*0.05,
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Company Logo',
                          style: CustomAppTheme().textFieldHeading,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: CustomAppTheme().secondaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: Text('Upload Photo',
                                style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().backgroundColor, fontSize: 10),
                              ),
                            ),
                          ),
                        ),

                      ],
                    )

                  ],
                ),*/

                SizedBox(
                  height: med.height * 0.05,
                ),
                SizedBox(
                  width: med.width,
                  child: YouOnlineButton(
                      text: 'Next',
                      onTap: () {
                        if(_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          // if (addTitleController.text.isEmpty ||
                          //     salaryFromController.text.isEmpty ||
                          //     descriptionController.text.isEmpty ||
                          //     salaryToController.text.isEmpty ||
                          //     phoneController.text.isEmpty ||
                          //     createAdPostViewModel.jobAdData == null ||
                          //     createAdPostViewModel.jobAdData?.streetAddress ==
                          //         null)
                          if (createAdPostViewModel.jobAdData?.streetAddress == null)
                          {
                            helper.showToast('Please enter address');
                          } else if(double.parse(salaryFromController.text.toString()) >=
                              double.parse(salaryToController.text.toString())) {
                              helper.showToast(
                                  'Salary to must be greater than salary from');
                            } else {
                              JobObject jobData = createAdPostViewModel.jobAdData!;
                              jobData.title = addTitleController.text;
                              jobData.salaryFrom = salaryFromController.text;
                              jobData.description = descriptionController.text;
                              jobData.phoneNumber = phoneController.text;
                              jobData.salaryTo = salaryToController.text;
                              jobData.jobType = jobTypeList[jobTypeIndex];
                              jobData.salaryPeriod =
                              salaryPeriodList[salaryPeriodIndex];
                              jobData.positionType =
                              positionTypeList[positionTypeIndex];
                              // jobData.currencyId = createAdPostViewModel.jobAdData?.currencyId;
                              createAdPostViewModel.changeJobAdData(jobData);

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

  List<String> jobTypeList = [
    'In-Office',
    'Remote',
    'Hybrid',
  ];

  List<String> salaryPeriodList = [
    'Hourly',
    'Monthly',
    'Weekly',
    'Yearly',
  ];

  List<String> positionTypeList = [
    'Contract',
    'Full Time',
    'Part Time',
    'Temporary',
  ];
}
