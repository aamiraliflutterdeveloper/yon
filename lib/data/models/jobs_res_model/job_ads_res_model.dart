import 'package:app/data/models/general_res_models/currency_model.dart';
import 'package:app/data/models/general_res_models/media_res_model.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/data/models/model_objects/categories_res_object.dart';

class JobAdsResModel {
  int? count;
  List<JobProductModel>? jobAdsList;

  JobAdsResModel({
    results,
  });

  JobAdsResModel.fromJson(Map<String, dynamic> json) {
    count = json['count'] ?? 0;
    if (json['results'] != null) {
      jobAdsList = <JobProductModel>[];
      json['results'].forEach((v) {
        jobAdsList!.add(JobProductModel.fromJson(v));
      });
    } else {
      jobAdsList = <JobProductModel>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (jobAdsList != null) {
      data['results'] = jobAdsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobProductModel {
  String? id;
  UserProfileModel? profile;
  UserProfileModel? company;
  CategoriesResModel? category;
  String? slug;
  String? title;
  String? description;
  String? jobType;
  String? dialCode;
  String? companyName;
  String? companyLicense;
  String? businessType;
  String? createdAt;
  String? companyLogo;
  String? salaryStart;
  String? mobile;
  String? salaryEnd;
  String? salaryPeriod;
  String? positionType;
  CurrencyModel? salaryCurrency;
  String? location;
  String? longitude;
  String? latitude;
  List<ImageMedia>? imageMedia;
  List<VideoMedia>? videoMedia;
  bool? isFavourite;
  bool? isPromoted;
  bool? isActive;
  bool? isApplied;
  int? totalApplied;
  bool? isViewed;

  JobProductModel({
    id,
    profile,
    category,
    slug,
    title,
    dialCode,
    description,
    jobType,
    companyName,
    companyLicense,
    businessType,
    companyLogo,
    salaryStart,
    salaryEnd,
    salaryPeriod,
    positionType,
    salaryCurrency,
    location,
    longitude,
    latitude,
    imageMedia,
    videoMedia,
    mobile,
    isFavourite,
    isPromoted,
    isActive,
    createdAd,
    isApplied,
    company,
    totalApplied,
    isViewed,
  });

  JobProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    profile = json['profile'] != null ? UserProfileModel.fromJson(json['profile']) : null;
    company = json['company'] != null ? UserProfileModel.fromJson(json['company']) : UserProfileModel();
    category = json['category'] != null ? CategoriesResModel.fromJson(json['category']) : null;
    slug = json['slug'] ?? "";
    title = json['title'] ?? "";
    description = json['description'] ?? "";
    jobType = json['job_type'] ?? "";
    companyName = json['company_name'] ?? "";
    companyLicense = json['company_license'] ?? "";
    businessType = json['business_type'] ?? "Individual";
    companyLogo = json['company_logo'] ?? "";
    salaryStart = json['salary_start'] ?? "";
    createdAt = json['created_at'] ?? "";
    dialCode = json['dial_code'] ?? "";
    salaryEnd = json['salary_end'] ?? "";
    salaryPeriod = json['salary_period'] ?? "";
    positionType = json['position_type'] ?? "";
    salaryCurrency = json['salary_currency'] != null ? CurrencyModel.fromJson(json['salary_currency']) : null;
    location = json['location'] ?? "";
    longitude = json['longitude'] ?? "";
    latitude = json['latitude'] ?? "";
    mobile = json['mobile'] ?? "";
    if (json['image_media'] != null) {
      imageMedia = <ImageMedia>[];
      json['image_media'].forEach((v) {
        imageMedia!.add(ImageMedia.fromJson(v));
      });
    }
    if (json['video_media'] != null) {
      videoMedia = <VideoMedia>[];
      json['video_media'].forEach((v) {
        videoMedia!.add(VideoMedia.fromJson(v));
      });
    }
    isFavourite = json['is_favourite'] ?? false;
    isPromoted = json['is_promoted'] ?? false;
    isActive = json['is_active'] ?? false;
    isApplied = json['is_applied'] ?? false;
    totalApplied = json['total_applied'] ?? 0;
    isViewed = json['is_viewed'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['created_at'] = slug;
    data['slug'] = slug;
    data['title'] = title;
    data['description'] = description;
    data['job_type'] = jobType;
    data['company_name'] = companyName;
    data['dial_code'] = dialCode;
    data['company_license'] = companyLicense;
    data['business_type'] = businessType;
    data['company_logo'] = companyLogo;
    data['salary_start'] = salaryStart;
    data['salary_end'] = salaryEnd;
    data['mobile'] = mobile;
    data['salary_period'] = salaryPeriod;
    data['position_type'] = positionType;
    if (salaryCurrency != null) {
      data['salary_currency'] = salaryCurrency!.toJson();
    }
    data['location'] = location;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    if (imageMedia != null) {
      data['image_media'] = imageMedia!.map((v) => v.toJson()).toList();
    }
    if (videoMedia != null) {
      data['video_media'] = videoMedia!.map((v) => v.toJson()).toList();
    }
    data['is_favourite'] = isFavourite;
    data['is_promoted'] = isPromoted;
    data['is_active'] = isActive;
    data['is_applied'] = isActive;
    data['total_applied'] = totalApplied;
    data['is_viewed'] = isViewed;
    return data;
  }
}
