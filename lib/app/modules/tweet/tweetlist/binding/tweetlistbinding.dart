import 'package:get/get.dart';

import '../../tweetreply/controller/tweetreplycontroller.dart';
import '../controller/tweetlistcontroller.dart';

class TweetListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TweetListController()) ;
    Get.put(TweetReplyController()) ;
    // TODO: implement dependencies
  }


}