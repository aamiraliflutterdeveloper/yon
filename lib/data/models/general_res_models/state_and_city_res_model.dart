class StateAndCityCodeResModel {
  bool? success;
  List<StateAndCityCodeModel>? response;

  StateAndCityCodeResModel({this.success, this.response});

  StateAndCityCodeResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response =  <StateAndCityCodeModel>[];
      json['response'].forEach((v) {
        response!.add(StateAndCityCodeModel.fromJson(v));
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

class StateAndCityCodeModel {
  String? id;
  String? name;

  StateAndCityCodeModel({this.id, this.name,});

  StateAndCityCodeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
