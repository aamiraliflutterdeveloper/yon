import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/domain/entities/id_entites.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:dartz/dartz.dart';

class DeleteFavClassifiedUseCase implements UseCase<MessageResModel, IdEntities> {
  DeleteFavClassifiedUseCase(this.repository);

  final IClassified repository;

  @override
  Future<Either<Failure, MessageResModel>> call(IdEntities params) async => await repository.deleteFavClassified(params.toMap());
}
