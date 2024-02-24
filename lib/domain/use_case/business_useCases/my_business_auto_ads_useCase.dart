import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/domain/entities/sorted_by_entities.dart';
import 'package:app/domain/repo_interface/business_repo/business_interface.dart';
import 'package:dartz/dartz.dart';

class GetMyBusinessAutomotiveAdsUseCase implements UseCase<AutomotiveAdsResModel, SortedByEntities> {
  GetMyBusinessAutomotiveAdsUseCase({required this.repository});

  IBusiness repository;

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> call(SortedByEntities prams) async => await repository.getMyBusinessAutomotiveAds(prams.toMap());
}
