import 'package:app/common/logger/log.dart';
import 'package:app/data/models/model_objects/categories_res_object.dart';
import 'package:app/presentation/add_post/ad_type_screen.dart';
import 'package:app/presentation/add_post/upload_images_videos.dart';
import 'package:app/presentation/add_post/view_model/create_ad_post_view_model.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/categories/sub_all_categories_screen.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/shimmers/categoryCardShimmer.dart';
import 'package:app/presentation/utils/widgets/category_card.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/widgets_screens/all_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCategoriesScreen extends StatefulWidget {
  final String categoryTitle;
  final bool? isAddPost;
  final int? categoryIndex;

  const AllCategoriesScreen(
      {Key? key,
      required this.categoryTitle,
      this.isAddPost = false,
      this.categoryIndex})
      : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  List<CategoriesResModel>? categoriesList = [];

  void getAllClassifiedCategories() async {
    final result =
        await context.read<ClassifiedViewModel>().getAllClassifiedCategories();
    result.fold((l) {}, (r) {
      print("basssssssssssssss");
      d('***********************************===');
      categoriesList = r.response;
      d(categoriesList.toString());
      print(categoriesList![0].subCategory![0].totalCount);
      print("total counts === ==== ==== == = == = == ");
      setState(() {});
    });
  }

  void getAllAutomotiveCategories() async {
    final result =
        await context.read<AutomotiveViewModel>().getAllAutomotiveCategories();
    result.fold((l) {}, (r) {
      categoriesList = r.response;
      d('***********************************');
      d(categoriesList.toString());
      setState(() {});
    });
  }

  void getAllPropertiesCategories() async {
    final result =
        await context.read<PropertiesViewModel>().getAllPropertiesCategories();
    result.fold((l) {}, (r) {
      categoriesList = r.response;
      d('***********************************');
      d(categoriesList.toString());
      setState(() {});
    });
  }

  void getAllJobCategories() async {
    final result = await context.read<JobViewModel>().getAllJobCategories();
    result.fold((l) {}, (r) {
      categoriesList = r.response;
      d('***********************************');
      d(categoriesList.toString());
      setState(() {});
    });
  }

  @override
  void initState() {
    print("yes bossssssssssss");
    if (widget.categoryIndex == 0) {
      getAllClassifiedCategories();
    } else if (widget.categoryIndex == 1) {
      getAllPropertiesCategories();
    } else if (widget.categoryIndex == 2) {
      getAllAutomotiveCategories();
    } else if (widget.categoryIndex == 3) {
      getAllJobCategories();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    final CreateAdPostViewModel createAdPostViewModel =
        context.watch<CreateAdPostViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: widget.categoryTitle, context: context, onTap: () {Navigator.of(context).pop();}),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: med.height * 0.035,
              ),
              Text(
                'Choose Category',
                style: CustomAppTheme().headingText,
              ),
              /*SizedBox(
                height: med.height * 0.015,
              ),*/
              /*Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                textAlign: TextAlign.start,
                style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
              ),*/
              SizedBox(
                height: med.height * 0.04,
              ),
              categoriesList!.isEmpty
                  ? GridView.builder(
                      itemCount: 9,
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
                        return const CategoryCardShimmer();
                      },
                    )
                  : const SizedBox.shrink(),
              GridView.builder(
                itemCount: categoriesList!.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: med.height * 0.15,
                  childAspectRatio: med.height * 0.001,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  String colorCode =
                      categoriesList![index].backgroundColor == null
                          ? 'FFF8D1'
                          : categoriesList![index].backgroundColor.toString();
                  int bgColor = int.parse('0XFF' + colorCode);
                  return GestureDetector(
                    onTap: widget.isAddPost == true
                        ? () { 
                          
                            if (widget.categoryIndex == 0) {
                              ClassifiedObject classifiedData =
                                  ClassifiedObject(
                                      categoryId: categoriesList![index].id);
                              createAdPostViewModel
                                  .changeClassifiedAdData(classifiedData);
                              d('CLASSIFIED AD CATEGORY ID : ' +
                                  createAdPostViewModel
                                      .classifiedAdData!.categoryId
                                      .toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllSubCategoriesScreen(
                                    categoryIndex: widget.categoryIndex!,
                                    subCategoryTitle:
                                        categoriesList![index].title.toString(),
                                    isAddPost: widget.isAddPost,
                                    subCategoriesIndex: index,
                                    allSubCategories:
                                        categoriesList![index].subCategory,
                                  ),
                                ),
                              );
                            } else if (widget.categoryIndex == 1) {
                              PropertiesObject propertiesData =
                                  PropertiesObject(
                                      categoryId: categoriesList![index].id);
                              createAdPostViewModel
                                  .changePropertyAdData(propertiesData);
                              d('PROPERTIES AD CATEGORY ID : ' +
                                  createAdPostViewModel
                                      .propertyAdData!.categoryId
                                      .toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllSubCategoriesScreen(
                                    categoryIndex: widget.categoryIndex!,
                                    subCategoryTitle:
                                        categoriesList![index].title.toString(),
                                    isAddPost: widget.isAddPost,
                                    subCategoriesIndex: index,
                                    allSubCategories:
                                        categoriesList![index].subCategory,
                                  ),
                                ),
                              );
                            } else if (widget.categoryIndex == 2) {
                              AutomotiveObject automotiveData =
                                  AutomotiveObject(
                                      categoryId: categoriesList![index].id);
                              createAdPostViewModel
                                  .changeAutomotiveAdData(automotiveData);
                              d('AUTOMOTIVE AD CATEGORY ID : ' +
                                  createAdPostViewModel
                                      .automotiveAdData!.categoryId
                                      .toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllSubCategoriesScreen(
                                    categoryIndex: widget.categoryIndex!,
                                    subCategoryTitle:
                                        categoriesList![index].title.toString(),
                                    isAddPost: widget.isAddPost,
                                    subCategoriesIndex: index,
                                    allSubCategories:
                                        categoriesList![index].subCategory,
                                  ),
                                ),
                              );
                            } else if (widget.categoryIndex == 3) {
                              JobObject jobData = JobObject(
                                  categoryId: categoriesList![index].id);
                              createAdPostViewModel.changeJobAdData(jobData);
                              jobData.adType =
                                  businessIndex == 0 ? 'Individual' : 'Company';
                              d('JOB AD CATEGORY ID : ' +
                                  createAdPostViewModel.jobAdData!.categoryId
                                      .toString());
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => AdTypeScreen(
                              //       categoryIndex: widget.categoryIndex!,
                              //     ),
                              //   ),
                              // );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UploadImagesVideosScreen(
                                              categoryIndex:
                                                  widget.categoryIndex!)));
                            }
                          }
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllProductScreen(
                                  title:
                                      categoriesList![index].title.toString(),
                                  moduleIndex: widget.categoryIndex!,
                                  categoryId: categoriesList![index].id!,
                                ),
                              ),
                            );
                          },
                    child: CategoryCard(
                      totalAds: categoriesList![index].totalCount.toString(),
                      bgColorCode: bgColor,
                      imagePath: categoriesList![index].image ??
                          'https://user-images.githubusercontent.com/10515204/56117400-9a911800-5f85-11e9-878b-3f998609a6c8.jpg',
                      title: categoriesList![index].title.toString(),
                      titleFontSize: 8,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
