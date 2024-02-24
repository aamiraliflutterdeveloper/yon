import 'package:app/application/network/external_values/IExternalValues.dart';

class ExternalValues implements IExternalValues {
  @override
  String getBaseUrl() {
    return 'https://services-dev.youonline.online/';
    return 'http://192.168.18.206:9000/';
  }
}
