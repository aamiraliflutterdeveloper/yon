import 'package:app/application/core/failure/failure.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/data/models/user_res_models/get_my_resume_res_model.dart';
import 'package:dartz/dartz.dart';

abstract class IUser {
  Future<Either<Failure, MyResumeResModel>> getMyResumes();
  Future<Either<Failure, UserProfileModel>> getUserProfile(Map<String, dynamic> map);
}
