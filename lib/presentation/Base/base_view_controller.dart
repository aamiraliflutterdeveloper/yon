import 'package:flutter/foundation.dart';

class BaseViewModel extends ChangeNotifier{

  @protected
  void setState() => notifyListeners();
}