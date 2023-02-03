import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../auth/controllers/auth_controller.dart';

class DrawerLogoutListTile extends ConsumerWidget {
  const DrawerLogoutListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        ref.read(authControllerProvider.notifier).logout(context: context);
      },
      leading: const Icon(
        Icons.logout_outlined,
        color: AppColors.whiteColor,
      ),
      title: const Text(AppStrings.logout, style: TextStyle(fontSize: 20)),
    );
  }
}