import 'dart:convert';
import 'dart:io';

import 'package:app/application/network/external_values/IExternalValues.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/presentation/add_post/add_created_screen.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/notification/notifications_services.dart';
import 'package:app/presentation/on_boarding/widgets/custom_page_route.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateAdPostViewModel extends ChangeNotifier {
  IPrefHelper iPrefHelper = inject<IPrefHelper>();
  IExternalValues iExternalValues = inject<IExternalValues>();

  int? adPostCategoryIndex;
  ClassifiedObject? classifiedAdData = ClassifiedObject();
  AutomotiveObject? automotiveAdData = AutomotiveObject();
  PropertiesObject? propertyAdData = PropertiesObject();
  JobObject? jobAdData = JobObject();

  changeJobAdData(JobObject updateJobAdData) {
    jobAdData = updateJobAdData;
    d('JOB AD DATA : ' + jobAdData.toString());
    notifyListeners();
  }

  changeAdPostCategoryIndex(int updatedAdPostCategoryIndex) {
    adPostCategoryIndex = updatedAdPostCategoryIndex;
    d('CATEGORY INDEX : ' + adPostCategoryIndex.toString());
    notifyListeners();
  }

  changeClassifiedAdData(ClassifiedObject? updateClassifiedAdData) {
    classifiedAdData = updateClassifiedAdData;
    d('CLASSIFIED AD DATA : ' + classifiedAdData.toString());
    notifyListeners();
  }

  changePropertyAdData(PropertiesObject? updatePropertyAdData) {
    propertyAdData = updatePropertyAdData;
    d('PROPERTY AD DATA : ' + propertyAdData.toString());
    notifyListeners();
  }

  changeAutomotiveAdData(AutomotiveObject? updatedAutomotiveAdData) {
    automotiveAdData = updatedAutomotiveAdData;
    d('AUTOMOTIVE AD DATA : ' + automotiveAdData.toString());
    notifyListeners();
  }

  Future createClassifiedAd({required BuildContext context}) async {
    ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    try {
      Uri uri =
          Uri.parse('${iExternalValues.getBaseUrl()}api/create_classified/');
      d('CLASSIFIED AD URL : $uri');
      var request = http.MultipartRequest("POST", uri);
      for (int i = 0; i < classifiedAdData!.images!.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
            'classified_image', classifiedAdData!.images![i].path));
      }

      Navigator.push(
          context,
          CustomPageRoute(
              child: const CreatedSuccessfullyScreen(),
              direction: AxisDirection.down));

      /*String fileName = classifiedAdData!.images![0].path.split("/").last;
      var stream = http.ByteStream(DelegatingStream.typed(classifiedAdData!.images![0].openRead()));
      var length = await classifiedAdData!.images![0].length();
      http.MultipartFile multipartFileSign;
      multipartFileSign = http.MultipartFile(
        'classified_image',
        stream,
        length,
        filename: fileName,
      );
      request.files.add(multipartFileSign);*/

      if (classifiedAdData!.video != null) {
        String fileName = classifiedAdData!.video!.path.split("/").last;
        // ignore: deprecated_member_use
        var stream = http.ByteStream(
            DelegatingStream.typed(classifiedAdData!.video!.openRead()));
        var length = await classifiedAdData!.video!.length();
        http.MultipartFile multipartFileSign;
        multipartFileSign = http.MultipartFile(
            'classified_video', stream, length,
            filename: fileName);
        request.files.add(multipartFileSign);
      }
      request.fields['name'] = classifiedAdData!.title!;
      request.fields['category'] = classifiedAdData!.categoryId.toString();
      request.fields['mobile'] = classifiedAdData!.phoneNumber.toString();
      request.fields['currency'] = classifiedAdData!.currencyId??"d7cad087-e7d7-4108-aa18-e07abde98ede";
      request.fields['price'] = classifiedAdData!.price.toString();
      request.fields['description'] = classifiedAdData!.description.toString();
      request.fields['type'] = classifiedAdData!.conditionType.toString();
      request.fields['sub_category'] =
          classifiedAdData!.subCategoryId.toString();
      request.fields['brand'] =
          classifiedAdData!.brandId == null ? '' : classifiedAdData!.brandId!;
      request.fields['business_type'] = classifiedAdData!.adType.toString();
      request.fields['street_adress'] =
          classifiedAdData!.streetAddress.toString();
      request.fields['longitude'] = classifiedAdData!.longitude.toString();
      request.fields['latitude'] = classifiedAdData!.latitude.toString();
      request.fields['dial_code'] = classifiedAdData!.dialCode.toString();
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      if (response.statusCode == 201) {
        ClassifiedProductModel classifiedSingleAd =
            ClassifiedProductModel.fromJson(decodedResponse['response']);
        d('CLASSIFIED SINGLE AD : $classifiedSingleAd');
        classifiedViewModel.classifiedAllAds!.insert(0, classifiedSingleAd);
        profileViewModel.myClassifiedAds.insert(0, classifiedSingleAd);
        classifiedViewModel
            .changeClassifiedAllAds(classifiedViewModel.classifiedAllAds!);
        profileViewModel
            .changeMyClassifiedAds(profileViewModel.myClassifiedAds);
        NotificationService showNotification = NotificationService();
        showNotification.cancelNotification(1);
        showNotification.showPostUploadingInfo(id: 1111, title: 'YouOnline', body: 'Your ad is posted successfully');
        // Navigator.push(
        //     context,
        //     CustomPageRoute(
        //         child: const CreatedSuccessfullyScreen(),
        //         direction: AxisDirection.down));

      } else {
        d('ERROR : ' + decodedResponse['response']['message']);
      }
    } catch (e) {
      d(e);
    }
  }

  Future addClassifiedAdMedia({required BuildContext context}) async {
    ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    if (classifiedAdData!.images!.isNotEmpty) {
      try {
        Uri uri = Uri.parse(
            '${iExternalValues.getBaseUrl()}api/add_classified_media/');
        d('CLASSIFIED AD URL : $uri');
        var request = http.MultipartRequest("POST", uri);
        request.fields['classified'] = classifiedAdData!.id!;
        for (int i = 0; i < classifiedAdData!.images!.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'classified_image', classifiedAdData!.images![i].path));
        }
        if (classifiedAdData!.video != null) {
          String fileName = classifiedAdData!.video!.path.split("/").last;
          // ignore: deprecated_member_use
          var stream = http.ByteStream(
              DelegatingStream.typed(classifiedAdData!.video!.openRead()));
          var length = await classifiedAdData!.video!.length();
          http.MultipartFile multipartFileSign;
          multipartFileSign = http.MultipartFile(
              'classified_video', stream, length,
              filename: fileName);
          request.files.add(multipartFileSign);
        }
        request.headers
            .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
        http.StreamedResponse? response;
        response = await request.send();
        d('This is add classified media status code : ' +
            response.statusCode.toString());
        var res = await http.Response.fromStream(response);
        var decodedResponse = json.decode(res.body);
        if (response.statusCode == 201 || response.statusCode == 200) {
          d('MEDIA UPDATED decodedResponse :: $decodedResponse');
          ClassifiedProductModel classifiedSingleAd =
              ClassifiedProductModel.fromJson(decodedResponse['response']);
          for (int i = 0;
              i < classifiedViewModel.classifiedAllAds!.length;
              i++) {
            if (classifiedViewModel.classifiedAllAds![i].id ==
                classifiedSingleAd.id) {
              classifiedViewModel.classifiedAllAds![i] = classifiedSingleAd;
            }
          }
          classifiedViewModel
              .changeClassifiedAllAds(classifiedViewModel.classifiedAllAds);
          for (int i = 0;
              i < classifiedViewModel.classifiedDealAds!.length;
              i++) {
            if (classifiedViewModel.classifiedDealAds![i].id ==
                classifiedSingleAd.id) {
              classifiedViewModel.classifiedDealAds![i] = classifiedSingleAd;
            }
          }
          classifiedViewModel
              .changeClassifiedDealAds(classifiedViewModel.classifiedDealAds);
        } else {
          d('ERROR : ' + decodedResponse['response']['message']);
        }
      } catch (e) {
        d(e);
      }
    }
  }

  Future updateClassifiedAd({required BuildContext context}) async {
    ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    try {
      Uri uri =
          Uri.parse('${iExternalValues.getBaseUrl()}api/update_classified/');
      d('CLASSIFIED AD URL : $uri');
      var request = http.MultipartRequest("PUT", uri);
      request.fields['id'] = classifiedAdData!.id!;
      request.fields['name'] = classifiedAdData!.title!;
      request.fields['category'] = classifiedAdData!.categoryId.toString();
      request.fields['mobile'] = classifiedAdData!.phoneNumber.toString();
      request.fields['currency'] = classifiedAdData!.currencyId.toString();
      request.fields['price'] = classifiedAdData!.price.toString();
      request.fields['description'] = classifiedAdData!.description.toString();
      request.fields['business_type'] = classifiedAdData!.adType.toString();
      request.fields['type'] = classifiedAdData!.conditionType.toString();
      request.fields['sub_category'] =
          classifiedAdData!.subCategoryId.toString();
      request.fields['brand'] = classifiedAdData!.brandId.toString();
      request.fields['street_adress'] =
          classifiedAdData!.streetAddress.toString();
      request.fields['longitude'] = classifiedAdData!.longitude.toString();
      request.fields['latitude'] = classifiedAdData!.latitude.toString();
      request.fields['dial_code'] = classifiedAdData!.dialCode.toString();
      request.fields['remove_media'] =
          jsonEncode(classifiedAdData!.removeMediaIds);
      print(jsonEncode(classifiedAdData!.removeMediaIds));

      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        d('MEDIA UPDATED decodedResponse :: $decodedResponse');
        addClassifiedAdMedia(context: context);
        ClassifiedProductModel classifiedSingleAd =
            ClassifiedProductModel.fromJson(decodedResponse['response']);
        for (int i = 0; i < classifiedViewModel.classifiedAllAds!.length; i++) {
          if (classifiedViewModel.classifiedAllAds![i].id ==
              classifiedSingleAd.id) {
            classifiedViewModel.classifiedAllAds![i] = classifiedSingleAd;
          }
        }
        classifiedViewModel
            .changeClassifiedAllAds(classifiedViewModel.classifiedAllAds);
        for (int i = 0;
            i < classifiedViewModel.classifiedDealAds!.length;
            i++) {
          if (classifiedViewModel.classifiedDealAds![i].id ==
              classifiedSingleAd.id) {
            classifiedViewModel.classifiedDealAds![i] = classifiedSingleAd;
          }
        }
        classifiedViewModel
            .changeClassifiedDealAds(classifiedViewModel.classifiedDealAds);
        profileViewModel
            .changeMyClassifiedAds(classifiedViewModel.classifiedDealAds!);
        Navigator.push(
            context,
            CustomPageRoute(
                child: const CreatedSuccessfullyScreen(),
                direction: AxisDirection.down));

      } else {
        d('ERROR : ' + decodedResponse['response']['message']);
      }
    } catch (e) {
      d(e);
    }
  }

  Future createAutomotiveAd({required BuildContext context}) async {
    AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    try {
      Uri uri =
          Uri.parse('${iExternalValues.getBaseUrl()}api/create_automotive/');
      d('AUTOMOTIVE AD URL : $uri');
      var request = http.MultipartRequest("POST", uri);
      for (int i = 0; i < automotiveAdData!.images!.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
            'automotive_image', automotiveAdData!.images![i].path));
      }

      Navigator.push(
          context,
          CustomPageRoute(
              child: const CreatedSuccessfullyScreen(),
              direction: AxisDirection.down));

      if (automotiveAdData!.video != null) {
        String fileName = automotiveAdData!.video!.path.split("/").last;
        // ignore: deprecated_member_use
        var stream = http.ByteStream(
            DelegatingStream.typed(automotiveAdData!.video!.openRead()));
        var length = await automotiveAdData!.video!.length();
        http.MultipartFile multipartFileSign;
        multipartFileSign = http.MultipartFile(
            'automotive_videos', stream, length,
            filename: fileName);
        request.files.add(multipartFileSign);
      }
      request.fields['name'] = automotiveAdData!.title!;
      request.fields['category'] = automotiveAdData!.categoryId.toString();
      request.fields['mobile'] = automotiveAdData!.phoneNumber.toString();
      request.fields['currency'] = automotiveAdData!.currencyId??"d7cad087-e7d7-4108-aa18-e07abde98ede";
      request.fields['price'] = automotiveAdData!.price.toString();
      request.fields['description'] = automotiveAdData!.description.toString();
      request.fields['type'] = automotiveAdData!.conditionType.toString();
      request.fields['sub_category'] =
          automotiveAdData!.subCategoryId.toString();
      request.fields['make'] = automotiveAdData!.makeId.toString();
      request.fields['automotive_model'] = automotiveAdData!.modelId.toString();
      request.fields['automotive_year'] = automotiveAdData!.year.toString();
      request.fields['kilometers'] = automotiveAdData!.mileage.toString();
      request.fields['fuel_type'] = automotiveAdData!.fuelType.toString();
      request.fields['transmission_type'] =
          automotiveAdData!.transmissionType.toString();
      request.fields['business_type'] = automotiveAdData!.adType.toString();
      request.fields['car_type'] = automotiveAdData!.conditionType.toString();
      request.fields['dial_code'] = automotiveAdData!.dialCode.toString();
      request.fields['street_adress'] =
          automotiveAdData!.streetAddress.toString();

      // Hard Code

      request.fields['color'] = automotiveAdData!.color.toString();

      if (automotiveAdData!.automaticType.toString() == "Rent") {
        request.fields['rent_hourly'] = automotiveAdData!.rentHours.toString();
      }

      request.fields['automotive_type'] =
          automotiveAdData!.automaticType.toString();

      //

      request.fields['longitude'] = automotiveAdData!.longitude.toString();
      request.fields['latitude'] = automotiveAdData!.latitude.toString();
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      if (response.statusCode == 201) {
        AutomotiveProductModel classifiedSingleAd =
            AutomotiveProductModel.fromJson(decodedResponse['response']);
        d('AUTOMOTIVE SINGLE AD : $classifiedSingleAd');
        automotiveViewModel.automotiveAllAds.insert(0, classifiedSingleAd);
        profileViewModel.myAutomotiveAds.insert(0, classifiedSingleAd);
        automotiveViewModel
            .changeAutomotiveAllAds(automotiveViewModel.automotiveAllAds);
        profileViewModel
            .changeMyAutomotiveAds(profileViewModel.myAutomotiveAds);

        NotificationService showNotification = NotificationService();
        showNotification.cancelNotification(1);
        showNotification.showPostUploadingInfo(id: 1111, title: 'YouOnline', body: 'Your ad is posted successfully');
      } else {
        d('ERROR : ' + decodedResponse['response']['message']);
      }
    } catch (e) {
      d(e);
    }
  }

  Future addAutomotiveAdMedia({required BuildContext context}) async {
    AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    if (automotiveAdData!.images!.isNotEmpty) {
      try {
        Uri uri = Uri.parse(
            '${iExternalValues.getBaseUrl()}api/add_automotive_media/');
        d('AUTOMOTIVE AD URL : $uri');
        var request = http.MultipartRequest("POST", uri);
        for (int i = 0; i < automotiveAdData!.images!.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'automotive_image', automotiveAdData!.images![i].path));
        }
        if (automotiveAdData!.video != null) {
          String fileName = automotiveAdData!.video!.path.split("/").last;
          // ignore: deprecated_member_use
          var stream = http.ByteStream(
              DelegatingStream.typed(automotiveAdData!.video!.openRead()));
          var length = await automotiveAdData!.video!.length();
          http.MultipartFile multipartFileSign;
          multipartFileSign = http.MultipartFile(
              'automotive_video', stream, length,
              filename: fileName);
          request.files.add(multipartFileSign);
        }
        request.fields['automotive'] = automotiveAdData!.id!;
        request.headers
            .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
        http.StreamedResponse? response;
        response = await request.send();
        d('This is auto add media status code : ' +
            response.statusCode.toString());
        var res = await http.Response.fromStream(response);
        var decodedResponse = json.decode(res.body);
        if (response.statusCode == 200) {
          AutomotiveProductModel automotiveSingleAd =
              AutomotiveProductModel.fromJson(decodedResponse['response']);
          for (int i = 0;
              i < automotiveViewModel.automotiveAllAds.length;
              i++) {
            if (automotiveViewModel.automotiveAllAds[i].id ==
                automotiveSingleAd.id) {
              automotiveViewModel.automotiveAllAds[i] = automotiveSingleAd;
            }
          }
          automotiveViewModel
              .changeAutomotiveAllAds(automotiveViewModel.automotiveAllAds);
        } else {
          d('ERROR : ' + decodedResponse['response']['message']);
        }
      } catch (e) {
        d(e);
      }
    }
  }

  Future updateAutomotiveAd({required BuildContext context}) async {
    d('This is automotiveAdData!.adType.toString() ::: ${automotiveAdData!.adType.toString()}');
    AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();

    Navigator.push(
        context,
        CustomPageRoute(
            child: const CreatedSuccessfullyScreen(),
            direction: AxisDirection.down));

    try {
      Uri uri =
          Uri.parse('${iExternalValues.getBaseUrl()}api/update_automotive/');
      d('AUTOMOTIVE AD URL : $uri');
      var request = http.MultipartRequest("PUT", uri);
      request.fields['id'] = automotiveAdData!.id!;
      request.fields['name'] = automotiveAdData!.title!;
      request.fields['category'] = automotiveAdData!.categoryId.toString();
      request.fields['mobile'] = automotiveAdData!.phoneNumber.toString();
      request.fields['currency'] = automotiveAdData!.currencyId.toString();
      request.fields['price'] = automotiveAdData!.price.toString();
      request.fields['description'] = automotiveAdData!.description.toString();
      request.fields['type'] = automotiveAdData!.conditionType.toString();
      request.fields['remove_media'] =
          jsonEncode(automotiveAdData!.removeMediaIds);
      print(jsonEncode(automotiveAdData!.removeMediaIds));

      request.fields['sub_category'] =
          automotiveAdData!.subCategoryId.toString();
      request.fields['make'] = automotiveAdData!.makeId.toString();
      request.fields['automotive_model'] = automotiveAdData!.modelId.toString();
      request.fields['automotive_year'] = automotiveAdData!.year.toString();
      request.fields['kilometers'] = automotiveAdData!.mileage.toString();
      request.fields['fuel_type'] = automotiveAdData!.fuelType.toString();
      request.fields['transmission_type'] =
          automotiveAdData!.transmissionType.toString();
      request.fields['business_type'] = automotiveAdData!.adType.toString();
      request.fields['car_type'] = automotiveAdData!.conditionType.toString();

      // Hard Code

      request.fields['color'] = "Green";
      request.fields['rent_hourly'] = "24Hours";
      request.fields['automotive_type'] = "Rent";

      //

      request.fields['dial_code'] = automotiveAdData!.dialCode.toString();
      request.fields['street_adress'] =
          automotiveAdData!.streetAddress.toString();
      request.fields['longitude'] = automotiveAdData!.longitude.toString();
      request.fields['latitude'] = automotiveAdData!.latitude.toString();
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        addAutomotiveAdMedia(context: context);
        AutomotiveProductModel automotiveSingleAd =
            AutomotiveProductModel.fromJson(decodedResponse['response']);
        for (int i = 0; i < automotiveViewModel.automotiveAllAds.length; i++) {
          if (automotiveViewModel.automotiveAllAds[i].id ==
              automotiveSingleAd.id) {
            automotiveViewModel.automotiveAllAds[i] = automotiveSingleAd;
          }
        }
        automotiveViewModel
            .changeAutomotiveAllAds(automotiveViewModel.automotiveAllAds);
        profileViewModel
            .changeMyAutomotiveAds(automotiveViewModel.automotiveAllAds);

        NotificationService showNotification = NotificationService();
        showNotification.cancelNotification(1);
        showNotification.showPostUploadingInfo(id: 1111, title: 'YouOnline', body: 'Your ad is posted successfully');

      } else {
        d('ERROR : ' + decodedResponse['response']['message']);
      }
    } catch (e) {
      d(e);
    }
  }

  Future createPropertyAd({required BuildContext context}) async {
    PropertiesViewModel propertiesViewModel =
        context.read<PropertiesViewModel>();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    try {
      Uri uri =
          Uri.parse('${iExternalValues.getBaseUrl()}api/create_property/');
      d('This is url : ' + uri.toString());
      var request = http.MultipartRequest("POST", uri);
      for (int i = 0; i < propertyAdData!.images!.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
            'property_image', propertyAdData!.images![i].path));
      }

      Navigator.push(
          context,
          CustomPageRoute(
              child: const CreatedSuccessfullyScreen(),
              direction: AxisDirection.down));

      /*String fileName = propertyAdData!.images![0].path.split("/").last;
      var stream = http.ByteStream(DelegatingStream.typed(propertyAdData!.images![0].openRead()));
      var length = await propertyAdData!.images![0].length();
      http.MultipartFile multipartFileSign;
      multipartFileSign = http.MultipartFile(
        'property_image',
        stream,
        length,
        filename: fileName,
      );
      request.files.add(multipartFileSign);*/
      if (propertyAdData!.video != null) {
        String fileName = propertyAdData!.video!.path.split("/").last;
        // ignore: deprecated_member_use
        var stream = http.ByteStream(
            DelegatingStream.typed(propertyAdData!.video!.openRead()));
        var length = await propertyAdData!.video!.length();
        http.MultipartFile multipartFileSign;
        multipartFileSign = http.MultipartFile('property_video', stream, length,
            filename: fileName);
        request.files.add(multipartFileSign);
      }
      request.fields['name'] = propertyAdData!.title!;
      request.fields['category'] = propertyAdData!.categoryId.toString();
      request.fields['mobile'] = propertyAdData!.phoneNumber.toString();
      request.fields['currency'] = propertyAdData!.currencyId??"d7cad087-e7d7-4108-aa18-e07abde98ede";
      request.fields['price'] = propertyAdData!.price.toString();
      request.fields['description'] = propertyAdData!.description.toString();
      request.fields['property_type'] = propertyAdData!.propertyType.toString();
      request.fields['business_type'] = propertyAdData!.adType.toString();
      request.fields['sub_category'] = propertyAdData!.subCategoryId.toString();
      request.fields['bedrooms'] = propertyAdData!.bedrooms.toString();
      request.fields['baths'] = propertyAdData!.bathrooms.toString();
      request.fields['area_unit'] = propertyAdData!.areaUnit.toString();
      request.fields['area'] = propertyAdData!.area.toString();
      request.fields['furnished'] = propertyAdData!.furnished.toString();
      request.fields['street_adress'] =
          propertyAdData!.streetAddress.toString();
      request.fields['longitude'] = propertyAdData!.longitude.toString();
      request.fields['latitude'] = propertyAdData!.latitude.toString();
      request.fields['dial_code'] = propertyAdData!.dialCode.toString();
      request.fields['city_area'] = propertyAdData!.locatedId.toString();
      request.fields['city'] = propertyAdData!.cityId.toString();
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      if (response.statusCode == 201) {
        PropertyProductModel propertySingleAd =
            PropertyProductModel.fromJson(decodedResponse['response']);
        d('CLASSIFIED SINGLE AD : $propertySingleAd');
        propertiesViewModel.propertyAllAds!.insert(0, propertySingleAd);
        profileViewModel.myPropertiesAds.insert(0, propertySingleAd);
        propertiesViewModel
            .changePropertiesAllAds(propertiesViewModel.propertyAllAds!);
        profileViewModel
            .changeMyPropertiesAds(profileViewModel.myPropertiesAds);

        NotificationService showNotification = NotificationService();
        showNotification.cancelNotification(1);
        showNotification.showPostUploadingInfo(id: 1111, title: 'YouOnline', body: 'Your ad is posted successfully');

      } else {
        d('ERROR : ' + decodedResponse['response']['message']);
      }
    } catch (e) {
      d(e);
    }
  }

  Future addPropertyAdMedia({required BuildContext context}) async {
    PropertiesViewModel propertiesViewModel =
        context.read<PropertiesViewModel>();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    if (propertyAdData!.images!.isNotEmpty) {
      try {
        Uri uri =
            Uri.parse('${iExternalValues.getBaseUrl()}api/add_property_media/');
        d('This is url : ' + uri.toString());
        var request = http.MultipartRequest("POST", uri);
        for (int i = 0; i < propertyAdData!.images!.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'property_image', propertyAdData!.images![i].path));
        }
        if (propertyAdData!.video != null) {
          String fileName = propertyAdData!.video!.path.split("/").last;
          // ignore: deprecated_member_use
          var stream = http.ByteStream(
              DelegatingStream.typed(propertyAdData!.video!.openRead()));
          var length = await propertyAdData!.video!.length();
          http.MultipartFile multipartFileSign;
          multipartFileSign = http.MultipartFile(
              'property_video', stream, length,
              filename: fileName);
          request.files.add(multipartFileSign);
        }
        request.fields['property'] = propertyAdData!.id!;
        request.headers
            .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
        http.StreamedResponse? response;
        response = await request.send();
        d('This is status code : ' + response.statusCode.toString());
        var res = await http.Response.fromStream(response);
        var decodedResponse = json.decode(res.body);
        if (response.statusCode == 200) {
          d('This is the decodedResponse :::: $decodedResponse');
          PropertyProductModel propertySingleAd =
              PropertyProductModel.fromJson(decodedResponse['response']);
          for (int i = 0; i < propertiesViewModel.propertyAllAds!.length; i++) {
            if (propertiesViewModel.propertyAllAds![i].id ==
                propertySingleAd.id) {
              propertiesViewModel.propertyAllAds![i] = propertySingleAd;
            }
          }
          propertiesViewModel
              .changePropertiesAllAds(propertiesViewModel.propertyAllAds);
        } else {
          d('ERROR : ' + decodedResponse['response']['message']);
        }
      } catch (e) {
        d(e);
      }
    }
  }

  Future updatePropertyAd({required BuildContext context}) async {
    d('This is the propertyAdData!.adType.toString() ::: ${propertyAdData!.adType.toString()}');
    PropertiesViewModel propertiesViewModel =
        context.read<PropertiesViewModel>();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();

    Navigator.push(
        context,
        CustomPageRoute(
            child: const CreatedSuccessfullyScreen(),
            direction: AxisDirection.down));

    try {
      Uri uri =
          Uri.parse('${iExternalValues.getBaseUrl()}api/update_property/');
      d('This is url : ' + uri.toString());
      var request = http.MultipartRequest("PUT", uri);
      request.fields['id'] = propertyAdData!.id!;
      request.fields['name'] = propertyAdData!.title!;
      request.fields['category'] = propertyAdData!.categoryId.toString();
      request.fields['mobile'] = propertyAdData!.phoneNumber.toString();
      request.fields['currency'] = propertyAdData!.currencyId.toString();
      request.fields['price'] = propertyAdData!.price.toString();
      request.fields['description'] = propertyAdData!.description.toString();
      request.fields['property_type'] = propertyAdData!.propertyType.toString();
      request.fields['business_type'] = propertyAdData!.adType.toString();
      request.fields['sub_category'] = propertyAdData!.subCategoryId.toString();
      request.fields['bedrooms'] = propertyAdData!.bedrooms.toString();
      request.fields['baths'] = propertyAdData!.bathrooms.toString();
      request.fields['area_unit'] = propertyAdData!.areaUnit.toString();
      request.fields['area'] = propertyAdData!.area.toString();
      request.fields['furnished'] = propertyAdData!.furnished.toString();
      request.fields['street_adress'] =
          propertyAdData!.streetAddress.toString();
      request.fields['remove_media'] =
          jsonEncode(propertyAdData!.removeMediaIds);
      print(jsonEncode(propertyAdData!.removeMediaIds));
      request.fields['longitude'] = propertyAdData!.longitude.toString();
      request.fields['latitude'] = propertyAdData!.latitude.toString();
      request.fields['dial_code'] = propertyAdData!.dialCode.toString();
      // request.fields['city_area'] = propertyAdData!.dialCode.toString();
      // request.fields['city'] = propertyAdData!.dialCode.toString();

      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        addPropertyAdMedia(context: context);
        PropertyProductModel propertySingleAd =
            PropertyProductModel.fromJson(decodedResponse['response']);
        for (int i = 0; i < propertiesViewModel.propertyAllAds!.length; i++) {
          if (propertiesViewModel.propertyAllAds![i].id ==
              propertySingleAd.id) {
            propertiesViewModel.propertyAllAds![i] = propertySingleAd;
          }
        }
        propertiesViewModel
            .changePropertiesAllAds(propertiesViewModel.propertyAllAds);
        profileViewModel
            .changeMyPropertiesAds(propertiesViewModel.propertyAllAds!);
        NotificationService showNotification = NotificationService();
        showNotification.cancelNotification(1);
        showNotification.showPostUploadingInfo(id: 1111, title: 'YouOnline', body: 'Your ad is posted successfully');

      } else {
        d('ERROR : ' + decodedResponse['response']['message']);
      }
    } catch (e) {
      d(e);
    }
  }

  Future createJobAd({required BuildContext context}) async {
    JobViewModel jobViewModel = context.read<JobViewModel>();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    try {
      Uri uri = Uri.parse('${iExternalValues.getBaseUrl()}api/create_job/');
      d('This is url : ' + uri.toString());
      var request = http.MultipartRequest("POST", uri);
      for (int i = 0; i < jobAdData!.images!.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
            'job_image', jobAdData!.images![i].path));
      }

      Navigator.push(
          context,
          CustomPageRoute(
              child: const CreatedSuccessfullyScreen(),
              direction: AxisDirection.down));

      if (jobAdData!.video != null) {
        String fileName = jobAdData!.video!.path.split("/").last;
        // ignore: deprecated_member_use
        var stream = http.ByteStream(
            DelegatingStream.typed(jobAdData!.video!.openRead()));
        var length = await jobAdData!.video!.length();
        http.MultipartFile multipartFileSign;
        multipartFileSign =
            http.MultipartFile('job_video', stream, length, filename: fileName);
        request.files.add(multipartFileSign);
      }
      d('response from my side :: =====');
      print("above are the variables:: === === === ");

      request.fields['title'] = jobAdData!.title!;
      request.fields['category'] = jobAdData!.categoryId.toString();
      request.fields['salary_currency'] = jobAdData!.currencyId??"d7cad087-e7d7-4108-aa18-e07abde98ede";
      request.fields['salary_start'] = jobAdData!.salaryFrom.toString();
      request.fields['salary_end'] = jobAdData!.salaryTo.toString();
      request.fields['business_type'] = jobAdData!.adType.toString();
      request.fields['mobile'] = jobAdData!.phoneNumber.toString();
      request.fields['dial_code'] = jobAdData!.dialCode.toString();
      request.fields['description'] = jobAdData!.description.toString();
      request.fields['job_type'] = jobAdData!.jobType.toString();
      request.fields['salary_period'] = jobAdData!.salaryPeriod.toString();
      request.fields['position_type'] = jobAdData!.positionType.toString();
      request.fields['location'] = jobAdData!.streetAddress.toString();
      request.fields['longitude'] = jobAdData!.longitude.toString();
      request.fields['latitude'] = jobAdData!.latitude.toString();
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      d('response : ${decodedResponse['response']}');
      d('response from my side :: ${decodedResponse['response']}');
      if (response.statusCode == 201) {
        JobProductModel jobSingleAd =
            JobProductModel.fromJson(decodedResponse['response']);
        d('CLASSIFIED SINGLE AD : ${jobSingleAd.profile.toString()}');
        jobViewModel.jobAllAds!.insert(0, jobSingleAd);
        profileViewModel.myJobAds.insert(0, jobSingleAd);
        jobViewModel.changeJobAllAds(jobViewModel.jobAllAds!);
        profileViewModel.changeMyJobAds(profileViewModel.myJobAds);


        NotificationService showNotification = NotificationService();
        showNotification.cancelNotification(1);
        showNotification.showPostUploadingInfo(id: 1111, title: 'YouOnline', body: 'Your ad is posted successfully');

      } else {
        d('ERROR : ' + decodedResponse['response']['message']);
      }
    } catch (e) {
      d(e);
    }
  }

  Future updateJobAdMedia({required BuildContext context}) async {
    JobViewModel jobViewModel = context.read<JobViewModel>();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    if (jobAdData!.images!.isNotEmpty) {
      try {
        Uri uri =
            Uri.parse('${iExternalValues.getBaseUrl()}api/add_job_media/');
        d('This is url : ' + uri.toString());
        var request = http.MultipartRequest("POST", uri);
        for (int i = 0; i < jobAdData!.images!.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'job_image', jobAdData!.images![i].path));
        }
        if (jobAdData!.video != null) {
          String fileName = jobAdData!.video!.path.split("/").last;
          // ignore: deprecated_member_use
          var stream = http.ByteStream(
              DelegatingStream.typed(jobAdData!.video!.openRead()));
          var length = await jobAdData!.video!.length();
          http.MultipartFile multipartFileSign;
          multipartFileSign = http.MultipartFile('job_video', stream, length,
              filename: fileName);
          request.files.add(multipartFileSign);
        }
        d('THIS IS JOB ID :::: ${jobAdData!.id!}');
        request.fields['job'] = jobAdData!.id!;
        request.headers
            .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
        http.StreamedResponse? response;
        response = await request.send();
        d('This is status code : ' + response.statusCode.toString());
        var res = await http.Response.fromStream(response);
        var decodedResponse = json.decode(res.body);
        if (response.statusCode == 201 || response.statusCode == 200) {
          JobProductModel jobSingleAd =
              JobProductModel.fromJson(decodedResponse['response']);
          for (int i = 0; i < jobViewModel.jobAllAds!.length; i++) {
            if (jobViewModel.jobAllAds![i].id == jobSingleAd.id) {
              jobViewModel.jobAllAds![i] = jobSingleAd;
            }
          }
          jobViewModel.changeJobAllAds(jobViewModel.jobAllAds!);
        } else {
          d('ERROR : ' + decodedResponse['response']['message']);
        }
      } catch (e) {
        d(e);
      }
    }
  }

  Future updateJobAd({required BuildContext context}) async {
    JobViewModel jobViewModel = context.read<JobViewModel>();
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    try {
      Uri uri = Uri.parse('${iExternalValues.getBaseUrl()}api/update_job/');
      d('This is url : ' + uri.toString());

      Navigator.push(
          context,
          CustomPageRoute(
              child: const CreatedSuccessfullyScreen(),
              direction: AxisDirection.down));

      var request = http.MultipartRequest("PUT", uri);
      request.fields['id'] = jobAdData!.id!;
      request.fields['title'] = jobAdData!.title!;
      request.fields['category'] = jobAdData!.categoryId.toString();
      request.fields['salary_currency'] = jobAdData!.currencyId.toString();
      request.fields['salary_start'] = jobAdData!.salaryFrom.toString();
      request.fields['salary_end'] = jobAdData!.salaryTo.toString();
      request.fields['business_type'] = jobAdData!.adType.toString();
      request.fields['mobile'] = jobAdData!.phoneNumber.toString();
      request.fields['dial_code'] = jobAdData!.dialCode.toString();
      request.fields['description'] = jobAdData!.description.toString();
      request.fields['job_type'] = jobAdData!.jobType.toString();
      request.fields['salary_period'] = jobAdData!.salaryPeriod.toString();
      request.fields['position_type'] = jobAdData!.positionType.toString();
      request.fields['location'] = jobAdData!.streetAddress.toString();
      request.fields['longitude'] = jobAdData!.longitude.toString();
      request.fields['latitude'] = jobAdData!.latitude.toString();
      request.fields['remove_media'] = jsonEncode(jobAdData!.removeMediaIds);
      print(jsonEncode(jobAdData!.removeMediaIds));
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        updateJobAdMedia(context: context);
        JobProductModel jobSingleAd =
            JobProductModel.fromJson(decodedResponse['response']);
        for (int i = 0; i < jobViewModel.jobAllAds!.length; i++) {
          if (jobViewModel.jobAllAds![i].id == jobSingleAd.id) {
            jobViewModel.jobAllAds![i] = jobSingleAd;
          }
        }
        jobViewModel.changeJobAllAds(jobViewModel.jobAllAds!);
        profileViewModel.changeMyJobAds(jobViewModel.jobAllAds!);

        NotificationService showNotification = NotificationService();
        showNotification.cancelNotification(1);
        showNotification.showPostUploadingInfo(id: 1111, title: 'YouOnline', body: 'Your ad is posted successfully');


      } else {
        d('ERROR : ' + decodedResponse['response']['message']);
      }
    } catch (e) {
      d(e);
    }
  }
}

