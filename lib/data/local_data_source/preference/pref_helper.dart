import 'dart:convert';

import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/models/business_module_models/get_business_profiles_models.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper implements IPrefHelper {
  late final SharedPreferences _pref;

  PrefHelper(SharedPreferences preferences) : _pref = preferences;

  @override
  void clear() {
    _pref.clear();
  }

  @override
  SharedPreferences get() {
    return _pref;
  }

  @override
  void removeToken() {
    _pref.remove('userToken');
  }

  @override
  String? retrieveToken() {
    if (_pref.containsKey("userToken")) {
      return _pref.getString("userToken");
    } else {
      return null;
    }
  }

  @override
  void saveToken(value) {
    _pref.setString("userToken", value);
  }

  @override
  bool? getIsOnboarded() {
    if (_pref.containsKey("isOnboarded")) {
      return _pref.getBool("isOnboarded");
    } else {
      return false;
    }
  }

  @override
  void setIsOnboarded(bool isOnboarded) {
    _pref.setBool('isOnboarded', isOnboarded);
  }

  @override
  bool? getIsLoggedIn() {
    if (_pref.containsKey("isLoggedIn")) {
      return _pref.getBool("isLoggedIn");
    } else {
      return false;
    }
  }

  @override
  void setIsLoggedIn(bool isLoggedIn) {
    _pref.setBool('isLoggedIn', isLoggedIn);
  }

  @override
  void saveUser(UserProfileModel user) {
    _pref.setString("user_data", json.encode(user.toJson()));
  }

  @override
  UserProfileModel? retrieveUser() {
    if (_pref.containsKey("user_data")) {
      Map<String, dynamic> _json = json.decode(_pref.getString("user_data")!);
      return UserProfileModel.fromJson(_json);
    } else {
      return null;
    }
  }

  @override
  List<String>? retrieveResentSearches() {
    if (_pref.containsKey("resentSearch")) {
      return _pref.getStringList("resentSearch");
    } else {
      return <String>[];
    }
  }

  @override
  void saveResentSearches(List<String> resentSearches) {
    _pref.setStringList("resentSearch", resentSearches);
  }

  @override
  bool? isBusinessModeOn() {
    if (_pref.containsKey("isBusinessMode")) {
      return _pref.getBool("isBusinessMode");
    } else {
      return false;
    }
  }

  @override
  void setBusinessMode(bool isBusinessMode) {
    _pref.setBool('isBusinessMode', isBusinessMode);
  }

  @override
  BusinessProfileModel? retrieveAutomotiveProfile() {
    if (_pref.containsKey("automotiveProfile")) {
      Map<String, dynamic> _json = json.decode(_pref.getString("automotiveProfile")!);
      return BusinessProfileModel.fromJson(_json);
    } else {
      return null;
    }
  }

  @override
  BusinessProfileModel? retrieveClassifiedProfile() {
    if (_pref.containsKey("classifiedProfile")) {
      Map<String, dynamic> _json = json.decode(_pref.getString("classifiedProfile")!);
      return BusinessProfileModel.fromJson(_json);
    } else {
      return null;
    }
  }

  @override
  BusinessProfileModel? retrieveJobProfile() {
    if (_pref.containsKey("jobProfile")) {
      Map<String, dynamic> _json = json.decode(_pref.getString("jobProfile")!);
      return BusinessProfileModel.fromJson(_json);
    } else {
      return null;
    }
  }

  @override
  BusinessProfileModel? retrievePropertyProfile() {
    if (_pref.containsKey("propertyProfile")) {
      Map<String, dynamic> _json = json.decode(_pref.getString("propertyProfile")!);
      return BusinessProfileModel.fromJson(_json);
    } else {
      return null;
    }
  }

  @override
  void saveAutomotiveProfile(BusinessProfileModel automotiveProfile) {
    _pref.setString("automotiveProfile", json.encode(automotiveProfile.toJson()));
  }

  @override
  void saveClassifiedProfile(BusinessProfileModel classifiedProfile) {
    _pref.setString("classifiedProfile", json.encode(classifiedProfile.toJson()));
  }

  @override
  void saveJobProfile(BusinessProfileModel jobProfile) {
    _pref.setString("jobProfile", json.encode(jobProfile.toJson()));
  }

  @override
  void savePropertyProfile(BusinessProfileModel propertyProfile) {
    _pref.setString("propertyProfile", json.encode(propertyProfile.toJson()));
  }

  @override
  void saveUserCurrentCountry(value) {
    _pref.setString("userCountry", value);
  }

  @override
  String? userCurrentCountry() {
    if (_pref.containsKey("userCountry")) {
      return _pref.getString("userCountry");
    } else {
      return null;
    }
  }

  @override
  void saveUserCurrentCity(value) {
    _pref.setString("userCity", value);
  }

  @override
  String? userCurrentCity() {
    if (_pref.containsKey("userCity")) {
      return _pref.getString("userCity");
    } else {
      return null;
    }
  }
}
