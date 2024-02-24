import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/domain/entities/id_with_sort_entities.dart';
import 'package:app/domain/repo_interface/properties_repo/properties_interface.dart';
import 'package:dartz/dartz.dart';

class GetPropertiesAdsByCategoryUseCase implements UseCase<PropertyAdsResModel, IdWithSortedByEntities> {
  GetPropertiesAdsByCategoryUseCase({required this.repository});

  IProperties repository;

  @override
  Future<Either<Failure, PropertyAdsResModel>> call(IdWithSortedByEntities prams) async => await repository.getPropertyByCategoryAds(prams.toMap());
}
