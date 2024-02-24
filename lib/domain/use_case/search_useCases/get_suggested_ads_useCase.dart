import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/search_models/suggested_ads_res_model.dart';
import 'package:app/domain/entities/serach_entities/get_suggested_ads_entities.dart';
import 'package:app/domain/repo_interface/search_repo/search_interface.dart';
import 'package:dartz/dartz.dart';

class GetSuggestedAdsUseCase implements UseCase<SuggestedAdsResModel, GetSuggestedAdsEntities> {
  GetSuggestedAdsUseCase(this.repository);

  final ISearch repository;

  @override
  Future<Either<Failure, SuggestedAdsResModel>> call(GetSuggestedAdsEntities params) async => await repository.getSuggestedAds(params.toMap());
}