class ClassifiedObject {
  String? id;
  List<String>? removeMediaIds;
  String? title;
  String? categoryId;
  String? subCategoryId;
  String? currencyId;
  String? currencyCode;
  String? dialCode;
  double? price;
  String? description;
  String? conditionType;
  String? phoneNumber;
  String? brandId;
  String? adType;
  String? brandName;
  String? streetAddress;
  List<XFile>? images;
  List<String>? imagesPath;
  String? videoPath;
  File? video;
  String? latitude;
  String? longitude;

  ClassifiedObject({
    this.id,
    this.removeMediaIds,
    this.title,
    this.videoPath,
    this.imagesPath,
    this.categoryId,
    this.subCategoryId,
    this.brandName,
    this.currencyId,
    this.price,
    this.description,
    this.phoneNumber,
    this.conditionType,
    this.brandId,
    this.streetAddress,
    this.images,
    this.latitude,
    this.longitude,
    this.video,
    this.dialCode,
    this.currencyCode,
    this.adType,
  });
}

class AutomotiveObject {
  String? id;
  String? title;
  List<String>? removeMediaIds;
  String? categoryId;
  String? subCategoryId;
  String? mobileNumber;
  String? dialCode;
  String? currencyId;
  double? price;
  String? subCategoryTitle;
  String? description;
  String? conditionType;
  String? phoneNumber;
  String? modelId;
  String? makeName;
  String? makeId;
  String? modelName;
  String? mileage;
  String? color;
  String? automaticType;
  String? rentHours;

