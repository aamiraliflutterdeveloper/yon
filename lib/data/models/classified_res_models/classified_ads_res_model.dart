import 'package:app/data/models/general_res_models/brands_res_models.dart';
import 'package:app/data/models/general_res_models/currency_model.dart';
import 'package:app/data/models/general_res_models/media_res_model.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';

class ClassifiedAdsResModel {
  int? count;
  List<ClassifiedProductModel>? results;

  ClassifiedAdsResModel({
    results,
    count,
  });

  ClassifiedAdsResModel.fromJson(Map<String, dynamic> json) {
    count = json['count'] ?? 0;
    if (json['results'] != null) {
      results = <ClassifiedProductModel>[];
      json['results'].forEach((v) {
        results!.add(ClassifiedProductModel.fromJson(v));
      });
    } else {
      results = <ClassifiedProductModel>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



class ClassifiedProductModel {
  String? id;
  Category? category;
  Category? subCategory;
  BrandsModel? brand;
  bool? isFavourite;
  UserProfileModel? profile;
  UserProfileModel? company;
  String? name;
  List<ImageMedia>? imageMedia;
  List<VideoMedia>? videoMedia;
  String? businessType;
  String? streetAdress;
  String? longitude;
  String? latitude;
  CurrencyModel? currency;
  String? price;
  String? description;
  String? type;
  String? phoneNumber;
  String? dialCode;
  String? verificationStatus;
  bool? isPromoted;
  String? createdAt;
  String? updatedAt;
  String? slug;
  String? establishedYear;
  String? employeesCount;
  bool? isDeal;
  String? dealPrice;
  bool? isActive;
  // int? total_applied;

  ClassifiedProductModel({
    id,
    category,
    subCategory,
    brand,
    isFavourite,
    profile,
    name,
    imageMedia,
    videoMedia,
    streetAddress,
    phoneNumber,
    longitude,
    latitude,
    currency,
    isActive,
    price,
    description,
    type,
    verificationStatus,
    isPromoted,
    createdAt,
    updatedAt,
    slug,
    establishedYear,
    dialCode,
    employeesCount,
    isDeal,
    dealPrice,
    company,
    businessType,
    // total_applied,
  });

  ClassifiedProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    subCategory = json['sub_category'] != null ? Category.fromJson(json['sub_category']) : null;
    brand = json['brand'] != null ? BrandsModel.fromJson(json['brand']) : null;
    isFavourite = json['is_favourite'] ?? false;
    profile = json['profile'] != null ? UserProfileModel.fromJson(json['profile']) : null;
    company = json['company'] != null ? UserProfileModel.fromJson(json['company']) : UserProfileModel();
    name = json['name'] ?? "";
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
    streetAdress = json['street_adress'] ?? "";
    businessType = json['business_type'] ?? "Individual";
    longitude = json['longitude'] ?? "";
    phoneNumber = json['mobile'] ?? "";
    latitude = json['latitude'] ?? "";
    currency = json['currency'] != null ? CurrencyModel.fromJson(json['currency']) : null;
    price = json['price'] ?? "";
    description = json['description'] ?? "";
    type = json['type'] ?? "";
    verificationStatus = json['verification_status'];
    isPromoted = json['is_promoted'] ?? false;
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    dialCode = json['dial_code'] ?? "";
    slug = json['slug'] ?? "";
    establishedYear = json['established_year'] ?? "";
    employeesCount = json['employees_count'] ?? "";
    isDeal = json['is_deal'] ?? false;
    dealPrice = json['deal_price'] ?? "";
    isActive = json['is_active'] ?? false;
    // total_applied = json['total_applied'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (subCategory != null) {
      data['sub_category'] = subCategory!.toJson();
    }
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    data['is_favourite'] = isFavourite;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (company != null) {
      data['company'] = company!.toJson();
    }
    data['name'] = name;
    if (imageMedia != null) {
      data['image_media'] = imageMedia!.map((v) => v.toJson()).toList();
    }
    if (videoMedia != null) {
      data['video_media'] = videoMedia!.map((v) => v.toJson()).toList();
    }
    data['street_adress'] = streetAdress;
    data['business_type'] = businessType;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    data['price'] = price;
    data['description'] = description;
    data['type'] = type;
    data['verification_status'] = verificationStatus;
    data['is_promoted'] = isPromoted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['dial_code'] = dialCode;
    data['mobile'] = phoneNumber;
    data['slug'] = slug;
    data['established_year'] = establishedYear;
    data['employees_count'] = employeesCount;
    data['is_deal'] = isDeal;
    data['deal_price'] = dealPrice;
    data['is_active'] = isActive;
    // data['total_applied'] = total_applied;
    return data;
  }
}

class Category {
  String? id;
  String? title;

  Category({id, title});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
