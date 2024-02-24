import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/domain/entities/id_entites.dart';
import 'package:app/domain/repo_interface/automotive_repo/automotive_interface.dart';
import 'package:dartz/dartz.dart';

class DeleteFavAutoUseCase implements UseCase<MessageResModel, IdEntities> {
  DeleteFavAutoUseCase(this.repository);

  final IAutomotive repository;

  @override
  Future<Either<Failure, MessageResModel>> call(IdEntities params) async => await repository.deleteFavAutomotive(params.toMap());
}