  int? year;
  String? fuelType;
  String? transmissionType;
  String? streetAddress;
  List<XFile>? images;
  List<String>? imagesPath;
  String? videoPath;
  File? video;
  String? adType;
  String? latitude;
  String? longitude;

  AutomotiveObject(
      {this.id,
      this.title,
      this.categoryId,
      this.subCategoryId,
      this.mobileNumber,
      this.currencyId,
      this.price,
      this.description,
      this.phoneNumber,
      this.conditionType,
      this.streetAddress,
      this.images,
      this.latitude,
      this.longitude,
      this.fuelType,
      this.makeId,
      this.makeName,
      this.modelId,
      this.modelName,
      this.transmissionType,
      this.year,
      this.subCategoryTitle,
      this.mileage,
      this.video,
      this.dialCode,
      this.automaticType,
      this.color,
      this.rentHours,
      this.imagesPath,
      this.removeMediaIds,
      this.adType,
      this.videoPath});
}

class PropertiesObject {
  String? id;
  String? title;
  String? categoryId;
  String? subCategoryId;
  String? dialCode;
  String? mobileNumber;
  String? currencyId;
  String? propertyType;
  String? cityId;
  String? locatedId;
  String? locatedName;
  String? subCategoryName;
  double? price;
  String? furnished;
  String? bedrooms;
  String? bathrooms;
  String? description;
  String? areaUnit;
  String? area;
  String? phoneNumber;
  String? streetAddress;
  String? adType;
  List<XFile>? images;
  List<String>? imagesPath;
  List<String>? removeMediaIds;

