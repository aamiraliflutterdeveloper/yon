import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/auth_res_models/change_pass_res_model.dart';
import 'package:app/domain/entities/auth_entities/reset_pass_entities.dart';
import 'package:app/domain/repo_interface/auth_repo_interface/auth_interface.dart';
import 'package:dartz/dartz.dart';

class ResetPassUseCase implements UseCase<ChangePassResModel, ResetPassEntities> {
  ResetPassUseCase(this.repository);

  final IAuth repository;

  @override
  Future<Either<Failure, ChangePassResModel>> call(ResetPassEntities params) async => await repository.resetPass(params.toMap());
}
