import 'dart:io';

import 'package:app/common/logger/log.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/add_location_screen.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/add_post/widgets/custom_ad_post_widgets.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/home/home_screen.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/profile/mixins/profile_mixin.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/profile/widgets/drop_downs.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/product_location_map_widget.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with ProfileMixin, BaseMixin {
  String? dialCodeDropDownValue;
  String? countriesDropDownValue;
  String? stateDropDownValue;
  String? cityDropDownValue;
  double? userLatitude = 31.5204;
  double? userLongitude = 74.3587;
  String streetAddress = '';

  bool isLoading = false;

  void getAllCountriesCode() async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result = await context.read<GeneralViewModel>().getAllCountryCode();
    result.fold((l) {}, (r) {
      d('COUNTRIES CODE ***********************************');
      context.read<GeneralViewModel>().changeCountriesCode(r.response!);
      dialCodeDropDownValue = context.read<GeneralViewModel>().countriesCode[0];
      dialCodeDropDownValue = iPrefHelper.retrieveUser() != null
          ? iPrefHelper.retrieveUser()!.dialCode.toString()
          : null;
      if (iPrefHelper.retrieveUser()!.country!.isNotEmpty) {
        for (int i = 0; i < r.response!.length; i++) {
          if (iPrefHelper.retrieveUser()!.country! == r.response![i].id) {
            countriesDropDownValue = r.response![i].name;
            profileViewModel.updatedUserProfileValues.countryId =
                r.response![i].id;
            setState(() {});
            getStates(countryId: r.response![i].id!);
          }
        }
      } else {
        countriesDropDownValue = context.read<GeneralViewModel>().countries[0];
        setState(() {});
        getStates(countryId: r.response![0].id!);
      }
    });
  }

  void getStates({required String countryId}) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result = await context
        .read<GeneralViewModel>()
        .getStatesByCountry(countryId: countryId);
    result.fold((l) {}, (r) {
      d('STATES ***********************************');
      context.read<GeneralViewModel>().changeStatesByCountry(r.response);
      if (iPrefHelper.retrieveUser()!.state!.isNotEmpty) {
        for (int i = 0; i < r.response!.length; i++) {
          if (iPrefHelper.retrieveUser()!.state! == r.response![i].id) {
            stateDropDownValue = r.response![i].name;
            profileViewModel.updatedUserProfileValues.stateId =
                r.response![i].id;
            setState(() {});
            getCities(stateId: r.response![i].id!);
          }
        }
      } else {
        stateDropDownValue =
            context.read<GeneralViewModel>().statesByCountry![0].name;
        setState(() {});
        getCities(
            stateId: context.read<GeneralViewModel>().statesByCountry![0].id!);
      }
    });
  }

  void getCities({required String stateId}) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result = await context
        .read<GeneralViewModel>()
        .getCitiesByState(citiesId: stateId);
    result.fold((l) {}, (r) {
      d('CITIES ***********************************');
      context.read<GeneralViewModel>().changeCitiesByStates(r.response);
      if (iPrefHelper.retrieveUser()!.city!.isNotEmpty) {
        for (int i = 0; i < r.response!.length; i++) {
          if (iPrefHelper.retrieveUser()!.city! == r.response![i].id) {
            cityDropDownValue = r.response![i].name;
            profileViewModel.updatedUserProfileValues.cityId =
                r.response![i].id;
            setState(() {});
          }
        }
      } else {
        cityDropDownValue =
            context.read<GeneralViewModel>().citiesByState![0].name;
        d('City 0 : $cityDropDownValue');
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final generalViewModel = context.read<GeneralViewModel>();
    final profileViewModel = context.read<ProfileViewModel>();
    if (generalViewModel.countriesCodeList.isEmpty) {
      d('COUNTRY CODE EMPTY LIST :');
      getAllCountriesCode();
    } else {
      d('COUNTRIES LIST : ' + generalViewModel.countriesCodeList.toString());
      dialCodeDropDownValue = iPrefHelper.retrieveUser()!.dialCode!.isNotEmpty
          ? iPrefHelper.retrieveUser()!.dialCode!
          : generalViewModel.countriesCode[0];

      if (iPrefHelper.retrieveUser()!.country!.isNotEmpty) {
        for (int i = 0; i < generalViewModel.countriesCodeList.length; i++) {
          if (iPrefHelper.retrieveUser()!.country! ==
              generalViewModel.countriesCodeList[i].id) {
            countriesDropDownValue = generalViewModel.countriesCodeList[i].name;
            profileViewModel.updatedUserProfileValues.countryId =
                generalViewModel.countriesCodeList[i].id;
            setState(() {});
            getStates(countryId: generalViewModel.countriesCodeList[i].id!);
          }
        }
      }
    }
    fullNameController.text = iPrefHelper.retrieveUser() != null
        ? iPrefHelper.retrieveUser()!.firstName.toString()
        : '';
    emailController.text = iPrefHelper.retrieveUser() != null
        ? iPrefHelper.retrieveUser()!.email.toString()
        : '';
    aboutController.text = iPrefHelper.retrieveUser() != null ||
            iPrefHelper.retrieveUser() != "null"
        ? iPrefHelper.retrieveUser()!.bio.toString()
        : '';
    phoneController.text = iPrefHelper.retrieveUser() != null
        ? iPrefHelper.retrieveUser()!.mobileNumber.toString()
        : '';
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    GeneralViewModel generalViewModel = context.watch<GeneralViewModel>();
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      // appBar: customAppBar(title: 'Edit Profile', context: context, bgColor: const Color(0xff01736E), isTextWhite: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  FocusedMenuHolder(
                    menuOffset: 10,
                    menuWidth: MediaQuery.of(context).size.width * 0.65,
                    blurSize: 1.0,
                    menuItemExtent: 45,
                    menuBoxDecoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    duration: const Duration(milliseconds: 100),
                    animateMenuItems: true,
                    blurBackgroundColor: Colors.black54,
                    openWithTap: true,
                    menuItems: <FocusedMenuItem>[
                      FocusedMenuItem(
                          title: const Text("Open Camera"),
                          trailingIcon: const Icon(Icons.camera_alt_outlined),
                          onPressed: () {
                            selectImageFromCamera(
                                isCamera: true, isProfileImage: false);
                          }),
                      FocusedMenuItem(
                        title: const Text("Open Gallery"),
                        trailingIcon: const Icon(Icons.image),
                        onPressed: () {
                          selectImageFromCamera(
                              isCamera: false, isProfileImage: false);
                        },
                      ),
                      FocusedMenuItem(
                        title: Text("View cover picture",
                            style: TextStyle(
                                color: CustomAppTheme().secondaryColor)),
                        trailingIcon: Icon(Icons.account_box,
                            color: CustomAppTheme().secondaryColor),
                        onPressed: () {
                          showImageViewer(
                            context,
                            profileViewModel
                                        .updatedUserProfileValues.coverImage !=
                                    null
                                ? Image.file(profileViewModel
                                        .updatedUserProfileValues.coverImage!)
                                    .image
                                : Image.network(iPrefHelper
                                        .retrieveUser()!
                                        .coverPicture!)
                                    .image,
                            swipeDismissible: true,
                          );
                        },
                      ),
                    ],
                    onPressed: () {},
                    child: Stack(
                      children: [
                        Container(
                          height: med.height * 0.3,
                          width: med.width,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: <Color>[
                                Color(0xff01736E),
                                Color(0xff39B68D),
                              ],
                              begin: Alignment
                                  .topCenter, //begin of the gradient color
                              end: Alignment
                                  .bottomCenter, //end of the gradient color
                            ),
                            image: profileViewModel
                                        .updatedUserProfileValues.coverImage !=
                                    null
                                ? DecorationImage(
                                    image: FileImage(profileViewModel
                                        .updatedUserProfileValues.coverImage!),
                                    fit: BoxFit.cover)
                                : iPrefHelper
                                        .retrieveUser()!
                                        .coverPicture!
                                        .isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(iPrefHelper
                                            .retrieveUser()!
                                            .coverPicture!),
                                        fit: BoxFit.cover)
                                    : null,
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              height: med.height * 0.18,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Container(
                                  height: med.height * 0.05,
                                  width: med.width * .1,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white54,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.camera_alt_outlined,
                                        size: 18,
                                        color: CustomAppTheme().blackColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: med.height * 0.03,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: CustomAppTheme().backgroundColor,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 0.3,
                                      blurRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.arrow_back_ios_rounded,
                                      size: 15,
                                      color: CustomAppTheme().blackColor),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: med.width * 0.25,
                            ),
                            Center(
                              child: Text(
                                'Edit Profile',
                                style: CustomAppTheme().headingText.copyWith(
                                    fontSize: 20,
                                    color: CustomAppTheme().backgroundColor),
                              ),
                            ),
                          ],
                        ),
                        /*Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: med.height * 0.05,
                            width: med.width * .1,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white54,
                            ),
                            child: Center(
                              child: Icon(Icons.camera_alt_outlined, size: 18, color: CustomAppTheme().blackColor),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: med.height * 0.25,
                  ),
                  Container(
                    width: med.width,
                    decoration: BoxDecoration(
                      color: CustomAppTheme().backgroundColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(35),
                        topLeft: Radius.circular(35),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: med.height * 0.1,
                          ),
                          Text(
                            'Basic Information',
                            style: CustomAppTheme().normalText.copyWith(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: med.height * 0.05,
                          ),
                          YouOnlineTextField(
                            headingText: 'Full Name',
                            controller: fullNameController,
                            hintText:
                                iPrefHelper.retrieveUser()!.firstName!.isEmpty
                                    ? 'Enter full name'
                                    : iPrefHelper.retrieveUser()!.firstName!,
                          ),
                          SizedBox(
                            height: med.height * 0.02,
                          ),
                          YouOnlineTextField(
                            headingText: 'Email Address',
                            controller: emailController,
                            hintText: 'Enter email address',
                            enabled: false,
                          ),
                          SizedBox(
                            height: med.height * 0.02,
                          ),
                          Text(
                            'Phone Number',
                            style: CustomAppTheme().textFieldHeading,
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Container(
                              color: Colors.transparent,
                              height: med.height * 0.047,
                              width: med.width,
                              child: Row(
                                children: <Widget>[
                                  countryCodeDropDown(
                                    countryCodeDropDownValue:
                                        dialCodeDropDownValue == ""
                                            ? null
                                            : dialCodeDropDownValue,
                                    onChange: (value) {
                                      setState(() {
                                        dialCodeDropDownValue = value!;
                                      });
                                    },
                                    context: context,
                                  ),
                                  SizedBox(
                                    width: med.width * 0.01,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: phoneController,
                                      autocorrect: true,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      cursorColor: CustomAppTheme().blackColor,
                                      decoration: InputDecoration(
                                        errorBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6.0)),
                                          borderSide: BorderSide(
                                              color: Color(0xffa3a8b6)),
                                        ),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6.0)),
                                          borderSide: BorderSide(
                                              color: Color(0xffa3a8b6)),
                                        ),
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                        hintText: iPrefHelper
                                                .retrieveUser()!
                                                .mobileNumber!
                                                .isEmpty
                                            ? 'Enter mobile number'
                                            : iPrefHelper
                                                .retrieveUser()!
                                                .mobileNumber!,
                                        hintStyle: const TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                        filled: true,
                                        fillColor: Colors.white70,
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6.0)),
                                          borderSide: BorderSide(
                                              color: Color(0xffa3a8b6)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: med.height * 0.02,
                          ),
                          Text(
                            'Country',
                            style: CustomAppTheme().textFieldHeading,
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Container(
                              color: Colors.transparent,
                              height: med.height * 0.047,
                              width: med.width,
                              child: countryDropDown(
                                countryCodeDropDownValue:
                                    countriesDropDownValue,
                                onChange: (value) {
                                  setState(
                                    () {
                                      countriesDropDownValue = value!;
                                      generalViewModel.statesByCountry = [];
                                      generalViewModel.citiesByState = [];
                                      stateDropDownValue = null;
                                      cityDropDownValue = null;
                                      generalViewModel.changeStatesByCountry(
                                          generalViewModel.statesByCountry);
                                      generalViewModel.changeCitiesByStates(
                                          generalViewModel.citiesByState);
                                      for (int i = 0;
                                          i <
                                              generalViewModel
                                                  .countriesCodeList.length;
                                          i++) {
                                        if (value ==
                                            generalViewModel
                                                .countriesCodeList[i].name) {
                                          getStates(
                                              countryId: generalViewModel
                                                  .countriesCodeList[i].id!);
                                          profileViewModel
                                                  .updatedUserProfileValues
                                                  .countryId =
                                              generalViewModel
                                                  .countriesCodeList[i].id!;
                                        }
                                      }
                                    },
                                  );
                                },
                                context: context,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: med.height * 0.02,
                          ),
                          Text(
                            'State',
                            style: CustomAppTheme().textFieldHeading,
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Container(
                              color: Colors.transparent,
                              height: med.height * 0.047,
                              width: med.width,
                              child: stateDropDown(
                                  stateDropDownValue: stateDropDownValue,
                                  onChange: (value) {
                                    setState(() {
                                      stateDropDownValue = value!;
                                      generalViewModel.citiesByState = [];
                                      cityDropDownValue = null;
                                      generalViewModel.changeCitiesByStates(
                                          generalViewModel.citiesByState);
                                      for (int i = 0;
                                          i <
                                              generalViewModel
                                                  .statesByCountry!.length;
                                          i++) {
                                        if (value ==
                                            generalViewModel
                                                .statesByCountry![i].name) {
                                          getCities(
                                              stateId: generalViewModel
                                                  .statesByCountry![i].id!);
                                          profileViewModel
                                                  .updatedUserProfileValues
                                                  .stateId =
                                              generalViewModel
                                                  .statesByCountry![i].id!;
                                        }
                                      }
                                    });
                                  },
                                  context: context),
                            ),
                          ),
                          SizedBox(
                            height: med.height * 0.02,
                          ),
                          Text(
                            'City',
                            style: CustomAppTheme().textFieldHeading,
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Container(
                              color: Colors.transparent,
                              height: med.height * 0.047,
                              width: med.width,
                              child: cityDropDown(
                                  cityDropDownValue: cityDropDownValue,
                                  onChange: (value) {
                                    setState(() {
                                      cityDropDownValue = value!;
                                      for (int i = 0;
                                          i <
                                              generalViewModel
                                                  .citiesByState!.length;
                                          i++) {
                                        if (value ==
                                            generalViewModel
                                                .citiesByState![i].name) {
                                          profileViewModel
                                                  .updatedUserProfileValues
                                                  .cityId =
                                              generalViewModel
                                                  .citiesByState![i].id;
                                        }
                                      }
                                    });
                                  },
                                  context: context),
                            ),
                          ),
                          SizedBox(
                            height: med.height * 0.02,
                          ),
                          YouOnlineTextField(
                            headingText: 'About',
                            controller: aboutController,
                            maxLine: 6,
                            hintText: iPrefHelper.retrieveUser()!.bio!.isEmpty
                                ? ''
                                : iPrefHelper.retrieveUser()!.bio!,
                          ),
                          SizedBox(
                            height: med.height * 0.02,
                          ),
                          Text(
                            'Street Address',
                            style: CustomAppTheme().textFieldHeading,
                          ),
                          SizedBox(
                            height: med.height * 0.01,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.location_on_rounded,
                                  color: CustomAppTheme().darkGreyColor,
                                  size: 14),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: SizedBox(
                                  width: med.width * 0.8,
                                  child: iPrefHelper
                                              .retrieveUser()!
                                              .streetAddress!
                                              .isEmpty &&
                                          profileViewModel
                                                  .updatedUserProfileValues
                                                  .streetAddress ==
                                              null
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddLocationScreen(
                                                  categoryIndex: -1,
                                                  location: "",
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Set Location',
                                            style: CustomAppTheme()
                                                .normalGreyText
                                                .copyWith(
                                                  fontSize: 12,
                                                  color: CustomAppTheme()
                                                      .primaryColor,
                                                ),
                                          ),
                                        )
                                      : profileViewModel
                                                  .updatedUserProfileValues
                                                  .streetAddress !=
                                              null
                                          ? Text(
                                              profileViewModel
                                                  .updatedUserProfileValues
                                                  .streetAddress
                                                  .toString(),
                                              style: CustomAppTheme()
                                                  .normalGreyText
                                                  .copyWith(
                                                      fontSize: 12,
                                                      color: CustomAppTheme()
                                                          .darkGreyColor),
                                            )
                                          : iPrefHelper
                                                  .retrieveUser()!
                                                  .streetAddress!
                                                  .isNotEmpty
                                              ? Text(
                                                  iPrefHelper
                                                      .retrieveUser()!
                                                      .streetAddress
                                                      .toString(),
                                                  style: CustomAppTheme()
                                                      .normalGreyText
                                                      .copyWith(
                                                          fontSize: 12,
                                                          color: CustomAppTheme()
                                                              .darkGreyColor),
                                                )
                                              : const SizedBox.shrink(),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddLocationScreen(
                                          categoryIndex: -1,
                                          lat: double.parse(iPrefHelper
                                              .retrieveUser()!
                                              .latitude!),
                                          long: double.parse(iPrefHelper
                                              .retrieveUser()!
                                              .longitude!),
                                          location: profileViewModel
                                                  .updatedUserProfileValues
                                                  .streetAddress ??
                                              iPrefHelper
                                                  .retrieveUser()!
                                                  .streetAddress!),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: const Color(0xffe6fff9),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.location_on_rounded,
                                        color: CustomAppTheme().primaryColor,
                                        size: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: med.height * 0.02,
                          ),
                          iPrefHelper.retrieveUser()!.latitude!.isEmpty &&
                                  profileViewModel
                                          .updatedUserProfileValues.latitude ==
                                      null
                              ? const SizedBox.shrink()
                              : profileViewModel
                                          .updatedUserProfileValues.latitude !=
                                      null
                                  ? ProductLocationMapWidget(
                                      latitude: double.parse(profileViewModel
                                          .updatedUserProfileValues.latitude!),
                                      longitude: double.parse(profileViewModel
                                          .updatedUserProfileValues.longitude!))
                                  : iPrefHelper
                                          .retrieveUser()!
                                          .latitude!
                                          .isNotEmpty
                                      ? ProductLocationMapWidget(
                                          latitude: double.parse(iPrefHelper
                                              .retrieveUser()!
                                              .latitude!),
                                          longitude: double.parse(
                                              iPrefHelper.retrieveUser()!.longitude!))
                                      : const SizedBox.shrink(),
                          SizedBox(
                            height: med.height * 0.05,
                          ),

                          /*Divider(
                            color: CustomAppTheme().greyColor.withOpacity(0.3),
                          ),
                          SizedBox(
                            height: med.height * 0.02,
                          ),
                          Text(
                            'Delete this account',
                            style: CustomAppTheme().normalText.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'Are you sure you want to delete your account?',
                              style: CustomAppTheme().normalGreyText.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: med.height * 0.03,
                          ),
                          Container(
                            height: med.height * 0.05,
                            width: med.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(color: CustomAppTheme().greyColor),
                            ),
                            child: Center(
                              child: Text(
                                'Yes, Delete my account',
                                style: CustomAppTheme().normalGreyText.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: med.height * 0.05,
                          ),*/

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              SizedBox(
                                width: med.width * 0.35,
                                height: med.height * 0.05,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            CustomAppTheme().lightGreyColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    )),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          color: CustomAppTheme().greyColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: SizedBox(
                                  width: med.width * 0.35,
                                  child: isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                              color: CustomAppTheme()
                                                  .primaryColor),
                                        )
                                      : YouOnlineButton(
                                          text: 'Save',
                                          onTap: () async {
                                            // Provider.of<ClassifiedViewModel>(
                                            //         context,
                                            //         listen: false)
                                            //     .dispose();
                                            // Provider.of<AutomotiveViewModel>(
                                            //         context,
                                            //         listen: false)
                                            //     .dispose();
                                            // Provider.of<PropertiesViewModel>(
                                            //         context,
                                            //         listen: false)
                                            //     .dispose();
                                            // Provider.of<JobViewModel>(context,
                                            //         listen: false)
                                            //     .dispose();
                                            UpdateUserProfile user =
                                                profileViewModel
                                                    .updatedUserProfileValues;
                                            user.fullName =
                                                fullNameController.text;
                                            user.phoneNumber =
                                                phoneController.text;
                                            user.dialCode =
                                                dialCodeDropDownValue;
                                            user.bio = aboutController.text;
                                            profileViewModel
                                                .changeUpdateUserProfile(user);
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await profileViewModel
                                                .updateProfileApi();
                                            setState(() {
                                              isLoading = false;
                                            });
                                            helper.showToast(
                                                'Profile Updated Successfully!');
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeScreen()));
                                            // Navigator.pop(context);
                                          },
                                        ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: med.height * 0.08,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: med.height * 0.175,
                  ),
                  Center(
                    child: FocusedMenuHolder(
                      menuOffset: 10,
                      menuWidth: MediaQuery.of(context).size.width * 0.65,
                      blurSize: 1.0,
                      menuItemExtent: 45,
                      menuBoxDecoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      duration: const Duration(milliseconds: 100),
                      animateMenuItems: true,
                      blurBackgroundColor: Colors.black54,
                      openWithTap: true,
                      menuItems: <FocusedMenuItem>[
                        FocusedMenuItem(
                            title: const Text("Open Camera"),
                            trailingIcon: const Icon(Icons.camera_alt_outlined),
                            onPressed: () {
                              selectImageFromCamera(
                                  isCamera: true, isProfileImage: true);
                            }),
                        FocusedMenuItem(
                          title: const Text("Open Gallery"),
                          trailingIcon: const Icon(Icons.image),
                          onPressed: () {
                            selectImageFromCamera(
                                isCamera: false, isProfileImage: true);
                          },
                        ),
                        FocusedMenuItem(
                          title: Text("View profile picture",
                              style: TextStyle(
                                  color: CustomAppTheme().secondaryColor)),
                          trailingIcon: Icon(Icons.account_box,
                              color: CustomAppTheme().secondaryColor),
                          onPressed: () {
                            showImageViewer(
                              context,
                              profileViewModel.updatedUserProfileValues
                                          .profileImage !=
                                      null
                                  ? Image.file(profileViewModel
                                          .updatedUserProfileValues
                                          .profileImage!)
                                      .image
                                  : Image.network(iPrefHelper
                                          .retrieveUser()!
                                          .profilePicture!)
                                      .image,
                              swipeDismissible: true,
                            );
                          },
                        ),
                      ],
                      onPressed: () {},
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: med.height * 0.15,
                            width: med.height * 0.15,
                            decoration: BoxDecoration(
                              color: CustomAppTheme().primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: CustomAppTheme().backgroundColor,
                                  width: 2),
                              image: profileViewModel.updatedUserProfileValues
                                          .profileImage !=
                                      null
                                  ? DecorationImage(
                                      image: FileImage(profileViewModel
                                          .updatedUserProfileValues
                                          .profileImage!),
                                      fit: BoxFit.cover)
                                  : iPrefHelper
                                          .retrieveUser()!
                                          .profilePicture!
                                          .isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(iPrefHelper
                                              .retrieveUser()!
                                              .profilePicture!),
                                          fit: BoxFit.contain)
                                      : const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/userIconImage.png"),
                                          fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 2,
                            child: Container(
                              height: med.height * 0.05,
                              width: med.width * .1,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 4,
                                    offset: Offset(2, 4), // Shadow position
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(Icons.camera_alt_outlined,
                                    size: 18,
                                    color: CustomAppTheme().blackColor),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isAvatarLoading = false;

  selectImageFromCamera(
      {required bool isCamera, required bool isProfileImage}) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    XFile? im =
        await pickImage(isCamera ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      if (im == null) {
        isAvatarLoading = false;
      } else {
        isAvatarLoading = true;
      }
    });
    final file = File(im!.path);
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    print('IMAGE SIZE : $sizeInMb');

    // if (isProfileImage) {
    //   profileViewModel.updatedUserProfileValues.profileImage = file;
    //   profileViewModel
    //       .changeUpdateUserProfile(profileViewModel.updatedUserProfileValues);
    //   setState(() {
    //     isAvatarLoading = false;
    //   });
    // } else {
    //   profileViewModel.updatedUserProfileValues.coverImage = file;
    //   profileViewModel
    //       .changeUpdateUserProfile(profileViewModel.updatedUserProfileValues);
    //   setState(() {
    //     isAvatarLoading = false;
    //   });
    // }
    if (isProfileImage) {
      if (sizeInMb > 3) {
        print('Size is $sizeInMb');
        helper.showLongToast('Image is more than 3 MB');
      } else {
        profileViewModel.updatedUserProfileValues.profileImage = file;
        profileViewModel
            .changeUpdateUserProfile(profileViewModel.updatedUserProfileValues);
      }

      setState(() {
        isAvatarLoading = false;
      });
    } else {
      if (sizeInMb > 3) {
        print('Size is $sizeInMb');
        helper.showLongToast('Image is more than 3 MB');
      } else {
        profileViewModel.updatedUserProfileValues.coverImage = file;
        profileViewModel
            .changeUpdateUserProfile(profileViewModel.updatedUserProfileValues);
      }
    }
    d('${file.path}\n ${im.path} ${im.name} ${im.mimeType}');
  }

  Future<XFile?> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file =
        await _imagePicker.pickImage(source: source, imageQuality: 60);
    return _file;
  }
}
