

import 'package:app/common/logger/log.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/data/models/model_objects/user_profile_object.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier{
  UserProfileModel? user;

  changeUserData(UserProfileModel updatedUserData){
    user = updatedUserData;
    d('UPDATED USER : '+ user.toString());
    notifyListeners();
  }


}