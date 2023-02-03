import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/core/constants/app_assets.dart';
import 'package:twitter_clone/models/notification_model.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/enums/notification_type.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key, required this.notification}) : super(key: key);

  final NotificationModel notification;
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      leading: getLeading(),
      title: Text(notification.text),
    );
  }
  Widget getLeading(){
     switch(notification.type){
       case NotificationType.like:
         return SvgPicture.asset(AppAssets.likeFilledIcon, width: 30, color: AppColors.redColor);
       case NotificationType.reply:
         return SvgPicture.asset(AppAssets.commentIcon, width: 30, color: AppColors.redColor);
       case NotificationType.follow:
         return const Icon(Icons.person_outline, size: 30);
       case NotificationType.retweet:
         return SvgPicture.asset(AppAssets.retweetIcon, width: 30, color: AppColors.redColor);
    }
  }

}
