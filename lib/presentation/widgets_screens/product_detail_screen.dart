import 'dart:convert';
import 'package:app/brand/brand_landing_screen.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/chat/dm_screen.dart';
import 'package:app/presentation/chat/view_model/chat_view_model.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/jobs/apply_job_screen.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/profile/view_profile_screen.dart';
import 'package:app/presentation/searchs/view_model/search_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/shimmers/product_card_shimmer.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/home_screen_headings_widget.dart';
import 'package:app/presentation/utils/widgets/jobAds_widget.dart';
import 'package:app/presentation/utils/widgets/product_card.dart';
import 'package:app/presentation/utils/widgets/product_location_map_widget.dart';
import 'package:app/presentation/widgets_screens/report_ad_screen.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:video_player/video_player.dart';

import '../properties/view_model/properties_view_model.dart';
import '../utils/dialogs/custom_dialog.dart';

class ProductDetailScreen extends StatefulWidget {
  final bool? isJobAd;
  final String? productType;
  final AutomotiveProductModel? automotiveProduct;
  final ClassifiedProductModel? classifiedProduct;
  final PropertyProductModel? propertyProduct;
  final JobProductModel? jobProduct;

  const ProductDetailScreen(
      {Key? key,
      this.isJobAd = false,
      this.automotiveProduct,
      this.productType,
      this.classifiedProduct,
      this.propertyProduct,
      this.jobProduct})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with BaseMixin {
  int totalImagesCount = 0;
  bool isVideo = false;
  int currentImageIndex = 0;
  String adId = '';
  String businessType = 'Individual';
  String productTitle = '- -';
  String productPrice = '0';
  String startingSalary = '0';
  String endingSalary = '0';
  String adCreatedTime = '0';
  String adDescription = '- -';
  String currencyCode = 'AED';
  String latitude = '31.5204';
  String longitude = '74.3587';
  String streetAddress = '- -';
  String videoThumbnail = '';
  String timeAgo = '- -';
  String propertyTag = "";
  bool isFeatured = false;
  bool isVerified = false;
  bool isDeal = false;
  UserProfileModel userProfile = UserProfileModel();
  UserProfileModel companyProfile = UserProfileModel();
  List<String>? images = [];
  List<DetailListModel> detailList = [];
  List<DetailListModel> classifiedDetailList = [];
  List<DetailListModel> automotiveDetailList = [];
  List<DetailListModel> propertiesDetailList = [];
  List<DetailListModel> jobDetailList = [];
  bool isReadMore = false;
  bool recommendedProductFetching = false;

  classifiedProduct() {
    productTitle = widget.classifiedProduct!.name.toString();
    productPrice = widget.classifiedProduct!.price.toString();
    adDescription = widget.classifiedProduct!.description.toString();
    adId = widget.classifiedProduct!.id.toString();
    businessType = widget.classifiedProduct!.businessType.toString();
    currencyCode = widget.classifiedProduct!.currency!.code.toString();
    latitude = widget.classifiedProduct!.latitude.toString();
    longitude = widget.classifiedProduct!.longitude.toString();
    timeAgo = timeago.format(
      DateTime.parse(
        widget.classifiedProduct!.createdAt!,
      ),
    );
    streetAddress = widget.classifiedProduct!.streetAdress.toString();
    userProfile = widget.classifiedProduct!.profile!;
    companyProfile = widget.classifiedProduct!.company!;
    isFeatured = widget.classifiedProduct!.isPromoted!;
    isDeal = widget.classifiedProduct!.isDeal!;
    if (widget.classifiedProduct!.videoMedia!.isNotEmpty) {
      initializeVideo(
          widget.classifiedProduct!.videoMedia![0].video.toString());
      videoThumbnail = widget.classifiedProduct!.videoMedia![0].videoThumbnail!;
      isVideo = true;
    }
    if (widget.classifiedProduct!.imageMedia!.isEmpty) {
      images!.add(
          'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg');
    } else {
      for (int i = 0; i < widget.classifiedProduct!.imageMedia!.length; i++) {
        images!.add(widget.classifiedProduct!.imageMedia![i].image!);
      }
    }
    totalImagesCount = images!.length;
    detailList = <DetailListModel>[
      DetailListModel(
          imageSvg: 'assets/svgs/priceTagIcon.svg',
          title: 'Price',
          value: widget.classifiedProduct!.price.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/typeIcon.svg',
          title: 'Type',
          value: widget.classifiedProduct!.category!.title.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/conditionIcon.svg',
          title: 'Condition',
          value: widget.classifiedProduct!.type.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/brandIcon.svg',
          title: 'Brand',
          value: widget.classifiedProduct!.brand == null
              ? 'Other'
              : widget.classifiedProduct!.brand!.title.toString()),
    ];
    setState(() {
      propertyTag = "";
    });
  }

  automotiveProduct() {
    productTitle = widget.automotiveProduct!.name.toString();
    productPrice = widget.automotiveProduct!.rentalHours != null
        ? "${widget.automotiveProduct!.price} / ${widget.automotiveProduct!.rentalHours}"
        : widget.automotiveProduct!.price.toString();
    adDescription = widget.automotiveProduct!.description.toString();
    currencyCode = widget.automotiveProduct!.currency!.code.toString();
    businessType = widget.automotiveProduct!.businessType.toString();
    adId = widget.automotiveProduct!.id.toString();
    latitude = widget.automotiveProduct!.latitude.toString();
    longitude = widget.automotiveProduct!.longitude.toString();
    timeAgo = timeago.format(
      DateTime.parse(
        widget.automotiveProduct!.createdAt!,
      ),
    );
    streetAddress = widget.automotiveProduct!.streetAddress.toString();
    userProfile = widget.automotiveProduct!.profile!;
    companyProfile = widget.automotiveProduct!.company!;
    isFeatured = widget.automotiveProduct!.isPromoted!;
    isDeal = widget.automotiveProduct!.isDeal!;
    if (widget.automotiveProduct!.videoMedia!.isNotEmpty) {
      initializeVideo(
          widget.automotiveProduct!.videoMedia![0].video.toString());
      videoThumbnail = widget.automotiveProduct!.videoMedia![0].videoThumbnail!;
      isVideo = true;
    }
    if (widget.automotiveProduct!.imageMedia!.isEmpty) {
      images!.add(
          'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg');
    } else {
      for (int i = 0; i < widget.automotiveProduct!.imageMedia!.length; i++) {
        images!.add(widget.automotiveProduct!.imageMedia![i].image!);
      }
    }
    totalImagesCount = images!.length;
    detailList = <DetailListModel>[
      DetailListModel(
          imageSvg: 'assets/svgs/priceTagIcon.svg',
          title: 'Price',
          value: widget.automotiveProduct!.price.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/typeIcon.svg',
          title: 'Type',
          value: widget.automotiveProduct!.category!.title.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/brandIcon.svg',
          title: 'Brand',
          value: widget.automotiveProduct!.make == null
              ? 'null'
              : widget.automotiveProduct!.make!.title.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/carIcon.svg',
          title: 'Model',
          value: widget.automotiveProduct!.automotiveModel!.title.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/milage.svg',
          title: 'Mileage',
          value: widget.automotiveProduct!.kilometers.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/calanderIcon.svg',
          title: 'Year',
          value: widget.automotiveProduct!.automotiveYear.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/transmission.svg',
          title: 'Transmission',
          value: widget.automotiveProduct!.transmissionType.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/conditionIcon.svg',
          title: 'Condition',
          value: widget.automotiveProduct!.carType.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/engine.svg',
          title: 'Condition',
          value: widget.automotiveProduct!.fuelType.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/color.svg',
          title: 'Color',
          value: widget.automotiveProduct!.color.toString()),
    ];
    setState(() {
      propertyTag = "";
    });
  }

  propertyProduct() {
    productTitle = widget.propertyProduct!.name.toString();
    productPrice = widget.propertyProduct!.price.toString();
    adDescription = widget.propertyProduct!.description.toString();
    currencyCode = widget.propertyProduct!.currency!.code.toString();
    businessType = widget.propertyProduct!.businessType.toString();
    adId = widget.propertyProduct!.id.toString();
    latitude = widget.propertyProduct!.latitude.toString();
    longitude = widget.propertyProduct!.longitude.toString();
    timeAgo = timeago.format(
      DateTime.parse(
        widget.propertyProduct!.createdAt!,
      ),
    );
    isVerified = widget.propertyProduct?.isVerified ?? false;
    streetAddress = widget.propertyProduct!.streetAddress.toString();
    userProfile = widget.propertyProduct!.profile!;
    companyProfile = widget.propertyProduct!.company!;
    isFeatured = widget.propertyProduct!.isPromoted!;
    isDeal = widget.propertyProduct!.isDeal!;
    if (widget.propertyProduct!.videoMedia!.isNotEmpty) {
      initializeVideo(widget.propertyProduct!.videoMedia![0].video.toString());
      videoThumbnail = widget.propertyProduct!.videoMedia![0].videoThumbnail!;
      isVideo = true;
    }
    if (widget.propertyProduct!.imageMedia!.isEmpty) {
      images!.add(
          'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg');
    } else {
      for (int i = 0; i < widget.propertyProduct!.imageMedia!.length; i++) {
        images!.add(widget.propertyProduct!.imageMedia![i].image!);
      }
    }
    totalImagesCount = images!.length;
    detailList = <DetailListModel>[
      DetailListModel(
          imageSvg: 'assets/svgs/priceTagIcon.svg',
          title: 'Price',
          value: widget.propertyProduct!.price.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/typeIcon.svg',
          title: 'Type',
          value: 'For ' + widget.propertyProduct!.propertyType.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/bedIcon1.svg',
          title: 'Bedroom',
          value: widget.propertyProduct!.bedrooms.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/bathroomIcon1.svg',
          title: 'Bathroom',
          value: widget.propertyProduct!.baths.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/rulerIcon.svg',
          title: 'Area Unit',
          value: widget.propertyProduct!.areaUnit.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/areaChartIcon.svg',
          title: 'Area',
          value: widget.propertyProduct!.area.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/cabinetIcon.svg',
          title: 'Furnished',
          value:
              widget.propertyProduct!.furnished == 'Furnished' ? 'Yes' : 'No'),
    ];
    setState(() {
      propertyTag = widget.propertyProduct!.propertyType ?? "";
    });
  }

  jobProduct() {
    d('IS APPLIED : ${widget.jobProduct!.isApplied}');
    productTitle = widget.jobProduct!.title.toString();
    startingSalary = widget.jobProduct!.salaryStart.toString();
    businessType = widget.jobProduct!.businessType.toString();
    endingSalary = widget.jobProduct!.salaryEnd.toString();
    adDescription = widget.jobProduct!.description.toString();
    timeAgo = timeago.format(
      DateTime.parse(
        widget.jobProduct!.createdAt!,
      ),
    );
    currencyCode = widget.jobProduct!.salaryCurrency!.code.toString();
    adId = widget.jobProduct!.id.toString();
    latitude = widget.jobProduct!.latitude.toString();
    longitude = widget.jobProduct!.longitude.toString();
    streetAddress = widget.jobProduct!.location.toString();
    userProfile = widget.jobProduct!.profile!;
    companyProfile = widget.jobProduct!.company!;
    isFeatured = widget.jobProduct!.isPromoted!;
    isDeal = false;
    if (widget.jobProduct!.videoMedia!.isNotEmpty) {
      initializeVideo(widget.jobProduct!.videoMedia![0].video.toString());
      videoThumbnail = widget.jobProduct!.videoMedia![0].videoThumbnail!;
      isVideo = true;
    }
    if (widget.jobProduct!.imageMedia!.isEmpty) {
      images!.add(
          'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg');
    } else {
      for (int i = 0; i < widget.jobProduct!.imageMedia!.length; i++) {
        images!.add(widget.jobProduct!.imageMedia![i].image!);
      }
    }
    totalImagesCount = images!.length;
    detailList = <DetailListModel>[
      DetailListModel(
          imageSvg: 'assets/svgs/priceTagIcon.svg',
          title: 'Salary From',
          value: widget.jobProduct!.salaryStart.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/priceTagIcon.svg',
          title: 'Salary End',
          value: widget.jobProduct!.salaryEnd.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/clockIcon.svg',
          title: 'Period',
          value: widget.jobProduct!.salaryPeriod.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/jobPositionIcon.svg',
          title: 'Position',
          value: widget.jobProduct!.positionType.toString()),
      DetailListModel(
          imageSvg: 'assets/svgs/typeIcon.svg',
          title: 'Type',
          value: widget.jobProduct!.jobType.toString()),
    ];
    setState(() {
      propertyTag = "";
    });
  }

  getSuggestedAds(
      {String? categoryId, String? adId, String? moduleName}) async {
    SearchViewModel searchViewModel = context.read<SearchViewModel>();
    setState(() {
      recommendedProductFetching = true;
    });
    final result = await searchViewModel.getSuggestedAds(
        categoryId: categoryId, adId: adId, moduleName: moduleName);
    result.fold((l) {}, (r) {
      searchViewModel.changeSuggestedAds(
        automotiveAds: r.suggestedAutomotiveAds!,
        propertyAds: r.suggestedPropertyAds!,
        classifiedAds: r.suggestedClassifiedAds!,
        jobAds: r.suggestedJobAds!,
      );
    });
    setState(() {
      recommendedProductFetching = false;
    });
  }

  bool isLoader = false;

  @override
  void initState() {
    super.initState();
    if (widget.productType == 'Automotive') {
      automotiveProduct();
      getSuggestedAds(
          categoryId: widget.automotiveProduct!.category!.id,
          moduleName: widget.productType,
          adId: widget.automotiveProduct!.id);
      Uri uri = Uri.parse(
          '${iExternalValues.getBaseUrl()}api/get_single_automotive?automotive=${widget.automotiveProduct!.slug}');
      http.get(uri,
          headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
    }
    if (widget.productType == 'Classified') {
      classifiedProduct();
      getSuggestedAds(
          categoryId: widget.classifiedProduct!.category!.id,
          moduleName: widget.productType,
          adId: widget.classifiedProduct!.id);
      Uri uri = Uri.parse(
          '${iExternalValues.getBaseUrl()}api/get_single_classified?classified=${widget.classifiedProduct!.slug}');
      http.get(uri,
          headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
    }
    if (widget.productType == 'Property') {
      propertyProduct();
      getSuggestedAds(
          categoryId: widget.propertyProduct!.category!.id,
          moduleName: widget.productType,
          adId: widget.propertyProduct!.id);
      Uri uri = Uri.parse(
          '${iExternalValues.getBaseUrl()}api/get_single_property?property=${widget.propertyProduct!.slug}');
      http.get(uri,
          headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
    }
    if (widget.productType == 'Job') {
      jobProduct();
      getSuggestedAds(
          categoryId: widget.jobProduct!.category!.id,
          moduleName: widget.productType,
          adId: widget.jobProduct!.id);
      Uri uri = Uri.parse(
          '${iExternalValues.getBaseUrl()}api/get_single_job?job=${widget.jobProduct!.slug}');
      http.get(uri,
          headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
    }
  }

  SwiperController swiperController = SwiperController();

  bool isLoading = false;
  Future<void> blockAd(String addId) async {
    // setState(() {
    //   isLoading = true;
    // });
    try {
      MultipartRequest? request;

      // bloc property add
      if (widget.propertyProduct != null) {
        Uri uri = Uri.parse(
            'https://services-dev.youonline.online/api/block_property/');
        request = http.MultipartRequest("Post", uri);
        request.fields['property_id'] = addId;
        request.headers
            .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      } else if (widget.classifiedProduct != null) {
        Uri uri = Uri.parse(
            'https://services-dev.youonline.online/api/block_classified/');
        request = http.MultipartRequest("Post", uri);
        request.fields['classified_id'] = addId;
        request.headers
            .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      } else if (widget.automotiveProduct != null) {
        Uri uri = Uri.parse(
            'https://services-dev.youonline.online/api/block_automotive/');
        request = http.MultipartRequest("Post", uri);
        request.fields['automotive_id'] = addId;
        request.headers
            .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      } else {
        /// need to be changed ...
        Uri uri =
        Uri.parse('https://services-dev.youonline.online/api/block_job/');
        request = http.MultipartRequest("Post", uri);
        request.fields['job_id'] = addId;
        request.headers
            .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      }

      http.StreamedResponse? response;
      response = await request.send();
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        d('Blocked Successfully');
        d(decodedResponse);
        // setState(() {
        //   isLoading = false;
        // });
        helper.showToast('This add has been Blocked...!');
      } else {
        // setState(() {
        //   isLoading = false;
        // });
        helper.showToast('something went wrong');
        d('ERROR');
      }
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });
      helper.showToast(e.toString());
      d(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController?.dispose();
    chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numLines = '<p>'.allMatches((adDescription)).length + 1;

    Size med = MediaQuery.of(context).size;
    ChatViewModel chatViewModel = context.watch<ChatViewModel>();
    SearchViewModel searchViewModel = context.watch<SearchViewModel>();
    final ClassifiedViewModel classifiedViewModel =
        context.watch<ClassifiedViewModel>();
    final AutomotiveViewModel automotiveViewModel =
        context.watch<AutomotiveViewModel>();
    final PropertiesViewModel propertiesViewModel =
        context.watch<PropertiesViewModel>();
    final JobViewModel jobViewModel = context.watch<JobViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(
          title: 'Detail',
          onTap: () {
            Navigator.of(context).pop();
          },
          context: context,
          actionWidget: PopupMenuButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            offset: const Offset(5, 40),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Center(
                  child: Icon(
                Icons.flag,
                color: CustomAppTheme().blackColor,
              )),
            ),
            onSelected: (value) {
              // your logic
              if (value == "/report") {
                showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      StatefulBuilder(builder: (context, setState) {
                    return ReportAdScreen(
                      adId: adId,
                      moduleName: widget.productType!,
                    );
                  }),
                );
              } else {
                CustomDialog.blockAdDialog(
                    context: context,
                    title: 'Are you sure do you want to block this ad!',
                    rightButtonText: 'Block',
                    cancelCallBack: () {
                      Get.back();
                    },
                    blockCallBack: () async {
                      setState(() {
                        isLoading = true;
                      });
                      CustomDialog.showAlertDialog();
                      await blockAd(adId).then((value) {
                        setState(() {
                          isLoading = false;
                          Get.back();
                          Get.back();
                          // Get.back();
                        });
                      });
                      // Get.back();
                      // Get.back();
                    });

                // Get.defaultDialog(
                //     middleText: "Are you sure do you want block this ad!",
                //     contentPadding: const EdgeInsets.all(20),
                //     actions: [
                //       ,
                //     ]);
              }
            },
            itemBuilder: (BuildContext bc) {
              return [
                PopupMenuItem(
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      'Report',
                      style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                    ),
                  ),
                  value: '/report',
                ),
                PopupMenuItem(
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      'Block',
                      style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                    ),
                  ),
                  value: '/block',
                ),
                // PopupMenuItem(
                //   child: SizedBox(
                //     width: 100,
                //     child: Text(
                //       'Report',
                //       style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                //     ),
                //   ),
                //   value: '/report',
                // ),
              ];
            },
          )

          //  Padding(
          //   padding: const EdgeInsets.only(right: 10),
          //   child: Center(
          //     child: GestureDetector(
          //       onTap: () {
          //         showMaterialModalBottomSheet(
          //           context: context,
          //           builder: (context) =>
          //               StatefulBuilder(builder: (context, setState) {
          //             return ReportAdScreen(
          //               adId: adId,
          //               moduleName: widget.productType!,
          //             );
          //           }),
          //         );
          //       },
          //       child: Text(
          //         'Report',
          //         style: CustomAppTheme().normalText.copyWith(fontSize: 12),
          //       ),
          //     ),
          //   ),
          // ),
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.productType == "Job"
                  ? Row(
                      children: [
                        SizedBox(
                          height: med.height * 0.09,
                          child: ListView.builder(
                            shrinkWrap: true,
                            // itemCount: isVideo ? images!.length + 1 : images!.length,
                            itemCount: 1,

                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              String imagePath = '';
                              if (isVideo && index == 0) {
                                imagePath = videoThumbnail;
                              } else {
                                if (isVideo) {
                                  imagePath = images![index - 1];
                                } else {
                                  imagePath = images![index];
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      swiperController.index = index;
                                      currentImageIndex = index;
                                      swiperController.move(index);
                                    });
                                  },
                                  child: Container(
                                    width: med.width * 0.2,
                                    decoration: BoxDecoration(
                                      color: CustomAppTheme().greyColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color:
                                              CustomAppTheme().lightGreyColor),
                                      image: DecorationImage(
                                        image: NetworkImage(imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productTitle,
                                style: CustomAppTheme()
                                    .headingText
                                    .copyWith(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    currencyCode,
                                    style: CustomAppTheme().normalText.copyWith(
                                        color: CustomAppTheme().primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      '$startingSalary - $endingSalary',
                                      style: CustomAppTheme()
                                          .normalText
                                          .copyWith(
                                              color:
                                                  CustomAppTheme().primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    timeAgo,
                                    style: CustomAppTheme()
                                        .normalGreyText
                                        .copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: med.height * 0.25,
                          width: med.width,
                          decoration: BoxDecoration(
                            color: CustomAppTheme().greyColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Swiper(
                                itemCount: isVideo
                                    ? images!.length + 1
                                    : images!.length,
                                itemWidth: med.width,
                                itemHeight: med.height * 0.25,
                                loop: false,
                                controller: swiperController,
                                onIndexChanged: (value) {
                                  setState(() {
                                    currentImageIndex = value;
                                    d('CURRENT IMAGE INDEX : $currentImageIndex');
                                  });
                                },
                                layout: SwiperLayout.DEFAULT,
                                itemBuilder: (BuildContext context, int index) {
                                  String imagePath = '';
                                  if (isVideo && index == 0) {
                                    imagePath = '';
                                  } else {
                                    if (isVideo) {
                                      imagePath = images![index - 1];
                                    } else {
                                      imagePath = images![index];
                                    }
                                  }
                                  return index == 0 && isVideo
                                      ? Stack(
                                          children: <Widget>[
                                            chewieController != null
                                                ? Container(
                                                    height: med.height * 0.25,
                                                    width: med.width,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: CustomAppTheme()
                                                          .blackColor,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: AspectRatio(
                                                        aspectRatio:
                                                            videoPlayerController!
                                                                .value
                                                                .aspectRatio,
                                                        child: Chewie(
                                                          controller:
                                                              chewieController!,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: med.height * 0.25,
                                                    width: med.width,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: CustomAppTheme()
                                                          .blackColor,
                                                    ),
                                                    child: Center(
                                                      child: CircularProgressIndicator(
                                                          color: CustomAppTheme()
                                                              .secondaryColor),
                                                    ),
                                                  ),
                                          ],
                                        )
                                      : Container(
                                          height: med.height * 0.25,
                                          width: med.width,
                                          decoration: BoxDecoration(
                                            color: CustomAppTheme().greyColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: NetworkImage(imagePath),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: <Widget>[
                                    isFeatured
                                        ? Container(
                                            height: med.height * 0.03,
                                            decoration: BoxDecoration(
                                              color: CustomAppTheme()
                                                  .secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.star,
                                                    size: 11,
                                                    color: CustomAppTheme()
                                                        .backgroundColor,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 2),
                                                    child: Center(
                                                      child: Text(
                                                        'Featured',
                                                        style: CustomAppTheme()
                                                            .normalText
                                                            .copyWith(
                                                                fontSize: 11,
                                                                color: CustomAppTheme()
                                                                    .backgroundColor),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    isFeatured
                                        ? SizedBox(
                                            width: med.width * 0.01,
                                          )
                                        : const SizedBox.shrink(),
                                    /*Container(
                            height: med.height * 0.03,
                            decoration: BoxDecoration(
                              color: CustomAppTheme().secondaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                              child: Center(
                                child: Text(
                                  '10% off',
                                  style: CustomAppTheme().normalText.copyWith(fontSize: 11, color: CustomAppTheme().backgroundColor),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: med.width * 0.01,
                          ),*/

                                    propertyTag == ""
                                        ? Container()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              !isVerified
                                                  ? Container()
                                                  : Container(
                                                      height: med.height * 0.03,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                // vertical: 2,
                                                                horizontal: 5),
                                                        child: Center(
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/svgs/truecheck.svg',
                                                            // height: MediaQuery.of(
                                                            //             context)
                                                            //         .size
                                                            //         .height *
                                                            //     0.012,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                              Container(
                                                height: med.height * 0.03,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xfffe2e2e),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 2,
                                                      horizontal: 5),
                                                  child: Center(
                                                    child: Text(
                                                      'For $propertyTag',
                                                      style: CustomAppTheme()
                                                          .normalText
                                                          .copyWith(
                                                              fontSize: 11,
                                                              color: CustomAppTheme()
                                                                  .backgroundColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    isDeal
                                        ? Container(
                                            height: med.height * 0.03,
                                            decoration: BoxDecoration(
                                              color: const Color(0xfffe2e2e),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 5),
                                              child: Center(
                                                child: Text(
                                                  'For Sale',
                                                  style: CustomAppTheme()
                                                      .normalText
                                                      .copyWith(
                                                          fontSize: 11,
                                                          color: CustomAppTheme()
                                                              .backgroundColor),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: med.height * 0.03,
                                    width: med.width * 0.18,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              'assets/svgs/imagesIcon.svg',
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.012,
                                              fit: BoxFit.cover,
                                            ),
                                            Text(
                                              '${currentImageIndex + 1}/${isVideo ? totalImagesCount + 1 : totalImagesCount}',
                                              style: CustomAppTheme()
                                                  .normalText
                                                  .copyWith(
                                                      fontSize: 11,
                                                      color: CustomAppTheme()
                                                          .backgroundColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: med.height * 0.015,
                        ),
                        SizedBox(
                          height: med.height * 0.09,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                isVideo ? images!.length + 1 : images!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              String imagePath = '';
                              if (isVideo && index == 0) {
                                imagePath = videoThumbnail;
                              } else {
                                if (isVideo) {
                                  imagePath = images![index - 1];
                                } else {
                                  imagePath = images![index];
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      swiperController.index = index;
                                      currentImageIndex = index;
                                      swiperController.move(index);
                                    });
                                  },
                                  child: Container(
                                    width: med.width * 0.2,
                                    decoration: BoxDecoration(
                                      color: CustomAppTheme().greyColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color:
                                              CustomAppTheme().lightGreyColor),
                                      image: DecorationImage(
                                        image: NetworkImage(imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              currencyCode,
                              style: CustomAppTheme().normalText.copyWith(
                                  color: CustomAppTheme().primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                widget.isJobAd == true
                                    ? '$startingSalary - $endingSalary'
                                    : productPrice,
                                style: CustomAppTheme().normalText.copyWith(
                                    color: CustomAppTheme().primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              timeAgo,
                              style: CustomAppTheme()
                                  .normalGreyText
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        Text(
                          productTitle,
                          style: CustomAppTheme()
                              .headingText
                              .copyWith(fontSize: 16),
                        ),
                      ],
                    ),
              /*SizedBox(
                height: med.height * 0.01,
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 8.0,
                children: <Widget>[
                  for (int index = 0; index < 3; index++)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: CustomAppTheme().primaryColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svgs/bedIcon.svg',
                              height: MediaQuery.of(context).size.height * 0.01,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Text(
                                featuresList[index],
                                style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().darkGreyColor, fontSize: 8, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),*/
              SizedBox(
                height: med.height * 0.02,
              ),
              Divider(
                color: CustomAppTheme().greyColor.withOpacity(0.3),
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: med.height * 0.05,
                    width: med.width * 0.12,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(businessType == 'Individual'
                            ? userProfile.profilePicture.toString()
                            : companyProfile.profilePicture.toString()),
                        fit: BoxFit.cover,
                      ),
                      color: CustomAppTheme().primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      height: med.height * 0.05,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            businessType == 'Individual'
                                ? userProfile.firstName.toString()
                                : companyProfile.companyName.toString(),
                            style: CustomAppTheme().normalText.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          (userProfile.cityName != null &&
                                  userProfile.countryName != null)
                              ? SizedBox(
                                  width: med.width * 0.4,
                                  child: Text(
                                    // userProfile.streetAddress.toString(),
                                    "${userProfile.cityName.toString()}, ${userProfile.countryName.toString()}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomAppTheme()
                                        .normalGreyText
                                        .copyWith(fontSize: 12),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  userProfile.id == iPrefHelper.retrieveUser()!.id
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewProfileScreen(
                                          userProfile:
                                              businessType == 'Individual'
                                                  ? userProfile
                                                  : companyProfile,
                                        )));
                          },
                          child: Container(
                            height: med.height * 0.042,
                            decoration: BoxDecoration(
                              color: CustomAppTheme().primaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'View Profile',
                                  style: CustomAppTheme().normalText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
              Divider(
                color: CustomAppTheme().greyColor.withOpacity(0.3),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              productDetailHeading(title: 'Description'),
              SizedBox(
                height: med.height * 0.01,
              ),
              /*Text(
                adDescription,
                // 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
              ),*/
              !isReadMore
                  ? IgnorePointer(
                      child: numLines > 7
                          ? SizedBox(
                              height: 180,
                              child: HtmlWidget(adDescription,
                                  renderMode: RenderMode.listView,
                                  textStyle: CustomAppTheme()
                                      .normalGreyText
                                      .copyWith(fontSize: 12)),
                            )
                          : HtmlWidget(adDescription,
                              textStyle: CustomAppTheme()
                                  .normalGreyText
                                  .copyWith(fontSize: 12)))
                  : HtmlWidget(adDescription,
                      textStyle: CustomAppTheme()
                          .normalGreyText
                          .copyWith(fontSize: 12)),
              numLines > 7
                  ? Column(
                      children: [
                        SizedBox(
                          height: isReadMore ? 0 : 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isReadMore = !isReadMore;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                isReadMore ? "See Less" : 'See More',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: CustomAppTheme().primaryColor),
                              ),
                              Icon(!isReadMore
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up)
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: med.height * 0.02,
              ),
              Divider(
                color: CustomAppTheme().greyColor.withOpacity(0.3),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              productDetailHeading(title: 'Product Detail'),
              SizedBox(
                height: med.height * 0.02,
              ),
              GridView.builder(
                itemCount: detailList.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 2.0,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 0,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BrandLandingScreen()));
                    },
                    child: productDetailWidget(
                      svgUrl: detailList[index].imageSvg,
                      title: detailList[index].title,
                      value: detailList[index].value,
                    ),
                  );
                },
              ),
              /*SizedBox(
                height: med.height * 0.02,
              ),
              Divider(
                color: CustomAppTheme().greyColor.withOpacity(0.3),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              productDetailHeading(title: 'Features'),
              SizedBox(
                height: med.height * 0.02,
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 8.0,
                children: <Widget>[
                  for (int index = 0; index < featuresList.length; index++)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: CustomAppTheme().primaryColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: Text(
                          featuresList[index],
                          style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().darkGreyColor, fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                ],
              ),*/
              SizedBox(
                height: med.height * 0.02,
              ),
              Divider(
                color: CustomAppTheme().greyColor.withOpacity(0.3),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              productDetailHeading(title: 'Location'),
              SizedBox(
                height: med.height * 0.01,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on_rounded,
                      color: CustomAppTheme().darkGreyColor, size: 14),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SizedBox(
                      width: med.width * 0.85,
                      child: Text(
                        streetAddress,
                        maxLines: 2,
                        style: CustomAppTheme().normalGreyText.copyWith(
                            fontSize: 12,
                            color: CustomAppTheme().darkGreyColor),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              ProductLocationMapWidget(
                  longitude: double.parse(longitude.toString()),
                  latitude: double.parse(latitude.toString())),
              SizedBox(
                height: med.height * 0.04,
              ),
              (searchViewModel.suggestedClassifiedAds.isNotEmpty ||
                      searchViewModel.suggestedAutomotiveAds.isNotEmpty ||
                      searchViewModel.suggestedPropertyAds.isNotEmpty ||
                      searchViewModel.suggestedJobAds.isNotEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeScreenHeadingWidget(
                          headingText: 'Recommended For You',
                          viewAllCallBack: () {},
                          isSuffix: false,
                        ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        SizedBox(
                          height: widget.productType == 'Job'
                              ? med.height * 0.28
                              : med.height * 0.35,
                          child: recommendedProductFetching
                              ? ListView.builder(
                                  itemCount: 4,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return const Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: ProductCardShimmer(),
                                    );
                                  },
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.only(
                                      bottom: med.height * 0.01),
                                  itemCount: widget.productType == 'Classified'
                                      ? searchViewModel
                                          .suggestedClassifiedAds.length
                                      : widget.productType == 'Automotive'
                                          ? searchViewModel
                                              .suggestedAutomotiveAds.length
                                          : widget.productType == 'Property'
                                              ? searchViewModel
                                                  .suggestedPropertyAds.length
                                              : widget.productType == 'Job'
                                                  ? searchViewModel
                                                      .suggestedJobAds.length
                                                  : 0,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return widget.productType == 'Classified'
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailScreen(
                                                      classifiedProduct:
                                                          searchViewModel
                                                                  .suggestedClassifiedAds[
                                                              index],
                                                      productType: 'Classified',
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: ProductCard(
                                                onFavTap: () {
                                                  if (searchViewModel
                                                          .suggestedClassifiedAds[
                                                              index]
                                                          .isFavourite ==
                                                      false) {
                                                    setState(() {
                                                      classifiedViewModel
                                                          .addFavClassified(
                                                              adId: searchViewModel
                                                                  .suggestedClassifiedAds[
                                                                      index]
                                                                  .id!);
                                                      searchViewModel
                                                          .suggestedClassifiedAds[
                                                              index]
                                                          .isFavourite = true;
                                                      searchViewModel
                                                          .changeSuggestedAds(
                                                        classifiedAds:
                                                            searchViewModel
                                                                .suggestedClassifiedAds,
                                                        propertyAds: searchViewModel
                                                            .suggestedPropertyAds,
                                                        jobAds: searchViewModel
                                                            .suggestedJobAds,
                                                        automotiveAds:
                                                            searchViewModel
                                                                .suggestedAutomotiveAds,
                                                      );
                                                      for (int i = 0;
                                                          i <
                                                              classifiedViewModel
                                                                  .classifiedAllAds!
                                                                  .length;
                                                          i++) {
                                                        if (classifiedViewModel
                                                                .classifiedAllAds![
                                                                    i]
                                                                .id ==
                                                            searchViewModel
                                                                .suggestedClassifiedAds[
                                                                    index]
                                                                .id) {
                                                          classifiedViewModel
                                                              .classifiedAllAds![
                                                                  i]
                                                              .isFavourite = true;
                                                          classifiedViewModel
                                                              .changeClassifiedAllAds(
                                                                  classifiedViewModel
                                                                      .classifiedAllAds!);
                                                        }
                                                      }
                                                    });
                                                  } else {
                                                    setState(() {
                                                      classifiedViewModel
                                                          .addFavClassified(
                                                              adId: searchViewModel
                                                                  .suggestedClassifiedAds[
                                                                      index]
                                                                  .id!);
                                                      searchViewModel
                                                          .suggestedClassifiedAds[
                                                              index]
                                                          .isFavourite = false;
                                                      searchViewModel
                                                          .changeSuggestedAds(
                                                        classifiedAds:
                                                            searchViewModel
                                                                .suggestedClassifiedAds,
                                                        propertyAds: searchViewModel
                                                            .suggestedPropertyAds,
                                                        jobAds: searchViewModel
                                                            .suggestedJobAds,
                                                        automotiveAds:
                                                            searchViewModel
                                                                .suggestedAutomotiveAds,
                                                      );
                                                      for (int i = 0;
                                                          i <
                                                              classifiedViewModel
                                                                  .classifiedAllAds!
                                                                  .length;
                                                          i++) {
                                                        if (classifiedViewModel
                                                                .classifiedAllAds![
                                                                    i]
                                                                .id ==
                                                            searchViewModel
                                                                .suggestedClassifiedAds[
                                                                    index]
                                                                .id) {
                                                          classifiedViewModel
                                                              .classifiedAllAds![
                                                                  i]
                                                              .isFavourite = false;
                                                          classifiedViewModel
                                                              .changeClassifiedAllAds(
                                                                  classifiedViewModel
                                                                      .classifiedAllAds!);
                                                        }
                                                      }
                                                    });
                                                  }
                                                },
                                                isFav: searchViewModel
                                                    .suggestedClassifiedAds[
                                                        index]
                                                    .isFavourite,
                                                isOff: searchViewModel
                                                    .suggestedClassifiedAds[
                                                        index]
                                                    .isDeal,
                                                isFeatured: searchViewModel
                                                    .suggestedClassifiedAds[
                                                        index]
                                                    .isPromoted,
                                                title: searchViewModel
                                                    .suggestedClassifiedAds[
                                                        index]
                                                    .name,
                                                address: searchViewModel
                                                    .suggestedClassifiedAds[
                                                        index]
                                                    .streetAdress,
                                                currencyCode: searchViewModel
                                                    .suggestedClassifiedAds[
                                                        index]
                                                    .currency!
                                                    .code,
                                                price: searchViewModel
                                                    .suggestedClassifiedAds[
                                                        index]
                                                    .price,
                                                logo: searchViewModel
                                                            .suggestedClassifiedAds[
                                                                index]
                                                            .businessType ==
                                                        "Company"
                                                    ? searchViewModel
                                                        .suggestedClassifiedAds[
                                                            index]
                                                        .company
                                                        ?.profilePicture
                                                    : searchViewModel
                                                        .suggestedClassifiedAds[
                                                            index]
                                                        .profile
                                                        ?.profilePicture,
                                                imageUrl: searchViewModel
                                                        .suggestedClassifiedAds[
                                                            index]
                                                        .imageMedia!
                                                        .isEmpty
                                                    ? null
                                                    : searchViewModel
                                                        .suggestedClassifiedAds[
                                                            index]
                                                        .imageMedia![0]
                                                        .image,
                                                beds:
                                                    "${searchViewModel.suggestedClassifiedAds[index].category?.title}",
                                                baths:
                                                    "${searchViewModel.suggestedClassifiedAds[index].type}",
                                              ),
                                            ),
                                          )
                                        : widget.productType == 'Automotive'
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetailScreen(
                                                          automotiveProduct:
                                                              searchViewModel
                                                                      .suggestedAutomotiveAds[
                                                                  index],
                                                          productType:
                                                              'Automotive',
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: ProductCard(
                                                    onFavTap: () {
                                                      if (searchViewModel
                                                              .suggestedAutomotiveAds[
                                                                  index]
                                                              .isFavourite ==
                                                          false) {
                                                        setState(() {
                                                          automotiveViewModel
                                                              .addFavAutomotive(
                                                                  adId: searchViewModel
                                                                      .suggestedAutomotiveAds[
                                                                          index]
                                                                      .id!);
                                                          searchViewModel
                                                              .suggestedAutomotiveAds[
                                                                  index]
                                                              .isFavourite = true;
                                                          searchViewModel
                                                              .changeSuggestedAds(
                                                            classifiedAds:
                                                                searchViewModel
                                                                    .suggestedClassifiedAds,
                                                            propertyAds:
                                                                searchViewModel
                                                                    .suggestedPropertyAds,
                                                            jobAds: searchViewModel
                                                                .suggestedJobAds,
                                                            automotiveAds:
                                                                searchViewModel
                                                                    .suggestedAutomotiveAds,
                                                          );
                                                          for (int i = 0;
                                                              i <
                                                                  automotiveViewModel
                                                                      .automotiveAllAds
                                                                      .length;
                                                              i++) {
                                                            if (searchViewModel
                                                                    .suggestedAutomotiveAds[
                                                                        index]
                                                                    .id! ==
                                                                automotiveViewModel
                                                                    .automotiveAllAds[
                                                                        i]
                                                                    .id) {
                                                              automotiveViewModel
                                                                  .automotiveAllAds[
                                                                      i]
                                                                  .isFavourite = true;
                                                              automotiveViewModel
                                                                  .changeAutomotiveAllAds(
                                                                      automotiveViewModel
                                                                          .automotiveAllAds);
                                                            }
                                                          }
                                                        });
                                                      } else {
                                                        setState(() {
                                                          automotiveViewModel
                                                              .addFavAutomotive(
                                                                  adId: searchViewModel
                                                                      .suggestedAutomotiveAds[
                                                                          index]
                                                                      .id!);
                                                          searchViewModel
                                                              .suggestedAutomotiveAds[
                                                                  index]
                                                              .isFavourite = false;
                                                          searchViewModel
                                                              .changeSuggestedAds(
                                                            classifiedAds:
                                                                searchViewModel
                                                                    .suggestedClassifiedAds,
                                                            propertyAds:
                                                                searchViewModel
                                                                    .suggestedPropertyAds,
                                                            jobAds: searchViewModel
                                                                .suggestedJobAds,
                                                            automotiveAds:
                                                                searchViewModel
                                                                    .suggestedAutomotiveAds,
                                                          );
                                                          for (int i = 0;
                                                              i <
                                                                  automotiveViewModel
                                                                      .automotiveAllAds
                                                                      .length;
                                                              i++) {
                                                            if (searchViewModel
                                                                    .suggestedAutomotiveAds[
                                                                        index]
                                                                    .id! ==
                                                                automotiveViewModel
                                                                    .automotiveAllAds[
                                                                        i]
                                                                    .id) {
                                                              automotiveViewModel
                                                                  .automotiveAllAds[
                                                                      i]
                                                                  .isFavourite = true;
                                                              automotiveViewModel
                                                                  .changeAutomotiveAllAds(
                                                                      automotiveViewModel
                                                                          .automotiveAllAds);
                                                            }
                                                          }
                                                        });
                                                      }
                                                    },
                                                    isFav: searchViewModel
                                                        .suggestedAutomotiveAds[
                                                            index]
                                                        .isFavourite,
                                                    isFeatured: searchViewModel
                                                        .suggestedAutomotiveAds[
                                                            index]
                                                        .isPromoted,
                                                    isOff: searchViewModel
                                                        .suggestedAutomotiveAds[
                                                            index]
                                                        .isDeal,
                                                    address: searchViewModel
                                                        .suggestedAutomotiveAds[
                                                            index]
                                                        .streetAddress,
                                                    price: searchViewModel
                                                        .suggestedAutomotiveAds[
                                                            index]
                                                        .price,
                                                    currencyCode: searchViewModel
                                                        .suggestedAutomotiveAds[
                                                            index]
                                                        .currency!
                                                        .code,
                                                    logo: searchViewModel
                                                                .suggestedAutomotiveAds[
                                                                    index]
                                                                .businessType ==
                                                            "Company"
                                                        ? searchViewModel
                                                            .suggestedAutomotiveAds[
                                                                index]
                                                            .company
                                                            ?.profilePicture
                                                        : searchViewModel
                                                            .suggestedAutomotiveAds[
                                                                index]
                                                            .profile
                                                            ?.profilePicture,
                                                    title: searchViewModel
                                                        .suggestedAutomotiveAds[
                                                            index]
                                                        .name,
                                                    imageUrl: searchViewModel
                                                            .suggestedAutomotiveAds[
                                                                index]
                                                            .imageMedia!
                                                            .isEmpty
                                                        ? null
                                                        : searchViewModel
                                                            .suggestedAutomotiveAds[
                                                                index]
                                                            .imageMedia![0]
                                                            .image,
                                                    beds:
                                                        "${searchViewModel.suggestedAutomotiveAds[index].category?.title}",
                                                    baths:
                                                        "${searchViewModel.suggestedAutomotiveAds[index].carType}",
                                                  ),
                                                ),
                                              )
                                            : widget.productType == 'Property'
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductDetailScreen(
                                                              propertyProduct:
                                                                  searchViewModel
                                                                          .suggestedPropertyAds[
                                                                      index],
                                                              productType:
                                                                  'Property',
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: ProductCard(
                                                        onFavTap: () {
                                                          if (searchViewModel
                                                                  .suggestedPropertyAds[
                                                                      index]
                                                                  .isFavourite ==
                                                              false) {
                                                            setState(() {
                                                              propertiesViewModel
                                                                  .addFavProperty(
                                                                      adId: searchViewModel
                                                                          .suggestedPropertyAds[
                                                                              index]
                                                                          .id!);
                                                              searchViewModel
                                                                  .suggestedPropertyAds[
                                                                      index]
                                                                  .isFavourite = true;
                                                              searchViewModel
                                                                  .changeSuggestedAds(
                                                                classifiedAds:
                                                                    searchViewModel
                                                                        .suggestedClassifiedAds,
                                                                propertyAds:
                                                                    searchViewModel
                                                                        .suggestedPropertyAds,
                                                                jobAds: searchViewModel
                                                                    .suggestedJobAds,
                                                                automotiveAds:
                                                                    searchViewModel
                                                                        .suggestedAutomotiveAds,
                                                              );
                                                            });
                                                          } else {
                                                            setState(() {
                                                              propertiesViewModel
                                                                  .addFavProperty(
                                                                      adId: searchViewModel
                                                                          .suggestedPropertyAds[
                                                                              index]
                                                                          .id!);
                                                              searchViewModel
                                                                  .suggestedPropertyAds[
                                                                      index]
                                                                  .isFavourite = false;
                                                              searchViewModel
                                                                  .changeSuggestedAds(
                                                                classifiedAds:
                                                                    searchViewModel
                                                                        .suggestedClassifiedAds,
                                                                propertyAds:
                                                                    searchViewModel
                                                                        .suggestedPropertyAds,
                                                                jobAds: searchViewModel
                                                                    .suggestedJobAds,
                                                                automotiveAds:
                                                                    searchViewModel
                                                                        .suggestedAutomotiveAds,
                                                              );
                                                            });
                                                          }
                                                        },
                                                        isFav: searchViewModel
                                                            .suggestedPropertyAds[
                                                                index]
                                                            .isFavourite,
                                                        isFeatured: searchViewModel
                                                            .suggestedPropertyAds[
                                                                index]
                                                            .isPromoted,
                                                        isOff: searchViewModel
                                                            .suggestedPropertyAds[
                                                                index]
                                                            .isDeal,
                                                        title: searchViewModel
                                                            .suggestedPropertyAds[
                                                                index]
                                                            .name,
                                                        currencyCode:
                                                            searchViewModel
                                                                .suggestedPropertyAds[
                                                                    index]
                                                                .currency!
                                                                .code,
                                                        price: searchViewModel
                                                            .suggestedPropertyAds[
                                                                index]
                                                            .price,
                                                        address: searchViewModel
                                                            .suggestedPropertyAds[
                                                                index]
                                                            .streetAddress,
                                                        logo: searchViewModel
                                                                    .suggestedPropertyAds[
                                                                        index]
                                                                    .businessType ==
                                                                "Company"
                                                            ? searchViewModel
                                                                .suggestedPropertyAds[
                                                                    index]
                                                                .company
                                                                ?.profilePicture
                                                            : searchViewModel
                                                                .suggestedPropertyAds[
                                                                    index]
                                                                .profile
                                                                ?.profilePicture,
                                                        imageUrl: searchViewModel
                                                                .suggestedPropertyAds[
                                                                    index]
                                                                .imageMedia!
                                                                .isEmpty
                                                            ? null
                                                            : searchViewModel
                                                                .suggestedPropertyAds[
                                                                    index]
                                                                .imageMedia![0]
                                                                .image,
                                                        categories: 'property',
                                                        beds:
                                                            "${searchViewModel.suggestedPropertyAds[index].bedrooms} Bedrooms",
                                                        baths:
                                                            "${searchViewModel.suggestedPropertyAds[index].baths} Baths",
                                                      ),
                                                    ),
                                                  )
                                                : widget.productType == 'Job'
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 5),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProductDetailScreen(
                                                                  isJobAd: true,
                                                                  jobProduct:
                                                                      searchViewModel
                                                                              .suggestedJobAds[
                                                                          index],
                                                                  productType:
                                                                      'Job',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: JobAdsWidget(
                                                            onFavTap: () {
                                                              if (searchViewModel
                                                                      .suggestedJobAds[
                                                                          index]
                                                                      .isFavourite ==
                                                                  false) {
                                                                setState(() {
                                                                  jobViewModel.addFavJob(
                                                                      adId: searchViewModel
                                                                          .suggestedJobAds[
                                                                              index]
                                                                          .id!);
                                                                  searchViewModel
                                                                      .suggestedJobAds[
                                                                          index]
                                                                      .isFavourite = true;
                                                                  searchViewModel
                                                                      .changeSuggestedAds(
                                                                    classifiedAds:
                                                                        searchViewModel
                                                                            .suggestedClassifiedAds,
                                                                    propertyAds:
                                                                        searchViewModel
                                                                            .suggestedPropertyAds,
                                                                    jobAds: searchViewModel
                                                                        .suggestedJobAds,
                                                                    automotiveAds:
                                                                        searchViewModel
                                                                            .suggestedAutomotiveAds,
                                                                  );
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  jobViewModel.addFavJob(
                                                                      adId: searchViewModel
                                                                          .suggestedJobAds[
                                                                              index]
                                                                          .id!);
                                                                  searchViewModel
                                                                      .suggestedJobAds[
                                                                          index]
                                                                      .isFavourite = false;
                                                                  searchViewModel
                                                                      .changeSuggestedAds(
                                                                    classifiedAds:
                                                                        searchViewModel
                                                                            .suggestedClassifiedAds,
                                                                    propertyAds:
                                                                        searchViewModel
                                                                            .suggestedPropertyAds,
                                                                    jobAds: searchViewModel
                                                                        .suggestedJobAds,
                                                                    automotiveAds:
                                                                        searchViewModel
                                                                            .suggestedAutomotiveAds,
                                                                  );
                                                                });
                                                              }
                                                            },
                                                            isFav: searchViewModel
                                                                .suggestedJobAds[
                                                                    index]
                                                                .isFavourite,
                                                            isFeatured:
                                                                searchViewModel
                                                                    .suggestedJobAds[
                                                                        index]
                                                                    .isPromoted,
                                                            isOff: false,
                                                            title: searchViewModel
                                                                .suggestedJobAds[
                                                                    index]
                                                                .title,
                                                            currencyCode:
                                                                searchViewModel
                                                                    .suggestedJobAds[
                                                                        index]
                                                                    .salaryCurrency!
                                                                    .code,
                                                            startingSalary:
                                                                searchViewModel
                                                                    .suggestedJobAds[
                                                                        index]
                                                                    .salaryStart,
                                                            endingSalary:
                                                                searchViewModel
                                                                    .suggestedJobAds[
                                                                        index]
                                                                    .salaryEnd,
                                                            description:
                                                                searchViewModel
                                                                    .suggestedJobAds[
                                                                        index]
                                                                    .description,
                                                            address: searchViewModel
                                                                .suggestedJobAds[
                                                                    index]
                                                                .location,
                                                            imageUrl: searchViewModel
                                                                    .suggestedJobAds[
                                                                        index]
                                                                    .imageMedia!
                                                                    .isEmpty
                                                                ? null
                                                                : searchViewModel
                                                                    .suggestedJobAds[
                                                                        index]
                                                                    .imageMedia![
                                                                        0]
                                                                    .image,
                                                            beds:
                                                                "${searchViewModel.suggestedJobAds[index].positionType}",
                                                            baths:
                                                                "${searchViewModel.suggestedJobAds[index].jobType}",
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink();
                                  },
                                ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: med.height * 0.08,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: userProfile.id! !=
              iPrefHelper.retrieveUser()?.id.toString()
          ? Container(
              height: med.height * 0.07,
              width: med.width,
              decoration: BoxDecoration(
                color: CustomAppTheme().backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0.5,
                    blurRadius: 3,
                    offset: const Offset(3, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  isLoader
                      ? SizedBox(
                          height: med.height * 0.045,
                          width: med.width * 0.4,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: CustomAppTheme().primaryColor,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            if (userProfile.id! !=
                                iPrefHelper.retrieveUser()?.id.toString()) {
                              setState(() {
                                isLoader = true;
                              });
                              final startChat = await chatViewModel.startChat(
                                  receiverId: userProfile.id!,
                                  context: context);
                              d('This is startChat : ${startChat.id}');

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DirectMessageScreen(
                                            chatId: startChat.id!,
                                            receiver: userProfile,
                                          )));
                              setState(() {
                                isLoader = false;
                              });
                            }
                          },
                          child: Container(
                            height: med.height * 0.045,
                            width: med.width * 0.4,
                            decoration: BoxDecoration(
                              color: CustomAppTheme().backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: CustomAppTheme().primaryColor,
                                  width: 1.5),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Text(
                                  'Chat With Seller',
                                  style: CustomAppTheme().normalText.copyWith(
                                      color: CustomAppTheme().primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                  widget.productType == 'Job'
                      ? GestureDetector(
                          onTap: widget.jobProduct!.isApplied == true
                              ? () {}
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ApplyJobScreen(
                                        jobId: widget.jobProduct!.id!,
                                        imageUrl: images![0],
                                        currency: currencyCode,
                                        startingSalary: startingSalary,
                                        endingSalary: endingSalary,
                                        title: productTitle,
                                        userImage: businessType == 'Individual'
                                            ? userProfile.profilePicture
                                                .toString()
                                            : companyProfile.profilePicture
                                                .toString(),
                                        userName:
                                            userProfile.firstName.toString(),
                                        createdAd: timeAgo,
                                      ),
                                    ),
                                  );
                                },
                          child: Container(
                            height: med.height * 0.045,
                            width: med.width * 0.4,
                            decoration: BoxDecoration(
                              color: CustomAppTheme().primaryColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: CustomAppTheme().primaryColor,
                                  width: 1.5),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Text(
                                  widget.jobProduct!.isApplied == true
                                      ? 'Applied'
                                      : 'Apply',
                                  style: CustomAppTheme().normalText.copyWith(
                                      color: CustomAppTheme().backgroundColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (userProfile.mobileNumber != null &&
                                userProfile.mobilePrivacy == "Show" &&
                                userProfile.mobileNumber != "null") {
                              UrlLauncher.launch(
                                  "tel://${userProfile.mobileNumber}");
                            } else {
                              helper
                                  .showToast('Phone Number is not available.');
                            }
                          },
                          child: Container(
                            height: med.height * 0.045,
                            width: med.width * 0.4,
                            decoration: BoxDecoration(
                              color: CustomAppTheme().primaryColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: CustomAppTheme().primaryColor,
                                  width: 1.5),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Text(
                                  'Contact Seller',
                                  style: CustomAppTheme().normalText.copyWith(
                                      color: CustomAppTheme().backgroundColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget productDetailHeading({required final String title}) {
    return Text(
      title,
      style: CustomAppTheme()
          .normalText
          .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }

  Widget productDetailWidget(
      {required final String svgUrl,
      required final String title,
      required final String value}) {
    return Row(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.04,
          width: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            color: CustomAppTheme().backgroundColor,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.2,
                blurRadius: 1,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: SvgPicture.asset(
              svgUrl,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: CustomAppTheme()
                      .normalText
                      .copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                ),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: CustomAppTheme().normalGreyText.copyWith(
                      fontSize: 9, color: CustomAppTheme().darkGreyColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  initializeVideo(String videoUrl) {
    videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then(
        (value) {
          setState(
            () {
              chewieController = ChewieController(
                videoPlayerController: videoPlayerController!,
                autoInitialize: true,
                autoPlay: true,
                looping: false,
                showOptions: true,
                materialProgressColors: ChewieProgressColors(
                    backgroundColor: CustomAppTheme().primaryColor,
                    playedColor: CustomAppTheme().primaryColor.withOpacity(1.0),
                    handleColor: CustomAppTheme().primaryColor),
                showControls: true,
                allowMuting: true,
                allowFullScreen: false,
                useRootNavigator: false,
                fullScreenByDefault: false,
                showControlsOnInitialize: false,
                zoomAndPan: false,
                errorBuilder: (
                  context,
                  errorMessage,
                ) {
                  return Center(
                    child: Text(
                      errorMessage,
                    ),
                  );
                },
              );
            },
          );
        },
      );
  }
}

class DetailListModel {
  late String imageSvg;
  late String title;
  late String value;

  DetailListModel({
    required this.imageSvg,
    required this.title,
    required this.value,
  });
}
