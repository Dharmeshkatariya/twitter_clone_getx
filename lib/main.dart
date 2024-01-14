import 'dart:async';
import 'package:appwrite/models.dart' as models;

import 'package:appwrite/models.dart';
import 'package:demo_appwrite_all_query/responsive.dart';
import 'package:demo_appwrite_all_query/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/modules/auth/bindings/binding.dart';
import 'app/modules/auth/controller/auth_controller.dart';
import 'app/routes/name_routes.dart';
import 'app/routes/page_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: GetMaterialApp(
        theme: AppTheme.theme,
        initialBinding: AuthBinding(),
        getPages: PageRoutes.pages,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final authController = Get.put(AuthController());

  getCurrentUser() async {
    bool user = await  authController.setSession();
    Timer(const Duration(seconds: 2), () {
      if (user == true) {
        Get.toNamed(NameRoutes.homeScreen);
        return ;
        // return const HomeView();
      }
      Get.toNamed(NameRoutes.signUpScreen);
      return ;
      // Get.toNamed(NameRoutes.authenticationScreen) ;
    });

  }

  @override
  void initState() {
    getCurrentUser();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return const  Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text("Splash screen"),
      ),
    );
  }
}
