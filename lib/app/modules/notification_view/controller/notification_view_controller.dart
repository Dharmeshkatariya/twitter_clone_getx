import 'package:demo_appwrite_all_query/api/notificationapicontroller.dart';
import 'package:demo_appwrite_all_query/models/notification_model.dart';
import 'package:get/get.dart';
import 'package:demo_appwrite_all_query/models/notification_model.dart' as model;

import '../../../../utils/enums/notification_type_enum.dart';

class NotificationViewController  extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  final notificationApiController  = Get.put(NotificationAPIController()) ;

  Future<List<Notification>> getNotification(String uid ){
   return notificationApiController.getNotifications(uid) ;
  }

   createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
    final notification = model.Notification(
      text: text,
      postId: postId,
      id: '',
      uid: uid,
      notificationType: notificationType,
    );
    final res = await notificationApiController.createNotification(notification);
    print("crate notification :${res}") ;
    return res ;
  }
  // createNotification(Notification notification){
  //  var res  =  notificationApiController.createNotification(notification) ;
  //  print("create notificaton :${res}") ;
  // }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}