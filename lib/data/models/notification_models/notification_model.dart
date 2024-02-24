import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';

class NotificationResModel {
  int? count;
  int? perPageResult;
  List<NotificationModel>? notificationList;

  NotificationResModel({
    count,
    perPageResult,
    results,
  });

  NotificationResModel.fromJson(Map<String, dynamic> json) {
    count = json['count'] ?? 0;
    perPageResult = json['per_page_result'] ?? 0;
    if (json['results'] != null) {
      notificationList = <NotificationModel>[];
      json['results'].forEach((v) {
        notificationList!.add(NotificationModel.fromJson(v));
      });
    } else {
      notificationList = <NotificationModel>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['per_page_result'] = perPageResult;
    if (notificationList != null) {
      data['results'] = notificationList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationModel {
  String? id;
  String? type;
  String? chatId;
  String? text;
  bool? isRead;
  List<String>? notifiersList;
  AutomotiveProductModel? automotive;
  JobProductModel? job;
  PropertyProductModel? property;
  ClassifiedProductModel? classified;
  UserProfileModel? profile;
  String? createdAt;
  List<String>? readBy;

  NotificationModel(
      {id,
      type,
      text,
      notifiersList,
      automotive,
      job,
      property,
      classified,
      profile,
      createdAt,
      readBy,
      isRead});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    type = json['type'] ?? '';
    text = json['text'] ?? '';
    chatId = json['chat'] ?? '';
    isRead = json['is_read'] ?? false;
    notifiersList = json['notifiers_list'].cast<String>();
    automotive = json['automotive'] != null
        ? AutomotiveProductModel.fromJson(json['automotive'])
        : null;
    job = json['job'] != null ? JobProductModel.fromJson(json['job']) : null;
    property = json['property'] != null
        ? PropertyProductModel.fromJson(json['property'])
        : null;
    classified = json['classified'] != null
        ? ClassifiedProductModel.fromJson(json['classified'])
        : null;
    profile = json['profile'] != null
        ? UserProfileModel.fromJson(json['profile'])
        : null;
    createdAt = json['created_at'] ?? '';
    readBy = json['read_by'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['text'] = text;
    data['chat'] = chatId;
    data['is_read'] = isRead;
    data['notifiers_list'] = notifiersList;
    if (automotive != null) {
      data['automotive'] = automotive!.toJson();
    }
    if (job != null) {
      data['job'] = job!.toJson();
    }
    if (property != null) {
      data['property'] = property!.toJson();
    }
    if (classified != null) {
      data['classified'] = classified!.toJson();
    }
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['created_at'] = createdAt;
    data['read_by'] = readBy;
    return data;
  }
}
