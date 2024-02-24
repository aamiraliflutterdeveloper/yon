import 'dart:developer';

import 'package:app/application/core/exceptions/exception.dart';
import 'package:app/application/network/client/iApiService.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/jobs_res_model/apply_job_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_categories_res_model.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/data/remote_data_source/jobs_api/i_job_api.dart';
import 'package:app/di/service_locator.dart';
import 'package:dio/dio.dart';

class JobApi implements IJobApi {
  JobApi(IApiService api) : dio = api.get();
  Dio dio;

  IPrefHelper iPrefHelper = inject<IPrefHelper>();
  @override
  Future<JobCategoriesResModel> getAllJobCategories() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
      return JobCategoriesResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<FilteredLimitsResModel> getJobFilterLimits(
      Map<String, dynamic> map) async {
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
      return FilteredLimitsResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<JobAdsResModel> getJobFeaturedAds() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
      return JobAdsResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<JobAdsResModel> getJobAllAds(Map<String, dynamic> map) async {
    try {
      // Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      d("${iPrefHelper.retrieveToken()}");
      d("${map}");
      d("this is current user :: ");

      final responseData =
          await dio.get("", queryParameters: map);
      return JobAdsResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<JobAdsResModel> getJobRecommendedAds() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
      return JobAdsResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<JobAdsResModel> getMyJobAds(Map<String, dynamic> map) async {
    d("this is all my jobs");
    try {
      map.addEntries({
        MapEntry('business_type',
            iPrefHelper.isBusinessModeOn() == true ? 'Company' : 'Individual')
      });
      d('map ::::::: $map');
      final responseData =
          await dio.get("", queryParameters: map);
      d("this is all my jobs :: ${responseData.data}");
      return JobAdsResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<MessageResModel> jobActiveInactive(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.put("", data: map);
      return MessageResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<MessageResModel> deleteJob(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.delete("", data: map);
      return MessageResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<JobAdsResModel> getJobFilteredAds(Map<String, dynamic> map) async {
    log(map.toString());
    try {
      d(map);
      d("this is map data in filter api");
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          // await dio.get("/api/filtering_job/", queryParameters: map, );
          await dio.get("", queryParameters: map, options: Options(headers: {"Authorization": "token ${iPrefHelper.retrieveToken()}"}));
      return JobAdsResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<MessageResModel> addFavJob(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.post("", data: map);
      return MessageResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<MessageResModel> deleteFavJob(Map<String, dynamic> map) async {
    try {
      final responseData =
          await dio.delete("", data: map);
      return MessageResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<JobAdsResModel> getFavJobAds(Map<String, dynamic> map) async {
    try {
      final responseData =
          await dio.get("", queryParameters: map);
      return JobAdsResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<ApplyJobResModel> applyOnJob(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.post("", data: map);
      return ApplyJobResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<JobAdsResModel> getAppliedJobs() async {
    try {
      final responseData = await dio.get("");
      return JobAdsResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<JobAdsResModel> getJobByCategoryAds(Map<String, dynamic> map) async {
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          // await dio.get("/api/get_job_by_category/", queryParameters: map);
          await dio.get("", queryParameters: map, options: Options(headers: {"Authorization": "token ${iPrefHelper.retrieveToken()}"}));
      return JobAdsResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<JobAdsResModel> getNearByJobAds(Map<String, dynamic> map) async {
    try {
      final responseData =
          await dio.get("", queryParameters: map);
      return JobAdsResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }
}
