import 'package:any_link_preview/any_link_preview.dart';
import 'package:appwrite/appwrite.dart';
import 'package:demo_appwrite_all_query/utils/constants/appwrite_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../models/tweet_model.dart';
import '../../../../../models/user_model.dart';
import '../../../../../utils/common/error_page.dart';
import '../../../../../utils/common/loading_page.dart';
import '../../../../../utils/constants/assets_constants.dart';
import '../../../../../utils/enums/tweet_type_enum.dart';
import '../../../../../utils/theme/pallete.dart';
import '../../../../routes/name_routes.dart';
import '../../tweetreply/views/twitter_reply_view.dart';
import '../../widgets/carousel_image.dart';
import '../../widgets/hashtag_text.dart';
import '../../widgets/tweet_icon_button.dart';
import '../controller/tweetlistcontroller.dart';

class TweetList extends GetView<TweetListController> {
  TweetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tweet List'),
        ),
        body:
            Obx(() => controller.userModel == null && controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      controller.getUserData();
                      // Handle refresh logic if needed
                      controller.currentPage =
                          1; // Reset current page when refreshing
                      controller.tweets.clear(); // Clear existing tweets
                      await controller.getTweets();
                    },
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!controller.isNewDataLoading.value &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          // Reached the end of the list, load more tweets
                          controller.getTweets();
                        }
                        return false;
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount:controller.tweets.length + (controller.isNewDataLoading.value ? 1 : 0),
                              // shrinkWrap: true,
                              // physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                if (index < controller.tweets.length) {
                                  final tweet = controller.tweets[index];
                                  return tweetCard(tweet, controller, context);
                                } else if (controller.isNewDataLoading.value) {
                                  // Show loading indicator at the end
                                  return Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                                   decoration: BoxDecoration(
                                     color: Pallete.backgroundColor,
                                   ),
                                    child: CircularProgressIndicator() ,
                                  );
                                } else {
                                  // You can replace this with an empty SizedBox or another widget
                                  return SizedBox();
                                }
                                // final tweet = controller.tweets.value[index];
                                // return tweetCard(tweet, controller, context);
                              },
                            ),
                          ),
                          // StreamBuilder<Map<String,dynamic>>(
                          //   stream: controller.tweetApiController.getLatestTweet(),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.hasData) {
                          //       final latestTweet = snapshot.data!;
                          //       // final data = latestTweet.events ;
                          //       var umap = latestTweet ;
                          //       print("latesttweet ${umap}");
                          //       return SizedBox();
                          //       // Render your latest tweet widget here
                          //       // return tweetCard( latestTweet ,controller , context);
                          //     } else if (snapshot.hasError) {
                          //       return ErrorText(error: snapshot.error.toString());
                          //     } else {
                          //       return Loader();
                          //     }
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  )));
  }
}

