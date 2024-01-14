import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:demo_appwrite_all_query/api/userController.dart';
import 'package:demo_appwrite_all_query/app/routes/name_routes.dart';
import 'package:demo_appwrite_all_query/models/user_model.dart';
import 'package:demo_appwrite_all_query/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../utils/providers.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPassController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  late PageController controller;
  RxInt selectedIndex = 0.obs;

  RxDouble pageValue = 0.0.obs;

  late Account _account;

  final globalController = Get.put(GlobalController());
  final userController = Get.put(UserController());


 Future<models.User> getUser()async{
  return  await _account.get() ;
  }

  createAnonymousSession() async {
    await _account.createAnonymousSession();
  }

  updateEmail() async {
    await _account.updateEmail(
        email: emailController.text, password: passController.text);
  }

  updateName(String name) async {
    await _account.updateName(name: name);
  }

  phoneVerification(String userId, String phone) async {
    await _account.createPhoneSession(userId: userId, phone: phone);
  }


  setSession()async{
    return false ;
  //
   var data  =  await _account.getSession(sessionId: 'current') ;
    if(data.current){
     user  = await  _account.get() ;
    if(user == null){
      return false ;
    }else{
      return true ;
    }
    }else{
      return false ;
    }
  }
  createPhoneVerification() async {
    await _account.createPhoneVerification();
  }

  currentUserAccountGet() async {
    // if(_account.getSession(sessionId: sessionId))
   // if(+_account.get != null){
   //   var user = await _account.get();
   //
   // }

  }

  RxBool isLoading = false.obs;

  Future<void> signUp() async {
    try {
      Utility.setLoading();
      // isLoading.value = true;
      models.User user = await _account.create(
        userId: ID.unique(),
        email: emailController.text,
        name: nameController.text,
        password: passController.text,
      );

      UserModel userModel = UserModel(
          email: emailController.text,
          name: nameController.text,
          followers: [],
          following: [],
          profilePic: "",
          bannerPic: "",
          uid: user.$id,
          bio: "",
          isTwitterBlue: false);
      userController.saveUserData(userModel);
      Utility.hideLoading();

      Get.snackbar("Done", "signup");

      Get.offAndToNamed(NameRoutes.loginScreen);

      // isLoading.value = false;
    } on AppwriteException catch (e) {
      Utility.hideLoading();

      Get.snackbar("error", e.message.toString());

      print(e.message);
    }
  }

  Future<void> login() async {
    try {
      Utility.setLoading();

      await _account.createEmailSession(
        email: loginEmailController.text.trim(),
        password: loginPassController.text.trim(),
      );
      Utility.hideLoading();

      Get.snackbar("Done", "login");

      Get.offAllNamed(NameRoutes.homeScreen);
    } on AppwriteException catch (e) {
      Utility.hideLoading();

      Get.snackbar("error", e.message.toString());

      print(e.message);
    }
  }

  Future<void> logout() async {
    try {
      Utility.setLoading();
      // await _account.deleteIdentity(identityId: identityId)
      // await _account.deleteSession(sessionId: 'current');
      // await _account.(sessionId: 'current');
      Get.offAllNamed(NameRoutes.signUpScreen);
      Utility.hideLoading();

      // Handle successful logout
    } on AppwriteException catch (e) {
      Utility.hideLoading();


      Get.snackbar("error", e.message.toString());

      print(e.message);
    }
  }

  models.User? user;

  // getUerAndSave() async {
  //   user = await currentUserAccount();
  // }

  @override
  void onInit() {
    // getUerAndSave();
    _account = globalController.appwriteAccount;
    // userAPI = UserAPI(db: globalController.appwriteDatabase,
    //     realtime: globalController.appwriteRealtime);
    // currentUserAccountGet();
    selectedIndex.value = 0;
    pageValue.value = 0.0;
    controller =
        PageController(initialPage: selectedIndex.value, viewportFraction: 1.0)
          ..addListener(() {
            pageValue.value = controller.page!;
          });

    setSession() ;
    // TODO: implement onInit
    super.onInit();
  }
  //
  // Future<void> signInWithApple() async {
  //   try {
  //     final credential = await AppleSignIn.performRequests([
  //       AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //     ]);
  //
  //     final oAuthProvider = OAuthProvider('apple.com');
  //     final credentialToken = String.fromCharCodes(credential.identityToken!);
  //     final AuthCredential authCredential =
  //     oAuthProvider.credential(idToken: credentialToken);
  //
  //     // Sign in with Firebase using Apple Auth credentials
  //     await FirebaseAuth.instance.signInWithCredential(authCredential);
  //
  //     // Use the Apple user ID token to sign in with Appwrite
  //     await _account.createOAuth2Session(
  //       provider: 'apple',
  //       accessToken: credentialToken,
  //     );
  //   } catch (error) {
  //     print("Error signing in with Apple: $error");
  //   }
  // }
  // Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     // Initialize GoogleSignIn
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //     if (googleUser == null) {
  //       // User cancelled the sign-in process
  //       return null;
  //     }
  //
  //     // Get GoogleSignInAuthentication
  //     final GoogleSignInAuthentication googleAuth =
  //     await googleUser.authentication;
  //
  //     // Create GoogleAuthProvider credential
  //     final GoogleAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     // Sign in with Firebase using Google Auth credentials
  //     final UserCredential userCredential =
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //     // Use the Firebase user ID token to sign in with Appwrite
  //     await _account.createOAuth2Session(
  //       provider: 'google',
  //       accessToken: googleAuth.accessToken,
  //     );
  //
  //     return userCredential;
  //   } catch (e) {
  //     print("Error signing in with Google: $e");
  //     return null;
  //   }
  // }
}
