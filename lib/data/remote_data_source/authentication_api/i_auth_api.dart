import 'package:app/data/models/auth_res_models/change_pass_res_model.dart';
import 'package:app/data/models/auth_res_models/forgot_password_res_model.dart';
import 'package:app/data/models/auth_res_models/login_res_model.dart';
import 'package:app/data/models/auth_res_models/resend_code_res_model.dart';
import 'package:app/data/models/auth_res_models/signUp_res_model.dart';
import 'package:app/data/models/auth_res_models/verify_email_res_model.dart';

abstract class IAuthApi {
  Future<SignUpResModel> signUp(Map<String, dynamic> map);
  Future<LoginResModel> login(Map<String, dynamic> map);
  Future<VerifyEmailResModel> verifyEmail(Map<String, dynamic> map);
  Future<ResendCodeResModel> resendCode(Map<String, dynamic> map);
  Future<ForgotPassResModel> forgotPassword(Map<String, dynamic> map);
  Future<ChangePassResModel> changePassword(Map<String, dynamic> map);
  Future<ChangePassResModel> resetPassword(Map<String, dynamic> map);
  Future<LoginResModel> googleLogin(Map<String, dynamic> map);
}
