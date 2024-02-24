import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/domain/entities/lat_long_entities.dart';
import 'package:app/domain/repo_interface/automotive_repo/automotive_interface.dart';
import 'package:dartz/dartz.dart';

class GetNearByAutomotiveUseCase implements UseCase<AutomotiveAdsResModel, LatLongEntities> {
  GetNearByAutomotiveUseCase({required this.repository});

  IAutomotive repository;

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> call(LatLongEntities prams) async => await repository.getNearByAutomotiveAds(prams.toMap());
}
