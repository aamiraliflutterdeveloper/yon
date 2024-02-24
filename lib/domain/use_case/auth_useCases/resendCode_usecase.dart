import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/auth_res_models/resend_code_res_model.dart';
import 'package:app/domain/entities/auth_entities/resendCode_entities.dart';
import 'package:app/domain/repo_interface/auth_repo_interface/auth_interface.dart';
import 'package:dartz/dartz.dart';

class ResendCodeUseCase implements UseCase<ResendCodeResModel, ResendCodeEntities> {
  ResendCodeUseCase(this.repository);

  final IAuth repository;

  @override
  Future<Either<Failure, ResendCodeResModel>> call(ResendCodeEntities params) async => await repository.resendCode(params.toMap());
}