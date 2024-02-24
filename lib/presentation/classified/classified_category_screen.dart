import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/brand_circular_widget.dart';
import 'package:app/presentation/utils/widgets/category_card.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/filter_widget.dart';
import 'package:app/presentation/utils/widgets/home_screen_headings_widget.dart';
import 'package:app/presentation/utils/widgets/location_and_notif_widget.dart';
import 'package:app/presentation/utils/widgets/product_card.dart';
import 'package:app/presentation/utils/widgets/searched_textfield.dart';
import 'package:flutter/material.dart';

class ClassifiedCategoryScreen extends StatefulWidget {
  final String category;

  const ClassifiedCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<ClassifiedCategoryScreen> createState() => _ClassifiedCategoryScreenState();
}

class _ClassifiedCategoryScreenState extends State<ClassifiedCategoryScreen> {
  int featuredAdsLength = 6;

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: widget.category, context: context, onTap: () {Navigator.of(context).pop();}),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const LocationAndNotificationWidget(),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: med.width * 0.8,
                      height: med.height * 0.048,
                      child: const RoundedTextField(),
                    ),
                    const Spacer(),
                    FilterWidget(onTab: () {}),
                  ],
                ),
              ),

              SizedBox(
                height: med.height * 0.05,
              ),

              SizedBox(
                height: med.height * 0.18,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryBannerImages.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(
                      children: <Widget>[
                        Container(
                          height: med.height * 0.18,
                          width: med.width * 0.7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CustomAppTheme().greyColor,
                              image: DecorationImage(
                                image: AssetImage(categoryBannerImages[index]),
                                fit: BoxFit.cover,
                              )),
                        ),
                        index != 1
                            ? SizedBox(
                                width: med.width * 0.025,
                              )
                            : const SizedBox.shrink(),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(
                height: med.height * 0.04,
              ),

              HomeScreenHeadingWidget(
                headingText: 'Browse By Categories',
                viewAllCallBack: () {},
              ),

              SizedBox(
                height: med.height * 0.02,
              ),

              //Sub Category cards
              SizedBox(
                height: med.height * 0.15,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: subCategoriesSvgs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CategoryCard(imagePath: subCategoriesSvgs[index]),
                    );
                  },
                ),
              ),

              SizedBox(
                height: med.height * 0.04,
              ),

              HomeScreenHeadingWidget(
                headingText: 'Deals of the day',
                viewAllCallBack: () {},
              ),

              SizedBox(
                height: med.height * 0.01,
              ),

              Row(
                children: <Widget>[
                  Text(
                    'Offer Ends:',
                    style: CustomAppTheme().normalGreyText.copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffe73c17),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Text(
                          '20h : 0m : 15s',
                          style: CustomAppTheme().normalText.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: med.height * 0.02,
              ),

              //Deals of the day
              SizedBox(
                height: med.height * 0.35,
                child: Center(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: med.height * 0.01),
                    itemCount: 5,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: ProductCard(isOff: true),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(
                height: med.height * 0.04,
              ),

              HomeScreenHeadingWidget(
                headingText: 'Featured Ads',
                viewAllCallBack: () {},
              ),

              SizedBox(
                height: med.height * 0.02,
              ),

              //Featured ads
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: featuredAdsLength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: med.height * 0.00072,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  return const ProductCard(
                    isFeatured: true,
                  );
                },
              ),

              SizedBox(
                height: med.height * 0.04,
              ),

              HomeScreenHeadingWidget(
                headingText: 'Featured Brands',
                viewAllCallBack: () {},
              ),

              SizedBox(
                height: med.height * 0.02,
              ),

              SizedBox(
                height: med.height * 0.15,
                child: ListView.builder(
                  itemCount: 6,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return BrandCircularWidget(index: index);
                  },
                ),
              ),

              SizedBox(
                height: med.height * 0.04,
              ),

              HomeScreenHeadingWidget(
                headingText: 'Recommended For You',
                viewAllCallBack: () {},
              ),

              SizedBox(
                height: med.height * 0.02,
              ),

              SizedBox(
                height: med.height * 0.35,
                child: Center(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: med.height * 0.01),
                    itemCount: 5,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: ProductCard(),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(
                height: med.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> categoryBannerImages = ['assets/temp/jobsBanner1.png', 'assets/temp/jobsBanner2.png'];

  List<String> subCategoriesSvgs = [
    'assets/temp/UIDesignIcon.svg',
    'assets/temp/world-wide-web 1.svg',
    'assets/temp/app-development.svg',
    'assets/temp/web-administrator.svg',
    'assets/temp/data-scientist.svg'
  ];
}
