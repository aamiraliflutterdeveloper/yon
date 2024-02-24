import 'package:app/data/models/general_res_models/country_code_res_model.dart';
import 'package:app/data/models/general_res_models/state_and_city_res_model.dart';

class CurrentCountryCityResModel {
  bool? success;
  Results? results;

  CurrentCountryCityResModel({success, results});

  CurrentCountryCityResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    results = json['results'] != null ? Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    if (results != null) {
      data['results'] = results!.toJson();
    }
    return data;
  }
}

class Results {
  CountriesModel? currentCountry;
  StateAndCityCodeModel? currentCity;
  List<StateAndCityCodeModel>? otherCities;
  List<CountriesModel>? otherCountries;

  Results({currentCountry, currentCity, otherCities, otherCountries});

  Results.fromJson(Map<String, dynamic> json) {
    currentCountry = (json['current_country'] != null ? CountriesModel.fromJson(json['current_country']) : null)!;
    currentCity = json['current_city'] != null ? StateAndCityCodeModel.fromJson(json['current_city']) : null;
    if (json['other_cities'] != null) {
      otherCities = <StateAndCityCodeModel>[];
      json['other_cities'].forEach((v) {
        otherCities!.add(StateAndCityCodeModel.fromJson(v));
      });
    }
    if (json['other_countries'] != null) {
      otherCountries = <CountriesModel>[];
      json['other_countries'].forEach((v) {
        otherCountries!.add(CountriesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_country'] = currentCountry!.toJson();
    if (currentCity != null) {
      data['current_city'] = currentCity!.toJson();
    }
    if (otherCities != null) {
      data['other_cities'] = otherCities!.map((v) => v.toJson()).toList();
    }
    if (otherCountries != null) {
      data['other_countries'] = otherCountries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
