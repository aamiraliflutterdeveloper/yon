import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/domain/entities/sorted_by_entities.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:dartz/dartz.dart';

class GetMyFavClassifiedUseCase implements UseCase<ClassifiedAdsResModel, SortedByEntities> {
  GetMyFavClassifiedUseCase(this.repository);

  final IClassified repository;

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> call(SortedByEntities params) async => await repository.getFavClassifiedAds(params.toMap());
}
