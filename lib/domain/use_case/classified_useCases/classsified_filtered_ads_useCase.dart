import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/domain/entities/classified_entities/filter_ads_entities.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:dartz/dartz.dart';

class ClassifiedFilteredAdsUseCase implements UseCase<ClassifiedAdsResModel, ClassifiedFilterAdsEntities> {
  ClassifiedFilteredAdsUseCase(this.repository);

  final IClassified repository;

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> call(ClassifiedFilterAdsEntities params) async => await repository.getClassifiedFilteredAds(params.toMap());
}
