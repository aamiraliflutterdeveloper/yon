import 'package:app/application/core/exceptions/exception.dart';
import 'package:app/application/network/client/iApiService.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/data/models/general_res_models/country_code_res_model.dart';
import 'package:app/data/models/general_res_models/state_and_city_res_model.dart';
import 'package:app/data/models/search_models/search_ads_res_model.dart';
import 'package:app/data/remote_data_source/general_api/i_general_api.dart';
import 'package:dio/dio.dart';

class GeneralApi implements IGeneralApi {
  GeneralApi(IApiService api) : dio = api.get();
  Dio dio;

  @override
  Future<CountryCodeResModel> getAllCountryCodes() async {
    try {
      final responseData = await dio.get("");
      return CountryCodeResModel.fromJson(responseData.data);
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
  Future<AllCurrenciesResModel> getAllCurrencies() async {
    try {
      final responseData = await dio.get("");
      return AllCurrenciesResModel.fromJson(responseData.data);
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
  Future<StateAndCityCodeResModel> getCities(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("", queryParameters: map);
      return StateAndCityCodeResModel.fromJson(responseData.data);
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
  Future<StateAndCityCodeResModel> getStates(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("", queryParameters: map);
      return StateAndCityCodeResModel.fromJson(responseData.data);
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
  Future<AllAdsResModel> getUserAllAds(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("", queryParameters: map);
      return AllAdsResModel.fromJson(responseData.data);
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
