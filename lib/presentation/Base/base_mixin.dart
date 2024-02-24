import 'package:app/application/network/external_values/IExternalValues.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/presentation/utils/overlay_utils.dart';
import 'package:flutter/material.dart';


mixin BaseMixin<T extends StatefulWidget> on State<T> {
  OverlyHelper helper = inject<OverlyHelper>();
  IPrefHelper iPrefHelper = inject<IPrefHelper>();
  IExternalValues iExternalValues = inject<IExternalValues>();

  @protected
  void showOverlay(String msg) {
    helper.showToast(msg);
  }
}






