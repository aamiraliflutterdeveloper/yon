import 'package:app/application/core/failure/failure.dart';
import 'package:app/data/models/search_models/search_ads_res_model.dart';
import 'package:app/data/models/search_models/suggested_ads_res_model.dart';
import 'package:dartz/dartz.dart';

abstract class ISearch {
  Future<Either<Failure, AllAdsResModel>> getSearchedAds(Map<String, dynamic> map);
  Future<Either<Failure, SuggestedAdsResModel>> getSuggestedAds(Map<String, dynamic> map);
}
