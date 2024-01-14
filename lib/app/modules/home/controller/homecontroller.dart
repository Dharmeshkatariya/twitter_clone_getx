import 'dart:async';
import 'package:demo_appwrite_all_query/api/userController.dart';
import 'package:demo_appwrite_all_query/app/routes/name_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/constants/ui_constants.dart';
import '../../auth/controller/auth_controller.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  final userController = Get.put(UserController());

  UserModel? userModel ;
  getUserData() async {
    isLoading.value = true;
    var user = await authController.getUser();

    var userdocument = await userController.getUserData(user.$id);
    // final tweets = userdocument.
    //     .map((doc) => UserModel.fromMap(doc.data))
    //     .toList();
    var data = userdocument.data;
    var model = UserModel.fromMap(data);
    userModel = model ;
    print("user :${model}");
    isLoading.value = false;

    return model;
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
  }) async {
    try {
      isLoading(true);
      print(userModel);
      //
      // if (bannerImage.value.isNotEmpty) {
      //   final bannerUrl = await storageApiController.uploadImage(bannerImagesImages);
      //   userModel = userModel.copyWith(
      //     bannerPic: bannerUrl[0],
      //   );
      // }
      //
      // if (profileImage.value.isNotEmpty) {
      //   final profileUrl = await storageApiController.uploadImage(profileImages);
      //   print(profileUrl);
      //   userModel = userModel.copyWith(
      //     profilePic: profileUrl[0],
      //   );
      // }

      final res = await userController.updateUserData(userModel);
      print(res);
      // res.fold(
      //       (l) => showSnackBar(context, l.message),
      //       (r) => Navigator.pop(context),
      // );
    } finally {
      isLoading(false);
    }
  }

  RxString bannerImage ="".obs ;
  RxString profileImage ="".obs ;


  @override
  void onInit() {
    getUserData() ;
    // getCurrentUser();
    // TODO: implement onInit
    super.onInit();
  }

  final authController = Get.put(AuthController());

  // final userProfileController = Get.put(UserProfileController());

  RxInt page = 0.obs;
  final appBar = UIConstants.appBar();

  onPageChange(int index) {
    page.value = index;
  }

  onCreateTweet() {
    Get.toNamed(NameRoutes.createTweetView,arguments: {
      "userModel" :userModel
    });
    // Navigator.push(context, CreateTweetScreen.route());
  }
}
