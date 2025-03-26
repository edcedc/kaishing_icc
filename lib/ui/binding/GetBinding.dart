import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../login/login_logic.dart';

class GetBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => LoginLogic(),fenix: true);
  }

}