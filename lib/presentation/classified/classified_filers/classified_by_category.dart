import 'package:app/common/logger/log.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/drop_downs_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassifiedByCategory extends StatefulWidget {
  const ClassifiedByCategory({Key? key}) : super(key: key);

  @override
  State<ClassifiedByCategory> createState() => _ClassifiedByCategoryState();
}

int categoryIndex = -1;

class _ClassifiedByCategoryState extends State<ClassifiedByCategory> {
  String? categoryValue;
  String? subCategoryValue;
  String? brandValue;
  int conditionIndex = -1;

  int subCategoryIndex = -1;
  List<String>? categoriesList = [];
  List<String>? subCategoriesList = [];
  List<String>? brandsList = [];

  void getAllClassifiedCategories() async {
    final ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    final result =
        await context.read<ClassifiedViewModel>().getAllClassifiedCategories();
    result.fold((l) {}, (r) {
      d('***********************************');
      for (int i = 0; i < r.response!.length; i++) {
        categoriesList!.add(r.response![i].title.toString());
      }
      if (classifiedViewModel.classifiedFilterMap!.containsKey('Category')) {
        categoryValue = classifiedViewModel.classifiedFilterMap!['Category'];
      }
      setState(() {});
    });
  }

  void getBrandsBySubCategory({required String subCategoryId}) async {
    final result = await context
        .read<ClassifiedViewModel>()
        .getBrandsBySubCategory(subCategoryId: subCategoryId);
    result.fold((l) {}, (r) {
      d('***********************************');
      context
          .read<ClassifiedViewModel>()
          .changeBrandsBySubCategory(r.response!);
      for (int i = 0; i < r.response!.length; i++) {
        brandsList!.add(r.response![i].title.toString());
      }
      d(brandsList.toString());
      setState(() {});
    });
  }

