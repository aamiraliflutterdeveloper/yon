import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/data/models/model_objects/user_profile_object.dart';

class LoginResModel {
  bool? success;
  Response? response;

  LoginResModel({success, response});

  LoginResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
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

class Response {
  UserProfileModel? profile;
  String? accessToken;

  Response({profile, accessToken});

  Response.fromJson(Map<String, dynamic> json) {
    profile =
    json['profile'] != null ? UserProfileModel.fromJson(json['profile']) : null;
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['access_token'] = accessToken;
    return data;
  }
}

