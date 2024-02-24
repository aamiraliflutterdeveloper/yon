import 'package:app/application/core/failure/failure.dart';
import 'package:app/data/models/auth_res_models/change_pass_res_model.dart';
import 'package:app/data/models/auth_res_models/forgot_password_res_model.dart';
import 'package:app/data/models/auth_res_models/login_res_model.dart';
import 'package:app/data/models/auth_res_models/resend_code_res_model.dart';
import 'package:app/data/models/auth_res_models/signUp_res_model.dart';
import 'package:app/data/models/auth_res_models/verify_email_res_model.dart';
import 'package:dartz/dartz.dart';

abstract class IAuth {
  Future<Either<Failure, SignUpResModel>> signUp(Map<String, dynamic> map);
  Future<Either<Failure, LoginResModel>> login(Map<String, dynamic> map);
  Future<Either<Failure, VerifyEmailResModel>> verifyEmail(Map<String, dynamic> map);
  Future<Either<Failure, ResendCodeResModel>> resendCode(Map<String, dynamic> map);
  Future<Either<Failure, ForgotPassResModel>> forgotPass(Map<String, dynamic> map);
  Future<Either<Failure, ChangePassResModel>> changePass(Map<String, dynamic> map);
  Future<Either<Failure, ChangePassResModel>> resetPass(Map<String, dynamic> map);
  Future<Either<Failure, LoginResModel>> googleLogin(Map<String, dynamic> map);
}




