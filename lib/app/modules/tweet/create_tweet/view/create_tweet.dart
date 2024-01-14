import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../utils/common/loading_page.dart';
import '../../../../../utils/common/rounded_small_button.dart';
import '../../../../../utils/constants/assets_constants.dart';
import '../../../../../utils/theme/pallete.dart';
import '../controller/create_tweetcontroller.dart';


class CreateTweetScreen extends GetView<CreateTweetController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close, size: 30),
            ),
            actions: [
              RoundedSmallButton(
                onTap: (){
                  controller.shareTweet(context: context) ;

                },
                label: 'Tweet',
                backgroundColor: Pallete.blueColor,
                textColor: Pallete.whiteColor,
              ),
            ],
          ),
          body: controller.isLoading.value || controller.userModel == null
              ? const Loader()
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                 controller.userModel!.profilePic.isNotEmpty ?   CircleAvatar(
                    backgroundImage: NetworkImage(controller.userModel!.profilePic),
                    radius: 30,
                  )
                            : CircleAvatar(
                   backgroundColor: Colors.lightBlue,
                              radius: 30,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: TextField(
                                controller: controller.tweetTextController,
                                style: const TextStyle(
                                  fontSize: 22,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "What's happening?",
                                  hintStyle: TextStyle(
                                    color: Pallete.greyColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                              ),
                            ),
                          ],
                        ),
                        if (controller.images.isNotEmpty)
                          CarouselSlider(
                            items: controller.images.map(
                              (file) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Image.file(file),
                                );
                              },
                            ).toList(),
                            options: CarouselOptions(
                              height: 400,
                              enableInfiniteScroll: false,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Pallete.greyColor,
                  width: 0.3,
                ),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(
                    left: 15,
                    right: 15,
                  ),
                  child: GestureDetector(
                    onTap: controller.onPickImages,
                    child: SvgPicture.asset(AssetsConstants.galleryIcon),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(
                    left: 15,
                    right: 15,
                  ),
                  child: SvgPicture.asset(AssetsConstants.gifIcon),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(
                    left: 15,
                    right: 15,
                  ),
                  child: SvgPicture.asset(AssetsConstants.emojiIcon),
                ),
              ],
            ),
          ),
        ));
  }
}
