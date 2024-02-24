import 'package:app/common/logger/log.dart';
import 'package:app/data/models/business_module_models/get_business_profiles_models.dart';
import 'package:app/data/models/general_res_models/current_country_city_res_model.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/authentication/signIn_screen.dart';
import 'package:app/presentation/profile/account_setting.dart';
import 'package:app/presentation/profile/business_mode/module_option.dart';
import 'package:app/presentation/profile/business_mode/view_model/business_view_model.dart';
import 'package:app/presentation/profile/edit_profile_screen.dart';
import 'package:app/presentation/profile/help_and_support.dart';
import 'package:app/presentation/profile/manage_ads_screen.dart';
import 'package:app/presentation/profile/my_jobs_screen.dart';
import 'package:app/presentation/profile/saved_ads_screen.dart';
import 'package:app/presentation/profile/saved_resume_screen.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/profile/view_profile_screen.dart';
import 'package:app/presentation/profile/widgets/profile_options_widget.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({Key? key}) : super(key: key);

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> with BaseMixin {
  bool isBusinessModeActive = false;

  getMyProfile({required String userId}) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result = await profileViewModel.getUserProfile(userId: userId);
    result.fold((l) {}, (r) {
      profileViewModel.changeMyProfile(r);
    });
  }

  getBusinessProfile() async {
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
  void initState() {
    super.initState();
    getMyProfile(userId: iPrefHelper.retrieveUser()!.id!);
    getBusinessProfile();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    BusinessViewModel businessViewModel = context.watch<BusinessViewModel>();
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff01736E),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          'Profile',
          style: CustomAppTheme()
              .headingText
              .copyWith(fontSize: 20, color: CustomAppTheme().backgroundColor),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                d('EDIT BUTTON PRESSED ');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()));
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
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SvgPicture.asset(
                    'assets/svgs/editIcon.svg',
                    width: med.width * 0.04,
                    // height: med.height*0.015,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: med.height * 0.15,
              width: med.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xff01736E),
                    Color(0xff39B68D),
                  ],
                  begin: Alignment.topCenter, //begin of the gradient color
                  end: Alignment.bottomCenter, //end of the gradient color
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: med.height * 0.1,
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
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: med.height * 0.1,
                        ),
                        iPrefHelper.retrieveUser()!.firstName!.isNotEmpty
                            ? Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewProfileScreen(
                                                  userProfile: iPrefHelper
                                                      .retrieveUser()!,
                                                )));
                                  },
                                  child: Text(
                                    iPrefHelper.retrieveUser()!.firstName!,
                                    style: CustomAppTheme()
                                        .headingText
                                        .copyWith(fontSize: 20),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        iPrefHelper.retrieveUser()!.city!.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Center(
                                  child: Text(
                                    iPrefHelper.retrieveUser()!.cityName!,
                                    style: CustomAppTheme()
                                        .normalGreyText
                                        .copyWith(fontSize: 16),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        /*Divider(
                          color: CustomAppTheme().greyColor,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            viewWidget(
                                heading:
                                    profileViewModel.myProfile.totalActiveAds == null ? '0' : profileViewModel.myProfile.totalActiveAds.toString(),
                                text: 'Active Ads'),
                            Container(
                              width: 0.5,
                              height: med.height * 0.04,
                              color: CustomAppTheme().greyColor,
                            ),
                            viewWidget(
                                heading: profileViewModel.myProfile.totalAdsViews == null ? '0' : profileViewModel.myProfile.totalAdsViews.toString(),
                                text: 'Total Ads Views'),
                            Container(
                              width: 0.5,
                              height: med.height * 0.04,
                              color: CustomAppTheme().greyColor,
                            ),
                            viewWidget(
                                heading: profileViewModel.myProfile.totalProfileViews == null
                                    ? '0'
                                    : profileViewModel.myProfile.totalProfileViews.toString(),
                                text: 'Total Profile Views'),
                          ],
                        ),
                        Divider(
                          color: CustomAppTheme().greyColor,
                        ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),*/
                        Container(
                          height: med.height * 0.05,
                          width: med.width,
                          decoration: BoxDecoration(
                            color: CustomAppTheme().primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Switch to business mode',
                                  style: CustomAppTheme().normalText.copyWith(
                                      color: CustomAppTheme().backgroundColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                FlutterSwitch(
                                  height: med.height * 0.025,
                                  width: med.width * 0.1,
                                  toggleSize: 18.0,
                                  value: iPrefHelper.isBusinessModeOn()!,
                                  activeColor: CustomAppTheme().secondaryColor,
                                  inactiveColor: const Color(0xff006054),
                                  padding: 1.5,
                                  onToggle: (value) {
                                    // ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
                                    profileViewModel.myAutomotiveAds.clear();
                                    profileViewModel.myClassifiedAds.clear();
                                    profileViewModel.myJobAds.clear();
                                    profileViewModel.myPropertiesAds.clear();

                                    setState(() {
                                      isBusinessModeActive = value;
                                      iPrefHelper.setBusinessMode(value);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: med.height * 0.05,
                        ),
                        // ProfileOptionWidget(
                        //   svgUrl: 'assets/svgs/shield 1.svg',
                        //   optionText: 'Verify Profile',
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 const UploadDocumentsScreen()));
                        //   },
                        //   iconBgColor: const Color(0xff55fff5).withOpacity(0.2),
                        // ),
                        // SizedBox(
                        //   height: med.height * 0.03,
                        // ),
                        // iPrefHelper.isBusinessModeOn()!
                        //     ? ProfileOptionWidget(
                        //         svgUrl: 'assets/svgs/manage_ad_icon.svg',
                        //         optionText: 'Business Dashboard',
                        //         onTap: () {
                        //           Navigator.push(context, MaterialPageRoute(builder: (context) => const BusinessDashboard()));
                        //         },
                        //         iconBgColor: const Color(0xff5566ff).withOpacity(0.2),
                        //       )
                        //     : const SizedBox.shrink(),
                        // iPrefHelper.isBusinessModeOn()!
                        //     ? SizedBox(
                        //         height: med.height * 0.03,
                        //       )
                        //     : const SizedBox.shrink(),
                        iPrefHelper.isBusinessModeOn()!
                            ? ProfileOptionWidget(
                                svgUrl:
                                    'assets/svgs/create_business_profile_icon.svg',
                                optionText: 'Business Profile',
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ModuleOptionScreen()));
                                },
                                iconBgColor:
                                    const Color(0xff55ff7a).withOpacity(0.2),
                              )
                            : const SizedBox.shrink(),
                        iPrefHelper.isBusinessModeOn()!
                            ? SizedBox(
                                height: med.height * 0.03,
                              )
                            : const SizedBox.shrink(),
                        ProfileOptionWidget(
                          svgUrl: 'assets/svgs/manage_ad_icon.svg',
                          optionText: 'Manage Ads',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ManageAdsScreen()));
                          },
                          iconBgColor: const Color(0xff5566ff).withOpacity(0.2),
                        ),
                        SizedBox(
                          height: med.height * 0.03,
                        ),
                        ProfileOptionWidget(
                          svgUrl: 'assets/svgs/heartIcon.svg',
                          optionText: 'Saved Ads',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SavedAdsScreen()));
                          },
                          iconBgColor: const Color(0xffffcf55).withOpacity(0.2),
                        ),
                        SizedBox(
                          height: med.height * 0.03,
                        ),
                        iPrefHelper.isBusinessModeOn()!
                            ? const SizedBox.shrink()
                            : ProfileOptionWidget(
                                svgUrl: 'assets/svgs/resumeIcon.svg',
                                iconBgColor: const Color(0XFFFFE2D2),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SavedResumeScreen()));
                                },
                                optionText: 'Saved Resume',
                              ),
                        iPrefHelper.isBusinessModeOn()!
                            ? const SizedBox.shrink()
                            : SizedBox(
                                height: med.height * 0.03,
                              ),
                        iPrefHelper.isBusinessModeOn()!
                            ? const SizedBox.shrink()
                            : ProfileOptionWidget(
                                svgUrl: 'assets/svgs/jobIcon.svg',
                                iconBgColor: const Color(0xffe1f4ff),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyJobScreen()));
                                },
                                optionText: 'My Jobs',
                              ),
                        iPrefHelper.isBusinessModeOn()!
                            ? const SizedBox.shrink()
                            : SizedBox(
                                height: med.height * 0.03,
                              ),
                        ProfileOptionWidget(
                          svgUrl: 'assets/svgs/settingIcon.svg',
                          iconBgColor: const Color(0xfff2e4fe),
                          optionText: 'Account Settings',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AccountSettings()));
                          },
                        ),
                        SizedBox(
                          height: med.height * 0.03,
                        ),
                        ProfileOptionWidget(
                          svgUrl: 'assets/svgs/customerSupportIcon.svg',
                          optionText: 'Help & Support',
                          iconBgColor: const Color(0xffffe8e0),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HelpAndSupport()));
                          },
                        ),
                        SizedBox(
                          height: med.height * 0.03,
                        ),
                        ProfileOptionWidget(
                          svgUrl: 'assets/svgs/logout_icon.svg',
                          optionText: 'Log Out',
                          iconBgColor: const Color(0xffffe6f3),
                          onTap: () {
                            logoutMethod(profileViewModel);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: med.height * 0.025,
                ),
                Center(
                  child: Container(
                    height: med.height * 0.15,
                    decoration: BoxDecoration(
                      color: CustomAppTheme().primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: CustomAppTheme().backgroundColor, width: 2),
                      image: iPrefHelper
                              .retrieveUser()!
                              .profilePicture!
                              .isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(
                                  iPrefHelper.retrieveUser()!.profilePicture!),
                              fit: BoxFit.contain)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  logoutMethod(profileViewModel) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MediaQuery.of(context).size.width * .03),
          topRight: Radius.circular(MediaQuery.of(context).size.width * .03),
        ),
      ),
      builder: (context) {
        GeneralViewModel generalViewModel = context.watch<GeneralViewModel>();
        return SizedBox(
          height: MediaQuery.of(context).size.height * .2,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                Text(
                  'YouOnline',
                  style: CustomAppTheme().normalText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                Text(
                  "Confirm to log out from YouOnline.",
                  style: CustomAppTheme().normalText.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
                const Spacer(),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .05,
                      width: MediaQuery.of(context).size.width * .3,
                      child: YouOnlineButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        text: 'Cancel',
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .03,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .05,
                      width: MediaQuery.of(context).size.width * .3,
                      child: YouOnlineButton(
                        onTap: () {
                          iPrefHelper
                              .saveClassifiedProfile(BusinessProfileModel());
                          iPrefHelper
                              .saveAutomotiveProfile(BusinessProfileModel());
                          iPrefHelper
                              .savePropertyProfile(BusinessProfileModel());
                          iPrefHelper.saveJobProfile(BusinessProfileModel());
                          iPrefHelper.saveResentSearches(<String>[]);
                          iPrefHelper.saveUser(UserProfileModel());
                          iPrefHelper.setBusinessMode(false);
                          iPrefHelper.saveToken('');
                          iPrefHelper.setIsLoggedIn(false);
                          iPrefHelper.saveUserCurrentCountry('');
                          iPrefHelper.saveUserCurrentCity('');
                          generalViewModel.userCurrentCountry = null;
                          generalViewModel.userCurrentCity = null;
                          generalViewModel.userCities = [];
                          generalViewModel.otherCountries = [];
                          generalViewModel.userLocationData =
                              CurrentCountryCityResModel();
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                              (route) => false);
                          profileViewModel.myClassifiedAds.clear();
                          profileViewModel.myAutomotiveAds.clear();
                          profileViewModel.myJobAds.clear();
                          profileViewModel.myPropertiesAds.clear();
                          profileViewModel.myFavClassifiedAds.clear();
                          profileViewModel.myFavAutomotiveAds.clear();
                          profileViewModel.myFavPropertyAds.clear();
                          profileViewModel.myFavJobAds.clear();
                        },
                        text: 'Confirm',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
