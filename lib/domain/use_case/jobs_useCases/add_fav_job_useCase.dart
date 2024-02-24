import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/domain/entities/id_entites.dart';
import 'package:app/domain/repo_interface/job_repo/jobs_interface.dart';
import 'package:dartz/dartz.dart';

class AddFavJobUseCase implements UseCase<MessageResModel, IdEntities> {
  AddFavJobUseCase(this.repository);

  final IJobs repository;

  @override
  Future<Either<Failure, MessageResModel>> call(IdEntities params) async => await repository.addFavJob(params.toMap());
}