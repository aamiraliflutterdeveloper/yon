import 'package:app/application/core/exceptions/exception.dart';
import 'package:app/application/network/client/iApiService.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/data/models/user_res_models/get_my_resume_res_model.dart';
import 'package:app/data/remote_data_source/user_api/i_user_api.dart';
import 'package:dio/dio.dart';

class UserApi implements IUserApi {
  UserApi(IApiService api) : dio = api.get();
  Dio dio;

  @override
  Future<MyResumeResModel> getMyResumes() async {
    try {
      final responseData = await dio.get("");
      return MyResumeResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }

  @override
  Future<UserProfileModel> getUserProfile(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("", queryParameters: map);
      return UserProfileModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }
}
