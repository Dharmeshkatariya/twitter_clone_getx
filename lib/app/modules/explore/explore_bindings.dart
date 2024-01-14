import 'package:demo_appwrite_all_query/app/modules/explore/controller/explore_controller.dart';
import 'package:get/get.dart';

class ExploreBindigs extends Bindings {
  @override
  void dependencies() {
    Get.put(ExploreController());
    // TODO: implement dependencies
  }
}
