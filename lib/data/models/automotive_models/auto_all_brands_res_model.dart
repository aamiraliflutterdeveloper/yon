import 'package:app/data/models/model_objects/brands_model.dart';

class AutoAllBrandsResModel {
  bool? success;
  List<BrandModel>? response;

  AutoAllBrandsResModel({success, response});

  AutoAllBrandsResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response = <BrandModel>[];
      json['response'].forEach((v) {
        response!.add(BrandModel.fromJson(v));
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

