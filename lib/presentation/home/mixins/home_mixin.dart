import 'package:flutter/material.dart';

mixin HomeMixin<T extends StatefulWidget> on State<T>{
  PageController pageController = PageController(initialPage: 0);

}