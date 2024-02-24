import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/application/network/external_values/IExternalValues.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/data/models/general_res_models/country_code_res_model.dart';
import 'package:app/data/models/general_res_models/current_country_city_res_model.dart';
import 'package:app/data/models/general_res_models/state_and_city_res_model.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/domain/entities/general_entities/get_cities_entities.dart';
import 'package:app/domain/entities/general_entities/get_states_entities.dart';
import 'package:app/domain/repo_interface/general_repo/general_interface.dart';
import 'package:app/domain/use_case/general_useCases/get_all_countries_code_usecase.dart';
import 'package:app/domain/use_case/general_useCases/get_all_currencies_useCase.dart';
import 'package:app/domain/use_case/general_useCases/get_cities_useCase.dart';
import 'package:app/domain/use_case/general_useCases/get_states_useCases.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneralViewModel extends ChangeNotifier {
  List<CountriesModel> countriesCodeList = [];
  List<String> countriesCode = [];
  List<String> countries = [];
  List<AllCurrenciesModel> allCurrenciesList = [];
  List<String> currenciesList = [];

  changeCountriesCode(List<CountriesModel> updatedCountriesCodeList) {
    countriesCodeList = updatedCountriesCodeList;
    countriesCode = [];
    for (int i = 0; i < countriesCodeList.length; i++) {
      countriesCode.add(countriesCodeList[i].dialCode.toString());
      countries.add(countriesCodeList[i].name.toString());
    }
    d('countriesCode : ' + countriesCode.toString());
    notifyListeners();
  }

  CurrentCountryCityResModel userLocationData = CurrentCountryCityResModel();

  changeUserLocationData(CurrentCountryCityResModel updatedUserLocationData) {
    userLocationData = updatedUserLocationData;
    notifyListeners();
  }

  String? userCurrentCountry;

  changeUserCurrentCountry(String? country) {
    userCurrentCountry = country;
    notifyListeners();
  }

  String? userCurrentCity;

  changeUserCurrentCity(String? city) {
    userCurrentCity = city;
    notifyListeners();
  }

  List<StateAndCityCodeModel> userCities = [];

  changeUserCities(List<StateAndCityCodeModel> newList) {
    userCities = newList;
    notifyListeners();
  }

  List<String> otherCountries = [];

  changeOtherCountries(List<String> newList) {
    otherCountries = newList;
    notifyListeners();
  }

  changeCurrencies(List<AllCurrenciesModel> updatedAllCurrenciesList) {
    allCurrenciesList = updatedAllCurrenciesList;
    d('UPDATED ALL CURRENCIES LIST : ' + allCurrenciesList.toString());
    currenciesList = [];
    for (int i = 0; i < allCurrenciesList.length; i++) {
      currenciesList.add(allCurrenciesList[i].code.toString());
    }
    d('currenciesList : ' + currenciesList.toString());
    notifyListeners();
  }

  IGeneral repo = inject<IGeneral>();

  Future<Either<Failure, CountryCodeResModel>> getAllCountryCode() async {
    final getAllCodes = GetAllCountriesCodeUseCase(repository: repo);
    final result = await getAllCodes(NoParams());
    d('GetAllCountriesCodeUseCase : ' + result.toString());
    return result;
  }

  Future<Either<Failure, AllCurrenciesResModel>> getAllCurrencies() async {
    final getCurrencies = GetAllCurrenciesUseCase(repository: repo);
    final result = await getCurrencies(NoParams());
    d('GetAllCountriesCodeUseCase : ' + result.toString());
    return result;
  }

  List<StateAndCityCodeModel>? statesByCountry = [];
  List<String> allStates = [];

  changeStatesByCountry(List<StateAndCityCodeModel>? newStatesByCountry) {
    statesByCountry = newStatesByCountry;
    allStates = [];
    for (int i = 0; i < statesByCountry!.length; i++) {
      allStates.add(statesByCountry![i].name.toString());
    }
    notifyListeners();
  }

  Future<Either<Failure, StateAndCityCodeResModel>> getStatesByCountry(
      {required String countryId}) async {
    final getStates = GetStatesUseCase(repository: repo);
    final result = await getStates(GetStateEntities(countryId: countryId));
    d('GetStatesUseCase : ' + result.toString());
    return result;
  }

  List<StateAndCityCodeModel>? citiesByState = [];
  List<String> allCities = [];

  changeCitiesByStates(List<StateAndCityCodeModel>? newCitiesByStates) {
    citiesByState = newCitiesByStates;
    allCities = [];
    for (int i = 0; i < citiesByState!.length; i++) {
      allCities.add(citiesByState![i].name.toString());
    }
    notifyListeners();
  }

  Future<Either<Failure, StateAndCityCodeResModel>> getCitiesByState(
      {required String citiesId}) async {
    final getCities = GetCitiesUseCase(repository: repo);
    final result = await getCities(GetCitiesEntities(stateId: citiesId));
    d('GetCitiesUseCase : ' + result.toString());
    return result;
  }

  void getCurrentLocation(
      {required BuildContext context, String? country}) async {
    GeneralViewModel generalViewModel = context.read<GeneralViewModel>();
    IExternalValues iExternalValues = inject<IExternalValues>();
    IPrefHelper iPrefHelper = inject<IPrefHelper>();
    Dio dio = Dio();
    d('This is abc');
    await dio.get('${iExternalValues.getBaseUrl()}api/country_code/',
        queryParameters: {
          'country': country,
        }).then((value) {
      d('Current LOCATION STATUS CODE ::: ${value.statusCode}');
      if (value.statusCode == 200) {
        CurrentCountryCityResModel userLocationData =
            CurrentCountryCityResModel.fromJson(value.data);
        generalViewModel.changeUserLocationData(userLocationData);
        generalViewModel.changeUserCities([]);
        for (int i = 0;
            i < userLocationData.results!.otherCities!.length;
            i++) {
          generalViewModel.userCities
              .add(userLocationData.results!.otherCities![i]);
        }
        d('THIS IS THE generalViewModel.userCities ::: ${generalViewModel.userCities}');
        generalViewModel.changeUserCities(generalViewModel.userCities);
        generalViewModel.changeOtherCountries([]);
        for (int i = 0;
            i < userLocationData.results!.otherCountries!.length;
            i++) {
          generalViewModel.otherCountries.add(
              userLocationData.results!.otherCountries![i].name.toString());
        }
        // generalViewModel.otherCountries.add(userLocationData.results!.currentCountry!.name.toString());
        generalViewModel.changeOtherCountries(generalViewModel.otherCountries);
        generalViewModel.changeUserCurrentCountry(
            userLocationData.results!.currentCountry!.name!);
        generalViewModel.changeUserCurrentCity(
            userLocationData.results!.currentCity!.name!);
        String country = userLocationData.results!.currentCountry!.name!;
        d('This is country ::::::: $country');
        iPrefHelper.saveUserCurrentCountry(country);
        iPrefHelper
            .saveUserCurrentCity(userLocationData.results!.currentCity!.name);
      }
    });
  }

  void updateCurrentLocation(
      {required BuildContext context, String? country}) async {
    GeneralViewModel generalViewModel = context.read<GeneralViewModel>();
    IExternalValues iExternalValues = inject<IExternalValues>();
    IPrefHelper iPrefHelper = inject<IPrefHelper>();
    Dio dio = Dio();
    d('This is abc');
    await dio.get('${iExternalValues.getBaseUrl()}api/country_code/',
        queryParameters: {
          'country': country,
        }).then((value) {
      d('Current LOCATION STATUS CODE ::: ${value.statusCode}');
      if (value.statusCode == 200) {
        CurrentCountryCityResModel userLocationData =
            CurrentCountryCityResModel.fromJson(value.data);
        generalViewModel.changeUserLocationData(userLocationData);
        for (int i = 0;
            i < userLocationData.results!.otherCities!.length;
            i++) {
          generalViewModel.userCities
              .add(userLocationData.results!.otherCities![i]);
        }
        d('THIS IS THE generalViewModel.userCities ::: ${generalViewModel.userCities}');
        generalViewModel.changeUserCities(generalViewModel.userCities);
      }
    });
  }
}