  String? videoPath;
  File? video;
  String? latitude;
  String? longitude;

  PropertiesObject({
    this.title,
    this.categoryId,
    this.subCategoryId,
    this.mobileNumber,
    this.currencyId,
    this.price,
    this.description,
    this.phoneNumber,
    this.streetAddress,
    this.images,
    this.cityId,
    this.locatedId,
    this.latitude,
    this.locatedName,
    this.longitude,
    this.propertyType,
    this.bathrooms,
    this.bedrooms,
    this.furnished,
    this.subCategoryName,
    this.areaUnit,
    this.area,
    this.removeMediaIds,
    this.video,
    this.dialCode,
    this.id,
    this.imagesPath,
    this.videoPath,
    this.adType,
  });
}

class JobObject {
  String? id;
  String? title;
  String? categoryId;
  String? currencyId;
  String? currencyCode;
  String? phoneNumber;
  String? dialCode;
  String? jobType;
  String? positionType;
  String? salaryPeriod;
  String? description;
  String? salaryFrom;
  String? salaryTo;
  String? streetAddress;
  String? adType;
  List<XFile>? images;
  List<String>? imagesPath;
  List<String>? removeMediaIds;

  String? videoPath;
  File? video;
  String? latitude;
  String? longitude;

  JobObject({
    this.title,
    this.categoryId,
    this.currencyId,
    this.description,
    this.streetAddress,
    this.images,
    this.latitude,
    this.longitude,
    this.jobType,
    this.salaryFrom,
    this.salaryPeriod,
    this.salaryTo,
    this.positionType,
    this.video,
    this.removeMediaIds,
    this.dialCode,
    this.phoneNumber,
    this.id,
    this.videoPath,
    this.imagesPath,
    this.currencyCode,
    this.adType,
  });
}
