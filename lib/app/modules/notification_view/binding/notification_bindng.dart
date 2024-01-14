import 'package:demo_appwrite_all_query/app/modules/notification_view/controller/notification_view_controller.dart';
import 'package:get/get.dart';

class NotificationViewBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(NotificationViewController());
    // TODO: implement dependencies
  }
}
