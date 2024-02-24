import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/auth_res_models/forgot_password_res_model.dart';
import 'package:app/domain/entities/auth_entities/forgot_pass_entities.dart';
import 'package:app/domain/repo_interface/auth_repo_interface/auth_interface.dart';
import 'package:dartz/dartz.dart';

class ForgotPassUseCase implements UseCase<ForgotPassResModel, ForgotPassEntities> {
  ForgotPassUseCase(this.repository);

  final IAuth repository;

  @override
  Future<Either<Failure, ForgotPassResModel>> call(ForgotPassEntities params) async => await repository.forgotPass(params.toMap());
}