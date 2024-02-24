import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/domain/entities/auth_entities/change_pass_entities.dart';
import 'package:app/domain/use_case/auth_useCases/change_pass_usecase.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/authentication/mixins/login_mixin.dart';
import 'package:app/presentation/profile/mixins/profile_mixin.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/account_setting_option_widget.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings>
    with ProfileMixin, LoginMixin, BaseMixin {
  bool isLoader = false;
  @override
  void initState() {
    super.initState();
    UserProfileModel user = iPrefHelper.retrieveUser() ?? UserProfileModel();
    isPhoneNumberOnAds = user.mobilePrivacy == 'Show' ? true : false;
    isSpecialOffers = user.specialOfferPrivacy == 'Show' ? true : false;
    isRecommendations = user.recommendedPrivacy == 'Show' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(
          context: context,
          title: 'Account Settings',
          onTap: () {Navigator.of(context).pop();},
          bgColor: const Color(0xff01736E),
          isTextWhite: true),
      body: Stack(
        children: <Widget>[
          Container(
            height: med.height * 0.1,
            width: med.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xff01736E),
                  Color(0xff39B68D),
                ],
                begin: Alignment.topCenter, //begin of the gradient color
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: med.height * 0.05,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: med.height * 0.05,
                        ),
                        Text(
                          'Privacy & Notifications',
                          style: CustomAppTheme().normalText.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SizedBox(
                          height: med.height * 0.03,
                        ),
                        AccountSettingOption(
                          headingText: 'Show Phone Number on Ads',
                          detailText: 'Display your phone on ads',
                          isActive: isPhoneNumberOnAds,
                          onToggle: (value) {
                            setState(() {
                              isPhoneNumberOnAds = value;
                              profileViewModel.editAccountSetting(
                                  privacy: value ? 'Show' : 'Hide',
                                  privacyField: 'mobile');
                              UserProfileModel user =
                                  iPrefHelper.retrieveUser() ??
                                      UserProfileModel();
                              user.mobilePrivacy =
                                  value == true ? 'Show' : 'Hide';
                              iPrefHelper.saveUser(user);
                            });
                          },
                        ),
                        // SizedBox(
                        //   height: med.height * 0.02,
                        // ),
                        // AccountSettingOption(
                        //   headingText: 'Special Offers',
                        //   detailText:
                        //       'Receive updates, offers, surveys and more',
                        //   isActive: isSpecialOffers,
                        //   onToggle: (value) {
                        //     setState(() {
                        //       isSpecialOffers = value;
                        //       profileViewModel.editAccountSetting(
                        //           privacy: value ? 'Show' : 'Hide',
                        //           privacyField: 'special_offer');
                        //       UserProfileModel user =
                        //           iPrefHelper.retrieveUser() ??
                        //               UserProfileModel();
                        //       user.specialOfferPrivacy =
                        //           value == true ? 'Show' : 'Hide';
                        //       iPrefHelper.saveUser(user);
                        //     });
                        //   },
                        // ),
                        // SizedBox(
                        //   height: med.height * 0.02,
                        // ),
                        // AccountSettingOption(
                        //   headingText: 'Recommendations',
                        //   detailText:
                        //       'Receive recommendations based on your activity',
                        //   isActive: isRecommendations,
                        //   onToggle: (value) {
                        //     setState(() {
                        //       isRecommendations = value;
                        //       profileViewModel.editAccountSetting(
                        //           privacy: value ? 'Show' : 'Hide',
                        //           privacyField: 'recommended');
                        //       UserProfileModel user =
                        //           iPrefHelper.retrieveUser() ??
                        //               UserProfileModel();
                        //       user.recommendedPrivacy =
                        //           value == true ? 'Show' : 'Hide';
                        //       iPrefHelper.saveUser(user);
                        //     });
                        //   },
                        // ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        Divider(
                          color: CustomAppTheme().greyColor.withOpacity(0.3),
                        ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        Text(
                          'Change Password',
                          style: CustomAppTheme().normalText.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SizedBox(
                          height: med.height * 0.03,
                        ),
                        YouOnlineTextField(
                            controller: currentPassword,
                            hintText: 'Enter current password',
                            headingText: 'Current Password',
                            isObscure: true,
                            isSuffix: true),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        YouOnlineTextField(
                            controller: newPassword,
                            hintText: 'Enter new password',
                            headingText: 'New Password',
                            isObscure: true,
                            isSuffix: true),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        YouOnlineTextField(
                            controller: confirmPassword,
                            hintText: 'Re-enter new password',
                            headingText: 'Confirm New Password',
                            isObscure: true,
                            isSuffix: true),
                        SizedBox(
                          height: med.height * 0.05,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: med.width * 0.35,
                            child: isLoader
                                ? Center(
                                    child: CircularProgressIndicator(
                                    color: CustomAppTheme().primaryColor,
                                  ))
                                : YouOnlineButton(
                                    text: 'Save',
                                    onTap: () async {
                                      if (currentPassword.text.isEmpty &&
                                          newPassword.text.isEmpty &&
                                          confirmPassword.text.isEmpty) {
                                        helper.showToast(
                                            'Please fill all the fields.');
                                      } else {
                                        if (newPassword.text.isEmpty !=
                                            confirmPassword.text.isEmpty) {
                                          helper.showToast(
                                              'New Password and Confirm Password does\'t match.');
                                        } else {
                                          setState(() {
                                            isLoader = true;
                                          });
                                          final changePass =
                                              ChangePassUseCase(repo);
                                          final result = await changePass(
                                            ChangePassEntities(
                                              oldPassword: currentPassword.text,
                                              newPassword: newPassword.text,
                                              confirmPassword:
                                                  confirmPassword.text,
                                            ),
                                          );
                                          result.fold((error) {
                                            String _error =
                                                ErrorMessage.fromError(error)
                                                    .message
                                                    .toString();
                                            d('ON ERROR : $_error');
                                            showOverlay(_error);
                                          }, (r) {
                                            showOverlay(
                                                r.response!.message.toString());
                                            Navigator.pop(context);
                                          });
                                          setState(() {
                                            isLoader = false;
                                          });
                                        }
                                      }
                                    },
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: med.height * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
