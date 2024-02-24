

import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/domain/repo_interface/automotive_repo/automotive_interface.dart';
import 'package:dartz/dartz.dart';

class GetAutomotiveFeaturedAdsUseCase implements UseCase<AutomotiveAdsResModel, NoParams> {
  GetAutomotiveFeaturedAdsUseCase({required this.repository});

  IAutomotive repository;

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> call(NoParams prams) async => await repository.getAutomotiveFeaturedAds();
}