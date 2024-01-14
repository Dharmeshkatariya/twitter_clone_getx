import 'dart:io';

import 'package:demo_appwrite_all_query/api/storageapiController.dart';
import 'package:demo_appwrite_all_query/api/tweetapi_controller.dart';
import 'package:demo_appwrite_all_query/app/modules/notification_view/controller/notification_view_controller.dart';
import 'package:demo_appwrite_all_query/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../models/tweet_model.dart';
import '../../../../../utils/enums/notification_type_enum.dart';
import '../../../../../utils/enums/tweet_type_enum.dart';
import '../../../../../utils/utils.dart';

class TweetReplyController extends GetxController{



  final storegeController  = Get.put(StorageAPIController()) ;
  final notificationViewController  = Get.put(NotificationViewController()) ;
  // final TweetListController tweetListController = Get.find<TweetListController>();

  // late TweetListController tweetListController ;
  // final tweetListController   = Get.find(TweetListController()) ;
  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required UserModel userModel,
    required String repliedTo,
    required String repliedToUserId,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        userModel: userModel,
        text: text,

        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    } else {
      _shareTextTweet(
        text: text,
        userModel: userModel,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    }
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final documents = await tweetApiController.getRepliesToTweet(tweet);
    return documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<List<Tweet>> getTweetsByHashtag(String hashtag) async {
    final documents = await tweetApiController.getTweetsByHashtag(hashtag);
    return documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<List<Tweet>> getRepliesStream(Tweet tweet) {
    return tweetApiController.getRepliesToTweetTo(tweet);
  }
RxBool isLoading = false.obs ;
  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required UserModel userModel,
    required String repliedToUserId,
  }) async {
    isLoading.value = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = userModel! ;
    final imageLinks = await storegeController.uploadImage(images);
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await tweetApiController.shareTweet(tweet);

    if(res != null){
      if (repliedToUserId.isNotEmpty) {
        await notificationViewController.createNotification(
          text: '${user.name} replied to your tweet!',
          postId: res.$id,
          notificationType: NotificationType.reply,
          uid: repliedToUserId,

        ) ;
        showSnackBar(context, "reply tweet notification created ");

      }
    }
    isLoading.value = false;
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required UserModel userModel,
    required String repliedToUserId,
  }) async {
    isLoading.value = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = userModel! ;
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await tweetApiController.shareTweet(tweet);
    await notificationViewController.createNotification(
      text: '${user.name} replied to your tweet!',
      postId: res.id,
      notificationType: NotificationType.reply,
      uid: repliedToUserId,

    ) ;
    showSnackBar(context, "reply tweet notification created ");
    // res.fold((l) => showSnackBar(context, l.message), (r) {
    //   if (repliedToUserId.isNotEmpty) {
    //     // _notificationController.createNotification(
    //     //   text: '${user.name} replied to your tweet!',
    //     //   postId: r.$id,
    //     //   notificationType: NotificationType.reply,
    //     //   uid: repliedToUserId,
    //     // );
    //   }
    // });
    isLoading.value = false;
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }


  final tweetApiController  = Get.put(TweetAPIController()) ;
  // getTweetArgument (){
  //   isLoading.value = true ;
  //   var argument = Get.arguments ;
  //
  //   if(Get.arguments !=null){
  //     tweet = argument["tweet"] ;
  //     userModel = argument["usermodel"] ;
  //     // tweetListController = argument["controller"] ;
  //   }
  //
  //   isLoading.value = false ;
  //
  // }


  @override
  void onInit() {
    // getTweetArgument () ;
    // TODO: implement onInit
    super.onInit();
  }

  // late Tweet  tweet;
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}