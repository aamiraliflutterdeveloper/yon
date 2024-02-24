import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/data/models/user_res_models/get_my_resume_res_model.dart';
import 'package:app/data/remote_data_source/user_api/i_user_api.dart';
import 'package:app/domain/repo_interface/user_repo/user_interface.dart';
import 'package:dartz/dartz.dart';

class UserRepo implements IUser {
  UserRepo({required this.api});

  IUserApi api;

  @override
  Future<Either<Failure, MyResumeResModel>> getMyResumes() async {
    try {
      final result = await api.getMyResumes();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, UserProfileModel>> getUserProfile(Map<String, dynamic> map) async {
    try {
      final result = await api.getUserProfile(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }
}
