import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/auth_res_models/signUp_res_model.dart';
import 'package:app/domain/entities/auth_entities/signup_entities.dart';
import 'package:app/domain/repo_interface/auth_repo_interface/auth_interface.dart';
import 'package:dartz/dartz.dart';

class SignupUseCase implements UseCase<SignUpResModel, SignUpEntities> {
  SignupUseCase(this.repository);

  final IAuth repository;

  @override
  Future<Either<Failure, SignUpResModel>> call(SignUpEntities params) async => await repository.signUp(params.toMap());
}
