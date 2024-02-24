import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';

class AllAdsResModel {
  Results? results;

  AllAdsResModel({
    results,
  });

  AllAdsResModel.fromJson(Map<String, dynamic> json) {
    results = json['results'] != null ? Results.fromJson(json['results']) : Results();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.toJson();
    }
    return data;
  }
}

class Results {
  List<AutomotiveProductModel>? automotiveAds;
  List<PropertyProductModel>? propertyAds;
  List<ClassifiedProductModel>? classifiedAds;
  List<JobProductModel>? jobAds;

  Results({automotiveAds, propertyAds, classifiedAds, jobAds});

  Results.fromJson(Map<String, dynamic> json) {
    if (json['automotive'] != null) {
      automotiveAds = <AutomotiveProductModel>[];
      json['automotive'].forEach((v) {
        automotiveAds!.add(AutomotiveProductModel.fromJson(v));
      });
    } else {
      json['automotive'] = [];
    }
    if (json['property'] != null) {
      propertyAds = <PropertyProductModel>[];
      json['property'].forEach((v) {
        propertyAds!.add(PropertyProductModel.fromJson(v));
      });
    } else {
      json['property'] = [];
    }
    if (json['classified'] != null) {
      classifiedAds = <ClassifiedProductModel>[];
      json['classified'].forEach((v) {
        classifiedAds!.add(ClassifiedProductModel.fromJson(v));
      });
    } else {
      json['classified'] = [];
    }
    if (json['job'] != null) {
      jobAds = <JobProductModel>[];
      json['job'].forEach((v) {
        jobAds!.add(JobProductModel.fromJson(v));
      });
    } else {
      json['job'] = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (automotiveAds != null) {
      data['automotive'] = automotiveAds!.map((v) => v.toJson()).toList();
    }
    if (propertyAds != null) {
      data['property'] = propertyAds!.map((v) => v.toJson()).toList();
    }
    if (classifiedAds != null) {
      data['classified'] = classifiedAds!.map((v) => v.toJson()).toList();
    }
    if (jobAds != null) {
      data['job'] = jobAds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
