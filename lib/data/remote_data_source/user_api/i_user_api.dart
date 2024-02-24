import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/data/models/user_res_models/get_my_resume_res_model.dart';

abstract class IUserApi {
  Future<MyResumeResModel> getMyResumes();
  Future<UserProfileModel> getUserProfile(Map<String, dynamic> map);
}
