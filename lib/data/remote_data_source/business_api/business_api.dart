import 'package:app/application/core/exceptions/exception.dart';
import 'package:app/application/network/client/iApiService.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/business_module_models/business_profile_stats_res_model.dart';
import 'package:app/data/models/business_module_models/get_business_profiles_models.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/data/remote_data_source/business_api/i_business_api.dart';
import 'package:dio/dio.dart';

class BusinessApi implements IBusinessApi {
  BusinessApi(IApiService api) : dio = api.get();
  Dio dio;

  @override
  Future<GetBusinessResModel> getMyBusinessProfile() async {
    try {
      final responseData = await dio.get("");

      return GetBusinessResModel.fromJson(responseData.data);
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
  Future<AutomotiveAdsResModel> getMyBusinessAutomotiveAds(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("", queryParameters: map);
      return AutomotiveAdsResModel.fromJson(responseData.data);
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
  Future<ClassifiedAdsResModel> getMyBusinessClassifiedAds(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("", queryParameters: map);
      return ClassifiedAdsResModel.fromJson(responseData.data);
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
  Future<JobAdsResModel> getMyBusinessJobAds(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("", queryParameters: map);
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
  Future<PropertyAdsResModel> getMyBusinessPropertyAds(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("", queryParameters: map);
      return PropertyAdsResModel.fromJson(responseData.data);
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
  Future<BusinessStatsResModel> getBusinessStats(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("", queryParameters: map);
      return BusinessStatsResModel.fromJson(responseData.data);
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
