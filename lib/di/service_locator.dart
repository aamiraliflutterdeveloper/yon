import 'package:app/application/network/client/api_service.dart';
import 'package:app/application/network/client/iApiService.dart';
import 'package:app/application/network/external_values/ExternalValues.dart';
import 'package:app/application/network/external_values/IExternalValues.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/local_data_source/preference/pref_helper.dart';
import 'package:app/data/remote_data_source/authentication_api/auth_api.dart';
import 'package:app/data/remote_data_source/authentication_api/i_auth_api.dart';
import 'package:app/data/remote_data_source/automotive_api/automotive_api.dart';
import 'package:app/data/remote_data_source/automotive_api/i_automotive_api.dart';
import 'package:app/data/remote_data_source/business_api/business_api.dart';
import 'package:app/data/remote_data_source/business_api/i_business_api.dart';
import 'package:app/data/remote_data_source/classified_api/classified_api.dart';
import 'package:app/data/remote_data_source/classified_api/i_classified_api.dart';
import 'package:app/data/remote_data_source/general_api/general_api.dart';
import 'package:app/data/remote_data_source/general_api/i_general_api.dart';
import 'package:app/data/remote_data_source/jobs_api/i_job_api.dart';
import 'package:app/data/remote_data_source/jobs_api/job_api.dart';
import 'package:app/data/remote_data_source/notifications_api/i_notification_api.dart';
import 'package:app/data/remote_data_source/notifications_api/notification_api.dart';
import 'package:app/data/remote_data_source/properties_api/i_properties_api.dart';
import 'package:app/data/remote_data_source/properties_api/properties_api.dart';
import 'package:app/data/remote_data_source/search/i_search_api.dart';
import 'package:app/data/remote_data_source/search/search_api.dart';
import 'package:app/data/remote_data_source/user_api/i_user_api.dart';
import 'package:app/data/remote_data_source/user_api/user_api.dart';
import 'package:app/data/repo_impl/auth_repo_impl/authRepo_impl.dart';
import 'package:app/data/repo_impl/automotive_repo_impl/automotive_repo_impl.dart';
import 'package:app/data/repo_impl/business_impl/business_repo_impl.dart';
import 'package:app/data/repo_impl/classified_repo_impl/classifiedRepo_impl.dart';
import 'package:app/data/repo_impl/general_repo_impl/general_repo_impl.dart';
import 'package:app/data/repo_impl/jobs_impl/jobs_impl.dart';
import 'package:app/data/repo_impl/notification_impl/notification_impl.dart';
import 'package:app/data/repo_impl/properties_impl/properties_impl.dart';
import 'package:app/data/repo_impl/search_impl/search_impl.dart';
import 'package:app/data/repo_impl/user_impl/user_impl.dart';
import 'package:app/domain/repo_interface/auth_repo_interface/auth_interface.dart';
import 'package:app/domain/repo_interface/automotive_repo/automotive_interface.dart';
import 'package:app/domain/repo_interface/business_repo/business_interface.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:app/domain/repo_interface/general_repo/general_interface.dart';
import 'package:app/domain/repo_interface/job_repo/jobs_interface.dart';
import 'package:app/domain/repo_interface/notification_repo/notification_interface.dart';
import 'package:app/domain/repo_interface/properties_repo/properties_interface.dart';
import 'package:app/domain/repo_interface/search_repo/search_interface.dart';
import 'package:app/domain/repo_interface/user_repo/user_interface.dart';
import 'package:app/presentation/utils/overlay_utils.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final inject = GetIt.instance;

Future<void> setupLocator() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // inject.registerSingletonAsync(() => SharedPreferences.getInstance());
  //Utils
  inject.registerLazySingleton<IPrefHelper>(() => PrefHelper(sharedPreferences));
  inject.registerLazySingleton<OverlyHelper>(() => OverlyHelper());
  //api clients
  inject.registerLazySingleton<IApiService>(() => ApiService.create(externalValues: ExternalValues()));

  inject.registerLazySingleton<IExternalValues>(() => ExternalValues());

  inject.registerLazySingleton<IAuthApi>(() => AuthApi(inject()));
  inject.registerLazySingleton<IAuth>(() => AuthRepo(api: inject()));

  inject.registerLazySingleton<IClassifiedApi>(() => ClassifiedApi(inject()));
  inject.registerLazySingleton<IClassified>(() => ClassifiedRepo(api: inject()));

  inject.registerLazySingleton<IAutomotiveApi>(() => AutomotiveApi(inject()));
  inject.registerLazySingleton<IAutomotive>(() => AutomotiveRepo(api: inject()));

  inject.registerLazySingleton<IPropertiesApi>(() => PropertiesApi(inject()));
  inject.registerLazySingleton<IProperties>(() => PropertiesRepo(api: inject()));

  inject.registerLazySingleton<IJobApi>(() => JobApi(inject()));
  inject.registerLazySingleton<IJobs>(() => JobsRepo(api: inject()));

  inject.registerLazySingleton<IGeneralApi>(() => GeneralApi(inject()));
  inject.registerLazySingleton<IGeneral>(() => GeneralRepo(api: inject()));

  inject.registerLazySingleton<ISearchApi>(() => SearchApi(inject()));
  inject.registerLazySingleton<ISearch>(() => SearchRepo(api: inject()));

  inject.registerLazySingleton<IBusinessApi>(() => BusinessApi(inject()));
  inject.registerLazySingleton<IBusiness>(() => BusinessRepo(api: inject()));

  inject.registerLazySingleton<IUserApi>(() => UserApi(inject()));
  inject.registerLazySingleton<IUser>(() => UserRepo(api: inject()));

  inject.registerLazySingleton<INotificationApi>(() => NotificationApi(inject()));
  inject.registerLazySingleton<INotification>(() => NotificationRepo(api: inject()));
}
