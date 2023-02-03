import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/core/constants/app_assets.dart';
import 'package:twitter_clone/core/constants/app_colors.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/routes_manager.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  _goNext() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        ref.watch(currentUserAccountProvider.future).then((account) {
          if (account != null) {
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signUp, (route) => false);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.twitterLogo,
              height: 120,
              width: 120,
              color: AppColors.blueColor,
            ),
            const SizedBox(
              width: 80,
              child: LinearProgressIndicator(
                color: AppColors.blueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
