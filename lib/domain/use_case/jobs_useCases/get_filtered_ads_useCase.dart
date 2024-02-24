import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/domain/entities/job_entities/job_filter_ads_entities.dart';
import 'package:app/domain/repo_interface/job_repo/jobs_interface.dart';
import 'package:dartz/dartz.dart';

class GetJobFilteredAdsUseCase implements UseCase<JobAdsResModel, JobFilteredAdsEntities> {
  GetJobFilteredAdsUseCase({required this.repository});

  IJobs repository;

  @override
  Future<Either<Failure, JobAdsResModel>> call(JobFilteredAdsEntities prams) async => await repository.getJobFilteredAds(prams.toMap());
}