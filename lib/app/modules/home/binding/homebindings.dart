import 'package:demo_appwrite_all_query/app/modules/explore/controller/explore_controller.dart';
import 'package:get/get.dart';

import '../../notification_view/controller/notification_view_controller.dart';
import '../../tweet/tweetlist/controller/tweetlistcontroller.dart';
import '../controller/homecontroller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(HomeController()) ;
    Get.put(ExploreController()) ;
    Get.put(TweetListController()) ;
    Get.put(NotificationViewController()) ;
    // TODO: implement dependencies
  }

}