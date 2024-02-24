import 'dart:developer';
import 'package:app/application/core/exceptions/exception.dart';
import 'package:app/application/network/client/iApiService.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/models/automotive_models/auto_all_brands_res_model.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/automotive_models/automotive_categories_res_model.dart';
import 'package:app/data/models/automotive_models/brandModels_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/data/remote_data_source/automotive_api/i_automotive_api.dart';
import 'package:app/di/service_locator.dart';
import 'package:dio/dio.dart';

class AutomotiveApi implements IAutomotiveApi {
  AutomotiveApi(IApiService api) : dio = api.get();
  Dio dio;
  IPrefHelper iPrefHelper = inject<IPrefHelper>();
  @override
  Future<AutoMotiveCategoriesResModel> getAllAutomotiveCategories() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData = await dio.get("",
          queryParameters: map);
      ("$responseData this is required data");
      return AutoMotiveCategoriesResModel.fromJson(responseData.data);
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
  Future<AutoAllBrandsResModel> getAutoFeaturedBrands() async {
    try {
      final responseData = await dio.get("");
      return AutoAllBrandsResModel.fromJson(responseData.data);
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
  Future<AutoAllBrandsResModel> getAutoAllBrands() async {
    try {
      final responseData = await dio.get("");
      d('This is response data : ' + responseData.toString());
      return AutoAllBrandsResModel.fromJson(responseData.data);
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
  Future<FilteredLimitsResModel> getAutomotiveFilterLimits(
      Map<String, dynamic> map) async {
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
      d('AUTOMOTIVE RESPONSE : ' + responseData.toString());
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
  Future<AutomotiveAdsResModel> getAutomotiveFeaturedAds() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
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
  Future<AutomotiveAdsResModel> getAutomotiveAllAds(
      Map<String, dynamic> map) async {
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
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
  Future<AutomotiveAdsResModel> getAutomotiveRecommendedAds() {
    // TODO: implement getAutomotiveRecommendedAds
    throw UnimplementedError();
  }

  @override
  Future<AutoAllBrandsResModel> getAutoBrandsById(
      Map<String, dynamic> map) async {
    map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
    d("Make By ID:: ${map}");
    try {
      final responseData =
          await dio.get("", queryParameters: map);
      d('This is response data : ' + responseData.toString());
      return AutoAllBrandsResModel.fromJson(responseData.data);
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
  Future<AutoBrandModelsResModel> getAutomotiveBrandModels(
      Map<String, dynamic> map) async {
    try {
      final responseData =
          await dio.get("", queryParameters: map);
      return AutoBrandModelsResModel.fromJson(responseData.data);
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
  Future<AutomotiveAdsResModel> getMyAutomotiveAds(
      Map<String, dynamic> map) async {
    try {
      map.addEntries({
        MapEntry('business_type',
            iPrefHelper.isBusinessModeOn() == true ? 'Company' : 'Individual')
      });
      d('map ::::::: $map');
      final responseData =
          await dio.get("", queryParameters: map);
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
  Future<MessageResModel> automotiveActiveInactive(
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
  Future<MessageResModel> deleteAutomotive(Map<String, dynamic> map) async {
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
  Future<AutomotiveAdsResModel> getAutomotiveFilteredAds(
      Map<String, dynamic> map) async {
    log(map.toString());
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          // await dio.get("/api/filtering_automotive/", queryParameters: map);
          await dio.get("", queryParameters: map, options: Options(headers: {"Authorization": "token ${iPrefHelper.retrieveToken()}"}));
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
  Future<MessageResModel> addFavAutomotive(Map<String, dynamic> map) async {
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
  Future<MessageResModel> deleteFavAutomotive(Map<String, dynamic> map) async {
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
  Future<AutomotiveAdsResModel> getFavAutomotiveAds(
      Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("",
          queryParameters: map);
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
  Future<AutomotiveAdsResModel> getAutomotiveByCategoryAds(
      Map<String, dynamic> map) async {
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      // final responseData = await dio.get("/api/get_automotives_by_category/",
      //     queryParameters: map, );
      final responseData = await dio.get("",
        queryParameters: map, options: Options(headers: {"Authorization": "token ${iPrefHelper.retrieveToken()}"}));
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
  Future<AutomotiveAdsResModel> getNearByAutomotiveAds(
      Map<String, dynamic> map) async {
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
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
}
