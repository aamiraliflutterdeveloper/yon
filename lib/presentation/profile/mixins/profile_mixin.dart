import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


mixin ProfileMixin<T extends StatefulWidget> on State<T> {
  bool isPhoneNumberOnAds = false;
  bool isSpecialOffers = false;
  bool isRecommendations = false;

  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController emailController = TextEditingController();
}
