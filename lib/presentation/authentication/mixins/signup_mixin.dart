import 'package:app/di/service_locator.dart';
import 'package:app/domain/repo_interface/auth_repo_interface/auth_interface.dart';
import 'package:flutter/material.dart';

mixin SignUpMixin<T extends StatefulWidget> on State<T> {
  IAuth repo = inject<IAuth>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final signupFormKey = GlobalKey<FormState>();

  bool isAgree = false;

  bool get validate => signupFormKey.currentState!.validate();
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
