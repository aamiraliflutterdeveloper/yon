class ClassifiedBrandsResModel {
  bool? success;
  List<ClassifiedBrandsModel>? response;

  ClassifiedBrandsResModel({this.success, this.response});

  ClassifiedBrandsResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response = <ClassifiedBrandsModel>[];
      json['response'].forEach((v) {
        response!.add(ClassifiedBrandsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['success'] = success;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClassifiedBrandsModel {
  String? id;
  String? image;
  String? title;
  String? backgroundColor;
  bool? isFeatured;
  String? subcategory;

  ClassifiedBrandsModel(
      {this.id,
        this.image,
        this.title,
        this.backgroundColor,
        this.isFeatured,
        this.subcategory});

  ClassifiedBrandsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'];
    backgroundColor = json['background_color'];
    isFeatured = json['is_featured'];
    subcategory = json['subcategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['title'] = title;
    data['background_color'] = backgroundColor;
    data['is_featured'] = isFeatured;
    data['subcategory'] = subcategory;
    return data;
  }
}
