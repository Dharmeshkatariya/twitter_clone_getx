import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/common/loading_page.dart';
import '../../tweetlist/view/tweet_list.dart';
import '../controller/hastagcontroller.dart';

class HashtagView extends GetView<HashTagController> {
  const HashtagView({super.key});




  @override
  Widget build(BuildContext context) {
     final tweetlistcontroller    = controller.tweetListController ;
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.hashTag.value),
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return const Loader();
          }



          return ListView.builder(
            itemCount: controller.tweet.length,
            itemBuilder: (BuildContext context, int index) {
              final tweet = controller.tweet[index];
              return tweetCard(tweet,tweetlistcontroller,context) ;

            },
          );
        },
      ),
    );
  }
}
