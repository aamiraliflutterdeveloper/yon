import 'package:app/data/models/model_objects/categories_res_object.dart';

class AutoMotiveCategoriesResModel {
  bool? success;
  List<CategoriesResModel>? response;

  AutoMotiveCategoriesResModel({success, response});

  AutoMotiveCategoriesResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response = <CategoriesResModel>[];
      json['response'].forEach((v) {
        response!.add(CategoriesResModel.fromJson(v));
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


