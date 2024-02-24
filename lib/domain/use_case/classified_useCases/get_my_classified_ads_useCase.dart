import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/domain/entities/sorted_by_entities.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:dartz/dartz.dart';

class GetMyClassifiedAdsUseCase implements UseCase<ClassifiedAdsResModel, SortedByEntities> {
  GetMyClassifiedAdsUseCase({required this.repository});

  IClassified repository;

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> call(SortedByEntities prams) async => await repository.getMyClassifiedAds(prams.toMap());
}
