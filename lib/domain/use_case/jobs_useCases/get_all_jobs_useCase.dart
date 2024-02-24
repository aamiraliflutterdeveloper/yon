import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/domain/entities/page_no_entity.dart';
import 'package:app/domain/repo_interface/job_repo/jobs_interface.dart';
import 'package:dartz/dartz.dart';

class GetJobAllAdsUseCase implements UseCase<JobAdsResModel, PageNoEntity> {
  GetJobAllAdsUseCase({required this.repository});

  IJobs repository;

  @override
  Future<Either<Failure, JobAdsResModel>> call(PageNoEntity prams) async => await repository.getJobAllAds(prams.toMap());
}
