class AllCurrenciesResModel {
  bool? success;
  List<AllCurrenciesModel>? response;

  AllCurrenciesResModel({this.success, this.response});

  AllCurrenciesResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response = <AllCurrenciesModel>[];
      json['response'].forEach((v) {
        response!.add(AllCurrenciesModel.fromJson(v));
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

class AllCurrenciesModel {
  String? id;
  String? name;
  String? code;
  String? country;

  AllCurrenciesModel({this.id, this.name, this.code, this.country});

  AllCurrenciesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['country'] = country;
    return data;
  }
}
