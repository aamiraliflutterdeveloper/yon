import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/jobs_res_model/job_categories_res_model.dart';
import 'package:app/domain/repo_interface/job_repo/jobs_interface.dart';
import 'package:dartz/dartz.dart';

class GetAllJobsCategoryUseCase implements UseCase<JobCategoriesResModel, NoParams> {
  GetAllJobsCategoryUseCase({required this.repository});

  IJobs repository;

  @override
  Future<Either<Failure, JobCategoriesResModel>> call(NoParams prams) async => await repository.getJobsCategories();
}