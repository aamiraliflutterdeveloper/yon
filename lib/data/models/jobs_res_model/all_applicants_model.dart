class AllApplicantsModel {
  Links? links;
  int? count;
  int? perPageResult;
  List<Results>? results;
  Null? details;
  Null? playlist;

  AllApplicantsModel(
      {this.links,
        this.count,
        this.perPageResult,
        this.results,
        this.details,
        this.playlist});

  AllApplicantsModel.fromJson(Map<String, dynamic> json) {
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    count = json['count'];
    perPageResult = json['per_page_result'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
    details = json['details'];
    playlist = json['playlist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    data['count'] = this.count;
    data['per_page_result'] = this.perPageResult;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['details'] = this.details;
    data['playlist'] = this.playlist;
    return data;
  }
}

class Links {
  Null? next;
  Null? previous;

  Links({this.next, this.previous});

  Links.fromJson(Map<String, dynamic> json) {
    next = json['next'];
    previous = json['previous'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next'] = this.next;
    data['previous'] = this.previous;
    return data;
  }
}

class Results {
  String? id;
  Profile? profile;
  Resume? resume;
  String? fullName;
  String? dialCode;
  String? mobile;
  String? email;
  Null? education;
  String? coverLetter;
  bool? isDeleted;
  bool? isViewed;
  String? createdAt;
  Null? updatedAt;
  String? job;

  Results(
      {this.id,
        this.profile,
        this.resume,
        this.fullName,
        this.dialCode,
        this.mobile,
        this.email,
        this.education,
        this.coverLetter,
        this.isDeleted,
        this.isViewed,
        this.createdAt,
        this.updatedAt,
        this.job});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    resume =
    json['resume'] != null ? new Resume.fromJson(json['resume']) : null;
    fullName = json['full_name'];
    dialCode = json['dial_code'];
    mobile = json['mobile'];
    email = json['email'];
    education = json['education'];
    coverLetter = json['cover_letter'];
    isDeleted = json['is_deleted'];
    isViewed = json['is_viewed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    job = json['job'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    if (this.resume != null) {
      data['resume'] = this.resume!.toJson();
    }
    data['full_name'] = this.fullName;
    data['dial_code'] = this.dialCode;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['education'] = this.education;
    data['cover_letter'] = this.coverLetter;
    data['is_deleted'] = this.isDeleted;
    data['is_viewed'] = this.isViewed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['job'] = this.job;
    return data;
  }
}

class Profile {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? gender;
  bool? isAdmin;
  String? profilePicture;
  String? coverPicture;
  String? country;
  String? state;
  String? city;
  String? bio;
  String? mobileNumber;
  String? streetAdress;
  String? longitude;
  String? latitude;
  String? dialCode;
  String? mobilePrivacy;
  String? specialOfferPrivacy;
  String? recommendedPrivacy;
  String? verificationStatus;
  String? countryName;
  String? stateName;
  String? cityName;

  Profile(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.username,
        this.gender,
        this.isAdmin,
        this.profilePicture,
        this.coverPicture,
        this.country,
        this.state,
        this.city,
        this.bio,
        this.mobileNumber,
        this.streetAdress,
        this.longitude,
        this.latitude,
        this.dialCode,
        this.mobilePrivacy,
        this.specialOfferPrivacy,
        this.recommendedPrivacy,
        this.verificationStatus,
        this.countryName,
        this.stateName,
        this.cityName});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    firstName = json['first_name'] ?? '';
    lastName = json['last_name'] ?? '';
    email = json['email'] ?? '';
    username = json['username'] ?? '';
    gender = json['gender'];
    isAdmin = json['is_admin'] ?? '';
    profilePicture = json['profile_picture'] ?? '';
    coverPicture = json['cover_picture'] ?? '';
    country = json['country'] ?? '';
    state = json['state'] ?? '';
    city = json['city'] ?? '';
    bio = json['bio'] ?? '';
    mobileNumber = json['mobile_number'] ?? '';
    streetAdress = json['street_adress'] ?? '';
    longitude = json['longitude'] ?? '';
    latitude = json['latitude'] ?? '';
    dialCode = json['dial_code'] ?? '';
    mobilePrivacy = json['mobile_privacy'] ?? '';
    specialOfferPrivacy = json['special_offer_privacy'] ?? '';
    recommendedPrivacy = json['recommended_privacy'] ?? '';
    verificationStatus = json['verification_status'] ?? '';
    countryName = json['country_name'] ?? '';
    stateName = json['state_name'] ?? '';
    cityName = json['city_name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['username'] = this.username;
    data['gender'] = this.gender;
    data['is_admin'] = this.isAdmin;
    data['profile_picture'] = this.profilePicture;
    data['cover_picture'] = this.coverPicture;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['bio'] = this.bio;
    data['mobile_number'] = this.mobileNumber;
    data['street_adress'] = this.streetAdress;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['dial_code'] = this.dialCode;
    data['mobile_privacy'] = this.mobilePrivacy;
    data['special_offer_privacy'] = this.specialOfferPrivacy;
    data['recommended_privacy'] = this.recommendedPrivacy;
    data['verification_status'] = this.verificationStatus;
    data['country_name'] = this.countryName;
    data['state_name'] = this.stateName;
    data['city_name'] = this.cityName;
    return data;
  }
}

class Resume {
  String? id;
  String? resumeFile;
  String? resumeName;
  String? resumeExtension;
  String? fileSize;

  Resume(
      {this.id,
        this.resumeFile,
        this.resumeName,
        this.resumeExtension,
        this.fileSize});

  Resume.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resumeFile = json['resume_file'];
    resumeName = json['resume_name'];
    resumeExtension = json['resume_extension'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['resume_file'] = this.resumeFile;
    data['resume_name'] = this.resumeName;
    data['resume_extension'] = this.resumeExtension;
    data['file_size'] = this.fileSize;
    return data;
  }
}
