// ignore_for_file: prefer_null_aware_operators

class BrandModel {
  String? id;
  String? title;
  String? image;
  String? backgroundColor;
  bool? isFeatured;
  String? category;
  String? totalCounts;

  BrandModel(
      {id, title, image, backgroundColor, isFeatured, category, totalCounts});

  BrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    backgroundColor = json['background_color'];
    isFeatured = json['is_featured'];
    category = json['sub_category'];
    totalCounts =
        json['total_count'] == null ? null : json['total_count'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['background_color'] = backgroundColor;
    data['is_featured'] = isFeatured;
    data['sub_category'] = category;
    data['total_count'] = totalCounts;
    return data;
  }
}
