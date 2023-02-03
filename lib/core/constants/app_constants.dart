import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/home/views/home_view.dart';
import '../../features/notification/views/notifications_view.dart';
import '../../features/search/views/search_view.dart';
import '../../features/tweet/widgets/tweet_list.dart';
import 'app_assets.dart';
import 'app_colors.dart';
import 'app_strings.dart';

abstract class AppConstants {
  static List<BottomNavigationBarItem> bottomNavBarItems = [
    BottomNavigationBarItem(
      label: AppStrings.home,
      icon: SvgPicture.asset(
        AppAssets.homeOutlinedIcon,
        color: AppColors.whiteColor,
      ),
    ),
    BottomNavigationBarItem(
      label: AppStrings.search,
      icon: SvgPicture.asset(
        AppAssets.searchIcon,
        color: AppColors.whiteColor,
      ),
    ),
    BottomNavigationBarItem(
      label: AppStrings.notifications,
      icon: SvgPicture.asset(
        AppAssets.notificationOutlinedIcon,
        color: AppColors.whiteColor,
      ),
    ),
  ];

  static const  List<Widget> mainViewPages = [
    HomeView(),
    SearchView(),
    NotificationView(),
  ];
}
