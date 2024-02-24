import 'package:flutter/material.dart';

mixin AddPostMixin<T extends StatefulWidget> on State<T> {
  TextEditingController addTitleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController salaryFromController = TextEditingController();
  TextEditingController salaryToController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController mileageController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyLicenseController = TextEditingController();



  bool isProductNew = false;

  bool isPropertyForSale = true;

  bool isAutomotiveForSale = true;

  bool? isPropertyFurnished;

}