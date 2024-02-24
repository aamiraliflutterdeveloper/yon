import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';

class ApplyJobResModel {
  bool? success;
  ApplyJobModel? response;

  ApplyJobResModel({success, response});

  ApplyJobResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    response = json['response'] != null ? ApplyJobModel.fromJson(json['response']) : ApplyJobModel();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class ApplyJobModel {
  String? id;
  String? profile;
  JobProductModel? job;
  String? fullName;
  String? mobile;
  String? email;
  String? coverLetter;
  String? createdAt;
  String? updatedAt;
  String? resume;
  String? dialCode;

  ApplyJobModel({id, profile, job, fullName, mobile, email, coverLetter, createdAt, updatedAt, resume, dialCode});

  ApplyJobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    profile = json['profile'] ?? "";
    job = json['job'] != null ? JobProductModel.fromJson(json['job']) : JobProductModel();
    fullName = json['full_name'] ?? "";
    mobile = json['mobile'] ?? "";
    email = json['email'] ?? "";
    coverLetter = json['cover_letter'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    resume = json['resume'] ?? "";
    dialCode = json['dial_code'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['profile'] = profile;
    if (job != null) {
      data['job'] = job!.toJson();
    }
    data['full_name'] = fullName;
    data['mobile'] = mobile;
    data['email'] = email;
    data['cover_letter'] = coverLetter;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['resume'] = resume;
    data['dial_code'] = dialCode;
    return data;
  }
}
