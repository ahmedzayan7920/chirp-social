import 'package:flutter/material.dart';
import 'package:twitter_clone/core/constants/app_colors.dart';
import 'package:twitter_clone/features/main/widgets/drawer_profile_section.dart';

import 'drawer_logout_list_tile.dart';
import 'drawer_verify_account_list_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundColor,
      child: SafeArea(
        child: Column(
          children: const [
            DrawerProfileSection(),
            DrawerVerifyAccountListTile(),
            DrawerLogoutListTile(),
          ],
        ),
      ),
    );
  }
}


