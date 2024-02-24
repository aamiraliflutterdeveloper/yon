import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';

class SuggestedAdsResModel {
  bool? success;
  List<AutomotiveProductModel>? suggestedAutomotiveAds;
  List<PropertyProductModel>? suggestedPropertyAds;
  List<ClassifiedProductModel>? suggestedClassifiedAds;
  List<JobProductModel>? suggestedJobAds;

  SuggestedAdsResModel({
    this.success,
    this.suggestedAutomotiveAds,
    this.suggestedClassifiedAds,
    this.suggestedJobAds,
    this.suggestedPropertyAds,
  });

  SuggestedAdsResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['classified'] != null) {
      suggestedClassifiedAds = <ClassifiedProductModel>[];
      json['classified'].forEach((v) {
        suggestedClassifiedAds!.add(ClassifiedProductModel.fromJson(v));
      });
    } else {
      suggestedClassifiedAds = <ClassifiedProductModel>[];
    }
    if (json['automotive'] != null) {
      suggestedAutomotiveAds = <AutomotiveProductModel>[];
      json['automotive'].forEach((v) {
        suggestedAutomotiveAds!.add(AutomotiveProductModel.fromJson(v));
      });
    } else {
      suggestedAutomotiveAds = <AutomotiveProductModel>[];
    }
    if (json['property'] != null) {
      suggestedPropertyAds = <PropertyProductModel>[];
      json['property'].forEach((v) {
        suggestedPropertyAds!.add(PropertyProductModel.fromJson(v));
      });
    } else {
      suggestedPropertyAds = <PropertyProductModel>[];
    }
    if (json['job'] != null) {
      suggestedJobAds = <JobProductModel>[];
      json['job'].forEach((v) {
        suggestedJobAds!.add(JobProductModel.fromJson(v));
      });
    } else {
      suggestedJobAds = <JobProductModel>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (suggestedClassifiedAds != null) {
      data['classified'] = suggestedClassifiedAds!.map((v) => v.toJson()).toList();
    }
    if (suggestedClassifiedAds != null) {
      data['automotive'] = suggestedAutomotiveAds!.map((v) => v.toJson()).toList();
    }
    if (suggestedClassifiedAds != null) {
      data['property'] = suggestedPropertyAds!.map((v) => v.toJson()).toList();
    }
    if (suggestedClassifiedAds != null) {
      data['job'] = suggestedJobAds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
