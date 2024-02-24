class CurrencyModel {
  String? id;
  String? name;
  String? code;
  String? country;

  CurrencyModel({id, name, code, country});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['country'] = country;
    return data;
  }
}
