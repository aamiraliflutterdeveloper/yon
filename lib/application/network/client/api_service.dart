import 'dart:io';
import 'package:app/application/network/external_values/IExternalValues.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/di/service_locator.dart';
import 'package:dio/dio.dart';
import 'iApiService.dart';

class ApiService extends Interceptor implements IApiService {
  ApiService.create({required IExternalValues externalValues}) {
    serviceGenerator(externalValues);
  }

  @override
  Dio get() => _dio;

  @override
  BaseOptions getBaseOptions(IExternalValues externalValues) {
    return BaseOptions(
        baseUrl: externalValues.getBaseUrl(),
        receiveDataWhenStatusError: true,
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        connectTimeout: 60 * 1000,
        receiveTimeout: 60 * 1000);
  }

  @override
  HttpClient httpClientCreate(HttpClient client) {
    // TODO: implement httpClientCreate
    throw UnimplementedError();
  }

  @override
  void serviceGenerator(externalValues) {
    _dio = Dio(getBaseOptions(externalValues));
    _dio.interceptors.add(this);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    IPrefHelper prefHelper = inject<IPrefHelper>();
    final token = prefHelper.retrieveToken();
    if (options.path == '/api/near_job_ads/' ||
        options.path == '/api/near_automotive_ads/' ||
        options.path == '/api/search_all/' ||
        options.path == '/api/get_notifications/' ||
        options.path == '/api/suggested_ads/' ||
        options.path == '/api/get_user_profile/' ||
        options.path == '/api/view_ads_by_profile/' ||
        options.path == '/api/get_property_by_category/' ||
        options.path == '/api/get_job_by_category/' ||
        options.path == '/api/get_automotives_by_category/' ||
        options.path == '/api/get_business_profile_stats/' ||
        options.path == '/api/get_my_business_automotives/' ||
        options.path == '/api/get_my_business_properties/' ||
        options.path == '/api/get_my_business_jobs/' ||
        options.path == '/api/get_my_business_classifieds/' ||
        options.path == '/api/get_my_apply_on_jobs/' ||
        options.path == '/api/apply_job/' ||
        options.path == '/api/get_my_resume/' ||
        options.path == '/api/get_business_profile/' ||
        options.path == '/api/get_favourite_classifieds/' ||
        options.path == '/api/get_favourite_automotives/' ||
        options.path == '/api/get_favourite_properties/' ||
        options.path == '/api/get_favorite_jobs/' ||
        options.path == '/api/get_all_classifieds/' ||
        options.path == '/api/get_all_automotives/' ||
        options.path == '/api/get_all_jobs/' ||
        options.path == '/api/get_all_properties/' ||
        options.path == '/api/make_active_classified/' ||
        options.path == '/api/make_active_automotive/' ||
        options.path == '/api/make_active_job/' ||
        options.path == '/api/make_active_property/' ||
        options.path == '/api/update_user_profile/' ||
        options.path == '/api/change_password/' ||
        options.path == '/api/recommended_classifieds/' ||
        options.path == '/api/get_my_classifieds/' ||
        options.path == '/api/get_my_automotives/' ||
        options.path == '/api/get_my_properties/' ||
        options.path == '/api/get_my_jobs/' ||
        options.path == '/api/delete_classified/' ||
        options.path == '/api/delete_automotive/' ||
        options.path == '/api/delete_property/' ||
        options.path == '/api/delete_job/' ||
        options.path == '/api/add_favourite_classified/' ||
        options.path == '/api/add_favourite_automotive/' ||
        options.path == '/api/add_favourite_property/' ||
        options.path == '/api/add_favourite_job/') {
      options.headers = {"Authorization": "Token $token"};
    }
    d("onRequest");
    d('path: ${options.uri}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    d("onResponse");
    d('status code: ${response.statusCode}');
    d('Response: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    d("onError");
    d('status code: ${err.response?.statusCode}');
    d('Response: ${err.response?.data}');
    return handler.next(err);
  }

/*  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path != 'api/auth/user' && options.path != 'api/auth/login') {
      final token = iPrefHelper.retrieveToken();
      options.headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    }
    print('path ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("onResponse");
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    return handler.next(err);
  }*/

  late Dio _dio;
}

