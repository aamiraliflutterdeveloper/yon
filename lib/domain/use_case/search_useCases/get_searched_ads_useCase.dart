import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/search_models/search_ads_res_model.dart';
import 'package:app/domain/entities/serach_entities/search_ads_entities.dart';
import 'package:app/domain/repo_interface/search_repo/search_interface.dart';
import 'package:dartz/dartz.dart';

class GetSearchAdsUseCase implements UseCase<AllAdsResModel, SearchAdsEntities> {
  GetSearchAdsUseCase(this.repository);

  final ISearch repository;

  @override
  Future<Either<Failure, AllAdsResModel>> call(SearchAdsEntities params) async => await repository.getSearchedAds(params.toMap());
}
