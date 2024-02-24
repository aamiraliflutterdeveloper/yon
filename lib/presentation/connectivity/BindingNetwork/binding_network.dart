import 'package:app/presentation/connectivity/GetXNetworkManager/getx_network_manager.dart';
import 'package:get/get.dart';

class BindingNetwork extends Bindings {
  @override
  void dependencies() {
    Get.put<GetXNetworkManager>(GetXNetworkManager());
  }
}
