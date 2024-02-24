import 'package:app/common/logger/log.dart';
import 'package:app/data/models/general_res_models/country_code_res_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/add_post/widgets/custom_ad_post_widgets.dart';
import 'package:app/presentation/authentication/mixins/signup_mixin.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ApplyJobScreen extends StatefulWidget {
  final String jobId;
  final String imageUrl;
  final String currency;
  final String startingSalary;
  final String endingSalary;
  final String title;
  final String createdAd;
  final String userImage;
  final String userName;

  const ApplyJobScreen({
    Key? key,
    required this.jobId,
    required this.imageUrl,
    required this.currency,
    required this.startingSalary,
    required this.endingSalary,
    required this.title,
    required this.userImage,
    required this.userName,
    required this.createdAd,
  }) : super(key: key);

  @override
  State<ApplyJobScreen> createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen>
    with BaseMixin, SignUpMixin {
  @override
  TextEditingController fullNameController = TextEditingController();
  @override
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController coverLetterController = TextEditingController();
  String? dialCodeDropDownValue;
  int? selectedResumeIndex;
  List<CountriesModel> countriesCodeList = [];

  void getAllCountriesCode() async {
    final result = await context.read<GeneralViewModel>().getAllCountryCode();
    result.fold((l) {}, (r) {
      d('COUNTRIES CODE ***********************************');
      countriesCodeList = r.response!;
      d(countriesCodeList.toString());
      context.read<GeneralViewModel>().changeCountriesCode(r.response!);
      dialCodeDropDownValue = context.read<GeneralViewModel>().countriesCode[0];
      if (iPrefHelper.retrieveUser()!.mobileNumber != null &&
          iPrefHelper.retrieveUser()!.mobileNumber!.isNotEmpty) {
        dialCodeDropDownValue = iPrefHelper.retrieveUser()!.dialCode;
      }
      setState(() {});
    });
  }

  getMyResume() async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result = await profileViewModel.getMyResumes();
    result.fold((l) {}, (r) {
      profileViewModel.changeMyResumeList(r.resumeList!);
      if (r.resumeList!.isNotEmpty) {
        setState(() {
          selectedResumeIndex = 0;
        });
      }
    });
  }

  final applyJobFormField = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    getAllCountriesCode();
    if (profileViewModel.myResumeList.isEmpty) {
      getMyResume();
    } else {
      setState(() {
        selectedResumeIndex = 0;
      });
    }
    emailController.text = iPrefHelper.retrieveUser()!.email!;
    fullNameController.text = iPrefHelper.retrieveUser()!.firstName!;
    if (iPrefHelper.retrieveUser()!.mobileNumber != null &&
        iPrefHelper.retrieveUser()!.mobileNumber!.isNotEmpty) {
      phoneNumberController.text = iPrefHelper.retrieveUser()!.mobileNumber!;
      dialCodeDropDownValue = iPrefHelper.retrieveUser()!.dialCode;
    }
  }

  bool isLoader = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    JobViewModel jobViewModel = context.watch<JobViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Apply for job', context: context, onTap: () {Navigator.of(context).pop();}),
      body: SingleChildScrollView(
        child: Form(
          key: applyJobFormField,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: CustomAppTheme().backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: med.height * 0.1,
                          width: med.width * 0.22,
                          decoration: BoxDecoration(
                            color: CustomAppTheme().backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                            image: widget.imageUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(widget.imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 0.8,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: SizedBox(
                            height: med.height * 0.1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                  width: med.width * 0.6,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        widget.currency,
                                        style: CustomAppTheme()
                                            .normalText
                                            .copyWith(
                                                color: CustomAppTheme()
                                                    .primaryColor,
                                                fontSize: 8,
                                                fontWeight: FontWeight.w700),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          '${widget.startingSalary} - ${widget.endingSalary}',
                                          style: CustomAppTheme()
                                              .normalText
                                              .copyWith(
                                                  color: CustomAppTheme()
                                                      .primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        widget.createdAd,
                                        style: CustomAppTheme()
                                            .normalText
                                            .copyWith(
                                                color:
                                                    CustomAppTheme().greyColor,
                                                fontSize: 8,
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: med.width * 0.6,
                                  height: med.height * 0.04,
                                  child: Text(
                                    widget.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomAppTheme().normalText.copyWith(
                                        color: CustomAppTheme().blackColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: med.height * 0.03,
                                      width: med.width * 0.06,
                                      decoration: BoxDecoration(
                                        color: CustomAppTheme().primaryColor,
                                        shape: BoxShape.circle,
                                        image: widget.userImage.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    widget.userImage),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        widget.userName,
                                        style: CustomAppTheme()
                                            .normalText
                                            .copyWith(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: med.height * 0.02,
                ),
                YouOnlineTextField(
                  controller: fullNameController,
                  hintText: 'Enter full name',
                  headingText: 'Full Name',
                  validator: (value) {
                    return value!.isEmpty ? 'Name cannot be empty' : null;
                  },
                ),
                SizedBox(
                  height: med.height * 0.02,
                ),
                YouOnlineTextField(
                  controller: emailController,
                  hintText: 'Enter email',
                  headingText: 'Email Address',
                  validator: (input) => input!.isValidEmail()
                      ? null
                      : "Email format is not correct",
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
                            countryCodeDropDownValue: dialCodeDropDownValue,
                            onChange: (value) {
                              setState(() {
                                dialCodeDropDownValue = value!;
                              });
                            },
                            context: context),
                        SizedBox(
                          width: med.width * 0.01,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: phoneNumberController,
                            autocorrect: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            cursorColor: CustomAppTheme().blackColor,
                            decoration: const InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                borderSide:
                                    BorderSide(color: Color(0xffa3a8b6)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                borderSide:
                                    BorderSide(color: Color(0xffa3a8b6)),
                              ),
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 10, 20, 10),
                              hintText: 'Enter mobile number',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                              filled: true,
                              fillColor: Colors.white70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                borderSide:
                                    BorderSide(color: Color(0xffa3a8b6)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                borderSide: BorderSide(color: Colors.grey),
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
                  controller: coverLetterController,
                  hintText: '',
                  headingText: 'Cover Letter (Optional)',
                  maxLine: 8,
                ),
                SizedBox(
                  height: med.height * 0.02,
                ),
                Text(
                  'Resume',
                  style: CustomAppTheme().textFieldHeading,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xffa3a8b6)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: med.height * 0.01,
                          ),
                          profileViewModel.myResumeList.isNotEmpty
                              ? SizedBox(
                                  height: med.height * 0.06,
                                  width: med.width,
                                  child: ListView.builder(
                                    itemCount:
                                        profileViewModel.myResumeList.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedResumeIndex = index;
                                            });
                                          },
                                          child: Container(
                                            height: med.height * 0.06,
                                            width: med.width * 0.6,
                                            decoration: BoxDecoration(
                                                color: const Color(0xfffdf4f1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: selectedResumeIndex ==
                                                        index
                                                    ? Border.all(
                                                        color: CustomAppTheme()
                                                            .redColor)
                                                    : null),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Row(
                                                children: <Widget>[
                                                  SvgPicture.asset(
                                                    'assets/svgs/pdfIcon.svg',
                                                    height: med.height * 0.04,
                                                    width: med.width * 0.12,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: SizedBox(
                                                      height: med.height * 0.04,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width:
                                                                med.width * 0.4,
                                                            child: Text(
                                                              profileViewModel
                                                                  .myResumeList[
                                                                      index]
                                                                  .resumeName
                                                                  .toString(),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: CustomAppTheme()
                                                                  .normalText
                                                                  .copyWith(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                            ),
                                                          ),
                                                          Text(
                                                            '805 KB',
                                                            style: CustomAppTheme()
                                                                .normalText
                                                                .copyWith(
                                                                    fontSize: 8,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                          profileViewModel.myResumeList.isNotEmpty
                              ? SizedBox(
                                  height: med.height * 0.03,
                                )
                              : const SizedBox.shrink(),
                          GestureDetector(
                            onTap: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf', 'doc'],
                                allowMultiple: false,
                              );
                              if (result != null) {
                                setState(() {
                                  isLoading = true;
                                });
                                d('RESUME PATH : ${result.files[0].path}');
                                d('RESUME NAME : ${result.files[0].name}');
                                d('RESUME EXTENSION : ${result.files[0].extension}');
                                d('RESUME IDENTIFIER : ${result.files[0].identifier}');
                                d('RESUME RUNTIME TYPE : ${result.files[0].runtimeType}');
                                d('RESUME SIZE : ${result.files[0].size}');
                                await profileViewModel.uploadResume(
                                  resumePath: result.files[0].path!,
                                  resumeName: result.files[0].name,
                                  extension: result.files[0].extension!,
                                );
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(6),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: med.width,
                                  height: med.height * 0.04,
                                  decoration: BoxDecoration(
                                      color: CustomAppTheme().backgroundColor),
                                  child: isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          color: CustomAppTheme().primaryColor,
                                        ))
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.upload_file,
                                              color: CustomAppTheme()
                                                  .darkGreyColor,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                'Upload new resume',
                                                style: CustomAppTheme()
                                                    .normalText
                                                    .copyWith(
                                                        fontSize: 12,
                                                        color: CustomAppTheme()
                                                            .darkGreyColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: med.height * 0.01,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: med.height * 0.05,
                ),
                SizedBox(
                  width: med.width,
                  child: isLoader
                      ? Center(
                          child: CircularProgressIndicator(
                              color: CustomAppTheme().primaryColor),
                        )
                      : YouOnlineButton(
                          text: 'Apply Now',
                          onTap: () async {
                            if (applyJobFormField.currentState!.validate()) {
                              if (fullNameController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  phoneNumberController.text.isNotEmpty) {
                                setState(() {
                                  isLoader = true;
                                });
                                if (selectedResumeIndex != null) {
                                  final result = await jobViewModel.applyOnJob(
                                    jobId: widget.jobId,
                                    fullName: fullNameController.text,
                                    email: emailController.text,
                                    phoneNumber: phoneNumberController.text,
                                    dialCode: dialCodeDropDownValue!,
                                    coverLetter: coverLetterController.text,
                                    resumeId: profileViewModel
                                        .myResumeList[selectedResumeIndex!].id!,
                                  );
                                  result.fold((l) {}, (r) {
                                    helper.showToast('Applied successfully!');
                                    for (int i = 0;
                                        i < jobViewModel.jobAllAds!.length;
                                        i++) {
                                      if (jobViewModel.jobAllAds![i].id ==
                                          widget.jobId) {
                                        jobViewModel.jobAllAds![i].isApplied =
                                            true;
                                      }
                                    }
                                    jobViewModel.changeJobAllAds(
                                        jobViewModel.jobAllAds!);
                                    for (int i = 0;
                                        i < jobViewModel.jobFeaturedAds!.length;
                                        i++) {
                                      if (jobViewModel.jobFeaturedAds![i].id ==
                                          widget.jobId) {
                                        jobViewModel.jobFeaturedAds![i]
                                            .isApplied = true;
                                      }
                                    }
                                    jobViewModel.changeJobFeaturedAds(
                                        jobViewModel.jobFeaturedAds!);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                } else {
                                  helper.showToast('Select resume');
                                }
                                setState(() {
                                  isLoader = false;
                                });
                              } else {
                                helper
                                    .showToast('Fill all the fields properly');
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
