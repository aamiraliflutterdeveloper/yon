import 'dart:convert';

import 'package:app/common/logger/log.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/chat/dm_screen.dart';
import 'package:app/presentation/chat/view_model/chat_view_model.dart';
import 'package:app/presentation/home/home_screen.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/jobAds_widget.dart';
import 'package:app/presentation/utils/widgets/product_card.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:app/presentation/widgets_screens/report_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ViewProfileScreen extends StatefulWidget {
  final UserProfileModel userProfile;
  const ViewProfileScreen({Key? key, required this.userProfile})
      : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> with BaseMixin {
  bool isDataFetching = false;
  int selectedModuleIndex = 0;
  int totalAds = 0;

  getUserAllAds() async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final result =
        await profileViewModel.getUserAllAds(userId: widget.userProfile.id!);
    result.fold((l) {}, (r) {
      profileViewModel.changeUserAllAds(
        automotiveAds: r.results!.automotiveAds!,
        classifiedAds: r.results!.classifiedAds!,
        jobAds: r.results!.jobAds!,
        propertyAds: r.results!.propertyAds!,
      );
      setState(() {
        totalAds = r.results!.classifiedAds!.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserAllAds();
  }

  Future<bool> onWillPop() {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    profileViewModel.userClassifiedAds = [];
    profileViewModel.userAutomotiveAds = [];
    profileViewModel.userPropertyAds = [];
    profileViewModel.userJobAds = [];
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    ChatViewModel chatViewModel = context.watch<ChatViewModel>();
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: med.height * 0.26,
                    width: med.width,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff01736E),
                          Color(0xff39B68D),
                        ],
                        begin:
                            Alignment.topCenter, //begin of the gradient color
                        end: Alignment.bottomCenter, //end of the gradient color
                      ),
                      image: widget.userProfile.coverPicture != null
                          ? DecorationImage(
                              image: NetworkImage(
                                  widget.userProfile.coverPicture!),
                              fit: BoxFit.contain)
                          : null,
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
                              width: med.width * 0.3,
                            ),
                            Center(
                              child: Text(
                                'Profile',
                                style: CustomAppTheme().headingText.copyWith(
                                    fontSize: 20,
                                    color: CustomAppTheme().backgroundColor),
                              ),
                            ),
                            const Spacer(),
                            PopupMenuButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              color: Colors.white,
                              child: Center(
                                  child: Icon(
                                Icons.flag,
                                color: CustomAppTheme().blackColor,
                              )),
                              onSelected: (value) {
                                // your logic
                                if (value == "/report") {
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                        builder: (context, setState) {
                                      return ReportUserScreen(
                                        userId: widget.userProfile.id!,
                                      );
                                    }),
                                  );
                                } else {
                                  Get.defaultDialog(
                                      middleText:
                                          "Are you sure do you want block this user!",
                                      contentPadding: const EdgeInsets.all(20),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Container(
                                                height: med.height * 0.038,
                                                margin: const EdgeInsets.only(
                                                    right: 15),
                                                decoration: BoxDecoration(
                                                  color: CustomAppTheme()
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                      'Cancel',
                                                      style: CustomAppTheme()
                                                          .normalText
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                Get.back();
                                                // print(
                                                //     "Token ${iPrefHelper.retrieveToken()}");
                                                // print(
                                                //     "Token ${widget.userProfile.id}");
                                                try {
                                                  var response = await http.post(
                                                      Uri.parse(
                                                          "https://services-dev.youonline.online/api/block_profile/"),
                                                      headers: {
                                                        "Authorization":
                                                            "Token ${iPrefHelper.retrieveToken()}"
                                                      },
                                                      body: {
                                                        "blocked_user": widget
                                                            .userProfile.id
                                                      });
                                                  d('Brand List : ' +
                                                      response.body.toString());
                                                  if (response.statusCode ==
                                                      200) {
                                                    Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                const HomeScreen()));
                                                    final jsonData = jsonDecode(
                                                        response.body);
                                                    helper.showToast(
                                                        jsonData['response']
                                                            ['message']);
                                                  } else {
                                                    throw Exception();
                                                  }
                                                } catch (e) {}
                                              },
                                              child: Container(
                                                height: med.height * 0.038,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: CustomAppTheme()
                                                          .primaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                      'Block',
                                                      style: CustomAppTheme()
                                                          .normalText
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: CustomAppTheme()
                                                                  .primaryColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]);
                                }
                              },
                              itemBuilder: (BuildContext bc) {
                                return [
                                  PopupMenuItem(
                                    child: Text(
                                      'Block',
                                      style: CustomAppTheme()
                                          .normalText
                                          .copyWith(fontSize: 12),
                                    ),
                                    value: '/block',
                                  ),
                                  PopupMenuItem(
                                    child: Text(
                                      'Report',
                                      style: CustomAppTheme()
                                          .normalText
                                          .copyWith(fontSize: 12),
                                    ),
                                    value: '/report',
                                  ),
                                ];
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: med.height * 0.26,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            // showMaterialModalBottomSheet(
                            //   context: context,
                            //   builder: (context) =>
                            //       StatefulBuilder(builder: (context, setState) {
                            //     return ReportUserScreen(
                            //       userId: widget.userProfile.id!,
                            //     );
                            //   }),
                            // );
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              '',
                              style: CustomAppTheme()
                                  .normalText
                                  .copyWith(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: med.height * 0.05,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            (widget.userProfile.firstName ??
                                    widget.userProfile.companyName)
                                .toString(),
                            style: CustomAppTheme()
                                .headingText
                                .copyWith(fontSize: 22),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            widget.userProfile.cityName ?? "",
                            style: CustomAppTheme()
                                .normalGreyText
                                .copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                      widget.userProfile.bio == null
                          ? const SizedBox.shrink()
                          : SizedBox(
                              height: med.height * 0.02,
                            ),
                      widget.userProfile.bio == null
                          ? const SizedBox.shrink()
                          : Center(
                              child: SizedBox(
                                width: med.width * 0.95,
                                child: ReadMoreText(
                                  widget.userProfile.bio.toString(),
                                  // 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
                                  textAlign: TextAlign.center,
                                  trimLines: 2,
                                  colorClickableText:
                                      CustomAppTheme().secondaryColor,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show',
                                  trimExpandedText: ' Hide',
                                  style: CustomAppTheme()
                                      .normalGreyText
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                      widget.userProfile.id == iPrefHelper.retrieveUser()!.id
                          ? const SizedBox.shrink()
                          : SizedBox(
                              height: med.height * 0.02,
                            ),
                      widget.userProfile.id == iPrefHelper.retrieveUser()!.id
                          ? const SizedBox.shrink()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (widget.userProfile.mobileNumber !=
                                        null) {
                                      UrlLauncher.launch(
                                          "tel://${widget.userProfile.mobileNumber}");
                                    } else {
                                      helper.showToast(
                                          'Phone Number is not available.');
                                    }
                                  },
                                  child: Container(
                                    width: med.width * 0.3,
                                    decoration: BoxDecoration(
                                      color: CustomAppTheme().primaryColor,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                          color: CustomAppTheme().primaryColor),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: Center(
                                        child: Text(
                                          'Contact',
                                          style: CustomAppTheme()
                                              .normalText
                                              .copyWith(
                                                  color: CustomAppTheme()
                                                      .backgroundColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: med.width * 0.05,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final startChat =
                                        await chatViewModel.startChat(
                                            receiverId: widget.userProfile.id!,
                                            context: context);
                                    d('This is startChat : ${startChat.id}');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DirectMessageScreen(
                                                  chatId: startChat.id!,
                                                  receiver: widget.userProfile,
                                                )));
                                  },
                                  child: Container(
                                    width: med.width * 0.3,
                                    decoration: BoxDecoration(
                                      color: CustomAppTheme().backgroundColor,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                          color: CustomAppTheme().primaryColor),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: Center(
                                        child: Text(
                                          'Message',
                                          style: CustomAppTheme()
                                              .normalText
                                              .copyWith(
                                                  color: CustomAppTheme()
                                                      .primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: med.height * 0.02,
                      ),
                      Divider(
                        color: CustomAppTheme().greyColor,
                      ),
                      SizedBox(
                        height: med.height * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          height: med.height * 0.035,
                          child: ListView.builder(
                            itemCount: modulesList.length,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedModuleIndex = index;
                                      if (selectedModuleIndex == 0) {
                                        totalAds = profileViewModel
                                            .userClassifiedAds.length;
                                      } else if (selectedModuleIndex == 1) {
                                        totalAds = profileViewModel
                                            .userAutomotiveAds.length;
                                      } else if (selectedModuleIndex == 2) {
                                        totalAds = profileViewModel
                                            .userPropertyAds.length;
                                      } else if (selectedModuleIndex == 3) {
                                        totalAds =
                                            profileViewModel.userJobAds.length;
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: selectedModuleIndex == index
                                            ? CustomAppTheme().primaryColor
                                            : CustomAppTheme().greyColor,
                                      ),
                                      color: selectedModuleIndex == index
                                          ? CustomAppTheme().lightGreenColor
                                          : CustomAppTheme().lightGreyColor,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                        child: Text(
                                          modulesList[index],
                                          style: CustomAppTheme()
                                              .normalText
                                              .copyWith(
                                                letterSpacing: 0.5,
                                                color:
                                                    selectedModuleIndex == index
                                                        ? CustomAppTheme()
                                                            .primaryColor
                                                        : CustomAppTheme()
                                                            .darkGreyColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          '$totalAds Active Ads',
                          style: CustomAppTheme()
                              .headingText
                              .copyWith(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: selectedModuleIndex == 0
                              ? profileViewModel.userClassifiedAds.length
                              : selectedModuleIndex == 1
                                  ? profileViewModel.userAutomotiveAds.length
                                  : selectedModuleIndex == 2
                                      ? profileViewModel.userPropertyAds.length
                                      : selectedModuleIndex == 3
                                          ? profileViewModel.userJobAds.length
                                          : 0,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: selectedModuleIndex == 3
                                ? med.height * 0.26
                                : 200,
                            childAspectRatio: selectedModuleIndex == 3
                                ? med.height * 0.00088
                                : med.height * 0.00072,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 15,
                          ),
                          itemBuilder: (context, index) {
                            return selectedModuleIndex == 0
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailScreen(
                                                    classifiedProduct:
                                                        profileViewModel
                                                                .userClassifiedAds[
                                                            index],
                                                    productType: 'Classified',
                                                  )));
                                    },
                                    child: ProductCard(
                                      onFavTap: () {},
                                      isFav: profileViewModel
                                          .userClassifiedAds[index].isFavourite,
                                      isOff: profileViewModel
                                          .userClassifiedAds[index].isDeal,
                                      isFeatured: profileViewModel
                                          .userClassifiedAds[index].isPromoted,
                                      title: profileViewModel
                                          .userClassifiedAds[index].name,
                                      address: profileViewModel
                                          .userClassifiedAds[index]
                                          .streetAdress,
                                      currencyCode: profileViewModel
                                          .userClassifiedAds[index]
                                          .currency!
                                          .code,
                                      price: profileViewModel
                                          .userClassifiedAds[index].price,
                                      imageUrl: profileViewModel
                                              .userClassifiedAds[index]
                                              .imageMedia!
                                              .isEmpty
                                          ? null
                                          : profileViewModel
                                              .userClassifiedAds[index]
                                              .imageMedia![0]
                                              .image,
                                      categories: "classified",
                                      beds:
                                          "${profileViewModel.userClassifiedAds[index].category?.title}",
                                      baths:
                                          "${profileViewModel.userClassifiedAds[index].type}",
                                    ),
                                  )
                                : selectedModuleIndex == 1
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailScreen(
                                                        automotiveProduct:
                                                            profileViewModel
                                                                    .userAutomotiveAds[
                                                                index],
                                                        productType:
                                                            'Automotive',
                                                      )));
                                        },
                                        child: ProductCard(
                                          onFavTap: () {},
                                          isFav: profileViewModel
                                              .userAutomotiveAds[index]
                                              .isFavourite,
                                          isFeatured: profileViewModel
                                              .userAutomotiveAds[index]
                                              .isPromoted,
                                          isOff: profileViewModel
                                              .userAutomotiveAds[index].isDeal,
                                          address: profileViewModel
                                              .userAutomotiveAds[index]
                                              .streetAddress,
                                          price: profileViewModel
                                              .userAutomotiveAds[index].price,
                                          currencyCode: profileViewModel
                                              .userAutomotiveAds[index]
                                              .currency!
                                              .code,
                                          title: profileViewModel
                                              .userAutomotiveAds[index].name,
                                          imageUrl: profileViewModel
                                                  .userAutomotiveAds[index]
                                                  .imageMedia!
                                                  .isEmpty
                                              ? null
                                              : profileViewModel
                                                  .userAutomotiveAds[index]
                                                  .imageMedia![0]
                                                  .image,
                                          categories: "auto",
                                          beds:
                                              "${profileViewModel.userAutomotiveAds[index].kilometers} KM",
                                          baths:
                                              "${profileViewModel.userAutomotiveAds[index].transmissionType}",
                                          baths1:
                                              "${profileViewModel.userAutomotiveAds[index].fuelType}",
                                        ),
                                      )
                                    : selectedModuleIndex == 2
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetailScreen(
                                                            propertyProduct:
                                                                profileViewModel
                                                                        .userPropertyAds[
                                                                    index],
                                                            productType:
                                                                'Property',
                                                          )));
                                            },
                                            child: ProductCard(
                                              onFavTap: () {},
                                              isFav: profileViewModel
                                                  .userPropertyAds[index]
                                                  .isFavourite,
                                              isFeatured: profileViewModel
                                                  .userPropertyAds[index]
                                                  .isPromoted,
                                              isOff: profileViewModel
                                                  .userPropertyAds[index]
                                                  .isDeal,
                                              title: profileViewModel
                                                  .userPropertyAds[index].name,
                                              currencyCode: profileViewModel
                                                  .userPropertyAds[index]
                                                  .currency!
                                                  .code,
                                              price: profileViewModel
                                                  .userPropertyAds[index].price,
                                              address: profileViewModel
                                                  .userPropertyAds[index]
                                                  .streetAddress,
                                              imageUrl: profileViewModel
                                                      .userPropertyAds[index]
                                                      .imageMedia!
                                                      .isEmpty
                                                  ? null
                                                  : profileViewModel
                                                      .userPropertyAds[index]
                                                      .imageMedia![0]
                                                      .image,
                                              categories: 'property',
                                              beds:
                                                  "${profileViewModel.userPropertyAds[index].bedrooms} Bedrooms",
                                              baths:
                                                  "${profileViewModel.userPropertyAds[index].area}",
                                            ),
                                          )
                                        : selectedModuleIndex == 3
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetailScreen(
                                                                jobProduct:
                                                                    profileViewModel
                                                                            .userJobAds[
                                                                        index],
                                                                isJobAd: true,
                                                                productType:
                                                                    'Job',
                                                              )));
                                                },
                                                child: JobAdsWidget(
                                                  onFavTap: () {},
                                                  isFav: profileViewModel
                                                      .userJobAds[index]
                                                      .isFavourite,
                                                  isFeatured: profileViewModel
                                                      .userJobAds[index]
                                                      .isPromoted,
                                                  isOff: false,
                                                  title: profileViewModel
                                                      .userJobAds[index].title,
                                                  currencyCode: profileViewModel
                                                      .userJobAds[index]
                                                      .salaryCurrency!
                                                      .code,
                                                  startingSalary:
                                                      profileViewModel
                                                          .userJobAds[index]
                                                          .salaryStart,
                                                  endingSalary: profileViewModel
                                                      .userJobAds[index]
                                                      .salaryEnd,
                                                  description: profileViewModel
                                                      .userJobAds[index]
                                                      .description,
                                                  address: profileViewModel
                                                      .userJobAds[index]
                                                      .location,
                                                  imageUrl: profileViewModel
                                                          .userJobAds[index]
                                                          .imageMedia!
                                                          .isEmpty
                                                      ? null
                                                      : profileViewModel
                                                          .userJobAds[index]
                                                          .imageMedia![0]
                                                          .image,
                                                  beds:
                                                      "${profileViewModel.userJobAds[index].positionType}",
                                                  baths:
                                                      "${profileViewModel.userJobAds[index].jobType}",
                                                ),
                                              )
                                            : const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: med.height * 0.185,
                  ),
                  Center(
                    child: Container(
                      height: med.height * 0.15,
                      decoration: BoxDecoration(
                        color: CustomAppTheme().primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: CustomAppTheme().backgroundColor, width: 2),
                        image: widget.userProfile.profilePicture != null
                            ? DecorationImage(
                                image: NetworkImage(
                                    widget.userProfile.profilePicture!),
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
      ),
    );
  }

  List<String> modulesList = [
    'Classified',
    'Automotive',
    'Property',
    'Job',
  ];
}
