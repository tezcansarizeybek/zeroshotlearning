import 'package:get/get.dart';
import 'package:zeroshotmobile/modules/main/main_controller.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
  }
}
