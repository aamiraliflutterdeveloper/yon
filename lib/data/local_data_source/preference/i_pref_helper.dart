import 'package:app/data/models/business_module_models/get_business_profiles_models.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IPrefHelper {
  SharedPreferences get();

  String? retrieveToken();

  void saveToken(value);

  String? userCurrentCountry();

  void saveUserCurrentCountry(value);

  String? userCurrentCity();

  void saveUserCurrentCity(value);

  void setIsOnboarded(bool isOnboarded);

  bool? getIsOnboarded();

  void setBusinessMode(bool isBusinessMode);

  bool? isBusinessModeOn();

  void setIsLoggedIn(bool isLoggedIn);

  bool? getIsLoggedIn();

  void removeToken();

  void saveResentSearches(List<String> resentSearches);

  List<String>? retrieveResentSearches();

  void saveUser(UserProfileModel user);

  UserProfileModel? retrieveUser();

  void saveClassifiedProfile(BusinessProfileModel classifiedProfile);

  BusinessProfileModel? retrieveClassifiedProfile();

  void saveAutomotiveProfile(BusinessProfileModel automotiveProfile);

  BusinessProfileModel? retrieveAutomotiveProfile();

  void savePropertyProfile(BusinessProfileModel propertyProfile);

  BusinessProfileModel? retrievePropertyProfile();

  void saveJobProfile(BusinessProfileModel jobProfile);

  BusinessProfileModel? retrieveJobProfile();

  void clear();
}
