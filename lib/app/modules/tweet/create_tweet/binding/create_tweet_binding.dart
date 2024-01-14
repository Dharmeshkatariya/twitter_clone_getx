import 'package:get/get.dart';

import '../../../../../api/tweetapi_controller.dart';
import '../controller/create_tweetcontroller.dart';

class CreateTweetBinding extends Bindings {


  @override
  void dependencies() {
    Get.put(CreateTweetController());
    Get.put(TweetAPIController());
    // TODO: implement dependencies
  }

}
