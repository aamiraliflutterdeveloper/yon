import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/jobs_res_model/apply_job_res_model.dart';
import 'package:app/domain/entities/job_entities/apply_job_entities.dart';
import 'package:app/domain/repo_interface/job_repo/jobs_interface.dart';
import 'package:dartz/dartz.dart';

class ApplyOnJobUseCase implements UseCase<ApplyJobResModel, ApplyJobEntities> {
  ApplyOnJobUseCase(this.repository);

  final IJobs repository;

  @override
  Future<Either<Failure, ApplyJobResModel>> call(ApplyJobEntities params) async => await repository.applyOnJob(params.toMap());
}
