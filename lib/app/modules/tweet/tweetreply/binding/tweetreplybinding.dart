import 'package:get/get.dart';

import '../controller/tweetreplycontroller.dart';

class TweetReplyBinding extends Bindings{
  @override
  void dependencies() {

    Get.put(TweetReplyController()) ;
    // TODO: implement dependencies
  }

}