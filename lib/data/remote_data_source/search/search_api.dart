import 'package:app/application/core/exceptions/exception.dart';
import 'package:app/application/network/client/iApiService.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/search_models/search_ads_res_model.dart';
import 'package:app/data/models/search_models/suggested_ads_res_model.dart';
import 'package:app/data/remote_data_source/search/i_search_api.dart';
import 'package:dio/dio.dart';

class SearchApi implements ISearchApi {
  SearchApi(IApiService api) : dio = api.get();
  Dio dio;

  @override
  Future<AllAdsResModel> getSearchedAds(Map<String, dynamic> map) async {
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

  @override
  Future<SuggestedAdsResModel> getSuggestedAds(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("", queryParameters: map);
      return SuggestedAdsResModel.fromJson(responseData.data);
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
