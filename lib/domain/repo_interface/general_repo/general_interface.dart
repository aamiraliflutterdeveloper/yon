import 'package:app/application/core/failure/failure.dart';
import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/data/models/general_res_models/country_code_res_model.dart';
import 'package:app/data/models/general_res_models/state_and_city_res_model.dart';
import 'package:app/data/models/search_models/search_ads_res_model.dart';
import 'package:dartz/dartz.dart';

abstract class IGeneral {
  Future<Either<Failure, CountryCodeResModel>> getCountiesCode();
  Future<Either<Failure, AllCurrenciesResModel>> getAllCurrencies();
  Future<Either<Failure, StateAndCityCodeResModel>> getStates(Map<String, dynamic> map);
  Future<Either<Failure, StateAndCityCodeResModel>> getCities(Map<String, dynamic> map);
  Future<Either<Failure, AllAdsResModel>> getUserAllAds(Map<String, dynamic> map);
}
