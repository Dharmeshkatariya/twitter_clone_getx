import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:appwrite/models.dart' as model;

import '../models/user_model.dart';
import '../utils/constants/appwrite_constants.dart';
import '../utils/providers.dart';
import '../utils/utility.dart';

class UserController extends GetxController {
  final globalController = Get.put(GlobalController());

  final latestUserProfileData = Rx<UserModel?>(null);

  @override
  void onClose() {
    latestUserProfileData.close();
    super.onClose();
  }

@override
  void onInit() {
  db = globalController.appwriteDatabase ;
  realtime = globalController.appwriteRealtime ;
  // getUserDa()  ;
  getLatestUserStrem() ;
    // TODO: implement onInit
    super.onInit();
  }
  late final Databases db;
  late final Realtime realtime;

  saveUserData(UserModel userModel) async {
    try {
      await db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return null;
    } on AppwriteException catch (e, st) {
      print("usererror ${e.toString()}");
      Get.snackbar("eroor", e.message.toString());
      Utility.hideLoading();

      // return e.message.toString() ;
    } catch (e, st) {
      Get.snackbar("eroor", e.toString());
      Utility.hideLoading();


      // return e.toString() ;
    }
  }

  Future<model.Document> getUserData(String uid) {
    return db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      documentId: uid,
    );
  }

  Future<List<model.Document>> searchUserByName(String name) async {
    final documents = await db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      queries: [
        Query.search('name', name),
      ],
    );

    return documents.documents;
  }

  updateUserData(UserModel userModel) async {
    try {
     var document = await db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      var map = document.data ;
      return UserModel.fromMap(map);
    } on AppwriteException catch (e, st) {
      Get.snackbar("eroor", e.message.toString());

      Utility.hideLoading();

      // return left(
      //   Failure(
      //     e.message ?? 'Some unexpected error occurred',
      //     st,
      //   ),
      // );
    } catch (e, st) {
      // return left(Failure(e.toString(), st));
    }
  }

  Stream<RealtimeMessage> getLatestUserProfileData() {
    return realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollection}.documents'
    ]).stream;
  }

  followUser(UserModel user) async {
    try {
      var data =await db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: user.uid,
        data: {
          'followers': user.followers,
        },
      );

      var map = data.data ;
     var model = UserModel
      .fromMap(map) ;
      return model;
    } on AppwriteException catch (e, st) {
      Get.snackbar("eroor", e.message.toString());

    } catch (e, st) {
      // return left(Failure(e.toString(), st));
    }
  }

  Stream<RealtimeMessage> getLatestUserProfile() {
    return realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollection}.documents'
    ]).stream;
  }
  addToFollowing(UserModel user) async {
    try {
     var data  =  await db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: user.uid,
        data: {
          'following': user.following,
        },
      );
     var map = data.data ;
  return    UserModel.fromMap(map) ;

    } on AppwriteException catch (e, st) {
      Get.snackbar("error", e.message.toString());
    } catch (e, st) {
      Get.snackbar("error", e.toString());

      // return left(Failure(e.toString(), st));
    }
  }

  void getLatestUserStrem() {
    realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollection}.documents'
    ]).stream.listen((event) {
      if (event is RealtimeMessage) {
        if (event!.events.first.isNotEmpty) {
          final latestUser = UserModel.fromMap(event.payload);
          latestUserProfileData.value = latestUser;
        }
      }
    });
  }
}
