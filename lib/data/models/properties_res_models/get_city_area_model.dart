class GetCityAreaModel {
  bool? success;
  List<Results>? results;

  GetCityAreaModel({this.success, this.results});

  GetCityAreaModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? id;
  String? name;
  var coverImage;
  String? city;

  Results({this.id, this.name, this.coverImage, this.city});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coverImage = json['cover_image'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover_image'] = coverImage;
    data['city'] = city;
    return data;
  }
}
