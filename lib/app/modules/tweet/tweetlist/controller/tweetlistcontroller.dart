import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:demo_appwrite_all_query/api/tweetapi_controller.dart';
import 'package:demo_appwrite_all_query/app/modules/notification_view/controller/notification_view_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../api/userController.dart';
import '../../../../../models/tweet_model.dart';
import '../../../../../models/user_model.dart';
import '../../../../../utils/enums/notification_type_enum.dart';
import '../../../../../utils/utils.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../tweetreply/controller/tweetreplycontroller.dart';

class TweetListController extends GetxController {
  UserModel? userModel;
  final List<Tweet> _tweets = <Tweet>[].obs;
  final StreamController<Tweet> _latestTweetController =
  StreamController<Tweet>.broadcast();
  final tweetReplyController  = Get.put(TweetReplyController());








  final authController = Get.put(AuthController());
  final userController = Get.put(UserController());

  final isLoading = false.obs;

  getUserData() async {
    isLoading.value = true;
    var user = await authController.getUser();

    var userdocument = await userController.getUserData(user.$id);
    // final tweets = userdocument.
    //     .map((doc) => UserModel.fromMap(doc.data))
    //     .toList();
    var data = userdocument.data;
    var model = UserModel.fromMap(data);
    userModel = model;
    print("user :${model}");

    return model;
  }

  @override
  void onInit() {
    getUserData();
    // getUserData();

    getTweets();
    // TODO: implement onInit
    super.onInit();
  }

  RxList<Tweet> tweets = <Tweet>[].obs;

  final tweetApiController = Get.put(TweetAPIController());

  // getTweet() async {
  //   tweets.value = await tweetApiController.getTweets();
  //   print(tweets);
  //
  // }
 RxBool isNewDataLoading  =  false.obs ;
   getTweets() async {
   if(isNewDataLoading.value){
     return ;
   }

    try {
      isNewDataLoading.value = true ;
      isLoading.value = true;
      final List<Tweet> newTweets =
      await tweetApiController.getTweetsPaginated(currentPage, tweetsPerPage);

      if (newTweets.isNotEmpty) {
        tweets.value.addAll(newTweets);
        currentPage++; // Increment the current page for the next request
      }
      Timer(const Duration(seconds: 4), () {
        isLoading.value = false;
        isNewDataLoading.value = false ;

      });
    } finally {
      Timer(const Duration(seconds: 4), () {
        isLoading.value = false;
        isNewDataLoading.value = false ;

      });
    }
  }
  final int tweetsPerPage = 10;
  int currentPage = 1;


  void reshareTweet(
      Tweet tweet,
      BuildContext context ,
      ) async {
    var currentUser = userModel!;
    tweet = tweet.copyWith(
      retweetedBy: currentUser.name,
      likes: [],
      commentIds: [],
      reshareCount: tweet.reshareCount + 1,
    );
print(tweet) ;
    final newtweet = await tweetApiController.updateReshareCount(tweet);

    // print(res)
    // Update the specific tweet in the list
    print(newtweet) ;

    final index = tweets.indexWhere((t) => t.id == tweet.id);
    if (index != -1) {
      tweets[index] = newtweet;
    }
    tweet = tweet.copyWith(
      id: ID.unique(),
      reshareCount: 0,
      tweetedAt: DateTime.now(),
    );
   var sharetweet  = await tweetApiController.shareTweet(tweet);
print(sharetweet) ;
   await notificationViewController.createNotification(
        text: '${currentUser.name} reshared your tweet!',
        postId: tweet.id,
        notificationType: NotificationType.retweet,
        uid: tweet.uid,

    ) ;


    // _notificationController.createNotification(

    // );
    showSnackBar(context, 'Retweeted!');
  }

  final notificationViewController  = Get.put(NotificationViewController()) ;

  Future<Tweet> getTweetById(String id) async {
    final tweet = await tweetApiController.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }
  void likeTweet(Tweet tweet, ) async {
    isLoading.value = true ;

    var user = userModel!;
    List<String> likes = tweet.likes;

    if (tweet.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    tweet = tweet.copyWith(likes: likes);
    final res = await tweetApiController.likeTweet(tweet);
    print(res) ;
   await notificationViewController.createNotification(
      text: '${user.name} liked your tweet!',
      postId: tweet.id,
      notificationType: NotificationType.like,
      uid: tweet.uid,
    );
    Get.snackbar("like your tweet ", "done") ;

    final index = tweets.value.indexWhere((t) => t.id == tweet.id);
    if (index != -1) {
      tweets.value[index] = tweet;
    }
    isLoading.value = false ;

    // res.fold((l) => null, (r) {
    //   _notificationController.createNotification(
    //     text: '${user.name} liked your tweet!',
    //     postId: tweet.id,
    //     notificationType: NotificationType.like,
    //     uid: tweet.uid,
    //   );
    // });
  }


}
