import 'dart:io';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/business_module_models/get_business_profiles_models.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/add_location_screen.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/add_post/widgets/custom_ad_post_widgets.dart';
import 'package:app/presentation/authentication/mixins/signup_mixin.dart';
import 'package:app/presentation/profile/business_mode/view_model/business_view_model.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/profile/widgets/drop_downs.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/product_location_map_widget.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateBusinessProfile extends StatefulWidget {
  final String module;
  final bool isCreateProfile;
  final bool isPending;
  final bool isRejected;
  final BusinessProfileModel businessData;

  const CreateBusinessProfile(
      {Key? key,
      required this.module,
      required this.isPending,
      this.isRejected = false,
      required this.isCreateProfile,
      required this.businessData})
      : super(key: key);

  @override
  State<CreateBusinessProfile> createState() => _CreateBusinessProfileState();
}

class _CreateBusinessProfileState extends State<CreateBusinessProfile>
    with BaseMixin, SignUpMixin {
  String? dialCodeDropDownValue;
  String? logoImageUrl;
  String? coverImageUrl;
  String? countriesDropDownValue;
  bool isBusinessActive = true;
  String? businessCategoryValue;
  String? stateDropDownValue;
  String? cityDropDownValue;
  double? businessLatitude = 31.5204;
  double? businessLongitude = 74.3587;
  String streetAddress = '';
  String? countryId;
  String? stateId;
  String? cityId;
  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessCategoryController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController licenceController = TextEditingController();

  List<File> nationalIdDoc = [];
  List<File> passportDoc = [];
  List<File> userPhoto = [];
  List<File> licenseFile = [];

  List nationalIdImage = [];
  List passportImage = [];
  List userPhotoImage = [];
  List licenseFileImage = [];
  bool isUploading = false;

  void getDoc({required String docType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'jpg',
        'png',
        'jpeg',
      ],
      allowMultiple: true,
    );
    if (result != null) {
      // d('DOC PATH : ${result.files[0].path}');
      // d('DOC NAME : ${result.files[0].name}');
      // d('DOC EXTENSION : ${result.files[0].extension}');
      // d('DOC IDENTIFIER : ${result.files[0].identifier}');
      // d('DOC RUNTIME TYPE : ${result.files[0].runtimeType}');
      // d('DOC SIZE : ${result.files[0].size}');
      if (docType == 'National') {
        setState(() {
          nationalIdDoc.add(File(result.files[0].path!));
        });
      } else if (docType == 'Passport') {
        setState(() {
          passportDoc.add(File(result.files[0].path!));
        });
      } else if (docType == 'User') {
        setState(() {
          userPhoto.add(File(result.files[0].path!));
        });
      } else {
        setState(() {
          licenseFile.add(File(result.files[0].path!));
        });
      }
    }
  }

  void getAllCountriesCode() async {
    final result = await context.read<GeneralViewModel>().getAllCountryCode();
    result.fold((l) {}, (r) {
      d('COUNTRIES CODE ***********************************');
      context.read<GeneralViewModel>().changeCountriesCode(r.response!);
      if (widget.isCreateProfile == false) {
        dialCodeDropDownValue = widget.businessData.dialCode;
        countriesDropDownValue = widget.businessData.country!.name;
        countryId = widget.businessData.country!.id;
        getStates(countryId: countryId!);
      } else {
        dialCodeDropDownValue =
            context.read<GeneralViewModel>().countriesCode[0];
        countryId = r.response![0].id;
      }
      setState(() {});
      // getStates(countryId: r.response![0].id!);
    });
  }

  void getStates({required String countryId}) async {
    final result = await context
        .read<GeneralViewModel>()
        .getStatesByCountry(countryId: countryId);
    result.fold((l) {}, (r) {
      d('STATES ***********************************');
      context.read<GeneralViewModel>().changeStatesByCountry(r.response);
      if (widget.isCreateProfile == false) {
        stateDropDownValue = widget.businessData.state!.name;
        stateId = widget.businessData.state!.id;
        getCities(stateId: stateId!);
      }
      // stateDropDownValue = context.read<GeneralViewModel>().statesByCountry![0].name;
      setState(() {});
      // getCities(citiesId: context.read<GeneralViewModel>().statesByCountry![0].id!);
    });
  }

  void getCities({required String stateId}) async {
    final result = await context
        .read<GeneralViewModel>()
        .getCitiesByState(citiesId: stateId);
    result.fold((l) {}, (r) {
      d('CITIES ***********************************');
      context.read<GeneralViewModel>().changeCitiesByStates(r.response);
      if (widget.isCreateProfile == false) {
        cityDropDownValue = widget.businessData.city!.name;
        cityId = widget.businessData.city!.id;
      }
      // cityDropDownValue = context.read<GeneralViewModel>().citiesByState![0].name;
      d('City 0 : $cityDropDownValue');
      setState(() {});
    });
  }

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final generalViewModel = context.read<GeneralViewModel>();
    final profileViewModel = context.read<ProfileViewModel>();
    if (!widget.isCreateProfile) {
      d('widget.businessData.companyStatus :::: ${widget.businessData.companyStatus}');
      isBusinessActive = widget.businessData.companyStatus!;
    }
    if (generalViewModel.countriesCodeList.isEmpty) {
      d('COUNTRY CODE EMPTY LIST :');
      getAllCountriesCode();
    } else {
      d('COUNTRIES LIST : ' + generalViewModel.countriesCodeList.toString());
      dialCodeDropDownValue = generalViewModel.countriesCode[0];
      if (widget.isCreateProfile == false) {
        dialCodeDropDownValue = widget.businessData.dialCode;
        countriesDropDownValue = widget.businessData.country!.name;
        countryId = widget.businessData.country!.id;
        getStates(countryId: countryId!);
      }
    }
    businessCategoryController.text = widget.module;
    businessCategoryValue = widget.module;
    if (widget.isCreateProfile == false) {
      businessNameController.text = widget.businessData.name!;
      emailController.text = widget.businessData.email!;
      phoneController.text = widget.businessData.phone!;
      aboutController.text = widget.businessData.about!;
      licenceController.text = widget.businessData.licenseNumber!;
      logoImageUrl = widget.businessData.logo;
      coverImageUrl = widget.businessData.coverImage;
      profileViewModel.tempBusinessValues.businessLocation =
          widget.businessData.streetAddress!;
      profileViewModel.tempBusinessValues.longitude =
          widget.businessData.longitude!;
      profileViewModel.tempBusinessValues.latitude =
          widget.businessData.latitude!;
      if (widget.businessData.nationalId!.isNotEmpty) {
        for (int i = 0; i < widget.businessData.nationalId!.length; i++) {
          nationalIdImage.add(widget.businessData.nationalId![i].idcardFile);
        }
      }
      if (widget.businessData.passport!.isNotEmpty) {
        for (int i = 0; i < widget.businessData.passport!.length; i++) {
          passportImage.add(widget.businessData.passport![i].passportFile);
        }
      }
      if (widget.businessData.recentImage!.isNotEmpty) {
        for (int i = 0; i < widget.businessData.recentImage!.length; i++) {
          userPhotoImage
              .add(widget.businessData.recentImage![i].recentimageFile);
        }
      }
      if (widget.businessData.licenseFile!.isNotEmpty) {
        for (int i = 0; i < widget.businessData.licenseFile!.length; i++) {
          licenseFileImage.add(widget.businessData.licenseFile![i].licenseFile);
        }
      }
      setState(() {});
    }
  }

  final createBusinessFormKey = GlobalKey<FormState>();

  updateAfterUpdateProfile() async {
    BusinessViewModel businessViewModel = context.read<BusinessViewModel>();
    final result = await businessViewModel.getMyBusinessProfiles();
    result.fold((l) {}, (r) {
      d('My Business Profiles : $r');
      for (int i = 0; i < r.response!.length; i++) {
        if (r.response![i].companyType == 'Classified') {
          businessViewModel.classifiedBusinessProfile = r.response![i];
          iPrefHelper.saveClassifiedProfile(
              businessViewModel.classifiedBusinessProfile);
        } else if (r.response![i].companyType == 'Automotive') {
          businessViewModel.automotiveBusinessProfile = r.response![i];
          iPrefHelper.saveAutomotiveProfile(
              businessViewModel.automotiveBusinessProfile);
        } else if (r.response![i].companyType == 'Property') {
          businessViewModel.propertyBusinessProfile = r.response![i];
          iPrefHelper
              .savePropertyProfile(businessViewModel.propertyBusinessProfile);
        } else if (r.response![i].companyType == 'Job') {
          businessViewModel.jobBusinessProfile = r.response![i];
          iPrefHelper.saveJobProfile(businessViewModel.jobBusinessProfile);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    final generalViewModel = context.watch<GeneralViewModel>();
    final profileViewModel = context.watch<ProfileViewModel>();

    return widget.isPending
        ? Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 160,
                  ),
                  Image.asset('assets/images/inprocess.png'),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Verification - In Process',
                    style: CustomAppTheme()
                        .normalText
                        .copyWith(fontSize: 21, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                      'Your profile has been submitted for verification. You will get a confirmation email after approval/rejection',
                      textAlign: TextAlign.center,
                      style: CustomAppTheme()
                          .normalGreyText
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                CustomAppTheme().primaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            )),
                          ),
                          child: Text(
                            'Back To Profile',
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: CustomAppTheme().backgroundColor,
            body: GestureDetector(
              onTap: () {
                print(iPrefHelper.retrieveToken());
                print("this is token value ::");
              },
              child: SafeArea(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            duration: const Duration(milliseconds: 100),
                            animateMenuItems: true,
                            blurBackgroundColor: Colors.black54,
                            openWithTap: true,
                            menuItems: <FocusedMenuItem>[
                              FocusedMenuItem(
                                  title: const Text("Open Camera"),
                                  trailingIcon:
                                      const Icon(Icons.camera_alt_outlined),
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
                                                .tempBusinessValues.coverImage !=
                                            null
                                        ? Image.file(profileViewModel
                                                .tempBusinessValues.coverImage!)
                                            .image
                                        : Image.network(coverImageUrl!).image,
                                    swipeDismissible: true,
                                  );
                                },
                              ),
                            ],
                            onPressed: () {},
                            child: Stack(
                              children: [
                                Container(
                                  height: med.height * 0.25,
                                  width: med.width,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: <Color>[
                                        Color(0xff01736E),
                                        Color(0xff39B68D),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    image: profileViewModel
                                                .tempBusinessValues.coverImage !=
                                            null
                                        ? DecorationImage(
                                            image: FileImage(profileViewModel
                                                .tempBusinessValues.coverImage!),
                                            fit: BoxFit.cover)
                                        : coverImageUrl != null
                                            ? DecorationImage(
                                                image:
                                                    NetworkImage(coverImageUrl!),
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
                                                color:
                                                    CustomAppTheme().blackColor),
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
                                  height: med.height * 0.01,
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
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 0.3,
                                              blurRadius: 2,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                              Icons.arrow_back_ios_rounded,
                                              size: 15,
                                              color: CustomAppTheme().blackColor),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: med.width * 0.17,
                                    ),
                                    Center(
                                      child: Text(
                                        'Business Profile',
                                        style: CustomAppTheme()
                                            .headingText
                                            .copyWith(
                                                fontSize: 20,
                                                color: CustomAppTheme()
                                                    .backgroundColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Form(
                        key: createBusinessFormKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: med.height * 0.25,
                            ),
                            Container(
                              width: med.width,
                              decoration: BoxDecoration(
                                color: CustomAppTheme().backgroundColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, left: 15, right: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    widget.isRejected
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: med.height * 0.1,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                color: Colors.red[400],
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 3),
                                                child: Text(
                                                  widget.businessData.message ??
                                                      "",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: widget.isRejected
                                          ? med.height * 0.015
                                          : med.height * 0.1,
                                    ),

                                    Text(
                                      'Basic Information',
                                      style: CustomAppTheme().normalText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: med.height * 0.02,
                                    ),
                                    Container(
                                      width: med.width,
                                      height: med.height * 0.05,
                                      decoration: BoxDecoration(
                                        color: CustomAppTheme().lightGreyColor,
                                        border: Border.all(
                                            color: CustomAppTheme().greyColor),
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
                                                    isBusinessActive = true;
                                                    if(widget.isCreateProfile == false) {
                                                      profileViewModel.updateStatus(companyId: widget.businessData.id!, companyStatus: isBusinessActive).then((value) {
                                                        updateAfterUpdateProfile();
                                                      });
                                                    }

                                                  });
                                                },
                                                child: Container(
                                                  height: med.height,
                                                  decoration: isBusinessActive
                                                      ? BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: CustomAppTheme()
                                                              .primaryColor,
                                                        )
                                                      : const BoxDecoration(
                                                          color:
                                                              Colors.transparent,
                                                        ),
                                                  child: Center(
                                                    child: Text(
                                                      'Active',
                                                      style: CustomAppTheme()
                                                          .normalText
                                                          .copyWith(
                                                              color: isBusinessActive
                                                                  ? CustomAppTheme()
                                                                      .backgroundColor
                                                                  : CustomAppTheme()
                                                                      .darkGreyColor,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  isBusinessActive
                                                                      ? FontWeight
                                                                          .w600
                                                                      : FontWeight
                                                                          .w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isBusinessActive = false;
                                                    if(widget.isCreateProfile == false) {
                                                      profileViewModel.updateStatus(companyId: widget.businessData.id!, companyStatus: isBusinessActive).then((value) {
                                                        updateAfterUpdateProfile();
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: med.height,
                                                  decoration: isBusinessActive
                                                      ? const BoxDecoration(
                                                          color:
                                                              Colors.transparent,
                                                        )
                                                      : BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: CustomAppTheme()
                                                              .primaryColor,
                                                        ),
                                                  child: Center(
                                                    child: Text(
                                                      'Inactive',
                                                      style: CustomAppTheme()
                                                          .normalText
                                                          .copyWith(
                                                              color: isBusinessActive
                                                                  ? CustomAppTheme()
                                                                      .darkGreyColor
                                                                  : CustomAppTheme()
                                                                      .backgroundColor,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  isBusinessActive
                                                                      ? FontWeight
                                                                          .w500
                                                                      : FontWeight
                                                                          .w600),
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
                                      height: med.height * 0.02,
                                    ),
                                    YouOnlineTextField(
                                      headingText: 'Business Name*',
                                      controller: businessNameController,
                                      hintText: 'Enter Business Name',
                                    ),
                                    SizedBox(
                                      height: med.height * 0.02,
                                    ),
                                    /*Text(
                                'Business Category',
                                style: CustomAppTheme().textFieldHeading,
                              ),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Container(
                                  color: Colors.transparent,
                                  height: med.height * 0.047,
                                  width: med.width,
                                  child: businessCategoryDropDown(
                                    businessCategoryValue: businessCategoryValue,
                                    onChange: (value) {
                                      setState(
                                        () {
                                          businessCategoryValue = value!;
                                        },
                                      );
                                    },
                                    context: context,
                                  ),
                                ),
                              ),*/
                                    YouOnlineTextField(
                                      headingText: 'Business Category*',
                                      controller: businessCategoryController,
                                      hintText: businessCategoryController.text,
                                      enabled: false,
                                    ),
                                    SizedBox(
                                      height: med.height * 0.02,
                                    ),
                                    YouOnlineTextField(
                                      headingText: 'Business Email*',
                                      controller: emailController,
                                      hintText: 'Enter Business Email',
                                      validator: (input) => input!.isValidEmail()
                                          ? null
                                          : "Email format is not correct",
                                    ),
                                    SizedBox(
                                      height: med.height * 0.02,
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
                                        height: med.height * 0.047,
                                        width: med.width,
                                        child: Row(
                                          children: <Widget>[
                                            countryCodeDropDown(
                                              countryCodeDropDownValue:
                                                  dialCodeDropDownValue,
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
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor:
                                                    CustomAppTheme().blackColor,
                                                decoration: const InputDecoration(
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(6.0)),
                                                    borderSide: BorderSide(
                                                        color: Color(0xffa3a8b6)),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(6.0)),
                                                    borderSide: BorderSide(
                                                        color: Color(0xffa3a8b6)),
                                                  ),
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          20, 10, 20, 10),
                                                  hintText:
                                                      'Business Phone Number',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                  filled: true,
                                                  fillColor: Colors.white70,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(6.0)),
                                                    borderSide: BorderSide(
                                                        color: Color(0xffa3a8b6)),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(6.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
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
                                      'Country*',
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
                                                generalViewModel.statesByCountry =
                                                    [];
                                                generalViewModel.citiesByState =
                                                    [];
                                                stateDropDownValue = null;
                                                cityDropDownValue = null;
                                                generalViewModel
                                                    .changeStatesByCountry(
                                                        generalViewModel
                                                            .statesByCountry);
                                                generalViewModel
                                                    .changeCitiesByStates(
                                                        generalViewModel
                                                            .citiesByState);
                                                for (int i = 0;
                                                    i <
                                                        generalViewModel
                                                            .countriesCodeList
                                                            .length;
                                                    i++) {
                                                  if (value ==
                                                      generalViewModel
                                                          .countriesCodeList[i]
                                                          .name) {
                                                    countryId = generalViewModel
                                                        .countriesCodeList[i].id!;
                                                    getStates(
                                                        countryId: generalViewModel
                                                            .countriesCodeList[i]
                                                            .id!);
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
                                      'State*',
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
                                            stateDropDownValue:
                                                stateDropDownValue,
                                            onChange: (value) {
                                              setState(() {
                                                stateDropDownValue = value!;
                                                generalViewModel.citiesByState =
                                                    [];
                                                cityDropDownValue = null;
                                                generalViewModel
                                                    .changeCitiesByStates(
                                                        generalViewModel
                                                            .citiesByState);
                                                for (int i = 0;
                                                    i <
                                                        generalViewModel
                                                            .statesByCountry!
                                                            .length;
                                                    i++) {
                                                  if (value ==
                                                      generalViewModel
                                                          .statesByCountry![i]
                                                          .name) {
                                                    stateId = generalViewModel
                                                        .statesByCountry![i].id!;
                                                    getCities(
                                                        stateId: generalViewModel
                                                            .statesByCountry![i]
                                                            .id!);
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
                                      'City*',
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
                                                            .citiesByState!
                                                            .length;
                                                    i++) {
                                                  if (value ==
                                                      generalViewModel
                                                          .citiesByState![i]
                                                          .name) {
                                                    cityId = generalViewModel
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
                                      headingText: 'About*',
                                      controller: aboutController,
                                      maxLine: 6,
                                      hintText: '',
                                    ),
                                    SizedBox(
                                      height: med.height * 0.02,
                                    ),
                                    Text(
                                      'Street Address*',
                                      style: CustomAppTheme().textFieldHeading,
                                    ),
                                    SizedBox(
                                      height: med.height * 0.01,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddLocationScreen(
                                              categoryIndex: -2,
                                              location: "",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xffa3a8b6)),
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.location_on_rounded,
                                                color: CustomAppTheme()
                                                    .darkGreyColor,
                                                size: 14),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 5),
                                              child: SizedBox(
                                                width: med.width * 0.7,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddLocationScreen(
                                                          categoryIndex: -2,
                                                          location: "",
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: profileViewModel
                                                              .tempBusinessValues
                                                              .businessLocation ==
                                                          null
                                                      ? Text(
                                                          'Set Location',
                                                          style: CustomAppTheme()
                                                              .normalGreyText
                                                              .copyWith(
                                                                fontSize: 12,
                                                                color: CustomAppTheme()
                                                                    .primaryColor,
                                                              ),
                                                        )
                                                      : Text(
                                                          profileViewModel
                                                              .tempBusinessValues
                                                              .businessLocation!,
                                                          style: CustomAppTheme()
                                                              .normalGreyText
                                                              .copyWith(
                                                                  fontSize: 12,
                                                                  color: CustomAppTheme()
                                                                      .darkGreyColor),
                                                        ),
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddLocationScreen(
                                                      categoryIndex: -2,
                                                      location: profileViewModel
                                                              .tempBusinessValues
                                                              .businessLocation ??
                                                          "",
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: const Color(0xffe6fff9),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Icon(
                                                      Icons.location_on_rounded,
                                                      color: CustomAppTheme()
                                                          .primaryColor,
                                                      size: 14),
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
                                    profileViewModel
                                                .tempBusinessValues.latitude !=
                                            null
                                        ? ProductLocationMapWidget(
                                            latitude: double.parse(
                                                profileViewModel
                                                    .tempBusinessValues
                                                    .latitude!),
                                            longitude: double.parse(
                                                profileViewModel
                                                    .tempBusinessValues
                                                    .longitude!),
                                          )
                                        : const SizedBox.shrink(),
                                    SizedBox(
                                      height: med.height * 0.02,
                                    ),
                                    YouOnlineTextField(
                                      headingText: 'Company License Number*',
                                      controller: licenceController,
                                      enabled: widget.isRejected
                                          ? true
                                          : widget.isCreateProfile,
                                      hintText: 'Enter Company License Number',
                                    ),
                                    SizedBox(
                                      height: med.height * 0.02,
                                    ),
                                    Text(
                                      'Upload National ID*',
                                      style: CustomAppTheme().textFieldHeading,
                                    ),
                                    SizedBox(
                                      height: med.height * 0.02,
                                    ),
                                    SizedBox(
                                      height: med.height * 0.12,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          nationalIdImage.isNotEmpty
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 15),
                                                  constraints: BoxConstraints(
                                                      maxHeight:
                                                          med.height * 0.25,
                                                      minHeight:
                                                          med.height * 0.12),
                                                  child: GridView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        nationalIdImage.length,
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    gridDelegate:
                                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 97,
                                                      childAspectRatio: 1.0,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 20,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        height: med.height * 0.12,
                                                        width: med.width * 0.25,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: CustomAppTheme()
                                                              .greyColor,
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  nationalIdImage[
                                                                      index]),
                                                              fit: BoxFit.cover),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  nationalIdImage
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/svgs/deleteIcon2.svg',
                                                                height:
                                                                    med.height *
                                                                        0.02,
                                                                width: med.width *
                                                                    0.6,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container(),
                                          Container(
                                            constraints: BoxConstraints(
                                                maxHeight: med.height * 0.25,
                                                minHeight: med.height * 0.12),
                                            child: GridView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: nationalIdDoc.length + 1,
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 97,
                                                childAspectRatio: 1.0,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 20,
                                              ),
                                              itemBuilder: (context, index) {
                                                return index ==
                                                        nationalIdDoc.length
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          getDoc(
                                                              docType:
                                                                  'National');
                                                        },
                                                        child: DottedBorder(
                                                          borderType:
                                                              BorderType.RRect,
                                                          radius: const Radius
                                                              .circular(6),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(6),
                                                            child: SizedBox(
                                                              height: med.height *
                                                                  0.12,
                                                              width: med.width *
                                                                  0.25,
                                                              child: const Center(
                                                                child: Icon(
                                                                    Icons
                                                                        .add_circle_outline,
                                                                    size: 30),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: med.height * 0.12,
                                                        width: med.width * 0.25,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: CustomAppTheme()
                                                              .greyColor,
                                                          image: DecorationImage(
                                                              image: FileImage(File(
                                                                  nationalIdDoc[
                                                                          index]
                                                                      .path)),
                                                              fit: BoxFit.cover),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  nationalIdDoc
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/svgs/deleteIcon2.svg',
                                                                height:
                                                                    med.height *
                                                                        0.02,
                                                                width: med.width *
                                                                    0.6,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: med.height * 0.04,
                                    ),
                                    Text(
                                      'Upload Passport Image*',
                                      style: CustomAppTheme().textFieldHeading,
                                    ),
                                    SizedBox(
                                      height: med.height * 0.02,
                                    ),
                                    SizedBox(
                                      height: med.height * 0.12,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          passportImage.isNotEmpty
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 15),
                                                  constraints: BoxConstraints(
                                                      maxHeight:
                                                          med.height * 0.25,
                                                      minHeight:
                                                          med.height * 0.12),
                                                  child: GridView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        passportImage.length,
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    gridDelegate:
                                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 97,
                                                      childAspectRatio: 1.0,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 20,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        height: med.height * 0.12,
                                                        width: med.width * 0.25,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: CustomAppTheme()
                                                              .greyColor,
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  passportImage[
                                                                      index]),
                                                              fit: BoxFit.cover),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  passportImage
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/svgs/deleteIcon2.svg',
                                                                height:
                                                                    med.height *
                                                                        0.02,
                                                                width: med.width *
                                                                    0.6,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container(),
                                          Container(
                                            constraints: BoxConstraints(
                                                maxHeight: med.height * 0.25,
                                                minHeight: med.height * 0.12),
                                            child: GridView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: passportDoc.length + 1,
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 97,
                                                childAspectRatio: 1.0,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 20,
                                              ),
                                              itemBuilder: (context, index) {
                                                return index == passportDoc.length
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          getDoc(
                                                              docType:
                                                                  'Passport');
                                                        },
                                                        child: DottedBorder(
                                                          borderType:
                                                              BorderType.RRect,
                                                          radius: const Radius
                                                              .circular(6),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(6),
                                                            child: SizedBox(
                                                              height: med.height *
                                                                  0.12,
                                                              width: med.width *
                                                                  0.25,
                                                              child: const Center(
                                                                child: Icon(
                                                                    Icons
                                                                        .add_circle_outline,
                                                                    size: 30),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: med.height * 0.12,
                                                        width: med.width * 0.25,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: CustomAppTheme()
                                                              .greyColor,
                                                          image: DecorationImage(
                                                              image: FileImage(
                                                                  File(passportDoc[
                                                                          index]
                                                                      .path)),
                                                              fit: BoxFit.cover),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  passportDoc
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/svgs/deleteIcon2.svg',
                                                                height:
                                                                    med.height *
                                                                        0.02,
                                                                width: med.width *
                                                                    0.6,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), // : docWidget(

                                    SizedBox(
                                      height: med.height * 0.04,
                                    ),
                                    Text(
                                      'Upload Your Recent Photo*',
                                      style: CustomAppTheme().textFieldHeading,
                                    ),
                                    SizedBox(
                                      height: med.height * 0.02,
                                    ),
                                    SizedBox(
                                      height: med.height * 0.12,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          userPhotoImage.isNotEmpty
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 15),
                                                  constraints: BoxConstraints(
                                                      maxHeight:
                                                          med.height * 0.25,
                                                      minHeight:
                                                          med.height * 0.12),
                                                  child: GridView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        userPhotoImage.length,
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    gridDelegate:
                                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 97,
                                                      childAspectRatio: 1.0,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 20,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                      print(
                                                          userPhotoImage[index]);
                                                      return Container(
                                                        height: med.height * 0.12,
                                                        width: med.width * 0.25,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: CustomAppTheme()
                                                              .greyColor,
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  userPhotoImage[
                                                                      index]),
                                                              fit: BoxFit.cover),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  userPhotoImage
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/svgs/deleteIcon2.svg',
                                                                height:
                                                                    med.height *
                                                                        0.02,
                                                                width: med.width *
                                                                    0.6,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container(),
                                          Container(
                                            constraints: BoxConstraints(
                                                maxHeight: med.height * 0.25,
                                                minHeight: med.height * 0.12),
                                            child: GridView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: userPhoto.length + 1,
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 97,
                                                childAspectRatio: 1.0,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 20,
                                              ),
                                              itemBuilder: (context, index) {
                                                return index == userPhoto.length
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          getDoc(docType: 'User');
                                                        },
                                                        child: DottedBorder(
                                                          borderType:
                                                              BorderType.RRect,
                                                          radius: const Radius
                                                              .circular(6),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(6),
                                                            child: SizedBox(
                                                              height: med.height *
                                                                  0.12,
                                                              width: med.width *
                                                                  0.25,
                                                              child: const Center(
                                                                child: Icon(
                                                                    Icons
                                                                        .add_circle_outline,
                                                                    size: 30),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: med.height * 0.12,
                                                        width: med.width * 0.25,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: CustomAppTheme()
                                                              .greyColor,
                                                          image: DecorationImage(
                                                              image: FileImage(
                                                                  File(userPhoto[
                                                                          index]
                                                                      .path)),
                                                              fit: BoxFit.cover),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  userPhoto
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/svgs/deleteIcon2.svg',
                                                                height:
                                                                    med.height *
                                                                        0.02,
                                                                width: med.width *
                                                                    0.6,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: med.height * 0.04,
                                        ),
                                        Text(
                                          'Upload Your Company License*',
                                          style:
                                              CustomAppTheme().textFieldHeading,
                                        ),
                                        SizedBox(
                                          height: med.height * 0.02,
                                        ),
                                        SizedBox(
                                          height: med.height * 0.12,
                                          width: double.infinity,
                                          child: Row(
                                            children: [
                                              licenseFileImage.isNotEmpty
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 15),
                                                      constraints: BoxConstraints(
                                                          maxHeight:
                                                              med.height * 0.25,
                                                          minHeight:
                                                              med.height * 0.12),
                                                      child: GridView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            licenseFileImage
                                                                .length,
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        gridDelegate:
                                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent: 97,
                                                          childAspectRatio: 1.0,
                                                          crossAxisSpacing: 10,
                                                          mainAxisSpacing: 20,
                                                        ),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Container(
                                                            height:
                                                                med.height * 0.12,
                                                            width:
                                                                med.width * 0.25,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              color:
                                                                  CustomAppTheme()
                                                                      .greyColor,
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      licenseFileImage[
                                                                          index]),
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      licenseFileImage
                                                                          .removeAt(
                                                                              index);
                                                                    });
                                                                  },
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/svgs/deleteIcon2.svg',
                                                                    height:
                                                                        med.height *
                                                                            0.02,
                                                                    width:
                                                                        med.width *
                                                                            0.6,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : Container(),
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxHeight: med.height * 0.25,
                                                    minHeight: med.height * 0.12),
                                                child: GridView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      licenseFile.length + 1,
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  gridDelegate:
                                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                                    maxCrossAxisExtent: 97,
                                                    childAspectRatio: 1.0,
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 20,
                                                  ),
                                                  itemBuilder: (context, index) {
                                                    return index ==
                                                            licenseFile.length
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              getDoc(
                                                                  docType:
                                                                      'License');
                                                            },
                                                            child: DottedBorder(
                                                              borderType:
                                                                  BorderType
                                                                      .RRect,
                                                              radius: const Radius
                                                                  .circular(6),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                child: SizedBox(
                                                                  height:
                                                                      med.height *
                                                                          0.12,
                                                                  width:
                                                                      med.width *
                                                                          0.25,
                                                                  child:
                                                                      const Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .add_circle_outline,
                                                                        size: 30),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            height:
                                                                med.height * 0.12,
                                                            width:
                                                                med.width * 0.25,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              color:
                                                                  CustomAppTheme()
                                                                      .greyColor,
                                                              image: DecorationImage(
                                                                  image: FileImage(File(
                                                                      licenseFile[
                                                                              index]
                                                                          .path)),
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      licenseFile
                                                                          .removeAt(
                                                                              index);
                                                                    });
                                                                  },
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/svgs/deleteIcon2.svg',
                                                                    height:
                                                                        med.height *
                                                                            0.02,
                                                                    width:
                                                                        med.width *
                                                                            0.6,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: med.height * 0.05,
                                    ),
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
                                                  MaterialStateProperty
                                                      .all<Color>(CustomAppTheme()
                                                          .lightGreyColor),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              )),
                                            ),
                                            child: Text(
                                              'Cancel',
                                              style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    color: CustomAppTheme()
                                                        .greyColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: SizedBox(
                                            width: med.width * 0.35,
                                            child: isLoading
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color: CustomAppTheme()
                                                                .primaryColor),
                                                  )
                                                : YouOnlineButton(
                                                    text: 'Save',
                                                    onTap: widget.isCreateProfile
                                                        ? () async {
                                                            if (createBusinessFormKey
                                                                .currentState!
                                                                .validate()) {
                                                              if (businessNameController.text.isNotEmpty &&
                                                                  emailController
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  phoneController
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  aboutController
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  licenceController
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  licenseFile
                                                                      .isNotEmpty &&
                                                                  userPhoto
                                                                      .isNotEmpty &&
                                                                  passportDoc
                                                                      .isNotEmpty &&
                                                                  nationalIdDoc
                                                                      .isNotEmpty &&
                                                                  businessCategoryValue !=
                                                                      null &&
                                                                  dialCodeDropDownValue !=
                                                                      null &&
                                                                  stateDropDownValue !=
                                                                      null &&
                                                                  countriesDropDownValue !=
                                                                      null &&
                                                                  profileViewModel
                                                                          .tempBusinessValues
                                                                          .businessLocation !=
                                                                      null &&
                                                                  profileViewModel
                                                                          .tempBusinessValues
                                                                          .latitude !=
                                                                      null &&
                                                                  profileViewModel
                                                                          .tempBusinessValues
                                                                          .longitude !=
                                                                      null) {
                                                                if (profileViewModel
                                                                        .tempBusinessValues
                                                                        .profileImage ==
                                                                    null) {
                                                                  helper.showToast(
                                                                      'Add a profile image of your business');
                                                                } else {
                                                                  if (profileViewModel
                                                                          .tempBusinessValues
                                                                          .coverImage ==
                                                                      null) {
                                                                    helper.showToast(
                                                                        'Add a cover image of your business');
                                                                  } else {
                                                                    setState(() {
                                                                      isLoading =
                                                                          true;
                                                                    });
                                                                    await profileViewModel.createBusinessProfile(
                                                                        context:
                                                                            context,
                                                                        businessName: businessNameController
                                                                            .text,
                                                                        businessCategory:
                                                                            businessCategoryValue!,
                                                                        email: emailController
                                                                            .text,
                                                                        phoneNumber:
                                                                            phoneController
                                                                                .text,
                                                                        dialCode:
                                                                            dialCodeDropDownValue!,
                                                                        countryId:
                                                                            countryId!,
                                                                        isBusinessActive:
                                                                            isBusinessActive,
                                                                        stateId:
                                                                            stateId!,
                                                                        cityId:
                                                                            cityId,
                                                                        about: aboutController
                                                                            .text,
                                                                        businessLocation: profileViewModel
                                                                            .tempBusinessValues
                                                                            .businessLocation!,
                                                                        latitude: profileViewModel
                                                                            .tempBusinessValues
                                                                            .latitude
                                                                            .toString(),
                                                                        longitude: profileViewModel
                                                                            .tempBusinessValues
                                                                            .longitude
                                                                            .toString(),
                                                                        licenceNumber:
                                                                            licenceController
                                                                                .text,
                                                                        coverImage: profileViewModel
                                                                            .tempBusinessValues
                                                                            .coverImage!,
                                                                        profileImage: profileViewModel
                                                                            .tempBusinessValues
                                                                            .profileImage!,
                                                                        nationalIdDoc:
                                                                            nationalIdDoc,
                                                                        passportDoc:
                                                                            passportDoc,
                                                                        userPhoto:
                                                                            userPhoto,
                                                                        licenseFile:
                                                                            licenseFile);
                                                                    profileViewModel
                                                                        .changeTempBusinessValues(
                                                                            CreateBusinessProfileModel());
                                                                    helper.showToast(
                                                                        '${widget.module} Profile created successfully, wait for the admin to approve your request');
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                }
                                                              } else {
                                                                helper.showToast(
                                                                    'Fill all the fields properly');
                                                              }
                                                            } else {
                                                              helper.showToast(
                                                                  'Fill all the fields properly');
                                                            }
                                                          }
                                                        : () async {
                                                            if (createBusinessFormKey
                                                                .currentState!
                                                                .validate()) {
                                                              if (businessNameController.text.isNotEmpty &&
                                                                  emailController
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  phoneController
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  aboutController
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  licenceController
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  businessCategoryValue !=
                                                                      null &&
                                                                  dialCodeDropDownValue !=
                                                                      null &&
                                                                  stateDropDownValue !=
                                                                      null &&
                                                                  countriesDropDownValue !=
                                                                      null &&
                                                                  profileViewModel
                                                                          .tempBusinessValues
                                                                          .businessLocation !=
                                                                      null &&
                                                                  profileViewModel
                                                                          .tempBusinessValues
                                                                          .latitude !=
                                                                      null &&
                                                                  profileViewModel
                                                                          .tempBusinessValues
                                                                          .longitude !=
                                                                      null) {
                                                                setState(() {
                                                                  isLoading =
                                                                      true;
                                                                });
                                                                await profileViewModel
                                                                    .updateBusinessProfile(
                                                                  id: widget
                                                                      .businessData
                                                                      .id!,
                                                                  businessName:
                                                                      businessNameController
                                                                          .text,
                                                                  businessCategory:
                                                                      businessCategoryValue!,
                                                                  email:
                                                                      emailController
                                                                          .text,
                                                                  phoneNumber:
                                                                      phoneController
                                                                          .text,
                                                                  dialCode:
                                                                      dialCodeDropDownValue!,
                                                                  isBusinessActive:
                                                                      isBusinessActive,
                                                                  countryId:
                                                                      countryId!,
                                                                  stateId:
                                                                      stateId!,
                                                                  cityId: cityId!,
                                                                  about:
                                                                      aboutController
                                                                          .text,
                                                                  businessLocation:
                                                                      profileViewModel
                                                                          .tempBusinessValues
                                                                          .businessLocation!,
                                                                  latitude: profileViewModel
                                                                      .tempBusinessValues
                                                                      .latitude
                                                                      .toString(),
                                                                  longitude: profileViewModel
                                                                      .tempBusinessValues
                                                                      .longitude
                                                                      .toString(),
                                                                  licenceNumber:
                                                                      licenceController
                                                                          .text,
                                                                  coverImage: profileViewModel
                                                                              .tempBusinessValues
                                                                              .coverImage ==
                                                                          null
                                                                      ? null
                                                                      : profileViewModel
                                                                          .tempBusinessValues
                                                                          .coverImage!,
                                                                  profileImage: profileViewModel
                                                                              .tempBusinessValues
                                                                              .profileImage ==
                                                                          null
                                                                      ? null
                                                                      : profileViewModel
                                                                          .tempBusinessValues
                                                                          .profileImage!,
                                                                );
                                                                profileViewModel
                                                                    .changeTempBusinessValues(
                                                                        CreateBusinessProfileModel());
                                                                helper.showToast(
                                                                    '${widget.module} profile updated!');
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              } else {
                                                                helper.showToast(
                                                                    'Fill all the fields properly');
                                                              }
                                                            } else {
                                                              helper.showToast(
                                                                  'Fill all the fields properly');
                                                            }
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
                      ),
                      Column(
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
                                    trailingIcon:
                                        const Icon(Icons.camera_alt_outlined),
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
                                          color:
                                              CustomAppTheme().secondaryColor)),
                                  trailingIcon: Icon(Icons.account_box,
                                      color: CustomAppTheme().secondaryColor),
                                  onPressed: () {
                                    showImageViewer(
                                      context,
                                      profileViewModel.tempBusinessValues
                                                  .profileImage !=
                                              null
                                          ? Image.file(profileViewModel
                                                  .tempBusinessValues
                                                  .profileImage!)
                                              .image
                                          : Image.network(logoImageUrl!).image,
                                      swipeDismissible: true,
                                    );
                                  },
                                ),
                              ],
                              onPressed: () {},
                              child: Stack(
                                children: [
                                  Container(
                                    height: med.height * 0.15,
                                    width: med.height * 0.15,
                                    decoration: BoxDecoration(
                                      color: CustomAppTheme().greyColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: CustomAppTheme().backgroundColor,
                                          width: 2),
                                      image: profileViewModel.tempBusinessValues
                                                  .profileImage !=
                                              null
                                          ? DecorationImage(
                                              image: FileImage(profileViewModel
                                                  .tempBusinessValues
                                                  .profileImage!),
                                              fit: BoxFit.contain)
                                          : logoImageUrl != null
                                              ? DecorationImage(
                                                  image:
                                                      NetworkImage(logoImageUrl!),
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
                                            offset:
                                                Offset(2, 4), // Shadow position
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
            ),
          );
  }

  Widget uploadDocWidget({required VoidCallback onTab}) {
    Size med = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTab,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: med.height * 0.08,
            width: med.width * 0.2,
            child: const Center(
              child: Icon(Icons.add_circle_outline, size: 30),
            ),
          ),
        ),
      ),
    );
  }

  Widget docWidget({required VoidCallback onDelete, required docName}) {
    Size med = MediaQuery.of(context).size;
    return Container(
      height: med.height * 0.08,
      width: med.width,
      decoration: BoxDecoration(
        color: const Color(0xfffdf4f1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/svgs/pdfIcon.svg',
              height: med.height * 0.05,
              width: med.width * 0.15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                height: med.height * 0.04,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: med.width * 0.6,
                      child: Text(
                        docName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CustomAppTheme().normalText.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '805 KB',
                      style: CustomAppTheme()
                          .normalText
                          .copyWith(fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onDelete,
              child: SvgPicture.asset(
                'assets/svgs/deleteIcon2.svg',
                height: med.height * 0.02,
                width: med.width * 0.6,
              ),
            ),
          ],
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

    if (isProfileImage) {
      if (sizeInMb > 3) {
        print('Size is $sizeInMb');
        helper.showLongToast('Image is more than 3 MB');
      } else {
        profileViewModel.tempBusinessValues.profileImage = file;
        profileViewModel
            .changeTempBusinessValues(profileViewModel.tempBusinessValues);
      }

      setState(() {
        isAvatarLoading = false;
      });
    } else {
      if (sizeInMb > 3) {
        print('Size is $sizeInMb');
        helper.showLongToast('Image is more than 3 MB');
      } else {
        profileViewModel.tempBusinessValues.coverImage = file;
        profileViewModel
            .changeTempBusinessValues(profileViewModel.tempBusinessValues);
      }

      setState(() {
        isAvatarLoading = false;
      });
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

Widget noDataFound() {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/svgs/notFound.svg',
          height: 90,
          width: 90,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'No Data Found',
          style: CustomAppTheme()
              .normalText
              .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ]);
}