tweetCard(Tweet tweet, TweetListController controller, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Get.to(TwitterReplyScreen(
          tweet: tweet,
          usermodel: controller.userModel!,
          tweetlistcontroller: controller));
      // Get.toNamed(NameRoutes.tweetReplyView, arguments: {
      //   "tweet": tweet,
      //   'usermodel': controller.userModel!
      // });
    },
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(NameRoutes.userStremView,
                      arguments: {"userModel": controller.userModel!});
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      controller.userModel!.profilePic.isNotEmpty
                          ? controller.userModel!.profilePic
                          : AppwriteConstants.images),
                  radius: 35,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tweet.retweetedBy.isNotEmpty)
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetsConstants.retweetIcon,
                          color: Pallete.greyColor,
                          height: 20,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${tweet.retweetedBy} retweeted',
                          style: const TextStyle(
                            color: Pallete.greyColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          right: controller.userModel!.isTwitterBlue ? 1 : 5,
                        ),
                        child: Text(
                          controller.userModel!.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),
                      if (controller.userModel!.isTwitterBlue)
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: SvgPicture.asset(
                            AssetsConstants.verifiedIcon,
                          ),
                        ),
                      Text(
                        '@${controller.userModel!.name} · ${timeago.format(
                          tweet.tweetedAt,
                          locale: 'en_short',
                        )}',
                        style: const TextStyle(
                          color: Pallete.greyColor,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  if (tweet.repliedTo.isNotEmpty)
                    FutureBuilder(
                      future: controller.tweetReplyController
                          .getRepliesStream(tweet),
                      builder: (context, AsyncSnapshot<List<Tweet>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Loader();
                        } else if (snapshot.hasError) {
                          return ErrorText(error: snapshot.error.toString());
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const SizedBox(); // or any other empty state widget
                        } else {
                          final tweets = snapshot.data!;
                          final UserModel? currentUser = controller
                              .userModel; // Get the current user model

                          return Column(
                            children: [
                              if (currentUser != null &&
                                  tweet.uid == currentUser.uid)
                                RichText(
                                  text: TextSpan(
                                    text: 'Replying to ',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '@${currentUser.name}',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        }
                      },
                    ),

                  //   FutureBuilder(
                  //     future: controller.tweetReplyController.getRepliesStream(tweet),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         final tweets = snapshot.data!;
                  //         return ListView.builder(
                  //           itemCount: tweets.length,
                  //           itemBuilder: (BuildContext context, int index) {
                  //             final tweet = tweets[index];
                  //             return tweetCard(
                  //                 tweet, controller,
                  //                 context);
                  //           },
                  //         );
                  //       } else if (snapshot.hasError) {
                  //         return ErrorText(error: snapshot.error.toString());
                  //       } else {
                  //         return const Loader();
                  //       }
                  //     },
                  //   )
                  // //
                  // ref
                  //     .watch(
                  //     getTweetByIdProvider(widget.tweet.repliedTo))
                  //     .when(
                  //   data: (repliedToTweet) {
                  //     final replyingToUser = ref
                  //         .watch(
                  //       userDetailsProvider(
                  //         repliedToTweet.uid,
                  //       ),
                  //     )
                  //         .value;
                  //     return RichText(
                  //       text: TextSpan(
                  //         text: 'Replying to',
                  //         style: const TextStyle(
                  //           color: Pallete.greyColor,
                  //           fontSize: 16,
                  //         ),
                  //         children: [
                  //           TextSpan(
                  //             text:
                  //             ' @${replyingToUser?.name}',
                  //             style: const TextStyle(
                  //               color: Pallete.blueColor,
                  //               fontSize: 16,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  //   error: (error, st) => ErrorText(
                  //     error: error.toString(),
                  //   ),
                  //   loading: () => const SizedBox(),
                  // ),
                  HashtagText(text: tweet.text),
                  if (tweet.tweetType == TweetType.image)
                    CarouselImage(imageLinks: tweet.imageLinks),
                  if (tweet.link.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    AnyLinkPreview(
                      displayDirection: UIDirection.uiDirectionHorizontal,
                      link: 'https://${tweet.link}',
                    ),
                  ],
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TweetIconButton(
                          pathName: AssetsConstants.viewsIcon,
                          text: (tweet.commentIds.length +
                                  tweet.reshareCount +
                                  tweet.likes.length)
                              .toString(),
                          onTap: () {},
                        ),
                        TweetIconButton(
                          pathName: AssetsConstants.commentIcon,
                          text: tweet.commentIds.length.toString(),
                          onTap: () {},
                        ),
                        TweetIconButton(
                          pathName: AssetsConstants.retweetIcon,
                          text: tweet.reshareCount.toString(),
                          onTap: () {
                            controller.reshareTweet(tweet, context);
                            // ref
                            //     .read(tweetControllerProvider
                            //     .notifier)
                            //     .reshareTweet(
                            //   widget.tweet,
                            //   userModel,
                            //   context,
                            // );
                          },
                        ),
                        LikeButton(
                          size: 25,
                          onTap: (isLiked) async {
                            controller.likeTweet(tweet);
                          },
                          isLiked:
                              tweet.likes.contains(controller.userModel!.uid),
                          likeBuilder: (isLiked) {
                            return isLiked
                                ? SvgPicture.asset(
                                    AssetsConstants.likeFilledIcon,
                                    color: Pallete.redColor,
                                  )
                                : SvgPicture.asset(
                                    AssetsConstants.likeOutlinedIcon,
                                    color: Pallete.greyColor,
                                  );
                          },
                          likeCount: tweet.likes.length,
                          countBuilder: (likeCount, isLiked, text) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: isLiked
                                      ? Pallete.redColor
                                      : Pallete.whiteColor,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share_outlined,
                            size: 25,
                            color: Pallete.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 1),
                ],
              ),
            ),
          ],
        ),
        const Divider(color: Pallete.greyColor),
      ],
    ),
  );
}
