import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/domain/entities/id_entites.dart';
import 'package:app/domain/repo_interface/properties_repo/properties_interface.dart';
import 'package:dartz/dartz.dart';

class AddFavPropertyUseCase implements UseCase<MessageResModel, IdEntities> {
  AddFavPropertyUseCase(this.repository);

  final IProperties repository;

  @override
  Future<Either<Failure, MessageResModel>> call(IdEntities params) async => await repository.addFavProperty(params.toMap());
}