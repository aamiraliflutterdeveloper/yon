import 'package:app/di/service_locator.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:flutter/material.dart';

mixin ClassifiedScreenMixin<T extends StatefulWidget> on State<T> {
  int currentMainMenuIndex = 0;
  IClassified repo = inject<IClassified>();


}