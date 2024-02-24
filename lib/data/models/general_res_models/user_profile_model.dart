class UserProfileModel {
  String? id;
  String? firstName;
  String? companyName;
  String? lastName;
  String? username;
  String? gender;
  String? email;
  bool? isAdmin;
  String? profilePicture;
  String? coverPicture;
  String? country;
  String? state;
  String? city;
  String? bio;
  String? streetAddress;
  String? longitude;
  String? latitude;
  String? dialCode;
  String? mobileNumber;
  String? mobilePrivacy;
  String? specialOfferPrivacy;
  String? recommendedPrivacy;
  int? totalActiveAds;
  int? totalAdsViews;
  int? totalProfileViews;
  String? businessType;
  String? countryName;
  String? cityName;
  String? streetName;

  UserProfileModel({
    id,
    firstName,
    lastName,
    username,
    gender,
    isAdmin,
    profilePicture,
    coverPicture,
    country,
    state,
    city,
    bio,
    streetAddress,
    longitude,
    latitude,
    dialCode,
    mobilePrivacy,
    specialOfferPrivacy,
    mobileNumber,
    email,
    recommendedPrivacy,
    totalActiveAds,
    totalAdsViews,
    businessType,
    companyName,
    this.countryName,
    this.cityName,
    this.streetName,
    totalProfileViews,
  });

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    companyName = json['name'];
    lastName = json['last_name'];
    username = json['username'];
    email = json['email'];
    gender = json['gender'];
    mobileNumber = json['mobile_number'];
    isAdmin = json['is_admin'];
    profilePicture = json['profile_picture'];
    coverPicture = json['cover_picture'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    bio = json['bio'];
    streetAddress = json['street_adress'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    dialCode = json['dial_code'];
    mobilePrivacy = json['mobile_privacy'];
    specialOfferPrivacy = json['special_offer_privacy'];
    recommendedPrivacy = json['recommended_privacy'];
    totalActiveAds = json['total_active_ads'] ?? 0;
    totalAdsViews = json['total_ads_view'] ?? 0;
    totalProfileViews = json['total_profile_views'] ?? 0;
    businessType = json['business_type'];
    countryName = json["country_name"];
    cityName = json["city_name"];
    streetName = json["street_name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? "";
    data['first_name'] = firstName ?? "";
    data['name'] = companyName ?? "";
    data['last_name'] = lastName ?? "";
    data['email'] = email ?? "";
    data['username'] = username ?? "";
    data['gender'] = gender ?? "";
    data['is_admin'] = isAdmin ?? false;
    data['profile_picture'] = profilePicture ?? "";
    data['cover_picture'] = coverPicture ?? "";
    data['country'] = country ?? "";
    data['state'] = state ?? "";
    data['city'] = city ?? "";
    data['bio'] = bio ?? "";
    data['street_adress'] = streetAddress ?? "";
    data['longitude'] = longitude ?? "";
    data['latitude'] = latitude ?? "";
    data['dial_code'] = dialCode ?? "";
    data['business_type'] = businessType ?? "";
    data['mobile_number'] = mobileNumber ?? "";
    data['mobile_privacy'] = mobilePrivacy ?? "";
    data['special_offer_privacy'] = specialOfferPrivacy ?? "";
    data['recommended_privacy'] = recommendedPrivacy ?? "";
    data['total_active_ads'] = totalActiveAds ?? 0;
    data['total_ads_view'] = totalAdsViews ?? 0;
    data['total_profile_views'] = totalProfileViews ?? 0;
    data["country_name"] = countryName;
    data["city_name"] = cityName;
    data["street_name"] = streetName;
    return data;
  }
}
