import 'package:demo_appwrite_all_query/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../models/tweet_model.dart';
import '../../../../../utils/common/error_page.dart';
import '../../../../../utils/common/loading_page.dart';
import '../../tweetlist/controller/tweetlistcontroller.dart';
import '../../tweetlist/view/tweet_list.dart';
import '../controller/tweetreplycontroller.dart';


class TwitterReplyScreen extends StatefulWidget {
   const TwitterReplyScreen({super.key,required this.tweet ,required this.usermodel,required this.tweetlistcontroller});

   final Tweet tweet ;
   final UserModel usermodel  ;
   final TweetListController tweetlistcontroller  ;

  @override
  State<TwitterReplyScreen> createState() => _TwitterReplyScreenState();
}

class _TwitterReplyScreenState extends State<TwitterReplyScreen> {


  final controller  = Get.put(TweetReplyController()) ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final replyController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
      body: Column(
        children: [
          // TweetCard(tweet: tweet),
          tweetCard(widget.tweet, widget.tweetlistcontroller, context),

          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return FutureBuilder(
                    future: controller.getRepliesStream(widget.tweet),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final tweets = snapshot.data!;
                        return ListView.builder(
                          itemCount: tweets.length,
                          itemBuilder: (BuildContext context, int index) {
                            final tweet = tweets[index];
                            return tweetCard(
                                tweet, widget.tweetlistcontroller, context);
                          },
                        );
                      } else if (snapshot.hasError) {
                        return ErrorText(error: snapshot.error.toString());
                      } else {
                        return const Loader();
                      }
                    },
                  );
                  // return StreamBuilder<List<Tweet>>(
                  //   stream: controller.getRepliesStream(controller.tweet.id),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       final tweets = snapshot.data!;
                  //       return ListView.builder(
                  //         itemCount: tweets.length,
                  //         itemBuilder: (BuildContext context, int index) {
                  //           final tweet = tweets[index];
                  //           return TweetCard(tweet: tweet);
                  //         },
                  //       );
                  //     } else if (snapshot.hasError) {
                  //       return ErrorText(error: snapshot.error.toString());
                  //     } else {
                  //       return const Loader();
                  //     }
                  //   },
                  // );
                }
              },
            ),
          ),
          // ref.watch(getRepliesToTweetsProvider(tweet)).when(
          //       data: (tweets) {
          //         return ref.watch(getLatestTweetProvider).when(
          //               data: (data) {
          //                 final latestTweet = Tweet.fromMap(data.payload);
          //
          //                 bool isTweetAlreadyPresent = false;
          //                 for (final tweetModel in tweets) {
          //                   if (tweetModel.id == latestTweet.id) {
          //                     isTweetAlreadyPresent = true;
          //                     break;
          //                   }
          //                 }
          //
          //                 if (!isTweetAlreadyPresent &&
          //                     latestTweet.repliedTo == tweet.id) {
          //                   if (data.events.contains(
          //                     'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
          //                   )) {
          //                     tweets.insert(0, Tweet.fromMap(data.payload));
          //                   } else if (data.events.contains(
          //                     'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
          //                   )) {
          //                     // get id of original tweet
          //                     final startingPoint =
          //                         data.events[0].lastIndexOf('documents.');
          //                     final endPoint =
          //                         data.events[0].lastIndexOf('.update');
          //                     final tweetId = data.events[0]
          //                         .substring(startingPoint + 10, endPoint);
          //
          //                     var tweet = tweets
          //                         .where((element) => element.id == tweetId)
          //                         .first;
          //
          //                     final tweetIndex = tweets.indexOf(tweet);
          //                     tweets.removeWhere(
          //                         (element) => element.id == tweetId);
          //
          //                     tweet = Tweet.fromMap(data.payload);
          //                     tweets.insert(tweetIndex, tweet);
          //                   }
          //                 }
          //
          //                 return Expanded(
          //                   child: ListView.builder(
          //                     itemCount: tweets.length,
          //                     itemBuilder: (BuildContext context, int index) {
          //                       final tweet = tweets[index];
          //                       return TweetCard(tweet: tweet);
          //                     },
          //                   ),
          //                 );
          //               },
          //               error: (error, stackTrace) => ErrorText(
          //                 error: error.toString(),
          //               ),
          //               loading: () {
          //                 return Expanded(
          //                   child: ListView.builder(
          //                     itemCount: tweets.length,
          //                     itemBuilder: (BuildContext context, int index) {
          //                       final tweet = tweets[index];
          //                       return TweetCard(tweet: tweet);
          //                     },
          //                   ),
          //                 );
          //               },
          //             );
          //       },
          //       error: (error, stackTrace) => ErrorText(
          //         error: error.toString(),
          //       ),
          //       loading: () => const Loader(),
          //     ),
        ],
      ),
      bottomNavigationBar: TextField(
        controller: replyController,
        onSubmitted: (value) {
          controller.shareTweet(
            images: [],
            text: value,
            userModel: widget.usermodel,
            context: context,
            repliedTo: widget.tweet!.id,
            repliedToUserId: widget.tweet!.uid,
          );
        },
        decoration: InputDecoration(
            hintText: 'Tweet your reply',
            suffixIcon: GestureDetector(
                onTap: () {
                  controller.shareTweet(
                    images: [],
                    userModel: widget.usermodel,
                    text: replyController.text,
                    context: context,
                    repliedTo: widget.tweet.id,
                    repliedToUserId: widget.tweet.uid,
                  );
                },
                child: Icon(Icons.send))),
      ),
    );
  }
}