  @override
  void initState() {
    final ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    super.initState();
    if (context.read<ClassifiedViewModel>().classifiedAllCategories!.isEmpty) {
      getAllClassifiedCategories();
    } else {
      for (int i = 0;
          i <
              context
                  .read<ClassifiedViewModel>()
                  .classifiedAllCategories!
                  .length;
          i++) {
        categoriesList!.add(context
            .read<ClassifiedViewModel>()
            .classifiedAllCategories![i]
            .title
            .toString());
      }
      if (classifiedViewModel.classifiedFilterMap!.containsKey('Category')) {
        int catIndex = 0;
        int subCatIndex = 0;
        String subCatId = '';
        categoryValue = classifiedViewModel.classifiedFilterMap!['Category'];
        for (int i = 0;
            i < classifiedViewModel.classifiedAllCategories!.length;
            i++) {
          d('categoryValue $categoryValue == ${classifiedViewModel.classifiedAllCategories![i].title}');
          if (categoryValue ==
              classifiedViewModel.classifiedAllCategories![i].title) {
            catIndex = i;
            for (int j = 0;
                j <
                    classifiedViewModel
                        .classifiedAllCategories![i].subCategory!.length;
                j++) {
              subCategoriesList!.add(classifiedViewModel
                  .classifiedAllCategories![i].subCategory![j].title!);
            }
          }
        }
        if (classifiedViewModel.classifiedFilterMap!
            .containsKey('SubCategory')) {
          subCategoryValue =
              classifiedViewModel.classifiedFilterMap!['SubCategory'];
          for (int j = 0;
              j <
                  classifiedViewModel
                      .classifiedAllCategories![catIndex].subCategory!.length;
              j++) {
            if (subCategoryValue ==
                classifiedViewModel
                    .classifiedAllCategories![catIndex].subCategory![j].title) {
              subCatId = classifiedViewModel
                  .classifiedAllCategories![catIndex].subCategory![j].id!;
              getBrandsBySubCategory(subCategoryId: subCatId);
            }
          }
        }
        if (classifiedViewModel.classifiedFilterMap!.containsKey('Brand')) {
          brandValue = classifiedViewModel.classifiedFilterMap!['Brand'];
        }
      }
      if (classifiedViewModel.classifiedFilterMap!.containsKey('Condition')) {
        for (int i = 0; i < conditionList.length; i++) {
          if (classifiedViewModel.classifiedFilterMap!['Condition'] ==
              conditionList[i]) {
            conditionIndex = i;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ClassifiedViewModel classifiedViewModel =
        context.watch<ClassifiedViewModel>();
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: med.height * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Category',
                    style: CustomAppTheme().textFieldHeading,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: SizedBox(
                      height: med.height * 0.047,
                      width: med.width,
                      child: categoryDropDown(
                        categoryDropDownValue: categoryValue,
                        onChange: (value) {
                          classifiedViewModel.classifiedFilterMap = {};
                          if (classifiedViewModel.classifiedFilterMap!
                              .containsValue(categoryValue)) {
                            classifiedViewModel.classifiedFilterMap!
                                .removeWhere((key, value) => key == 'Category');
                            classifiedViewModel.classifiedFilterMap!
                                .addEntries({MapEntry('Category', value!)});
                            classifiedViewModel.changeClassifiedFilterMap(
                                classifiedViewModel.classifiedFilterMap!);
                            classifiedViewModel.classifiedFilterData =
                                ClassifiedFilterModel();
                            for (int i = 0;
                                i <
                                    classifiedViewModel
                                        .classifiedAllCategories!.length;
                                i++) {
                              print(
                                  "Filter Data ID:::${classifiedViewModel.classifiedAllCategories![i].title}");
                              print(
                                  "Filter Data ID:::${classifiedViewModel.classifiedAllCategories![i].id}");
                              d('VALUE Is: $value = ${classifiedViewModel.classifiedAllCategories![i].title}');
                              if (classifiedViewModel
                                      .classifiedAllCategories![i].title ==
                                  value) {
                                d('VALUE : $value = ${classifiedViewModel.classifiedAllCategories![i].title}');
                                classifiedViewModel
                                        .classifiedFilterData!.category =
                                    classifiedViewModel
                                        .classifiedAllCategories![i].id;
                              }
                            }
                          } else {
                            classifiedViewModel.classifiedFilterMap!
                                .addEntries({MapEntry('Category', value!)});
                            classifiedViewModel.changeClassifiedFilterMap(
                                classifiedViewModel.classifiedFilterMap!);
                            classifiedViewModel.classifiedFilterData =
                                ClassifiedFilterModel();
                            for (int i = 0;
                                i <
                                    classifiedViewModel
                                        .classifiedAllCategories!.length;
                                i++) {
                              print(
                                  "Filter Data ID:::${classifiedViewModel.classifiedAllCategories![i].title}");
                              print(
                                  "Filter Data ID:::${classifiedViewModel.classifiedAllCategories![i].id}");
                              d('VALUE Is: $value = ${classifiedViewModel.classifiedAllCategories![i].title}');
                              if (classifiedViewModel
                                      .classifiedAllCategories![i].title ==
                                  value) {
                                d('VALUE : $value = ${classifiedViewModel.classifiedAllCategories![i].title}');
                                classifiedViewModel
                                        .classifiedFilterData!.category =
                                    classifiedViewModel
                                        .classifiedAllCategories![i].id;
                              }
                            }
                          }
                          setState(
                            () {
                              subCategoryValue = null;
                              subCategoriesList = [];
                              categoryValue = value;
                              // categoryIndex = 0;
                              for (int i = 0;
                                  i <
                                      classifiedViewModel
                                          .classifiedAllCategories!.length;
                                  i++) {
                                if (classifiedViewModel
                                        .classifiedAllCategories![i].title ==
                                    value) {
                                  setState(() {
                                    categoryIndex = i;
                                  });
                                }
                              }
                              for (int i = 0;
                                  i <
                                      classifiedViewModel
                                          .classifiedAllCategories![
                                              categoryIndex]
                                          .subCategory!
                                          .length;
                                  i++) {
                                subCategoriesList!.add(classifiedViewModel
                                    .classifiedAllCategories![categoryIndex]
                                    .subCategory![i]
                                    .title
                                    .toString());
                              }
                            },
                          );
                        },
                        itemsList: categoriesList!,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Sub Category',
                    style: CustomAppTheme().textFieldHeading,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: SizedBox(
                      height: med.height * 0.047,
                      width: med.width,
                      child: subCategoryDropDown(
                          subCateDropDownValue: subCategoryValue,
                          categoryValue: categoryValue,
                          onChange: (value) {
                            print("object:::$value");
                            print("Id::::$categoryIndex");
                            classifiedViewModel.classifiedFilterMap!
                                .addEntries({MapEntry('SubCategory', value!)});

                            if (classifiedViewModel.classifiedFilterMap!
                                .containsKey('Brand')) {
                              classifiedViewModel.classifiedFilterMap!
                                  .removeWhere((key, value) => key == 'Brand');
                            }
                            if (classifiedViewModel.classifiedFilterMap!
                                .containsKey('Condition')) {
                              classifiedViewModel.classifiedFilterMap!
                                  .removeWhere(
                                      (key, value) => key == 'Condition');
                            }
                            classifiedViewModel.changeClassifiedFilterMap(
                                classifiedViewModel.classifiedFilterMap!);
                            setState(
                              () {
                                brandValue = null;
                                brandsList = [];
                                subCategoryValue = value;
                                String subCategoriesId = '';
                                for (int i = 0;
                                    i <
                                        classifiedViewModel
                                            .classifiedAllCategories![
                                                categoryIndex]
                                            .subCategory!
                                            .length;
                                    i++) {
                                  print(
                                      "object::::${classifiedViewModel.classifiedAllCategories![categoryIndex].subCategory![i].title}");
                                  if (classifiedViewModel
                                          .classifiedAllCategories![
                                              categoryIndex]
                                          .subCategory![i]
                                          .title ==
                                      value) {
                                    print("object:::$value");
                                    print(
                                        "Filter Data ID:::${classifiedViewModel.classifiedAllCategories![categoryIndex].subCategory![i].title}");
                                    print(
                                        "Filter Data ID:::${classifiedViewModel.classifiedAllCategories![categoryIndex].subCategory![i].id}");
                                    subCategoryIndex = i;
                                    subCategoriesId = classifiedViewModel
                                        .classifiedAllCategories![categoryIndex]
                                        .subCategory![i]
                                        .id!;
                                    d('VALUE : $value = ${classifiedViewModel.classifiedAllCategories![categoryIndex].subCategory![i].title} INDEX : $subCategoryIndex ID : $subCategoriesId');
                                    classifiedViewModel.classifiedFilterData!
                                        .subCategory = subCategoriesId;
                                    classifiedViewModel
                                        .changeClassifiedFilterMap(
                                            classifiedViewModel
                                                .classifiedFilterMap!);
                                    getBrandsBySubCategory(
                                        subCategoryId: subCategoriesId);
                                  }
                                }
                              },
                            );
                            setState(() {});
                          },
                          itemsList: subCategoriesList!),
                    ),
                  ),
                ],
              ),
              subCategoryValue != null
                  ? SizedBox(
                      height: med.height * 0.02,
                    )
                  : const SizedBox.shrink(),
              subCategoryValue != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Brand',
                          style: CustomAppTheme().textFieldHeading,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: SizedBox(
                            height: med.height * 0.047,
                            width: med.width,
                            child: brandDropDown(
                              itemsList: brandsList!,
                              brandDropDownValue: brandValue,
                              onChange: (value) {
                                classifiedViewModel.classifiedFilterMap!
                                    .addEntries({MapEntry('Brand', value!)});
                                if (classifiedViewModel.classifiedFilterMap!
                                    .containsKey('Condition')) {
                                  classifiedViewModel.classifiedFilterMap!
                                      .removeWhere(
                                          (key, value) => key == 'Condition');
                                }
                                classifiedViewModel.changeClassifiedFilterMap(
                                    classifiedViewModel.classifiedFilterMap!);
                                setState(
                                  () {
                                    brandValue = value;
                                    conditionIndex = -1;
                                    for (int i = 0;
                                        i <
                                            classifiedViewModel
                                                .brandsBySubCategory!.length;
                                        i++) {
                                      if (classifiedViewModel
                                              .brandsBySubCategory![i].title ==
                                          value) {
                                        print(
                                            "Filter Data ID:::${classifiedViewModel.brandsBySubCategory![i].title}");
                                        print(
                                            "Filter Data ID:::${classifiedViewModel.brandsBySubCategory![i].id}");
                                        classifiedViewModel
                                                .classifiedFilterData!.brand =
                                            classifiedViewModel
                                                .brandsBySubCategory![i].id;
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              SizedBox(
                height: med.height * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Condition',
                    style: CustomAppTheme().textFieldHeading,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              conditionIndex = 0;
                              classifiedViewModel.classifiedFilterMap!
                                  .addEntries(
                                      {const MapEntry('Condition', 'New')});
                              classifiedViewModel.changeClassifiedFilterMap(
                                  classifiedViewModel.classifiedFilterMap!);
                              classifiedViewModel
                                  .classifiedFilterData!.condition = 'New';
                              print(
                                  "Filter Data ID:::${classifiedViewModel.classifiedFilterData!.condition}");
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: conditionIndex == 0
                                      ? CustomAppTheme().lightGreenColor
                                      : CustomAppTheme().lightGreyColor,
                                  border: Border.all(
                                      color: conditionIndex == 0
                                          ? CustomAppTheme().primaryColor
                                          : CustomAppTheme().greyColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 15),
                                  child: Text(
                                    'New',
                                    style: CustomAppTheme().normalText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: CustomAppTheme().blackColor,
                                        fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              conditionIndex = 1;
                              classifiedViewModel.classifiedFilterMap!
                                  .addEntries(
                                      {const MapEntry('Condition', 'Used')});
                              classifiedViewModel.changeClassifiedFilterMap(
                                  classifiedViewModel.classifiedFilterMap!);
                              classifiedViewModel
                                  .classifiedFilterData!.condition = 'Used';
                              print(
                                  "Filter Data ID:::${classifiedViewModel.classifiedFilterData!.condition}");
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: conditionIndex == 1
                                        ? CustomAppTheme().lightGreenColor
                                        : CustomAppTheme().lightGreyColor,
                                    border: Border.all(
                                        color: conditionIndex == 1
                                            ? CustomAppTheme().primaryColor
                                            : CustomAppTheme().greyColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 15),
                                    child: Text(
                                      'Used',
                                      style: CustomAppTheme()
                                          .normalText
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  CustomAppTheme().blackColor,
                                              fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<String> conditionList = ['New', 'Used'];
}
