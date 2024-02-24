import 'package:app/data/models/general_res_models/currency_model.dart';
import 'package:app/data/models/general_res_models/media_res_model.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/data/models/model_objects/categories_res_object.dart';

class AutomotiveAdsResModel {
  int? count;
  List<AutomotiveProductModel>? automotiveAdsList;

  AutomotiveAdsResModel({count, automotiveAdsList});

  AutomotiveAdsResModel.fromJson(Map<String, dynamic> json) {
    count = json['count'] ?? 0;
    if (json['results'] != null) {
      automotiveAdsList = <AutomotiveProductModel>[];
      json['results'].forEach((v) {
        automotiveAdsList!.add(AutomotiveProductModel.fromJson(v));
      });
    } else {
      automotiveAdsList = <AutomotiveProductModel>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (automotiveAdsList != null) {
      data['results'] = automotiveAdsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AutomotiveProductModel {
  String? id;
  String? name;
  CurrencyModel? currency;
  bool? isFavourite;
  CategoriesResModel? category;
  SubCategory? subCategory;
  String? price;
  UserProfileModel? profile;
  UserProfileModel? company;
  List<ImageMedia>? imageMedia;
  List<VideoMedia>? videoMedia;
  String? mobile;
  String? businessType;
  String? streetAddress;
  String? longitude;
  String? latitude;
  Make? make;
  AutomotiveModel? automotiveModel;
  String? description;
  String? carType;
  int? kilometers;
  int? automotiveYear;
  String? transmissionType;
  String? slug;
  String? fuelType;
  String? verificationStatus;
  String? updatedAt;
  String? createdAt;
  String? color;
  String? rentalHours;
  String? automotiveType;

  bool? isPromoted;
  bool? isDeal;
  bool? isActive;

  AutomotiveProductModel({
    id,
    name,
    currency,
    isFavourite,
    category,
    subCategory,
    price,
    profile,
    imageMedia,
    videoMedia,
    mobile,
    companyName,
    companyLicense,
    businessType,
    companyLogo,
    streetAdress,
    longitude,
    latitude,
    make,
    automotiveModel,
    description,
    carType,
    quantity,
    automotiveType,
    color,
    kilometers,
    automotiveYear,
    insideOut,
    transmissionType,
    slug,
    fuelType,
    rentalHours,
    verificationStatus,
    updatedAt,
    createdAt,
    isDeal,
    isPromoted,
    isActive,
    company,
  });

  AutomotiveProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    currency = json['currency'] != null
        ? CurrencyModel.fromJson(json['currency'])
        : null;
    isFavourite = json['is_favourite'] ?? false;
    category = json['category'] != null
        ? CategoriesResModel.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? SubCategory.fromJson(json['sub_category'])
        : null;
    price = json['price'] ?? "";
    profile = json['profile'] != null
        ? UserProfileModel.fromJson(json['profile'])
        : null;
    company = json['company'] != null
        ? UserProfileModel.fromJson(json['company'])
        : UserProfileModel();
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
    mobile = json['mobile'] ?? "";
    businessType = json['business_type'] ?? "Individual";
    streetAddress = json['street_adress'] ?? "";
    longitude = json['longitude'] ?? "";
    latitude = json['latitude'] ?? "";
    make = json['make'] != null ? Make.fromJson(json['make']) : null;
    automotiveModel = json['automotive_model'] != null
        ? AutomotiveModel.fromJson(json['automotive_model'])
        : null;
    description = json['description'] ?? "";
    carType = json['car_type'] ?? "";
    kilometers = json['kilometers'] ?? 0;
    automotiveYear = json['automotive_year'] ?? 0;
    transmissionType = json['transmission_type'] ?? "";
    slug = json['slug'] ?? "";
    fuelType = json['fuel_type'] ?? "";
    verificationStatus = json['verification_status'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    createdAt = json['created_at'] ?? "";
    color = json["color"] ?? "";
    rentalHours = json['rent_hourly'];
    automotiveType = json['automotive_type'];

    isDeal = json['is_deal'] ?? false;
    isPromoted = json['is_promoted'] ?? false;
    isActive = json['is_active'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data["rent_hourly"] = rentalHours;
    data['automotive_type'] = automotiveType;
    data['name'] = name;
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    data['is_favourite'] = isFavourite;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (subCategory != null) {
      data['sub_category'] = subCategory!.toJson();
    }
    data['price'] = price;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (imageMedia != null) {
      data['image_media'] = imageMedia!.map((v) => v.toJson()).toList();
    }
    if (videoMedia != null) {
      data['video_media'] = videoMedia!.map((v) => v.toJson()).toList();
    }
    data['mobile'] = mobile;
    data['business_type'] = businessType;
    data['street_adress'] = streetAddress;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    if (make != null) {
      data['make'] = make!.toJson();
    }
    if (automotiveModel != null) {
      data['automotive_model'] = automotiveModel!.toJson();
    }
    data['description'] = description;
    data['car_type'] = carType;
    data['kilometers'] = kilometers;
    data['automotive_year'] = automotiveYear;
    data['transmission_type'] = transmissionType;
    data['slug'] = slug;
    data['fuel_type'] = fuelType;
    data['verification_status'] = verificationStatus;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data["color"] = color;
    data['is_promoted'] = isPromoted;
    data['is_deal'] = isDeal;
    data['is_active'] = isActive;
    return data;
  }
}

class Make {
  String? id;
  String? title;
  String? image;

  Make({id, title, image});

  Make.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    title = json['title'] ?? "";
    image = json['image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    return data;
  }
}

class AutomotiveModel {
  String? id;
  String? title;
  String? image;
  String? backgroundColor;
  String? year;
  String? brand;

  AutomotiveModel({id, title, image, backgroundColor, year, brand});

  AutomotiveModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    title = json['title'] ?? "";
    image = json['image'] ?? "";
    backgroundColor = json['background_color'] ?? "";
    year = json['year'] ?? "";
    brand = json['brand'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['background_color'] = backgroundColor;
    data['year'] = year;
    data['brand'] = brand;
    return data;
  }
}
