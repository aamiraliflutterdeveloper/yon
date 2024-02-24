


import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/auth_res_models/verify_email_res_model.dart';
import 'package:app/domain/entities/auth_entities/verify_email_entities.dart';
import 'package:app/domain/repo_interface/auth_repo_interface/auth_interface.dart';
import 'package:dartz/dartz.dart';

class VerifyEmailUseCase implements UseCase<VerifyEmailResModel, VerifyEmailEntities> {
  VerifyEmailUseCase(this.repository);

  final IAuth repository;

  @override
  Future<Either<Failure, VerifyEmailResModel>> call(VerifyEmailEntities params) async => await repository.verifyEmail(params.toMap());
}