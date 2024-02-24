import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/user_res_models/get_my_resume_res_model.dart';
import 'package:app/domain/repo_interface/user_repo/user_interface.dart';
import 'package:dartz/dartz.dart';

class GetMyResumeUseCase implements UseCase<MyResumeResModel, NoParams> {
  GetMyResumeUseCase(this.repository);

  final IUser repository;

  @override
  Future<Either<Failure, MyResumeResModel>> call(NoParams params) async => await repository.getMyResumes();
}
