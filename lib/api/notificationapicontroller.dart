import 'package:appwrite/appwrite.dart';
import 'package:demo_appwrite_all_query/utils/providers.dart';
import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../utils/constants/appwrite_constants.dart';

class NotificationAPIController extends GetxController {
  late Databases _db;
  late Realtime _realtime;


  createNotification(Notification notification) async {
    try {
      var data  =await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notificationsCollection,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      var map = data.data ;
      var umap = Notification.fromMap(map) ;
      return umap ;
      // return null;
    } on AppwriteException catch (e, st) {
      return e.message ;
    } catch (e, st) {
      return e.toString() ;
    }
  }

  // Future<List<Document>> getNotifications(String uid) async {
  //   final documents = await _db.listDocuments(
  //     databaseId: AppwriteConstants.databaseId,
  //     collectionId: AppwriteConstants.notificationsCollection,
  //     queries: [
  //       Query.equal('uid', uid),
  //     ],
  //   );
  //   return documents.documents;
  // }
  Future<List<Notification>> getNotifications(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.notificationsCollection,
      queries: [
        Query.equal('uid', uid),
      ],
    );

    var documentList = documents.documents;
    var notificationlist = documentList.map((document) {
      // Assuming your tweet data is stored in a 'tweet' field in the document
      var tweetData = document.data;
      return Notification.fromMap(tweetData);
    }).toList();

    return notificationlist;
  }

  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.notificationsCollection}.documents'
    ]).stream;
  }

  final globalController  = Get.put(GlobalController()) ;

  @override
  void onInit() {
    _db =  globalController.appwriteDatabase ;
    _realtime = globalController.appwriteRealtime ;
    // TODO: implement onInit
    super.onInit();
  }
}
