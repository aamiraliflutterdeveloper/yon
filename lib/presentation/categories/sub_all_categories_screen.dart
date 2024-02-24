import 'package:app/common/logger/log.dart';
import 'package:app/data/models/model_objects/categories_res_object.dart';
import 'package:app/presentation/add_post/ad_type_screen.dart';
import 'package:app/presentation/add_post/upload_images_videos.dart';
import 'package:app/presentation/add_post/view_model/create_ad_post_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/category_card.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllSubCategoriesScreen extends StatefulWidget {
  final bool? isAddPost;
  final String subCategoryTitle;
  final int? subCategoriesIndex;
  final int categoryIndex;
  final List<SubCategory>? allSubCategories;

  const AllSubCategoriesScreen(
      {Key? key,
      required this.subCategoryTitle,
      this.isAddPost = false,
      required this.categoryIndex,
      this.subCategoriesIndex,
      this.allSubCategories})
      : super(key: key);

  @override
  State<AllSubCategoriesScreen> createState() => _AllSubCategoriesScreenState();
}

class _AllSubCategoriesScreenState extends State<AllSubCategoriesScreen> {

  @override
  void initState() {
    print("yes bossssssssssss");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    d("========== ${widget.allSubCategories!.length}");
    d("ahaaaaaaaaaaaaaaaa");
    final CreateAdPostViewModel createAdPostViewModel =
        context.watch<CreateAdPostViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: widget.subCategoryTitle, context: context, onTap: () {Navigator.of(context).pop();}),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: med.height * 0.03,
              ),
              Text(
                'Choose Sub-Category',
                style: CustomAppTheme().headingText,
              ),
              /*SizedBox(
                height: med.height * 0.015,
              ),
              Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                textAlign: TextAlign.start,
                style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
              ),*/
              SizedBox(
                height: med.height * 0.04,
              ),
              GridView.builder(
                itemCount: widget.allSubCategories!.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: med.height * 0.15,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  print(widget.allSubCategories![index].totalCount);
                  print("hahahhhahhahahhahahahha");
                  String colorCode =
                      widget.allSubCategories![index].backgroundColor == null
                          ? 'FFF3FF'
                          : widget.allSubCategories![index].backgroundColor
                              .toString();
                  int bgColor = int.parse('0XFF' + colorCode);
                  return GestureDetector(
                    onTap: widget.isAddPost == true
                        ? () {
                            if (widget.categoryIndex == 0) {
                              ClassifiedObject classifiedData =
                                  createAdPostViewModel.classifiedAdData!;
                              classifiedData.subCategoryId =
                                  widget.allSubCategories![index].id;
                              classifiedData.conditionType =
                                  widget.allSubCategories![index].title;
                              createAdPostViewModel
                                  .changeClassifiedAdData(classifiedData);
                              classifiedData.adType =
                                  businessIndex == 0 ? 'Individual' : 'Company';
                              d('CLASSIFIED AD DATA : ' +
                                  createAdPostViewModel
                                      .classifiedAdData!.categoryId
                                      .toString());
                              d('CLASSIFIED AD SUB CATEGORY ID : ' +
                                  createAdPostViewModel
                                      .classifiedAdData!.subCategoryId
                                      .toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UploadImagesVideosScreen(
                                    categoryIndex: widget.categoryIndex,
                                  ),
                                ),
                              );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => AdTypeScreen(
                              //       categoryIndex: widget.categoryIndex,
                              //     ),
                              //   ),
                              // );
                            } else if (widget.categoryIndex == 1) {
                              PropertiesObject propertyData =
                                  createAdPostViewModel.propertyAdData!;
                              propertyData.subCategoryId =
                                  widget.allSubCategories![index].id;
                              propertyData.subCategoryName =
                                  widget.allSubCategories![index].title;
                              createAdPostViewModel
                                  .changePropertyAdData(propertyData);
                              propertyData.adType =
                                  businessIndex == 0 ? 'Individual' : 'Company';
                              d('PROPERTY AD DATA : ' +
                                  createAdPostViewModel
                                      .propertyAdData!.categoryId
                                      .toString());
                              d('PROPERTY AD SUB CATEGORY ID : ' +
                                  createAdPostViewModel
                                      .propertyAdData!.subCategoryId
                                      .toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UploadImagesVideosScreen(
                                            categoryIndex: widget.categoryIndex,
                                          )));
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => AdTypeScreen(
                              //       categoryIndex: widget.categoryIndex,
                              //     ),
                              //   ),
                              // );
                            } else if (widget.categoryIndex == 2) {
                              AutomotiveObject automotiveData =
                                  createAdPostViewModel.automotiveAdData!;
                              automotiveData.subCategoryId =
                                  widget.allSubCategories![index].id;
                              automotiveData.subCategoryTitle =
                                  widget.allSubCategories![index].title;
                              createAdPostViewModel
                                  .changeAutomotiveAdData(automotiveData);
                              automotiveData.adType =
                                  businessIndex == 0 ? 'Individual' : 'Company';
                              d('AUTOMOTIVE AD DATA : ' +
                                  createAdPostViewModel
                                      .automotiveAdData!.categoryId
                                      .toString());
                              d('AUTOMOTIVE AD SUB CATEGORY ID : ' +
                                  createAdPostViewModel
                                      .automotiveAdData!.subCategoryId
                                      .toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UploadImagesVideosScreen(
                                            categoryIndex: widget.categoryIndex,
                                          )));
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => AdTypeScreen(
                              //       categoryIndex: widget.categoryIndex,
                              //     ),
                              //   ),
                              // );
                            }
                          }
                        : () {},
                    child: CategoryCard(
                      imagePath: widget.allSubCategories![index].image,
                      totalAds:
                          widget.allSubCategories![index].totalCount == null
                              ? "0"
                              : widget.allSubCategories![index].totalCount
                                  .toString(),
                      title: widget.allSubCategories![index].title.toString(),
                      bgColorCode: bgColor,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


