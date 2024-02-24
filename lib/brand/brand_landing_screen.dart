import 'package:app/common/logger/log.dart';
import 'package:app/presentation/automotive/automotive_filters/automotive_filter_screen.dart';
import 'package:app/presentation/automotive/automotive_on_map_screen.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/categories/all_categories_screen.dart';
import 'package:app/presentation/home/mixins/home_mixin.dart';
import 'package:app/presentation/home/view_model/home_view_model.dart';
import 'package:app/presentation/profile/business_mode/create_business_profile.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/searchs/searchScreen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/shimmers/categoryCardShimmer.dart';
import 'package:app/presentation/utils/shimmers/product_card_shimmer.dart';
import 'package:app/presentation/utils/widgets/category_card.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/explore_more_button.dart';
import 'package:app/presentation/utils/widgets/filter_widget.dart';
import 'package:app/presentation/utils/widgets/home_screen_headings_widget.dart';
import 'package:app/presentation/utils/widgets/location_and_notif_widget.dart';
import 'package:app/presentation/utils/widgets/menu_with_icon_widget.dart';
import 'package:app/presentation/utils/widgets/product_card.dart';
import 'package:app/presentation/utils/widgets/searched_textfield.dart';
import 'package:app/presentation/widgets_screens/all_products_screen.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/svg.dart';

class BrandLandingScreen extends StatefulWidget {
  const BrandLandingScreen({Key? key}) : super(key: key);

  @override
  State<BrandLandingScreen> createState() => _BrandLandingScreenState();
}

class _BrandLandingScreenState extends State<BrandLandingScreen> {

  String description = 'Mitsubishi Motors Corporation is a Japanese multinational automobile manufacturer headquartered in Minato, Tokyo, Japan. In 2011, Mitsubishi. Mitsubishi Motors Corporation is a Japanese multinational automobile manufacturer headquartered in Minato, Tokyo, Japan. In 2011, Mitsubishi.';

