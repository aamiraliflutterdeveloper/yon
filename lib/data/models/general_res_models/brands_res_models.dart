class BrandsResModel {
  bool? success;
  List<BrandsModel>? brandsList;

  BrandsResModel({this.success, this.brandsList});

  BrandsResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      brandsList = <BrandsModel>[];
      json['response'].forEach((v) {
        brandsList!.add(BrandsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (brandsList != null) {
      data['response'] = brandsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BrandsModel {
  String? title;
  String? backgroundColor;
  bool? isFeatured;
  String? subcategory;
  String? id;
  String? image;

  BrandsModel({title, backgroundColor, isFeatured, subcategory, id, image});

  BrandsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    backgroundColor = json['background_color'];
    isFeatured = json['is_featured'];
    subcategory = json['subcategory'];
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['title'] = title;
    data['background_color'] = backgroundColor;
    data['is_featured'] = isFeatured;
    data['subcategory'] = subcategory;
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}
