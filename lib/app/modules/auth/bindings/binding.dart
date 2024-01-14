import 'package:get/get.dart';

import '../../../../utils/providers.dart';
import '../controller/auth_controller.dart';

class AuthBinding extends Bindings{

  @override
  void dependencies() {
    Get.put(AuthController(),permanent: true) ;
    Get.put(GlobalController() ,permanent: true) ;
    // TODO: implement dependencies
  }

}