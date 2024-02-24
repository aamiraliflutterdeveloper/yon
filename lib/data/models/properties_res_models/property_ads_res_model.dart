import 'package:app/data/models/general_res_models/currency_model.dart';
import 'package:app/data/models/general_res_models/media_res_model.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/data/models/model_objects/categories_res_object.dart';

class PropertyAdsResModel {
  int? count;
  List<PropertyProductModel>? propertyProductList;
  PropertyAdsResModel({
    count,
    results,
  });

  PropertyAdsResModel.fromJson(Map<String, dynamic> json) {
    count = json['count'] ?? 0;
    if (json['results'] != null) {
      propertyProductList = <PropertyProductModel>[];
      json['results'].forEach((v) {
        propertyProductList!.add(PropertyProductModel.fromJson(v));
      });
    } else {
      propertyProductList = <PropertyProductModel>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (propertyProductList != null) {
      data['results'] = propertyProductList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertyProductModel {
  String? id;
  UserProfileModel? profile;
  UserProfileModel? company;
  bool? isFavourite;
  CategoriesResModel? category;
  SubCategory? subCategory;
  List<ImageMedia>? imageMedia;
  List<VideoMedia>? videoMedia;
  String? companyName;
  String? companyLicense;
  String? businessType;
  String? cityId;
  CityAreaModel? located;
  String? companyLogo;
  String? streetAddress;
  String? longitude;
  String? latitude;
  String? name;
  String? area;
  String? areaUnit;
  String? bedrooms;
  String? baths;
  String? description;
  CurrencyModel? currency;
  String? price;
  String? mobile;
  String? livingRoom;
  String? furnished;
  String? propertyType;
  String? duration;
  String? verificationStatus;
  bool? isPromoted;
  bool? isActive;
  bool? isDeal;
  bool? isVerified;
  String? createdAt;
  String? updatedAt;
  String? slug;

  PropertyProductModel({
    id,
    profile,
    isFavourite,
    category,
    subCategory,
    imageMedia,
    videoMedia,
    companyName,
    companyLicense,
    businessType,
    companyLogo,
    streetAdress,
    longitude,
    latitude,
    name,
    area,
    areaUnit,
    bedrooms,
    baths,
    description,
    currency,
    price,
    mobile,
    livingRoom,
    furnished,
    propertyType,
    duration,
    verificationStatus,
    isPromoted,
    createdAt,
    updatedAt,
    cityId,
    located,
    slug,
    isDeal,
    isVerified,
    isActive,
    company,
  });

  PropertyProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    profile = json['profile'] != null
        ? UserProfileModel.fromJson(json['profile'])
        : null;
    company = json['company'] != null
        ? UserProfileModel.fromJson(json['company'])
        : UserProfileModel();
    isFavourite = json['is_favourite'] ?? false;
    category = json['category'] != null
        ? CategoriesResModel.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? SubCategory.fromJson(json['sub_category'])
        : null;
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
    companyName = json['company_name'] ?? "";
    companyLicense = json['company_license'] ?? "";
    businessType = json['business_type'] ?? "Individual";
    companyLogo = json['company_logo'] ?? "";
    streetAddress = json['street_adress'] ?? "";
    longitude = json['longitude'] ?? "";
    latitude = json['latitude'] ?? "";
    name = json['name'] ?? "";
    area = json['area'] ?? "";
    areaUnit = json['area_unit'] ?? "";
    bedrooms = json['bedrooms'] ?? "";
    baths = json['baths'] ?? "";
    description = json['description'] ?? "";
    currency = json['currency'] != null
        ? CurrencyModel.fromJson(json['currency'])
        : null;
    located = json["city_area"] != null
        ? CityAreaModel.fromJson(json["city_area"])
        : null;
    cityId = json["city"];
    price = json['price'] ?? "";
    mobile = json['mobile'] ?? "";
    livingRoom = json['living_room'] ?? "";
    furnished = json['furnished'] ?? "";
    propertyType = json['property_type'] ?? "";
    duration = json['duration'] ?? "";
    verificationStatus = json['verification_status'] ?? "";
    isPromoted = json['is_promoted'] ?? false;
    isActive = json['is_active'] ?? false;
    isVerified = json['is_verified'] ?? false;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    isDeal = json['is_deal'] ?? false;
    slug = json['slug'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (company != null) {
      data['company'] = company!.toJson();
    }
    data['is_favourite'] = isFavourite;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (subCategory != null) {
      data['sub_category'] = subCategory!.toJson();
    }
    if (imageMedia != null) {
      data['image_media'] = imageMedia!.map((v) => v.toJson()).toList();
    }
    if (videoMedia != null) {
      data['video_media'] = videoMedia!.map((v) => v.toJson()).toList();
    }
    data['company_name'] = companyName;
    data['company_license'] = companyLicense;
    data['business_type'] = businessType;
    data['company_logo'] = companyLogo;
    data['street_adress'] = streetAddress;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['name'] = name;
    data['area'] = area;
    data['area_unit'] = areaUnit;
    data['bedrooms'] = bedrooms;
    data['baths'] = baths;
    data['description'] = description;
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    if (located != null) {
      data['city_area'] = located!.toJson();
    }
    data['city'] = cityId;
    data['price'] = price;
    data['mobile'] = mobile;
    data['living_room'] = livingRoom;
    data['furnished'] = furnished;
    data['property_type'] = propertyType;
    data['duration'] = duration;
    data['verification_status'] = verificationStatus;
    data['is_promoted'] = isPromoted;
    data['is_active'] = isActive;
    data['is_verified'] = isVerified;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['slug'] = slug;
    data['is_deal'] = isDeal;
    return data;
  }
}

class CityAreaModel {
  String? id;
  String? name;
  var coverImage;
  String? city;

  CityAreaModel({this.id, this.name, this.coverImage, this.city});

  CityAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coverImage = json['cover_image'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cover_image'] = this.coverImage;
    data['city'] = this.city;
    return data;
  }
}
