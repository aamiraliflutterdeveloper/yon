import 'dart:convert';
import 'dart:io';

import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/application/network/external_values/IExternalValues.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/business_module_models/get_business_profiles_models.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/data/models/search_models/search_ads_res_model.dart';
import 'package:app/data/models/user_res_models/get_my_resume_res_model.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/domain/entities/id_entites.dart';
import 'package:app/domain/entities/sorted_by_entities.dart';
import 'package:app/domain/entities/visited_profile_entity.dart';
import 'package:app/domain/repo_interface/automotive_repo/automotive_interface.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:app/domain/repo_interface/general_repo/general_interface.dart';
import 'package:app/domain/repo_interface/job_repo/jobs_interface.dart';
import 'package:app/domain/repo_interface/properties_repo/properties_interface.dart';
import 'package:app/domain/repo_interface/user_repo/user_interface.dart';
import 'package:app/domain/use_case/automotive_useCases/automotive_active_inactive_useCase.dart';
import 'package:app/domain/use_case/automotive_useCases/delete_automotive_useCase.dart';
import 'package:app/domain/use_case/automotive_useCases/get_my_automotive_useCase.dart';
import 'package:app/domain/use_case/automotive_useCases/get_my_fav_automotive_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/delete_classified_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/get_my_classified_ads_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/get_my_fav_classified_useCase.dart';
import 'package:app/domain/use_case/general_useCases/user_all_ads_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/delete_job_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/get_my_fav_job_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/get_my_jobs_ads_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/job_active_inactive_useCase.dart';
import 'package:app/domain/use_case/properties_useCases/delete_property_useCase.dart';
import 'package:app/domain/use_case/properties_useCases/get_my_fav_property_useCase.dart';
import 'package:app/domain/use_case/properties_useCases/get_my_properties_ads_useCase.dart';
import 'package:app/domain/use_case/properties_useCases/property_active_inactive_useCase.dart';
import 'package:app/domain/use_case/user_useCases/get_my_resumes_useCase.dart';
import 'package:app/domain/use_case/user_useCases/get_user_profile_useCase.dart';
import 'package:app/presentation/profile/business_mode/view_model/business_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfileViewModel extends ChangeNotifier {
  IPrefHelper iPrefHelper = inject<IPrefHelper>();
  IExternalValues iExternalValues = inject<IExternalValues>();
  IClassified classifiedRepo = inject<IClassified>();
  IAutomotive autoRepo = inject<IAutomotive>();
  IProperties propertiesRepo = inject<IProperties>();
  IJobs jobsRepo = inject<IJobs>();
  IUser userRepo = inject<IUser>();
  IGeneral generalRepo = inject<IGeneral>();

  List<AutomotiveProductModel> userAutomotiveAds = [];
  List<PropertyProductModel> userPropertyAds = [];
  List<ClassifiedProductModel> userClassifiedAds = [];
  List<JobProductModel> userJobAds = [];

  int allClassifiedTotalPages = 1;
  int autoAllAdsTotalPages = 1;
  int allPropertiesTotalPages = 1;
  int allJobTotalPages = 1;

  changeUserAllAds(
      {required List<AutomotiveProductModel> automotiveAds,
      required List<PropertyProductModel> propertyAds,
      required List<ClassifiedProductModel> classifiedAds,
      required List<JobProductModel> jobAds}) {
    userAutomotiveAds = automotiveAds;
    userPropertyAds = propertyAds;
    userClassifiedAds = classifiedAds;
    userJobAds = jobAds;
    d('userAutomotiveAds : $userAutomotiveAds');
    d('userPropertyAds : $userPropertyAds');
    d('userClassifiedAds : $userClassifiedAds');
    d('userJobAds : $userJobAds');
  }

  Future<Either<Failure, AllAdsResModel>> getUserAllAds(
      {required String userId}) async {
    final userAllAds = GetUserAllAdsUseCase(repository: generalRepo);
    final result = await userAllAds(IdEntities(id: userId));
    return result;
  }

  UserProfileModel myProfile = UserProfileModel();

  changeMyProfile(UserProfileModel profile) {
    myProfile = profile;
    notifyListeners();
  }

  Future<Either<Failure, UserProfileModel>> getUserProfile(
      {required String userId}) async {
    final userProfile = GetUserProfileUseCase(userRepo);
    final result = userProfile(VisitedProfileEntity(userId: userId));
    return result;
  }

  int allClassifiedPageNo = 1;

  changeAllClassifiedPageNo(int pageNo) {
    allClassifiedPageNo = pageNo;
    notifyListeners();
  }

  int autoAllAdsPageNo = 1;

  changeAutoAllAdsPageNo(int pageNo) {
    autoAllAdsPageNo = pageNo;
    notifyListeners();
  }

  int allPropertiesPageNo = 1;

  changeAllPropertiesPageNo(int pageNo) {
    allPropertiesPageNo = pageNo;
    notifyListeners();
  }

  int allJobPageNo = 1;

  changeAllJobPageNo(int pageNo) {
    allJobPageNo = pageNo;
    notifyListeners();
  }

  List<ClassifiedProductModel> myClassifiedAds = [];

  changeMyClassifiedAds(List<ClassifiedProductModel> updatedMyClassifiedAds) {
    myClassifiedAds = updatedMyClassifiedAds;
    notifyListeners();
  }

  Future<Either<Failure, ClassifiedAdsResModel>> getMyClassifiedAds(
      {String? sortedBy, int? pageNo}) async {
    final getMyAds = GetMyClassifiedAdsUseCase(repository: classifiedRepo);
    final result =
        await getMyAds(SortedByEntities(sortedBy: sortedBy, pageNo: pageNo));
    return result;
  }

  List<AutomotiveProductModel> myAutomotiveAds = [];

  changeMyAutomotiveAds(List<AutomotiveProductModel> updatedMyAutomotiveAds) {
    myAutomotiveAds = updatedMyAutomotiveAds;
    notifyListeners();
  }

  Future<Either<Failure, AutomotiveAdsResModel>> getMyAutomotiveAds(
      {String? sortedBy, int? pageNo}) async {
    final getMyAds = GetMyAutomotiveAdsUseCase(repository: autoRepo);
    final result =
        await getMyAds(SortedByEntities(sortedBy: sortedBy, pageNo: pageNo));
    return result;
  }

  List<PropertyProductModel> myPropertiesAds = [];

  changeMyPropertiesAds(List<PropertyProductModel> updatedMyPropertiesAds) {
    myPropertiesAds = updatedMyPropertiesAds;
    notifyListeners();
  }

  Future<Either<Failure, PropertyAdsResModel>> getMyPropertiesAds(
      {String? sortedBy, int? pageNo}) async {
    final getMyAds = GetMyPropertyAdsUseCase(repository: propertiesRepo);
    final result =
        await getMyAds(SortedByEntities(sortedBy: sortedBy, pageNo: pageNo));
    return result;
  }

  List<JobProductModel> myJobAds = [];

  changeMyJobAds(List<JobProductModel> updatedMyJobAds) {
    myJobAds = updatedMyJobAds;
    notifyListeners();
  }

  Future<Either<Failure, JobAdsResModel>> getMyJobAds(
      {String? sortedBy, int? pageNo}) async {
    final getMyAds = GetMyJobAdsUseCase(repository: jobsRepo);
    final result =
        await getMyAds(SortedByEntities(sortedBy: sortedBy, pageNo: pageNo));
    return result;
  }

  void automotiveActiveInactive({required String adId}) async {
    final activeInactive = AutomotiveActiveInactiveUseCase(autoRepo);
    await activeInactive(IdEntities(id: adId));
  }

  void propertyActiveInactive({required String adId}) async {
    final activeInactive = PropertyActiveInactiveUseCase(propertiesRepo);
    await activeInactive(IdEntities(id: adId));
  }

  void jobActiveInactive({required String adId}) async {
    final activeInactive = JobActiveInactiveUseCase(jobsRepo);
    await activeInactive(IdEntities(id: adId));
  }

  void deleteClassified({required String adId}) async {
    final activeInactive = DeleteClassifiedUseCase(classifiedRepo);
    await activeInactive(IdEntities(id: adId));
  }

  void deleteAutomotive({required String adId}) async {
    final activeInactive = DeleteAutomotiveUseCase(autoRepo);
    await activeInactive(IdEntities(id: adId));
  }

  void deleteProperty({required String adId}) async {
    final activeInactive = DeletePropertyUseCase(propertiesRepo);
    await activeInactive(IdEntities(id: adId));
  }

  void deleteJob({required String adId}) async {
    final activeInactive = DeleteJobUseCase(jobsRepo);
    await activeInactive(IdEntities(id: adId));
  }

  List<ClassifiedProductModel> myFavClassifiedAds = [];
  List<AutomotiveProductModel> myFavAutomotiveAds = [];
  List<PropertyProductModel> myFavPropertyAds = [];
  List<JobProductModel> myFavJobAds = [];

  changeMyFavClassified(
      List<ClassifiedProductModel> updatedMyFavClassifiedAds) {
    myFavClassifiedAds = updatedMyFavClassifiedAds;
    notifyListeners();
  }

  Future<Either<Failure, ClassifiedAdsResModel>> getMyFavClassifiedAds(
      {required String sortedBy}) async {
    final getMyAds = GetMyFavClassifiedUseCase(classifiedRepo);
    final result = await getMyAds(SortedByEntities(sortedBy: sortedBy));
    return result;
  }

  changeMyFavAutomotive(
      List<AutomotiveProductModel> updatedMyFavAutomotiveAds) {
    myFavAutomotiveAds = updatedMyFavAutomotiveAds;
    notifyListeners();
  }

  Future<Either<Failure, AutomotiveAdsResModel>> getMyFavAutomotiveAds(
      {required String sortedBy}) async {
    final getMyAds = GetMyFavAutomotiveAdsUseCase(repository: autoRepo);
    final result = await getMyAds(SortedByEntities(sortedBy: sortedBy));
    return result;
  }

  changeMyFavProperty(List<PropertyProductModel> updatedMyFavPropertyAds) {
    myFavPropertyAds = updatedMyFavPropertyAds;
    notifyListeners();
  }

  Future<Either<Failure, PropertyAdsResModel>> getMyFavPropertyAds(
      {required String sortedBy}) async {
    final getMyAds = GetMyFavPropertyAdsUseCase(repository: propertiesRepo);
    final result = await getMyAds(SortedByEntities(sortedBy: sortedBy));
    return result;
  }

  changeMyFavJob(List<JobProductModel> updatedMyFavJobAds) {
    myFavJobAds = updatedMyFavJobAds;
    notifyListeners();
  }

  Future<Either<Failure, JobAdsResModel>> getMyFavJobAds(
      {required String sortedBy}) async {
    final getMyAds = GetMyFavJobAdsUseCase(repository: jobsRepo);
    final result = await getMyAds(SortedByEntities(sortedBy: sortedBy));
    return result;
  }

  UpdateUserProfile updatedUserProfileValues = UpdateUserProfile();

  changeUpdateUserProfile(UpdateUserProfile newUpdatedUserProfileValues) {
    updatedUserProfileValues = newUpdatedUserProfileValues;
    notifyListeners();
  }

  Future<void> updateProfileApi() async {
    // print(updatedUserProfileValues.fullName);
    // print("Token is :: ");
    // print("${iPrefHelper.retrieveToken()}");
    try {
      Uri uri =
          Uri.parse('${iExternalValues.getBaseUrl()}api/update_user_profile/');
      d('UPDATED USER PROFILE URL : $uri');
      var request = http.MultipartRequest("PUT", uri);
      if (updatedUserProfileValues.profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'picture', updatedUserProfileValues.profileImage!.path));
      }
      if (updatedUserProfileValues.coverImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'cover', updatedUserProfileValues.coverImage!.path));
      }
      request.fields['full_name'] = updatedUserProfileValues.fullName ?? '';
      request.fields['mobile_number'] =
          updatedUserProfileValues.phoneNumber ?? '';
      request.fields['country'] = updatedUserProfileValues.countryId ?? '';
      request.fields['state'] = updatedUserProfileValues.stateId ?? '';
      request.fields['city'] = updatedUserProfileValues.cityId ?? '';
      request.fields['bio'] = updatedUserProfileValues.bio ?? '';
      request.fields['street_adress'] =
          updatedUserProfileValues.streetAddress ?? '';
      request.fields['longitude'] = updatedUserProfileValues.longitude ?? '';
      request.fields['latitude'] = updatedUserProfileValues.latitude ?? '';
      request.fields['dial_code'] = updatedUserProfileValues.dialCode ?? '';
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      d('STATUS CODE : ${response.statusCode}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        UserProfileModel userProfileModel =
            UserProfileModel.fromJson(decodedResponse['response']);
        iPrefHelper.saveUser(userProfileModel);
        d('Updated successfully');
        d(decodedResponse);
      } else {
        d('ERROR');
      }
    } catch (e) {
      d(e);
    }
  }

  CreateBusinessProfileModel tempBusinessValues = CreateBusinessProfileModel();

  changeTempBusinessValues(CreateBusinessProfileModel newValues) {
    tempBusinessValues = newValues;
    notifyListeners();
  }

  createBusinessProfile({
    required File profileImage,
    required File coverImage,
    required List<File> nationalIdDoc,
    required List<File> passportDoc,
    required List<File> userPhoto,
    required List<File> licenseFile,
    required String businessName,
    required String businessCategory,
    required String email,
    required String dialCode,
    required String phoneNumber,
    required String countryId,
    required String stateId,
    required bool isBusinessActive,
    String? cityId,
    required String about,
    required String businessLocation,
    required String latitude,
    required String longitude,
    required licenceNumber,
    required BuildContext context,
  }) async {
    BusinessViewModel businessViewModel = context.read<BusinessViewModel>();
    try {
      Uri uri = Uri.parse(
          '${iExternalValues.getBaseUrl()}api/create_business_profile/');
      d('UPDATED USER PROFILE URL : $uri');
      var request = http.MultipartRequest("Post", uri);
      request.files
          .add(await http.MultipartFile.fromPath('logo', profileImage.path));
      request.files.add(
          await http.MultipartFile.fromPath('cover_image', coverImage.path));
      if (nationalIdDoc.isNotEmpty) {
        for (int i = 0; i < nationalIdDoc.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'national_id', nationalIdDoc[i].path));
        }
      }
      if (nationalIdDoc.isNotEmpty) {
        for (int i = 0; i < nationalIdDoc.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'passport', nationalIdDoc[i].path));
        }
      }
      if (userPhoto.isNotEmpty) {
        for (int i = 0; i < userPhoto.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'recent_image', userPhoto[i].path));
        }
      }
      if (licenseFile.isNotEmpty) {
        for (int i = 0; i < licenseFile.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'license_file', licenseFile[i].path));
        }
      }

      request.fields['name'] = businessName;
      request.fields['company_type'] = businessCategory;
      request.fields['email'] = email;
      request.fields['phone'] = phoneNumber;
      request.fields['country'] = countryId;
      request.fields['state'] = stateId;
      if (cityId != null) {
        request.fields['city'] = cityId;
      }
      request.fields['company_status'] = isBusinessActive.toString();
      request.fields['about'] = about;
      request.fields['street_address'] = businessLocation;
      request.fields['longitude'] = longitude;
      request.fields['latitude'] = latitude;
      request.fields['dial_code'] = dialCode;
      request.fields['license_number'] = licenceNumber;
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      d('STATUS CODE : ${response.statusCode}');
      d(decodedResponse);
      if (response.statusCode == 201 || response.statusCode == 200) {
        BusinessProfileModel businessProfile =
            BusinessProfileModel.fromJson(decodedResponse['response']);
        d('businessProfile : ${businessProfile.companyType}');
        if (businessProfile.companyType == 'Classified') {
          businessViewModel.classifiedBusinessProfile = businessProfile;
          iPrefHelper.saveClassifiedProfile(
              businessViewModel.classifiedBusinessProfile);
        } else if (businessProfile.companyType == 'Automotive') {
          businessViewModel.automotiveBusinessProfile = businessProfile;
          iPrefHelper.saveAutomotiveProfile(
              businessViewModel.automotiveBusinessProfile);
        } else if (businessProfile.companyType == 'Property') {
          businessViewModel.propertyBusinessProfile = businessProfile;
          iPrefHelper
              .savePropertyProfile(businessViewModel.propertyBusinessProfile);
        } else if (businessProfile.companyType == 'Job') {
          businessViewModel.jobBusinessProfile = businessProfile;
          iPrefHelper.saveJobProfile(businessViewModel.jobBusinessProfile);
          d('Company Name: ${iPrefHelper.retrieveJobProfile()!.name}');
        }
      } else {
        d('ERROR : ${decodedResponse['response']['message']}');
      }
    } catch (e) {
      d(e);
    }
  }

 Future updateStatus({
    required String companyId,
    required bool companyStatus,
  }) async {
    try {
      Uri uri = Uri.parse(
          '${iExternalValues.getBaseUrl()}api/change_business_profile_status/');
      d('UPDATED USER PROFILE URL : $uri');
      var request = http.MultipartRequest("PUT", uri);

      request.fields['company'] = companyId;
      request.fields['company_status'] = companyStatus.toString();

      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      d(response);
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      d('STATUS CODE : ${response.statusCode}');
      d(decodedResponse);
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("this is what i need");
        print("============");
      } else {
        d('ERROR : ${decodedResponse['response']['message']}');
      }
    } catch (e) {
      d(e);
    }
  }




  updateBusinessProfile({
    required String id,
    File? profileImage,
    File? coverImage,
    File? nationalIdDoc,
    File? passportDoc,
    File? userPhoto,
    File? licenseFile,
    required String businessName,
    required String businessCategory,
    required String email,
    required String dialCode,
    required String phoneNumber,
    required String countryId,
    required bool isBusinessActive,
    required String stateId,
    required String cityId,
    required String about,
    required String businessLocation,
    required String latitude,
    required String longitude,
    required licenceNumber,
  }) async {
    try {
      Uri uri = Uri.parse(
          '${iExternalValues.getBaseUrl()}api/edit_business_profile/');
      d('UPDATED USER PROFILE URL : $uri');
      var request = http.MultipartRequest("PUT", uri);
      if (profileImage != null) {
        request.files
            .add(await http.MultipartFile.fromPath('logo', profileImage.path));
      }
      if (coverImage != null) {
        request.files.add(
            await http.MultipartFile.fromPath('cover_image', coverImage.path));
      }

      request.fields['id'] = id;
      request.fields['name'] = businessName;
      request.fields['company_type'] = businessCategory;
      request.fields['email'] = email;
      request.fields['phone'] = phoneNumber;
      request.fields['country'] = countryId;
      request.fields['state'] = stateId;
      request.fields['city'] = cityId;
      request.fields['about'] = about;
      request.fields['company_status'] = isBusinessActive.toString();
      request.fields['street_address'] = businessLocation;
      request.fields['longitude'] = longitude;
      request.fields['latitude'] = latitude;
      request.fields['dial_code'] = dialCode;
      request.fields['license_number'] = licenceNumber;
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      d(response);
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      d('STATUS CODE : ${response.statusCode}');
      d(decodedResponse);
      if (response.statusCode == 201 || response.statusCode == 200) {
      } else {
        d('ERROR : ${decodedResponse['response']['message']}');
      }
    } catch (e) {
      d(e);
    }
  }

  editAccountSetting({
    required String privacy,
    required String privacyField,
  }) async {
    try {
      Uri uri = Uri.parse('${iExternalValues.getBaseUrl()}api/change_privacy/');
      d('UPDATED USER PROFILE URL : $uri');
      var request = http.MultipartRequest("PUT", uri);
      request.fields['privacy'] = privacy;
      request.fields['privacy_field'] = privacyField;
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      d(response);
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      d('STATUS CODE : ${response.statusCode}');
      d(decodedResponse);
      if (response.statusCode == 201 || response.statusCode == 200) {
      } else {
        d('ERROR : ${decodedResponse['response']['message']}');
      }
    } catch (e) {
      d(e);
    }
  }

  List<ResumeModel> myResumeList = [];

  changeMyResumeList(List<ResumeModel> newResumeList) {
    myResumeList = newResumeList;
    notifyListeners();
  }

  Future<void> uploadResume(
      {required String resumePath,
      required String resumeName,
      required String extension}) async {
    try {
      Uri uri = Uri.parse('${iExternalValues.getBaseUrl()}api/upload_resume/');
      d('UPLOAD RESUME : $uri');
      var request = http.MultipartRequest("POST", uri);
      request.files
          .add(await http.MultipartFile.fromPath('resume_file', resumePath));
      request.fields['resume_extension'] = extension;
      request.fields['resume_name'] = resumeName;
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('STATUS CODE : ${response.statusCode}');
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        ResumeModel resume = ResumeModel.fromJson(decodedResponse['response']);
        myResumeList.insert(0, resume);
        changeMyResumeList(myResumeList);
        d(decodedResponse);
      } else {
        d('ERROR');
      }
    } catch (e) {
      d(e);
    }
  }

  Future<Either<Failure, MyResumeResModel>> getMyResumes() async {
    final myResumes = GetMyResumeUseCase(userRepo);
    final result = myResumes(NoParams());
    return result;
  }
}

class UpdateUserProfile {
  String? fullName;
  File? profileImage;
  File? coverImage;
  String? email;
  String? dialCode;
  String? phoneNumber;
  String? countryId;
  String? stateId;
  String? cityId;
  String? bio;
  String? streetAddress;
  String? latitude;
  String? longitude;
}

class CreateBusinessProfileModel {
  File? profileImage;
  File? coverImage;
  String? businessName;
  String? businessCategory;
  String? businessEmail;
  String? businessPhoneNumber;
  String? dialCode;
  String? country;
  String? state;
  String? city;
  String? businessAbout;
  String? businessLocation;
  String? licenceNumber;
  String? latitude;
  String? longitude;
}
