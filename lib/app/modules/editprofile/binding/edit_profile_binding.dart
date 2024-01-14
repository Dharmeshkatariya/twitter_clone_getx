import 'package:demo_appwrite_all_query/app/modules/editprofile/controller/edit_controller.dart';
import 'package:get/get.dart';

class EditProfileBindin extends Bindings{
  @override
  void dependencies() {
    Get.put(EditProfileController()) ;
    // TODO: implement dependencies
  }

}