class CountryCodeResModel {
  bool? success;
  List<CountriesModel>? response;

  CountryCodeResModel({this.success, this.response});

  CountryCodeResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response = <CountriesModel>[];
      json['response'].forEach((v) {
        response!.add(CountriesModel.fromJson(v));
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

class CountriesModel {
  String? id;
  int? counter;
  String? name;
  String? countryCode;
  String? dialCode;

  CountriesModel({this.id, this.counter, this.name, this.countryCode, this.dialCode});

  CountriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    counter = json['counter'];
    name = json['name'];
    countryCode = json['country_code'];
    dialCode = json['dial_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['counter'] = counter;
    data['name'] = name;
    data['country_code'] = countryCode;
    data['dial_code'] = dialCode;
    return data;
  }
}
