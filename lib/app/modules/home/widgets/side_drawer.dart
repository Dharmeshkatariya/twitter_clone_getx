import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/theme/pallete.dart';
import '../../../routes/name_routes.dart';
import '../controller/homecontroller.dart';

class SideDrawer extends GetView<HomeController> {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Drawer(
        backgroundColor: Pallete.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 30,
              ),
              title: const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Get.toNamed(NameRoutes.userStremView,arguments: {
                  "userModel":controller.userModel
                }) ;
                // Get.to(page)
                // Navigator.push(
                //   context,
                //   UserProfileView.route(currentUser),
                // );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.payment,
                size: 30,
              ),
              title: const Text(
                'Twitter Blue',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                // controller.updateUserProfile( context: context);
             controller
                    .updateUserProfile(
                      userModel: controller.userModel!.copyWith(isTwitterBlue: true),
                      context: context,
                      // bannerFile: null,
                      // profileFile: null,
                    );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                controller.authController.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
