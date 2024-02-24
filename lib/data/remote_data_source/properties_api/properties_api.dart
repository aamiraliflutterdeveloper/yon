import 'dart:developer';

import 'package:app/application/core/exceptions/exception.dart';
import 'package:app/application/network/client/iApiService.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/data/models/properties_res_models/properties_categories_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/data/remote_data_source/properties_api/i_properties_api.dart';
import 'package:app/di/service_locator.dart';
import 'package:dio/dio.dart';

class PropertiesApi implements IPropertiesApi {
  PropertiesApi(IApiService api) : dio = api.get();
  Dio dio;
  IPrefHelper iPrefHelper = inject<IPrefHelper>();
  @override
  Future<PropertiesCategoriesResModel> getAllPropertiesCategories() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
      return PropertiesCategoriesResModel.fromJson(responseData.data);
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
  Future<FilteredLimitsResModel> getPropertyFilterLimits(
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
  Future<PropertyAdsResModel> getPropertyFeaturedAds() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
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
  Future<PropertyAdsResModel> getPropertyAllAds(
      Map<String, dynamic> map) async {
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
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
  Future<PropertyAdsResModel> getPropertyRecommendedAds() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
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
  Future<PropertyAdsResModel> getMyPropertyAds(Map<String, dynamic> map) async {
    try {
      map.addEntries({
        MapEntry('business_type',
            iPrefHelper.isBusinessModeOn() == true ? 'Company' : 'Individual')
      });
      d('map ::::::: $map');
      final responseData =
          await dio.get("", queryParameters: map);
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
  Future<MessageResModel> propertyActiveInactive(
      Map<String, dynamic> map) async {
    try {
      final responseData =
          await dio.put("", data: map);
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
  Future<MessageResModel> deleteProperty(Map<String, dynamic> map) async {
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
  Future<PropertyAdsResModel> getPropertyFilteredAds(
      Map<String, dynamic> map) async {
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      log(map.toString());
      final responseData =
          await dio.get("", queryParameters: map, options: Options(headers: {"Authorization": "token ${iPrefHelper.retrieveToken()}"}));
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
  Future<MessageResModel> addFavProperty(Map<String, dynamic> map) async {
    try {
      final responseData =
          await dio.post("", data: map);
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
  Future<MessageResModel> deleteFavProperty(Map<String, dynamic> map) async {
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
  Future<PropertyAdsResModel> getFavPropertyAds(
      Map<String, dynamic> map) async {
    try {
      final responseData =
          await dio.get("", queryParameters: map);
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
  Future<PropertyAdsResModel> nearByPropertyAds(
      Map<String, dynamic> map) async {
    try {
      final responseData =
          await dio.get("", queryParameters: map);
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
  Future<PropertyAdsResModel> getPropertyByCategoryAds(
      Map<String, dynamic> map) async {
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          // await dio.get("/api/get_property_by_category/", queryParameters: map);
      await dio.get("", queryParameters: map, options: Options(headers: {"Authorization": "token ${iPrefHelper.retrieveToken()}"}));
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
}
