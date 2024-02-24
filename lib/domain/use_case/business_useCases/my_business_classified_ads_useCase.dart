import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/domain/entities/sorted_by_entities.dart';
import 'package:app/domain/repo_interface/business_repo/business_interface.dart';
import 'package:dartz/dartz.dart';

class GetMyBusinessClassifiedAdsUseCase implements UseCase<ClassifiedAdsResModel, SortedByEntities> {
  GetMyBusinessClassifiedAdsUseCase({required this.repository});

  IBusiness repository;

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> call(SortedByEntities prams) async => await repository.getMyBusinessClassifiedAds(prams.toMap());
}
