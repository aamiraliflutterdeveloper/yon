import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/data/models/general_res_models/country_code_res_model.dart';
import 'package:app/data/models/general_res_models/state_and_city_res_model.dart';
import 'package:app/data/models/search_models/search_ads_res_model.dart';

abstract class IGeneralApi {
  Future<CountryCodeResModel> getAllCountryCodes();
  Future<AllCurrenciesResModel> getAllCurrencies();
  Future<StateAndCityCodeResModel> getStates(Map<String, dynamic> map);
  Future<StateAndCityCodeResModel> getCities(Map<String, dynamic> map);
  Future<AllAdsResModel> getUserAllAds(Map<String, dynamic> map);
}
