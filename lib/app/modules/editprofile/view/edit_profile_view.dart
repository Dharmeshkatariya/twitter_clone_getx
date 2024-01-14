import 'dart:io';
import 'package:demo_appwrite_all_query/app/modules/editprofile/controller/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/common/loading_page.dart';
import '../../../../utils/theme/pallete.dart';
import '../../../../utils/utils.dart';


class EditProfileView extends GetView<EditProfileController>{






  @override
  Widget build(BuildContext context) {
    final user = controller.userModel! ;
    // final isLoading = ref.watch(userProfileControllerProvider);

    return Obx(() => Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              controller
                  .updateUserProfile(
                userModel: user!.copyWith(
                  bio: controller . bioController.text,
                  name: controller .nameController.text,
                ),
                context: context,
                // bannerFile: controller.bann ,
                // profileFile:File(controller.profileImage.value),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: controller .isLoading.value || user == null
          ? const
      Loader()
          : Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: controller .selectBannerImage,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: controller.bannerImage.value.isNotEmpty?
                    Image.file(
                      File(controller.bannerImage.value),
                      fit: BoxFit.fitWidth,
                    )
                        : user.bannerPic.isEmpty
                        ? Container(
                      color: Pallete.blueColor,
                    )
                        : Image.network(
                      user.bannerPic,
                      fit: BoxFit.fitWidth,
                    ) ,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: GestureDetector(
                    onTap: controller. selectProfileImage,
                    child: controller.profileImage.isNotEmpty
                        ?
                    CircleAvatar(
                      backgroundImage:
                      FileImage( File(controller.profileImage.value)),
                      radius: 40,
                    )

                        : CircleAvatar(
                      backgroundImage:
                      NetworkImage(user.profilePic),
                      radius: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: controller .nameController,
            decoration: const InputDecoration(
              hintText: 'Name',
              contentPadding: EdgeInsets.all(18),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller.bioController,
            decoration: const InputDecoration(
              hintText: 'Bio',
              contentPadding: EdgeInsets.all(18),
            ),
            maxLines: 4,
          ),
        ],
      ),
    ));
  }
}
