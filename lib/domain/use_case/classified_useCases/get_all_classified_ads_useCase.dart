import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/domain/entities/page_no_entity.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:dartz/dartz.dart';

class GetClassifiedAllAdsUseCase implements UseCase<ClassifiedAdsResModel, PageNoEntity> {
  GetClassifiedAllAdsUseCase({required this.repository});

  IClassified repository;

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> call(PageNoEntity prams) async => await repository.getClassifiedAllAds(prams.toMap());
}
