import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/data/models/search_models/search_ads_res_model.dart';
import 'package:app/data/models/search_models/suggested_ads_res_model.dart';
import 'package:app/data/remote_data_source/search/i_search_api.dart';
import 'package:app/domain/repo_interface/search_repo/search_interface.dart';
import 'package:dartz/dartz.dart';

class SearchRepo implements ISearch {
  SearchRepo({required this.api});
  ISearchApi api;

  @override
  Future<Either<Failure, AllAdsResModel>> getSearchedAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getSearchedAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, SuggestedAdsResModel>> getSuggestedAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getSuggestedAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }
}
