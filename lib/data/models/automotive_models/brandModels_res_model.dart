class AutoBrandModelsResModel {
  bool? success;
  List<BrandModelsModel>? response;

  AutoBrandModelsResModel({success, response});

  AutoBrandModelsResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response = <BrandModelsModel>[];
      json['response'].forEach((v) {
        response!.add(BrandModelsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class BrandModelsModel {
  String? id;
  String? title;
  String? image;
  String? backgroundColor;
  String? year;
  String? brand;

  BrandModelsModel(
      {id,
        title,
        image,
        backgroundColor,
        isFeatured,
        category});

  BrandModelsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    backgroundColor = json['background_color'];
    year = json['year'];
    brand = json['brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['background_color'] = backgroundColor;
    data['year'] = year;
    data['brand'] = brand;
    return data;
  }
}
