import 'package:demo_appwrite_all_query/api/userController.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../models/user_model.dart';

class ExploreController extends GetxController {


  final searchController = TextEditingController();
  RxBool isShowUsers = false.obs;
  final userController  = Get.put(UserController()) ;

  RxBool isLoading = false.obs;
RxList<UserModel> userlist = <UserModel>[].obs ;
  searchUser(String name) async {
    try {
      isLoading.value = true ;
      final users = await userController.searchUserByName(name);
      userlist.value =   users.map((e) => UserModel.fromMap(e.data)).toList();
      print(userlist);
      isLoading.value = false ;
      isShowUsers.value = false ;

    } finally {
      isLoading(false);
    }
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
