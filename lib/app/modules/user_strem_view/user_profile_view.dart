import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:demo_appwrite_all_query/app/modules/auth/controller/auth_controller.dart';
import 'package:demo_appwrite_all_query/app/modules/notification_view/controller/notification_view_controller.dart';
import 'package:demo_appwrite_all_query/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../api/tweetapi_controller.dart';
import '../../../api/userController.dart';
import '../../../models/tweet_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/common/error_page.dart';
import '../../../utils/common/loading_page.dart';
import '../../../utils/constants/appwrite_constants.dart';
import '../../../utils/constants/assets_constants.dart';
import '../../../utils/enums/notification_type_enum.dart';
import '../../../utils/theme/pallete.dart';
import '../../routes/name_routes.dart';
import '../tweet/tweetlist/controller/tweetlistcontroller.dart';
import '../tweet/tweetlist/view/tweet_list.dart';
import '../user_profile/widget/follow_count.dart';

class UserStremView extends StatefulWidget {
  UserStremView({super.key});

  @override
  State<UserStremView> createState() => _UserStremViewState();
}

class _UserStremViewState extends State<UserStremView> {
  // final _userStremController  = Get.put(UserStreamController()) ;
  late UserModel copyOfUser;
  final authController = Get.put(AuthController());
  final userController = Get.put(UserController());
  final globalController = Get.put(GlobalController());
  final notificationViewController = Get.put(NotificationViewController());
  late UserModel userModel;
  late Databases _db;

  void followUser({
    required UserModel user,
    required BuildContext context,
    required UserModel currentUser,
  }) async {
    // already following
    if (currentUser.following.contains(user.uid)) {
      user.followers.remove(currentUser.uid);
      currentUser.following.remove(user.uid);
    } else {
      user.followers.add(currentUser.uid);
      currentUser.following.add(user.uid);
    }

    user = user.copyWith(followers: user.followers);
    currentUser = currentUser.copyWith(
      following: currentUser.following,
    );

    final res = await userController.followUser(user);
    print("follow ${res}");
    final sres = await userController.addToFollowing(currentUser);
    print("following  ${sres}");
    isLoading.value = false;

    print(res);
    await notificationViewController.createNotification(
      text: '${currentUser.name} followed you!',
            postId: currentUser.uid,
            notificationType: NotificationType.follow,
            uid: user.uid,
    );
    Get.snackbar("notification created ", currentUser.name) ;

    // res.fold((l) => showSnackBar(context, l.message), (r) async {
    //   final res2 = await _userAPI.addToFollowing(currentUser);
    //   res2.fold((l) => showSnackBar(context, l.message), (r) {
    //     _notificationController.createNotification(
    //       text: '${currentUser.name} followed you!',
    //       postId: '',
    //       notificationType: NotificationType.follow,
    //       uid: user.uid,
    //     );
    //   });
    // });
  }

  getUserData() async {
    isLoading.value = true;
    setState(() {});
    _db = globalController.appwriteDatabase;
    var user = await authController.getUser();

    var userdocument = await userController.getUserData(user.$id);
    // final tweets = userdocument.
    //     .map((doc) => UserModel.fromMap(doc.data))
    //     .toList();
    var data = userdocument.data;
    var model = UserModel.fromMap(data);
    userModel = model;
    print("user :${model}");
    getArgument();

    return model;
  }

  // List<Tweet> tweets = [];
  RxList<Tweet> tweets = <Tweet>[].obs;

