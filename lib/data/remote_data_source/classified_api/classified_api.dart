import 'package:app/application/core/exceptions/exception.dart';
import 'package:app/application/network/client/iApiService.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_brands_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_categories_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/general_res_models/brands_res_models.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/data/remote_data_source/classified_api/i_classified_api.dart';
import 'package:app/di/service_locator.dart';
import 'package:dio/dio.dart';

class ClassifiedApi implements IClassifiedApi {
  ClassifiedApi(IApiService api) : dio = api.get();
  Dio dio;

  IPrefHelper iPrefHelper = inject<IPrefHelper>();

  @override
  Future<ClassifiedCategoriesResModel> getAllClassifiedCategories() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData = await dio.get("",
          queryParameters: map);
      print("brother this is what i need == ==== === ==== == = = = = =  = = = ");
      return ClassifiedCategoriesResModel.fromJson(responseData.data);
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
  Future<FilteredLimitsResModel> getClassifiedFilterLimits(
      Map<String, dynamic> map) async {
    try {
      Map<String, dynamic> map = {};
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
      d(e);
      d("this is model value issues :: ");
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<ClassifiedBrandsResModel> getBrandsBySubCategory(
      Map<String, dynamic> map) async {
    try {
      d('map : $map');
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData = await dio.get("");
      return ClassifiedBrandsResModel.fromJson(responseData.data);
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
  Future<ClassifiedAdsResModel> getClassifiedFeaturedAds() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData = await dio.get("");
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
  Future<ClassifiedAdsResModel> getClassifiedDealsAds() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData = await dio.get("");
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
  Future<BrandsResModel> getClassifiedFeaturedBrands() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData = await dio.get("",
          queryParameters: map);
      return BrandsResModel.fromJson(responseData.data);
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
  Future<ClassifiedAdsResModel> getClassifiedAllAds(
      Map<String, dynamic> map) async {
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      d("${iPrefHelper.retrieveToken()}");
      d("this is token value");
      // map.addEntries({MapEntry('country', iPrefHelper.retrieveToken())});
      // map.addEntries({MapEntry('country', 'United Arab Emirates')});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      print(map);
      print("ahhahahahahahhahahahahah ====================");
      print("this is inside the classified api repo.");
      final responseData =
          await dio.get("", queryParameters: map);
      d("this is classified reposne 000000000000 heloooooooooooo");
      d("${responseData}");
      d("this is classified reposne");

      ClassifiedAdsResModel clas = ClassifiedAdsResModel.fromJson(responseData.data);
      d("$clas this is class classification class value");
      d("${clas.results!.map((e) => e.isFavourite)} this is dollar sign value");

      return ClassifiedAdsResModel.fromJson(responseData.data);
    }
    on DioError catch (e) {
      d(e);
      print("========================================");

      final exception = getException(e);
      throw exception;
    }
    catch (e, t) {
      d("$t this is t point ");
      d("$e this is e point ");
      print("========================================");
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<ClassifiedAdsResModel> getRecommendedClassifiedAds() async {
    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          await dio.get("", queryParameters: map);
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
  Future<ClassifiedAdsResModel> getMyClassifiedAds(
      Map<String, dynamic> map) async {
    try {
      map.addEntries({
        MapEntry('business_type',
            iPrefHelper.isBusinessModeOn() == true ? 'Company' : 'Individual')
      });
      d('map ::::::: $map');
      final responseData =
          await dio.get("", queryParameters: map);
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
  Future<MessageResModel> classifiedActiveInactive(
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
  Future<MessageResModel> deleteClassified(Map<String, dynamic> map) async {
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
  Future<ClassifiedAdsResModel> getClassifiedFilteredAds(
      Map<String, dynamic> map) async {
    d(map);
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      final responseData =
          // await dio.get("/api/filtering_classifieds/", queryParameters: map);
      await dio.get("", queryParameters: map, options: Options(headers: {"Authorization": "token ${iPrefHelper.retrieveToken()}"}));
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
  Future<MessageResModel> addFavClassified(Map<String, dynamic> map) async {
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
  Future<MessageResModel> deleteFavClassified(Map<String, dynamic> map) async {
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
  Future<ClassifiedAdsResModel> getFavClassifiedAds(
      Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("",
          queryParameters: map);
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
  Future<ClassifiedAdsResModel> getClassifiedByCategoryAds(
      Map<String, dynamic> map) async {
    d("this is entry point of the day :: ");
    d("$map");
    d("this is token value");
    try {
      map.addEntries({MapEntry('country', iPrefHelper.userCurrentCountry())});
      map.addEntries({MapEntry('city', iPrefHelper.userCurrentCity())});
      // map.addEntries({MapEntry('id', iPrefHelper.retrieveToken())});
      final responseData = await dio.get("",
          queryParameters: map, options: Options(headers: {"Authorization": "token ${iPrefHelper.retrieveToken()}"}));
      print("==================");
      print("this is checking for categories =====");
      d("${responseData.data} this is response data");
      print(responseData.data);
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
}
