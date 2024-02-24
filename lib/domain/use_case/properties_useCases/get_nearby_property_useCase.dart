import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/domain/entities/lat_long_entities.dart';
import 'package:app/domain/repo_interface/properties_repo/properties_interface.dart';
import 'package:dartz/dartz.dart';

class GetNearByPropertyAdsUseCase implements UseCase<PropertyAdsResModel, LatLongEntities> {
  GetNearByPropertyAdsUseCase({required this.repository});

  IProperties repository;

  @override
  Future<Either<Failure, PropertyAdsResModel>> call(LatLongEntities prams) async => await repository.getNearByPropertyAds(prams.toMap());
}
