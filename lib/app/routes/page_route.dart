import 'package:demo_appwrite_all_query/app/modules/editprofile/binding/edit_profile_binding.dart';
import 'package:demo_appwrite_all_query/app/modules/explore/explore_bindings.dart';
import 'package:demo_appwrite_all_query/app/modules/explore/view/explore_view.dart';
import 'package:demo_appwrite_all_query/app/modules/home/binding/homebindings.dart';
import 'package:demo_appwrite_all_query/app/modules/home/view/home_view.dart';
import 'package:demo_appwrite_all_query/app/modules/user_strem_view/binings/user_stremviewbindinhg.dart';
import 'package:demo_appwrite_all_query/app/modules/user_strem_view/user_profile_view.dart';
import 'package:get/get.dart';
import '../modules/auth/bindings/binding.dart';
import '../modules/auth/view/login_view.dart';
import '../modules/auth/view/signup_view.dart';
import '../modules/editprofile/view/edit_profile_view.dart';
import '../modules/tweet/create_tweet/binding/create_tweet_binding.dart';
import '../modules/tweet/create_tweet/view/create_tweet.dart';
import '../modules/tweet/hastaagview/binding/hashtagviewbinidng.dart';
import '../modules/tweet/hastaagview/view/hashtag_view.dart';
import '../modules/tweet/tweetlist/binding/tweetlistbinding.dart';
import '../modules/tweet/tweetlist/view/tweet_list.dart';
import 'name_routes.dart';


class PageRoutes {
  static final pages = [

    // GetPage(
    //   name: NameRoutes.notificationScreen,
    //   page: () => const NotificationView(),
    //   binding: NotificationBindings(),
    // ),
    GetPage(
      name: NameRoutes.signUpScreen,
      page: () =>  SignUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: NameRoutes.userStremView,
      page: () =>  UserStremView(),
      binding: UserStremViewBidnig(),
    ),
    GetPage(
      name: NameRoutes.editProfile,
      page: () =>  EditProfileView(),
      binding: EditProfileBindin(),
    ),
    GetPage(
      name: NameRoutes.loginScreen,
      page: () =>  LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: NameRoutes.exploreScreen,
      page: () =>  ExploreView(),
      binding: ExploreBindigs(),
    ),
    GetPage(
      name: NameRoutes.homeScreen,
      page: () =>  HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: NameRoutes.createTweetView,
      page: () =>  CreateTweetScreen(),
      binding: CreateTweetBinding(),
    ),
    GetPage(
      name: NameRoutes.hashTagView,
      page: () =>  HashtagView(),
      binding: HashTagViewBindign(),
    ),
    // GetPage(
    //   name: NameRoutes.tweetReplyView,
    //   page: () =>  TwitterReplyScreen(),
    //   binding: TweetReplyBinding(),
    // ),
    GetPage(
      name: NameRoutes.tweetList,
      page: () =>  TweetList(),
      binding: TweetListBinding(),
    ),
    // GetPage(
    //   name: NameRoutes.editProfile,
    //   page: () =>  EditProfileView(),
    //   binding: UserProfileBinding(),
    // ),GetPage(
    //   name: NameRoutes.userProfile,
    //   page: () =>  UserProfileView(),
    //   binding: UserProfileBinding(),
    // ),
    // GetPage(
    //   name: NameRoutes.loginScreen,
    //   page: () => const LoginScreen(controller: controller),
    //   binding: AuthBinding(),
    // ),
    // GetPage(
    //       name: NameRoutes.tabBarListScreen,
    //       page: () => TabBarViewCategoryScreen(category: category),
    //       binding: DashboardBinding(),
    //     ),
  ];
}
