class FacebookUserResModel {
  String? name;
  String? firstName;
  String? lastName;
  Picture? picture;
  String? email;
  String? id;

  FacebookUserResModel({this.name, this.firstName, this.lastName, this.picture, this.email, this.id});

  FacebookUserResModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    picture = json['picture'] != null ? Picture.fromJson(json['picture']) : null;
    email = json['email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    if (picture != null) {
      data['picture'] = picture!.toJson();
    }
    data['email'] = email;
    data['id'] = id;
    return data;
  }
}

class Picture {
  Data? data;

  Picture({this.data});

  Picture.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? height;
  bool? isSilhouette;
  String? url;
  int? width;

  Data({this.height, this.isSilhouette, this.url, this.width});

  Data.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    isSilhouette = json['is_silhouette'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = height;
    data['is_silhouette'] = isSilhouette;
    data['url'] = url;
    data['width'] = width;
    return data;
  }
}