  int currentAdIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: CustomAppTheme().backgroundColor,
        appBar: customAppBar(title: 'Mitsubishi', context: context, onTap: () {Navigator.of(context).pop();}),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const LocationAndNotificationWidget(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: med.width * 0.8,
                              height: med.height * 0.048,
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const SearchScreen()));
                                },
                                child: const RoundedTextField(isEnabled: false),
                              ),
                            ),
                            const Spacer(),
                            FilterWidget(onTab: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const AutomotiveFiltersScreen()));
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                    color: const Color(0xFFF6F6F6),
                  child: Column(
                    children: [
                      // description part ...
                      Image.asset('assets/images/brand_detail_header.png', height: 150, width: med.width, fit: BoxFit.cover),
                      DescriptionWidget(description: description),

                      // slider part ...
                      //Ads
                      SizedBox(
                        height: med.height * 0.27,
                        child: Swiper(
                          itemHeight: med.height * 0.27,
                          // itemWidth: med.width * 0.7,
                          // itemHeight: med.height * 0.17,
                          itemCount: 3,
                          viewportFraction: .43,
                          scale: 1,
                          loop: false,
                          onIndexChanged: (value) {
                            setState(() {
                              currentAdIndex = value;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(width: 2, color: Colors.grey.withOpacity(.2))
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 25),
                                      Image.asset(bannerImages[index]),
                                      SizedBox(height: 20),
                                      Text("Outlander Sport", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                      SizedBox(height: 10),
                                      Text("20222-2023")
                                      // Container(
                                      //   width: 120,
                                      //   decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(10),
                                      //     image: DecorationImage(
                                      //       image: AssetImage(bannerImages[index]),
                                      //       fit: BoxFit.cover,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      //Indicator
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: AnimatedSmoothIndicator(
                            activeIndex: currentAdIndex,
                            count: 3,
                            effect: SlideEffect(
                                dotWidth: 10,
                                dotHeight: 10,
                                spacing: 5.0,
                                paintStyle: PaintingStyle.stroke,
                                strokeWidth: 1.5,
                                dotColor: Colors.grey,
                                activeDotColor: CustomAppTheme().primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                Column(
                  children: [
                   const SizedBox(height: 15),
                    Container(
                      alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: const Text("All Ads", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))),
                    const SizedBox(height: 15),
                    GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shrinkWrap: true,
                      itemCount: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        // childAspectRatio: 2 / 3.25,
                        childAspectRatio: MediaQuery.of(context)
                            .size
                            .width /
                            (MediaQuery.of(context).size.height / 1.29),
                        crossAxisCount: 2,
                        mainAxisSpacing: 15.0,
                        crossAxisSpacing: 5.0,
                        // maxCrossAxisExtent: 200,
                        // childAspectRatio: med.height * 0.00072,
                        // crossAxisSpacing: 5,
                        // mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         ProductDetailScreen(
                            //           classifiedProduct: classifiedViewModel
                            //               .classifiedAllAds![index],
                            //           productType: 'Classified',
                            //         ),
                            //   ),
                            // );
                          },
                          child: BrandProductCard(
                            onFavTap: () {},
                            // onFavTap: () {
                            //   if (classifiedViewModel
                            //       .classifiedAllAds![index]
                            //       .isFavourite ==
                            //       false) {
                            //     setState(() {
                            //       classifiedViewModel.addFavClassified(
                            //           adId: classifiedViewModel
                            //               .classifiedAllAds![index]
                            //               .id!);
                            //       for (int i = 0;
                            //       i <
                            //           classifiedViewModel
                            //               .classifiedAllAds!.length;
                            //       i++) {
                            //         if (classifiedViewModel
                            //             .classifiedAllAds![index]
                            //             .id! ==
                            //             classifiedViewModel
                            //                 .classifiedAllAds![i].id) {
                            //           classifiedViewModel
                            //               .classifiedAllAds![index]
                            //               .isFavourite = true;
                            //           classifiedViewModel
                            //               .changeClassifiedAllAds(
                            //               classifiedViewModel
                            //                   .classifiedAllAds!);
                            //         }
                            //       }
                            //       for (int i = 0;
                            //       i <
                            //           classifiedViewModel
                            //               .classifiedFeaturedAds!
                            //               .length;
                            //       i++) {
                            //         if (classifiedViewModel
                            //             .classifiedFeaturedAds![
                            //         index]
                            //             .id! ==
                            //             classifiedViewModel
                            //                 .classifiedFeaturedAds![i]
                            //                 .id) {
                            //           classifiedViewModel
                            //               .classifiedFeaturedAds![index]
                            //               .isFavourite = true;
                            //           classifiedViewModel
                            //               .changeClassifiedFeaturedAds(
                            //               classifiedViewModel
                            //                   .classifiedFeaturedAds!);
                            //         }
                            //       }
                            //       for (int i = 0;
                            //       i <
                            //           profileViewModel
                            //               .myClassifiedAds.length;
                            //       i++) {
                            //         if (profileViewModel
                            //             .myClassifiedAds[index]
                            //             .id! ==
                            //             profileViewModel
                            //                 .myClassifiedAds[i].id) {
                            //           profileViewModel
                            //               .myClassifiedAds[index]
                            //               .isFavourite = true;
                            //           profileViewModel
                            //               .changeMyClassifiedAds(
                            //               profileViewModel
                            //                   .myClassifiedAds);
                            //         }
                            //       }
                            //     });
                            //     profileViewModel.myFavClassifiedAds.add(
                            //         classifiedViewModel
                            //             .classifiedAllAds![index]);
                            //     profileViewModel.changeMyFavClassified(
                            //         profileViewModel
                            //             .myFavClassifiedAds);
                            //   }
                            //   else {
                            //     setState(() {
                            //       classifiedViewModel.addFavClassified(
                            //           adId: classifiedViewModel
                            //               .classifiedAllAds![index]
                            //               .id!);
                            //       for (int i = 0;
                            //       i <
                            //           classifiedViewModel
                            //               .classifiedAllAds!.length;
                            //       i++) {
                            //         if (classifiedViewModel
                            //             .classifiedAllAds![index]
                            //             .id! ==
                            //             classifiedViewModel
                            //                 .classifiedAllAds![i].id) {
                            //           classifiedViewModel
                            //               .classifiedAllAds![index]
                            //               .isFavourite = false;
                            //           classifiedViewModel
                            //               .changeClassifiedAllAds(
                            //               classifiedViewModel
                            //                   .classifiedAllAds!);
                            //         }
                            //       }
                            //       for (int i = 0;
                            //       i <
                            //           classifiedViewModel
                            //               .classifiedFeaturedAds!
                            //               .length;
                            //       i++) {
                            //         if (classifiedViewModel
                            //             .classifiedFeaturedAds![
                            //         index]
                            //             .id! ==
                            //             classifiedViewModel
                            //                 .classifiedFeaturedAds![i]
                            //                 .id) {
                            //           classifiedViewModel
                            //               .classifiedFeaturedAds![index]
                            //               .isFavourite = false;
                            //           classifiedViewModel
                            //               .changeClassifiedFeaturedAds(
                            //               classifiedViewModel
                            //                   .classifiedFeaturedAds!);
                            //         }
                            //       }
                            //       for (int i = 0;
                            //       i <
                            //           profileViewModel
                            //               .myClassifiedAds.length;
                            //       i++) {
                            //         if (profileViewModel
                            //             .myClassifiedAds[index]
                            //             .id! ==
                            //             profileViewModel
                            //                 .myClassifiedAds[i].id) {
                            //           profileViewModel
                            //               .myClassifiedAds[index]
                            //               .isFavourite = false;
                            //           profileViewModel
                            //               .changeMyClassifiedAds(
                            //               profileViewModel
                            //                   .myClassifiedAds);
                            //         }
                            //       }
                            //     });
                            //     profileViewModel.myFavClassifiedAds
                            //         .removeWhere((element) =>
                            //     element.id ==
                            //         classifiedViewModel
                            //             .classifiedAllAds![index]
                            //             .id!);
                            //     profileViewModel.changeMyFavClassified(
                            //         profileViewModel
                            //             .myFavClassifiedAds);
                            //   }
                            // },
                            isFav: true,
                            isOff: true,
                            isFeatured: true,
                            title: 'chishti',
                            address: 'Arifwala',
                            currencyCode: '+971',
                            price: '122',
                            imageUrl: 'assets/images/brand_car.png',
                            logo: null,
                            categories: "classified",
                            beds:
                            "sasdasdas",
                            baths:
                            "05",
                          ),
                        );
                      },
                    )

                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> bannerImages = [
    'assets/images/outlander_support.png',
    'assets/images/outlander_support.png',
    'assets/images/outlander_support.png',
    // 'assets/images/properties_bnr.png',
    // 'assets/images/job_bnr.png',
  ];



}


class DescriptionWidget extends StatefulWidget {
  final String description;
  const DescriptionWidget({Key? key, required this.description}) : super(key: key);

  @override
  State<DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {


  String firstHalf = '';
  String secondHalf = '';
  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.description.length > 117) {
      firstHalf = widget.description.substring(0, 117);
      secondHalf = widget.description.substring(117, widget.description.length);
    } else {
      firstHalf = widget.description;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F6F6),
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
      child: secondHalf.isEmpty
          ? Text(firstHalf, style: const TextStyle())
          : Column(
        children: <Widget>[
          RichText(
            overflow: TextOverflow.clip,
            textAlign: TextAlign.end,
            textDirection: TextDirection.rtl,
            softWrap: true,
            textScaleFactor: 1,
            text: flag ? TextSpan(
              text: firstHalf,
              style: const TextStyle(decoration: TextDecoration.none, color: Color(0xFF464545), height: 1.45),
              children: <TextSpan>[
                TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () {
                      setState(() {
                        flag = false;
                      });
                    },
                    text: " ...read more", style: const TextStyle(color: Color(0xFF03AA7F), height: 1.45, fontWeight: FontWeight.w500)),
              ],
            ) : TextSpan(
              text: firstHalf + secondHalf,
              style: const TextStyle(decoration: TextDecoration.none, color: Color(0xFF464545), fontWeight: FontWeight.w500, height: 1.45),
              children: <TextSpan>[
                TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () {
                      setState(() {
                        flag = true;
                      });
                    },
                    text: ' show less', style: const TextStyle(color: Color(0xFF03AA7F), fontWeight: FontWeight.w500, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






class BrandProductCard extends StatefulWidget {
  final bool? isFeatured;
  final bool? isFav;
  final bool? isVerified;
  final bool? isOff;
  final String? categories;
  final String? logo;
  final String? imageUrl;
  final String? title;
  final String? address;
  final String? price;
  final String? currencyCode;
  final VoidCallback? onFavTap;
  final String? beds;
  final String? baths;
  final String? baths1;

  const BrandProductCard({
    Key? key,
    this.isFeatured = false,
    this.isOff = false,
    this.imageUrl =
    'assets/images/brand_car.png',
    this.title = '',
    this.address = '',
    this.price = '',
    this.baths = '',
    this.logo,
    this.categories = '',
    this.beds = '',
    this.baths1 = '',
    this.currencyCode = '',
    this.isFav = false,
    this.isVerified = false,
    this.onFavTap,
  }) : super(key: key);

  @override
  State<BrandProductCard> createState() => _BrandProductCardState();
}

class _BrandProductCardState extends State<BrandProductCard> {
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    String imageUrl;
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      imageUrl =
      'assets/images/brand_car.png';
    } else {
      imageUrl = widget.imageUrl!;
    }
    return Container(
      // height: med.height * 0.32,
      width: med.width * 0.45,
      margin:
      EdgeInsets.only(bottom: med.height * 0.005, right: med.width * 0.005),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CustomAppTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0.2,
            blurRadius: 1,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: med.height * 0.16,
                    width: med.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: <Widget>[
                        widget.isFeatured!
                            ? Container(
                          height: med.height * 0.022,
                          // width: med.width*0.18,
                          decoration: BoxDecoration(
                            color: CustomAppTheme().secondaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  size: 10,
                                  color: CustomAppTheme().backgroundColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Center(
                                    child: Text(
                                      'Featured',
                                      style: CustomAppTheme()
                                          .normalText
                                          .copyWith(
                                          fontSize: 10,
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
                        widget.isFeatured!
                            ? SizedBox(
                          width: med.width * 0.01,
                        )
                            : const SizedBox.shrink(),
                        //10% OFF BOX
                        /*widget.isOff!
                           ? Container(
                               height: med.height * 0.022,
                               // width: med.width*0.18,
                               decoration: BoxDecoration(
                                 color: CustomAppTheme().secondaryColor,
                                 borderRadius: BorderRadius.circular(4),
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                 child: Center(
                                   child: Text(
                                     '10% off',
                                     style: CustomAppTheme().normalText.copyWith(fontSize: 10, color: CustomAppTheme().backgroundColor),
                                   ),
                                 ),
                               ),
                             )
                           : const SizedBox.shrink(),
                       widget.isOff!
                           ? SizedBox(
                               width: med.width * 0.01,
                             )
                           : const SizedBox.shrink(),*/
                        widget.isOff!
                            ? Container(
                          height: med.height * 0.022,
                          // width: med.width*0.18,
                          decoration: BoxDecoration(
                            color: const Color(0xfffe2e2e),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            child: Center(
                              child: Text(
                                'For Sale',
                                style: CustomAppTheme()
                                    .normalText
                                    .copyWith(
                                    fontSize: 10,
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, bottom: 5, right: 5),
                child: Column(
                  children: <Widget>[
                    //Verified widget
                    widget.isVerified!
                        ? Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: med.width * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color:
                            const Color(0xffFFF0D2), // Colors.white
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 2),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.verified_outlined,
                                  color:
                                  Color(0xff653700) /*Colors.white*/,
                                  size: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Text(
                                    'Verified',
                                    style: CustomAppTheme()
                                        .normalText
                                        .copyWith(
                                        color: const Color(
                                            0xff653700) /*Colors
                                                      .white*/
                                        ,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: med.width * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color:
                            Colors.white /*const Color(0xffFFF0D2)*/,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 2),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.verified_outlined,
                                  color:
                                  Colors.white /*Color(0xff653700)*/,
                                  size: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Text(
                                    'Verified',
                                    style: CustomAppTheme()
                                        .normalText
                                        .copyWith(
                                        color: Colors
                                            .white /*const Color(0xff653700)*/,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: med.height * 0.01,
                    ),

                    //Title and fav
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: med.width * 0.33,
                          child: Text(
                            widget.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: CustomAppTheme().normalText.copyWith(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: widget.onFavTap ?? () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xffe6fff9),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(
                                  widget.isFav == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: CustomAppTheme().primaryColor,
                                  size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on_rounded,
                            color: CustomAppTheme().primaryColor,
                            size: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: SizedBox(
                              width: med.width * 0.37,
                              child: Text(
                                widget.address!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CustomAppTheme()
                                    .normalText
                                    .copyWith(fontSize: 9),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: med.height * 0.015,
                    ),

                    Row(
                      children: <Widget>[
                        Text(
                          '${widget.currencyCode} ${widget.price}',
                          style: CustomAppTheme().normalText.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: CustomAppTheme().primaryColor),
                        ),

                        /*widget.isOff!
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  '${widget.currencyCode} 56',
                                  style: CustomAppTheme().normalText.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                ),
                              )
                            : const SizedBox.shrink(),*/

                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white /*const Color(0xffe6fff9)*/,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(Icons.location_on_rounded,
                                color: Colors
                                    .white /*CustomAppTheme().primaryColor*/,
                                size: 14),
                          ),
                        ),

                        //View on map
                        /*Container(
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(4),
                                         color: const Color(0xffe6fff9),
                                         border: Border.all(color: CustomAppTheme().primaryColor),
                                       ),
                                       child: Padding(
                                         padding: const EdgeInsets.all(2.0),
                                         child: Row(
                                           children: <Widget>[
                                             Icon(Icons.location_on_rounded, size: 12, color: CustomAppTheme().primaryColor,),
                                             Text('View on Map',
                                               style: CustomAppTheme().normalText.copyWith(fontSize: 8, color: CustomAppTheme().primaryColor),
                                             )
                                           ],
                                         ),
                                       ),
                                     ),
*/
                      ],
                    ),

                    SizedBox(
                      height: med.height * 0.008,
                    ),

                    const Divider(
                      thickness: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: widget.categories == "auto"
                            ? [
                          propertyFeatureWidget(
                              svgUrl: 'assets/svgs/milage.svg',
                              type: widget.beds ?? 'Beds'),
                          propertyFeatureWidget(
                              svgUrl: 'assets/svgs/transmission.svg',
                              type: widget.baths ?? ''),
                          // propertyFeatureWidget(
                          //     svgUrl: 'assets/svgs/engine.svg',
                          //     type: widget.baths ?? ''),
                        ]
                            : <Widget>[
                          propertyFeatureWidget(
                              svgUrl: widget.categories == "property"
                                  ? 'assets/svgs/bedIcon.svg'
                                  : 'assets/svgs/typeIcon.svg',
                              type: widget.beds ?? ''),
                          propertyFeatureWidget(
                              svgUrl: widget.categories == "property"
                                  ? 'assets/svgs/sqftIcon.svg'
                                  : 'assets/svgs/conditionIcon.svg',
                              type: widget.baths ?? ''),
                          // propertyFeatureWidget(
                          //     svgUrl: 'assets/svgs/sqftIcon.svg',
                          //     type: 'sqft',
                          //     isEmpty: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: med.height * 0.135,
              ),
              Container(
                height: med.height * 0.05,
                width: med.width * 0.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: CustomAppTheme().backgroundColor, width: 2.0),
                  image: widget.logo != null
                      ? DecorationImage(
                    image: NetworkImage(
                      widget.logo!,
                    ),
                    fit: BoxFit.cover,
                  )
                      : const DecorationImage(
                    image: AssetImage('assets/images/userIconImage.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget propertyFeatureWidget({required String svgUrl, required String type}) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(
          svgUrl,
          height: MediaQuery.of(context).size.height * 0.012,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(
            type,
            style: CustomAppTheme().normalText.copyWith(fontSize: 8),
          ),
        ),
      ],
    );
  }
}
