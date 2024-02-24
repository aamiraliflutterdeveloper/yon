import 'package:app/common/logger/log.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier{
  int currentMainMenuIndex = 0;

  changeCurrentMainMenuIndex(int newIndex){
    currentMainMenuIndex = newIndex;
    d('CURRENT MAIN MENU INDEX :' + currentMainMenuIndex.toString());
    notifyListeners();
  }

}