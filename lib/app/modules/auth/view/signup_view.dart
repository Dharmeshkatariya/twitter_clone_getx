import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/common/loading_page.dart';
import '../../../../utils/common/rounded_small_button.dart';
import '../../../../utils/constants/ui_constants.dart';
import '../../../../utils/theme/pallete.dart';
import '../../../routes/name_routes.dart';
import '../controller/auth_controller.dart';
import '../widget/auth_field.dart';




class SignUpView extends GetView<AuthController> {
  final appbar = UIConstants.appBar();

  void onSignUp() {
    controller.signUp(
        );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appbar,
      body: controller.isLoading.value
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [

                      AuthField(
                        controller: controller .nameController,
                        hintText: 'UserName',
                      ),
                      const SizedBox(height: 30),

                      AuthField(
                        controller: controller .emailController,
                        hintText: 'Email',
                      ),

                      const SizedBox(height: 25),
                      AuthField(
                        controller: controller. passController,
                        hintText: 'Password',
                      ),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.topRight,
                        child: RoundedSmallButton(
                          onTap: onSignUp,
                          label: 'Done',
                        ),
                      ),
                      const SizedBox(height: 40),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account?",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: ' Login',
                              style: const TextStyle(
                                color: Pallete.blueColor,
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                Get.toNamed(
                                    NameRoutes.loginScreen) ;

                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
