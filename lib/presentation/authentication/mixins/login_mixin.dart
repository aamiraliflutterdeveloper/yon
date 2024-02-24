import 'package:app/di/service_locator.dart';
import 'package:app/domain/repo_interface/auth_repo_interface/auth_interface.dart';
import 'package:flutter/material.dart';

mixin LoginMixin<T extends StatefulWidget> on State<T> {
  IAuth repo = inject<IAuth>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController forgotPassEmailController = TextEditingController();

  final emailKey = GlobalKey();
  final passKey = GlobalKey();
  final signInFormKey = GlobalKey<FormState>();
  final forgotPassEmailKey = GlobalKey();
  final forPassEmailFormKey = GlobalKey<FormState>();

  bool get validate => signInFormKey.currentState!.validate();
}
