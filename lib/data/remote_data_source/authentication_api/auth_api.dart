import 'dart:convert';
import 'package:app/application/core/exceptions/exception.dart';
import 'package:app/application/network/client/iApiService.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/auth_res_models/change_pass_res_model.dart';
import 'package:app/data/models/auth_res_models/facebook_user_res_model.dart';
import 'package:app/data/models/auth_res_models/forgot_password_res_model.dart';
import 'package:app/data/models/auth_res_models/login_res_model.dart';
import 'package:app/data/models/auth_res_models/resend_code_res_model.dart';
import 'package:app/data/models/auth_res_models/signUp_res_model.dart';
import 'package:app/data/models/auth_res_models/verify_email_res_model.dart';
import 'package:app/data/remote_data_source/authentication_api/i_auth_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthApi implements IAuthApi {
  AuthApi(IApiService api) : dio = api.get();
  Dio dio;

  @override
  Future<SignUpResModel> signUp(Map<String, dynamic> map) async {
    try {
      d('map : $map');
      final responseData = await dio.post("", data: map);
      return SignUpResModel.fromJson(responseData.data);
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
  Future<LoginResModel> login(Map<String, dynamic> map) async {
    try {
      d('map : $map');
      final responseData = await dio.post("", data: map);
      return LoginResModel.fromJson(responseData.data);
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
  Future<VerifyEmailResModel> verifyEmail(Map<String, dynamic> map) async {
    try {
      d('map : $map');
      String email = map['email'].toString().replaceAll('%40', '@');
      d('EMAIL: $email');
      final responseData = await dio.post("", data: {
        'email': email,
        'code': map['code'],
      });
      return VerifyEmailResModel.fromJson(responseData.data);
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
  Future<ResendCodeResModel> resendCode(Map<String, dynamic> map) async {
    try {
      d('map : $map');
      final responseData = await dio.post("", data: map);
      return ResendCodeResModel.fromJson(responseData.data);
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
  Future<ForgotPassResModel> forgotPassword(Map<String, dynamic> map) async {
    try {
      d('map : $map');
      final responseData = await dio.post("", data: map);
      return ForgotPassResModel.fromJson(responseData.data);
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
  Future<ChangePassResModel> changePassword(Map<String, dynamic> map) async {
    try {
      d('map : $map');
      final responseData = await dio.post("", data: map);
      return ChangePassResModel.fromJson(responseData.data);
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
  Future<LoginResModel> googleLogin(Map<String, dynamic> map) async {
    try {
      Map<String, dynamic> _map = {};
      if (map['platform'] == 'Google') {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        d('GOOGLE : USER : $googleUser');
        _map = {
          'first_name': googleUser!.displayName.toString(),
          'social_platform': 'Google',
          'email': googleUser.email,
        };
      } else if (map['platform'] == 'Facebook') {
        final LoginResult loginResult = await FacebookAuth.instance.login();
        d('LoginResult :: $LoginResult');
        var fbRes = await dio.get(
            '');
        FacebookUserResModel response = FacebookUserResModel.fromJson(json.decode(fbRes.data));
        _map = {
          'first_name': response.name,
          'social_platform': 'Facebook',
          'email': response.email,
        };
        await FacebookAuth.instance.logOut();
      }
      d('MODEL : $_map');
      final responseData = await dio.post("", data: _map);
      print(responseData.data);
      return LoginResModel.fromJson(responseData.data);
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
  Future<ChangePassResModel> resetPassword(Map<String, dynamic> map) async {
    try {
      d('map : $map');
      final responseData = await dio.post("/api/reset_password/", data: map);
      return ChangePassResModel.fromJson(responseData.data);
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
