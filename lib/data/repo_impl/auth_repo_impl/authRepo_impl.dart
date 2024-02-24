import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/data/models/auth_res_models/change_pass_res_model.dart';
import 'package:app/data/models/auth_res_models/forgot_password_res_model.dart';
import 'package:app/data/models/auth_res_models/login_res_model.dart';
import 'package:app/data/models/auth_res_models/resend_code_res_model.dart';
import 'package:app/data/models/auth_res_models/signUp_res_model.dart';
import 'package:app/data/models/auth_res_models/verify_email_res_model.dart';
import 'package:app/data/remote_data_source/authentication_api/i_auth_api.dart';
import 'package:app/domain/repo_interface/auth_repo_interface/auth_interface.dart';
import 'package:dartz/dartz.dart';

class AuthRepo implements IAuth {
  AuthRepo({required this.api});

  IAuthApi api;

  @override
  Future<Either<Failure, SignUpResModel>> signUp(Map<String, dynamic> map) async {
    try {
      final result = await api.signUp(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, LoginResModel>> login(Map<String, dynamic> map) async {
    try {
      final result = await api.login(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, VerifyEmailResModel>> verifyEmail(Map<String, dynamic> map) async {
    try {
      final result = await api.verifyEmail(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ResendCodeResModel>> resendCode(Map<String, dynamic> map) async {
    try {
      final result = await api.resendCode(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ForgotPassResModel>> forgotPass(Map<String, dynamic> map) async {
    try {
      final result = await api.forgotPassword(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ChangePassResModel>> changePass(Map<String, dynamic> map) async {
    try {
      final result = await api.changePassword(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, LoginResModel>> googleLogin(Map<String, dynamic> map) async {
    try {
      final result = await api.googleLogin(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ChangePassResModel>> resetPass(Map<String, dynamic> map) async {
    try {
      final result = await api.resetPassword(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }
}
