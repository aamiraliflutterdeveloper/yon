import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/domain/entities/automotive_entities/auto_filter_ads_entities.dart';
import 'package:app/domain/repo_interface/automotive_repo/automotive_interface.dart';
import 'package:dartz/dartz.dart';

class GetAutomotiveFilteredAdsUseCase implements UseCase<AutomotiveAdsResModel, AutoFilteredAdsEntities> {
  GetAutomotiveFilteredAdsUseCase({required this.repository});

  IAutomotive repository;

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> call(AutoFilteredAdsEntities prams) async => await repository.getAutomotiveFilteredAds(prams.toMap());
}
