import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/domain/entities/visited_profile_entity.dart';
import 'package:app/domain/repo_interface/user_repo/user_interface.dart';
import 'package:dartz/dartz.dart';

class GetUserProfileUseCase implements UseCase<UserProfileModel, VisitedProfileEntity> {
  GetUserProfileUseCase(this.repository);

  final IUser repository;

  @override
  Future<Either<Failure, UserProfileModel>> call(VisitedProfileEntity params) async => await repository.getUserProfile(params.toMap());
}
