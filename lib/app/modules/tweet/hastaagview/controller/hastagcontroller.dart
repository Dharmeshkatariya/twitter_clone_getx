import 'package:get/get.dart';

import '../../../../../api/tweetapi_controller.dart';
import '../../../../../models/tweet_model.dart';
import '../../tweetlist/controller/tweetlistcontroller.dart';

class HashTagController extends GetxController{

  final tweetListController  = Get.put(TweetListController());

  @override
  void onInit() {
    getArgument() ;
    // TODO: implement onInit
    super.onInit();
  }

  final tweetApiController = Get.put(TweetAPIController()) ;
  RxString hashTag = "".obs ;
  getArgument()async{
    var argument = Get.arguments ;
    hashTag.value =  argument["hashTag"] ;
    getTweetsByHashtag(hashTag.value);
  }
  RxBool  isLoading =  false.obs ;
  List<Tweet>   tweet = [] ;

  Future<List<Tweet>> getTweetsByHashtag(String hashtag) async {
    try {
      isLoading.value = true ;
      final documents = await tweetApiController.getTweetsByHashtag(hashtag);
      tweet =  documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
      isLoading.value = false ;

      return tweet ;
    } finally {
      isLoading.value = false ;

    }
  }

}