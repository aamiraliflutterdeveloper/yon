import 'package:app/data/models/general_res_models/country_code_res_model.dart';
import 'package:app/data/models/general_res_models/state_and_city_res_model.dart';

class GetBusinessResModel {
  bool? success;
  List<BusinessProfileModel>? response;

  GetBusinessResModel({success, response});

  GetBusinessResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response = <BusinessProfileModel>[];
      json['response'].forEach((v) {
        response!.add(BusinessProfileModel.fromJson(v));
      });
    } else {
      response = <BusinessProfileModel>[];
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

class BusinessProfileModel {
  String? id;
  String? profile;
  String? name;
  String? about;
  String? companyType;
  bool? companyStatus;
  String? licenseNumber;
  String? email;
  String? phone;
  String? dialCode;
  CountriesModel? country;
  StateAndCityCodeModel? state;
  StateAndCityCodeModel? city;
  String? streetAddress;
  String? longitude;
  String? latitude;
  bool? isBusinessActive;
  String? logo;
  String? coverImage;
  String? verificationStatus;
  String? message;
  List<NationalId>? nationalId;
  List<Passport>? passport;
  List<RecentImage>? recentImage;
  List<LicenseFile>? licenseFile;

  BusinessProfileModel(
      {id,
      profile,
      name,
      about,
      companyType,
      companyStatus,
      licenseNumber,
      email,
      phone,
      dialCode,
      country,
      state,
      city,
      streetAddress,
      longitude,
      latitude,
      this.nationalId,
      this.passport,
      this.recentImage,
      this.licenseFile,
      isBusinessActive,
      logo,
      this.message,
      this.verificationStatus,
      coverImage});

  BusinessProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    profile = json['profile'] ?? "";
    name = json['name'] ?? "";
    about = json['about'] ?? "";
    isBusinessActive = json['company_status'] ?? false;
    companyType = json['company_type'] ?? "";
    companyStatus = json['company_status'] ?? false;
    licenseNumber = json['license_number'] ?? "";
    email = json['email'] ?? "";
    phone = json['phone'] ?? "";
    dialCode = json['dial_code'] ?? "";
    country = json['country'] != null
        ? CountriesModel.fromJson(json['country'])
        : CountriesModel();
    state = json['state'] != null
        ? StateAndCityCodeModel.fromJson(json['state'])
        : StateAndCityCodeModel();
    city = json['city'] != null
        ? StateAndCityCodeModel.fromJson(json['city'])
        : StateAndCityCodeModel();
    streetAddress = json['street_address'] ?? "";
    longitude = json['longitude'] ?? "";
    latitude = json['latitude'] ?? "";
    logo = json['logo'] ?? "";
    coverImage = json['cover_image'] ?? "";
    if (json['national_id'] != null) {
      nationalId = <NationalId>[];
      json['national_id'].forEach((v) {
        nationalId!.add(NationalId.fromJson(v));
      });
    }
    if (json['passport'] != null) {
      passport = <Passport>[];
      json['passport'].forEach((v) {
        passport!.add(Passport.fromJson(v));
      });
    }
    if (json['recent_image'] != null) {
      recentImage = <RecentImage>[];
      json['recent_image'].forEach((v) {
        recentImage!.add(RecentImage.fromJson(v));
      });
    }
    if (json['license_file'] != null) {
      licenseFile = <LicenseFile>[];
      json['license_file'].forEach((v) {
        licenseFile!.add(LicenseFile.fromJson(v));
      });
    }
    message = json['message'];
    verificationStatus = json["verification_status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['profile'] = profile;
    data['name'] = name;
    data['about'] = about;
    data['company_type'] = companyType;
    data['company_status'] = companyStatus;
    data['license_number'] = licenseNumber;
    data['email'] = email;
    data['phone'] = phone;
    data['dial_code'] = dialCode;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    if (state != null) {
      data['state'] = state!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    data['street_address'] = streetAddress;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['logo'] = logo;
    data['company_status'] = isBusinessActive;
    data['cover_image'] = coverImage;
    if (nationalId != null) {
      data['national_id'] = nationalId!.map((v) => v.toJson()).toList();
    }
    if (passport != null) {
      data['passport'] = passport!.map((v) => v.toJson()).toList();
    }
    if (recentImage != null) {
      data['recent_image'] = recentImage!.map((v) => v.toJson()).toList();
    }
    if (licenseFile != null) {
      data['license_file'] = licenseFile!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['verification_status'] = verificationStatus;
    return data;
  }
}

class NationalId {
  String? id;
  String? idcardFile;
  String? fileName;
  String? fileSize;

  NationalId({this.id, this.idcardFile, this.fileName, this.fileSize});

  NationalId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idcardFile = json['idcard_file'];
    fileName = json['file_name'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['idcard_file'] = idcardFile;
    data['file_name'] = fileName;
    data['file_size'] = fileSize;
    return data;
  }
}

class Passport {
  String? id;
  String? passportFile;
  String? fileName;
  String? fileSize;

  Passport({this.id, this.passportFile, this.fileName, this.fileSize});

  Passport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    passportFile = json['passport_file'];
    fileName = json['file_name'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['passport_file'] = passportFile;
    data['file_name'] = fileName;
    data['file_size'] = fileSize;
    return data;
  }
}

class RecentImage {
  String? id;
  String? recentimageFile;
  String? fileName;
  String? fileSize;

  RecentImage({this.id, this.recentimageFile, this.fileName, this.fileSize});

  RecentImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recentimageFile = json['recentimage_file'];
    fileName = json['file_name'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['recentimage_file'] = recentimageFile;
    data['file_name'] = fileName;
    data['file_size'] = fileSize;
    return data;
  }
}

class LicenseFile {
  String? id;
  String? licenseFile;
  String? fileName;
  String? fileSize;

  LicenseFile({this.id, this.licenseFile, this.fileName, this.fileSize});

  LicenseFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    licenseFile = json['license_file'];
    fileName = json['file_name'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['license_file'] = licenseFile;
    data['file_name'] = fileName;
    data['file_size'] = fileSize;
    return data;
  }
}
