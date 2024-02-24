import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/data/models/general_res_models/country_code_res_model.dart';
import 'package:app/data/models/general_res_models/state_and_city_res_model.dart';
import 'package:app/data/models/search_models/search_ads_res_model.dart';
import 'package:app/data/remote_data_source/general_api/i_general_api.dart';
import 'package:app/domain/repo_interface/general_repo/general_interface.dart';
import 'package:dartz/dartz.dart';

class GeneralRepo implements IGeneral {
  GeneralRepo({required this.api});

  IGeneralApi api;

  @override
  Future<Either<Failure, CountryCodeResModel>> getCountiesCode() async {
    try {
      final result = await api.getAllCountryCodes();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AllCurrenciesResModel>> getAllCurrencies() async {
    try {
      final result = await api.getAllCurrencies();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, StateAndCityCodeResModel>> getCities(Map<String, dynamic> map) async {
    try {
      final result = await api.getCities(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, StateAndCityCodeResModel>> getStates(Map<String, dynamic> map) async {
    try {
      final result = await api.getStates(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AllAdsResModel>> getUserAllAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getUserAllAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }
}
