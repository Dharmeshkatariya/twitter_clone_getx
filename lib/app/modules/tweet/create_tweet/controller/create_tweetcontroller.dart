import 'dart:io';
import 'package:appwrite/models.dart' as model;
import 'package:demo_appwrite_all_query/api/storageapiController.dart';
import 'package:demo_appwrite_all_query/api/tweetapi_controller.dart';
import 'package:demo_appwrite_all_query/app/modules/auth/controller/auth_controller.dart';
import 'package:demo_appwrite_all_query/app/modules/notification_view/controller/notification_view_controller.dart';
import 'package:demo_appwrite_all_query/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../models/tweet_model.dart';
import '../../../../../utils/enums/notification_type_enum.dart';
import '../../../../../utils/enums/tweet_type_enum.dart';
import '../../../../../utils/utils.dart';
import '../../tweetreply/controller/tweetreplycontroller.dart';

class CreateTweetController extends GetxController {
  final tweetTextController = TextEditingController();
  final authcontroller = Get.put(AuthController());

  List<File> images = [];

  @override
  void onInit() async {
    isLoading.value = true;
    getargument();

    currentUser = await authcontroller.getUser()!;

    super.onInit();
  }

  late model.User currentUser;

  final tweetApiController = Get.put(TweetAPIController());
  final tweetreplyController = Get.put(TweetReplyController());

  // final storageApiController = Get.put(StorageAPIController());

  RxBool isLoading = false.obs;

  // void shareTweet() async {
  //   try {
  //     isLoading.value = true;
  //     List<String> imageLinks = await storageApiController.uploadImage(images);
  //     Tweet tweet = Tweet(
  //         text: tweetTextController.text,
  //         hashtags: [],
  //         link: "",
  //         imageLinks: imageLinks,
  //         uid: "",
  //         tweetType: TweetType.text,
  //         tweetedAt: DateTime.now(),
  //         likes: [],
  //         commentIds: [],
  //         id: "",
  //         reshareCount: 0,
  //         retweetedBy: "",
  //         repliedTo: "");
  //     tweetApiController.shareTweet(tweet);
  //     isLoading.value = false;
  //     Get.snackbar("Share", "Done") ;
  //     Get.back();
  //
  //   } catch (e) {
  //     isLoading.value = false;
  //
  //     print(e);
  //   }
  //
  //   // ref.read(tweetControllerProvider.notifier).shareTweet(
  //   //   images: images,
  //   //   text: tweetTextController.text,
  //   //   context: context,
  //   //   repliedTo: '',
  //   //   repliedToUserId: '',
  //   // );
  //   // Navigator.pop(context);
  // }
  // sharetweets(BuildContext context) {
  //   isLoading.value = true;
  //   var res = tweetreplyController.shareTweet(
  //       images: images,
  //       text: tweetTextController.text,
  //       context: context,
  //       userModel: userModel!,
  //       repliedTo: "",
  //       repliedToUserId: "");
  //
  //   isLoading.value = false;
  //   Get.snackbar("Share", "Done");
  //   Get.back();
  // }

  onPickImages() async {
    isLoading.value = true;
    var data = await pickImages();
    images.addAll(data);
    print(images);
    isLoading.value = false;

    update();
    // setState(() {});
  }

  UserModel? userModel;

  getargument() {
    var argument = Get.arguments;
    var model = argument["userModel"];
    print("user:${userModel}") ;
    userModel = model;
    isLoading.value = false;
  }

  @override
  void dispose() {
    super.dispose();
    tweetTextController.dispose();
  }

  // late TweetListController tweetListController ;
  final storegeController   = Get.put(StorageAPIController()) ;
  void shareTweet({
    required BuildContext context,
  }) {
    
    print("object");
    isLoading.value =  true ;

    var text = tweetTextController.text ;
    if (tweetTextController.text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        userModel: userModel!,
        text: text,

        context: context,
        repliedTo: "",
        repliedToUserId: "",
      );
    } else {
      _shareTextTweet(
        text: text,
        userModel: userModel!,
        context: context,
        repliedTo: "",
        repliedToUserId: "",
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

  final notificationController  = Get.put(NotificationViewController()) ;
  Future<List<Tweet>> getRepliesStream(Tweet tweet) {
    return tweetApiController.getRepliesToTweetTo(tweet);
  }
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

    if (repliedToUserId.isNotEmpty) {

    await  notificationController.createNotification(
        text: '${user.name} replied to your tweet!',
        postId: res.$id,
        notificationType: NotificationType.reply,
        uid: repliedToUserId,
      );
    Get.snackbar("create notification replied share tweet ", "done ") ;

    }
    isLoading.value =  false ;
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
   var res2  =await  notificationController.createNotification(
      text: '${user.name} replied to your tweet!',
      postId: res.$id,
      notificationType: NotificationType.reply,
      uid: repliedToUserId,
    );
    Get.snackbar("replied to your tweet  ", "done tweet") ;

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
}
