import 'package:demo_appwrite_all_query/app/modules/home/controller/homecontroller.dart';
import 'package:demo_appwrite_all_query/app/modules/notification_view/view/notificationview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/assets_constants.dart';
import '../../../../utils/theme/pallete.dart';
import '../../explore/view/explore_view.dart';
import '../../tweet/tweetlist/view/tweet_list.dart';
import '../widgets/side_drawer.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});



  @override
  Widget build(BuildContext context) {
    return Obx(() =>
     controller.isLoading.value ?Center(child: CircularProgressIndicator(),):

        Scaffold(
      appBar: controller.page.value == 0 ? controller.appBar : null ,
      body: IndexedStack(
        index: controller.page.value,
        children: [
          TweetList(),
          ExploreView(),
          NotificationView(userModel: controller.userModel!),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          controller.onCreateTweet() ;
        },
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      drawer:  SideDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: controller.page.value,
        onTap: (int index){
         controller. page.value = index;
         print(index);
        },
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              controller.page.value == 0
                  ? AssetsConstants.homeFilledIcon
                  : AssetsConstants.homeOutlinedIcon,
              color: Pallete.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetsConstants.searchIcon,
              color: Pallete.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              controller.page.value == 2
                  ? AssetsConstants.notifFilledIcon
                  : AssetsConstants.notifOutlinedIcon,
              color: Pallete.whiteColor,
            ),
          ),
        ],
      ),
    ));
  }
}
