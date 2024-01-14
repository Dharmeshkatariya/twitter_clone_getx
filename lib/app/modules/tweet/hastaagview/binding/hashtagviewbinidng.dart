import 'package:get/get.dart';

import '../../tweetlist/controller/tweetlistcontroller.dart';
import '../controller/hastagcontroller.dart';

class HashTagViewBindign extends Bindings {
  @override
  void dependencies() {
    Get.put(HashTagController());
    Get.put(TweetListController());
    // TODO: implement dependencies
  }
}
