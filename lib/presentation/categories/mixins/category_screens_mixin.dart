import 'package:flutter/material.dart';

mixin CategoriesScreenMixin<T extends StatefulWidget> on State<T> {
  List<CategoryModel> categoryList = [
    CategoryModel(svgIconUrl: 'assets/svgs/classifiedIcon.svg', categoryTitle: 'Classified', totalProducts: '1200'),
    CategoryModel(svgIconUrl: 'assets/svgs/propertyIcon.svg', categoryTitle: 'Property', totalProducts: '1200'),
    CategoryModel(svgIconUrl: 'assets/svgs/automotiveIcon.svg', categoryTitle: 'Automotive', totalProducts: '1200'),
    CategoryModel(svgIconUrl: 'assets/svgs/jobs.svg', categoryTitle: 'Job', totalProducts: '1200'),
  ];
}

class CategoryModel{
  late String svgIconUrl;
  late String categoryTitle;
  late String totalProducts;

  CategoryModel({
    required this.svgIconUrl,
    required this.categoryTitle,
    required this.totalProducts,
  });
}