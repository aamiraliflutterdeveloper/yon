class CategoriesResModel {
  String? id;
  String? title;
  List<SubCategory>? subCategory;
  String? image;
  String? backgroundColor;
  bool? businessDirectory;
  int? totalCount;

  CategoriesResModel({id, title, classifiedSubCategory, image, backgroundColor, businessDirectory, totalCount});

  CategoriesResModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['sub_category'] != null) {
      subCategory = <SubCategory>[];
      json['sub_category'].forEach((v) {
        subCategory!.add(SubCategory.fromJson(v));
      });
    }
    image = json['image'];
    backgroundColor = json['background_color'];
    businessDirectory = json['business_directory'];
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (subCategory != null) {
      data['sub_category'] = subCategory!.map((v) => v.toJson()).toList();
    }
    data['image'] = image;
    data['background_color'] = backgroundColor;
    data['business_directory'] = businessDirectory;
    data['total_count'] = totalCount;
    return data;
  }
}

class SubCategory {
  String? id;
  String? title;
  String? backgroundColor;
  String? image;
  List<SubSubCategory>? subSubCategory;
  int? totalCount;

  SubCategory({id, title, classifiedSubSubCategory, backgroundColor, totalCount});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'] ?? '';
    if (json['ub_sub_category'] != null) {
      subSubCategory = <SubSubCategory>[];
      json['sub_sub_category'].forEach((v) {
        subSubCategory!.add(SubSubCategory.fromJson(v));
      });
    }
    backgroundColor = json['background_color'];
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (subSubCategory != null) {
      data['sub_sub_category'] = subSubCategory!.map((v) => v.toJson()).toList();
    }
    data['background_color'] = backgroundColor;
    data['image'] = image;
    data['total_count'] = totalCount;
    return data;
  }
}

class SubSubCategory {
  String? id;
  String? title;

  SubSubCategory({id, title});

  SubSubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
