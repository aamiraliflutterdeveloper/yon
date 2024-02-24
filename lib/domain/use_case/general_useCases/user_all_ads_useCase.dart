import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/search_models/search_ads_res_model.dart';
import 'package:app/domain/entities/id_entites.dart';
import 'package:app/domain/repo_interface/general_repo/general_interface.dart';
import 'package:dartz/dartz.dart';

class GetUserAllAdsUseCase implements UseCase<AllAdsResModel, IdEntities> {
  GetUserAllAdsUseCase({required this.repository});

  IGeneral repository;

  @override
  Future<Either<Failure, AllAdsResModel>> call(IdEntities prams) async => await repository.getUserAllAds(prams.toMap());
}
