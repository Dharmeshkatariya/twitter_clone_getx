import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/constants/assets_constants.dart';
import '../../../../utils/enums/notification_type_enum.dart';
import '../../../../utils/theme/pallete.dart';
import 'package:demo_appwrite_all_query/models/notification_model.dart' as model;


class NotificationTile extends StatelessWidget {
  final model.Notification notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
        Icons.person,
        color: Pallete.blueColor,
      )
          : notification.notificationType == NotificationType.like
          ? SvgPicture.asset(
        AssetsConstants.likeFilledIcon,
        color: Pallete.redColor,
        height: 20,
      )
          : notification.notificationType == NotificationType.retweet
          ? SvgPicture.asset(
        AssetsConstants.retweetIcon,
        color: Pallete.whiteColor,
        height: 20,
      )
          : notification.notificationType == NotificationType.reply ?
      const Icon(
        Icons.replay_10_sharp,
        color: Pallete.redColor,
      ) :  null
      ,
      title: Text(notification.text),
    );
  }
}