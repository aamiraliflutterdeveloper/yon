import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/auth_res_models/login_res_model.dart';
import 'package:app/domain/entities/auth_entities/login_entities.dart';
import 'package:app/domain/repo_interface/auth_repo_interface/auth_interface.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements UseCase<LoginResModel, LoginEntities> {
  LoginUseCase(this.repository);

  final IAuth repository;

  @override
  Future<Either<Failure, LoginResModel>> call(LoginEntities params) async => await repository.login(params.toMap());
}