  getUserTweetsREal(String uid) async {
    // isLoading.value = true;
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.equal('uid', uid),
      ],
    );
    // Convert List<Document> to List<Tweet>
    final tweetLists = documents.documents.map((document) {
      // Assuming Tweet has a factory method to create instances from a map
      return Tweet.fromMap(document.data);
    }).toList();

    tweets.value = tweetLists;
    // Timer(Duration(seconds: 5), () {
    //   isLoading =false ;
    //
    // })
    Timer(Duration(seconds: 5), () {
      isLoading.value = false;
      setState(() {});
    });
  }

  final tweetAPIController = Get.put(TweetAPIController());
  final tweetListModel = Get.put(TweetListController());

  // RxBool isLoading = false.obs;
  RxBool isLoading = false.obs;

  getArgument() {
    // isLoading.value = true;
    var argument = Get.arguments;
    var usermodel = argument["userModel"];
    copyOfUser = usermodel;
    getUserTweetsREal(copyOfUser.uid);
  }

  @override
  void initState() {
    getUserData();
    // getUserTweets(uid)

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: isLoading.value
              ? Loader()
              : StreamBuilder<RealtimeMessage?>(
                  stream: userController.getLatestUserProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return ErrorText(error: snapshot.error.toString());
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return userProfileCard(context, userModel, copyOfUser,
                          tweets, tweetListModel);
                    }
                    if (snapshot.data!.events.contains(
                      'databases.*.collections.${AppwriteConstants.usersCollection}.documents.${copyOfUser.uid}.update',
                    )) {
                      WidgetsBinding.instance?.addPostFrameCallback((_) {
                        copyOfUser = UserModel.fromMap(snapshot.data!.payload);
                      });
                    }
                    // if (snapshot.data!.events.contains(
                    //   'databases.*.collections.${AppwriteConstants
                    //       .usersCollection}.documents.${controller.copyOfUser
                    //       .uid}.update',
                    // )) {
                    //   controller.copyOfUser = UserModel.fromMap(snapshot.data!.payload);
                    //   print(controller.copyOfUser);
                    // }

                    return userProfileCard(
                        context, userModel, copyOfUser, tweets, tweetListModel);
                  },
                ),
          // userProfileCard(context, userModel, copyOfUser, tweets, tweetListModel)
        ));
  }

  Widget userProfileCard(BuildContext context, UserModel userModelForAppwrite,
      UserModel usermodel, RxList tweets, tweetListModel) {
    final currentUser = userModelForAppwrite;
    final user = usermodel;

    return Obx(() => NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 150,
              floating: true,
              snap: true,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                    child: user.bannerPic.isEmpty
                        ? Container(
                            color: Pallete.blueColor,
                          )
                        : Image.network(
                            user.bannerPic,
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: user.profilePic.isEmpty ?
                    Container(
                      color: Pallete.blueColor,
                    ) :
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      radius: 45,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: const EdgeInsets.all(20),
                    child: OutlinedButton(
                      onPressed: () {
                        if (currentUser.uid == user.uid) {
                          // edit profile
                          Get.toNamed(NameRoutes.editProfile,
                              arguments: {"user": user});
                          // Navigator.push(context, EditProfileView.route());
                        } else {
                          print(user);
                          print(currentUser);
                          followUser(
                              user: user,
                              context: context,
                              currentUser: currentUser);
                          // controoler .follwuser
                          // controller.followUser(
                          //   user: user,
                          //   context: context,
                          //   currentUser: currentUser,
                          // );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Pallete.whiteColor,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                      ),
                      child: Text(
                        currentUser.uid == user.uid
                            ? 'Edit Profile'
                            : currentUser.following.contains(user.uid)
                                ? 'Unfollow'
                                : 'Follow',
                        style: const TextStyle(
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (user.isTwitterBlue)
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: SvgPicture.asset(
                              AssetsConstants.verifiedIcon,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '@${user.name}',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Pallete.greyColor,
                      ),
                    ),
                    Text(
                      user.bio,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        FollowCount(
                          count: user.following.length,
                          text: 'Following',
                        ),
                        const SizedBox(width: 15),
                        FollowCount(
                          count: user.followers.length,
                          text: 'Followers',
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Divider(color: Pallete.whiteColor),
                  ],
                ),
              ),
            ),
          ];
        },
        body: tweets.value.isNotEmpty
            ? ListView.builder(
                itemCount: tweets.value.length,
                itemBuilder: (BuildContext context, int index) {
                  final tweet = tweets.value[index];
                  return tweetCard(tweet, tweetListModel, context);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              )

        // body: ref.watch(getUserTweetsProvider(user.uid)).when(
        //       data: (tweets) {
        //         // can make it realtime by copying code
        //         // from twitter_reply_view
        //         return ListView.builder(
        //           itemCount: tweets.length,
        //           itemBuilder: (BuildContext context, int index) {
        //             final tweet = tweets[index];
        //             return TweetCard(tweet: tweet);
        //           },
        //         );
        //       },
        //       error: (error, st) => ErrorText(
        //         error: error.toString(),
        //       ),
        //       loading: () => const Loader(),
        //     ),
        ));
  }
}
