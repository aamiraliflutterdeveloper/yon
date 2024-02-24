import 'dart:io';

import 'package:app/application/network/external_values/IExternalValues.dart';
import 'package:dio/dio.dart';


abstract class IApiService {
  Dio get();
  void serviceGenerator(IExternalValues externalValues);
  BaseOptions getBaseOptions(IExternalValues externalValues);
  HttpClient httpClientCreate(HttpClient client);
}