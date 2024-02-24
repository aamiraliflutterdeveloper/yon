import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/domain/entities/id_with_sort_entities.dart';
import 'package:app/domain/repo_interface/job_repo/jobs_interface.dart';
import 'package:dartz/dartz.dart';

class GetJobsByCategoryUseCase implements UseCase<JobAdsResModel, IdWithSortedByEntities> {
  GetJobsByCategoryUseCase({required this.repository});

  IJobs repository;

  @override
  Future<Either<Failure, JobAdsResModel>> call(IdWithSortedByEntities prams) async => await repository.getJobByCategoryAds(prams.toMap());
}
