import 'dart:io'as io;
import 'dart:io';

import 'package:demo_appwrite_all_query/api/storageapiController.dart';
import 'package:demo_appwrite_all_query/api/userController.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/providers.dart';
import '../../../../utils/utils.dart';
import '../../auth/controller/auth_controller.dart';

class EditProfileController extends GetxController{


  final  userController  = Get.put(UserController());
  final  storageApiController  = Get.put(StorageAPIController());
  var nameController  = TextEditingController() ;
  var bioController  = TextEditingController() ;

  UserModel? userModel ;
  getArgument()async{
    var argument = Get.arguments ;
    var model   = argument["user"] ;
    userModel =  model ;
    nameController = TextEditingController(
      text: userModel!.name ?? '',
    );
    bioController = TextEditingController(
      text: userModel!.email ?? '',
    );
  }
  selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      var data  =  banner! ;
      bannerImagesImages.add(data) ;
      bannerImage.value = data.path;
      print(bannerImage);
    }
  }

  List<File> profileImages = [] ;
  List<File> bannerImagesImages = [] ;
  selectProfileImage() async {
    final profile = await pickImage();
    if (profile != null) {

       var data  = profile!;
       profileImages.add(data) ;

       profileImage.value = profile.path ;
       print(profileImage);
    }
  }
  @override
  void onInit()async {
    getArgument();
    super.onInit();
  }



  RxBool isLoading = false.obs;

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
  }) async {
    try {
    isLoading.value = true ;

      if (bannerImage.value.isNotEmpty) {
        final bannerUrl = await storageApiController.uploadImage(bannerImagesImages);
        userModel = userModel.copyWith(
          bannerPic: bannerUrl[0],
        );
      }

      if (profileImage.value.isNotEmpty) {
        final profileUrl = await storageApiController.uploadImage(profileImages);
        print(profileUrl);
        userModel = userModel.copyWith(
          profilePic: profileUrl[0],
        );
      }

      final res = await userController.updateUserData(userModel);
      print(res);
    isLoading.value = false ;

    } finally {
      isLoading(false);
    }
  }

  RxString bannerImage ="".obs ;
  RxString profileImage ="".obs ;




  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}