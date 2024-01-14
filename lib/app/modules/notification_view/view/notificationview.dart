
import 'package:demo_appwrite_all_query/app/modules/notification_view/controller/notification_view_controller.dart';
import 'package:demo_appwrite_all_query/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/common/error_page.dart';
import '../../../../utils/common/loading_page.dart';
import 'notification_tile_widget.dart';
import 'package:demo_appwrite_all_query/models/notification_model.dart' as model;

class NotificationView extends StatefulWidget {
  const NotificationView({super.key,required this.userModel});
  final UserModel userModel ;

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {


  final notificationController  = Get.put(NotificationViewController()) ;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder(
        future: notificationController .getNotification(widget.userModel.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          } else if (snapshot.hasError) {
            return ErrorText(error: snapshot.error.toString());
          } else {
            List<model.Notification> notifications = snapshot.data! ;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, int index) {
                final notification = notifications[index];
                return NotificationTile(notification: notification);
              },
            );
          }
        },
      ),
    ) ;
      // body: currentUser == null
      //     ? const Loader()
      //     : ref.watch(getNotificationsProvider(currentUser.uid)).when(
      //           data: (notifications) {
      //             return ref.watch(getLatestNotificationProvider).when(
      //                   data: (data) {
      //                     if (data.events.contains(
      //                       'databases.*.collections.${AppwriteConstants.notificationsCollection}.documents.*.create',
      //                     )) {
      //                       final latestNotif =
      //                           model.Notification.fromMap(data.payload);
      //                       if (latestNotif.uid == currentUser.uid) {
      //                         notifications.insert(0, latestNotif);
      //                       }
      //                     }
      //
      //                     return ListView.builder(
      //                       itemCount: notifications.length,
      //                       itemBuilder: (BuildContext context, int index) {
      //                         final notification = notifications[index];
      //                         return NotificationTile(
      //                           notification: notification,
      //                         );
      //                       },
      //                     );
      //                   },
      //                   error: (error, stackTrace) => ErrorText(
      //                     error: error.toString(),
      //                   ),
      //                   loading: () {
      //                     return ListView.builder(
      //                       itemCount: notifications.length,
      //                       itemBuilder: (BuildContext context, int index) {
      //                         final notification = notifications[index];
      //                         return NotificationTile(
      //                           notification: notification,
      //                         );
      //                       },
      //                     );
      //                   },
      //                 );
      //           },
      //           error: (error, stackTrace) => ErrorText(
      //             error: error.toString(),
      //           ),
      //           loading: () => const Loader(),
      //         ),

  }
}
