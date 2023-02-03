import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/core/constants/app_colors.dart';

class TweetIconButton extends StatelessWidget {
  const TweetIconButton({
    Key? key,
    required this.path,
    required this.onTap,
    required this.label,
  }) : super(key: key);
  final String path;
  final void Function() onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
        child: Row(
          children: [
            SvgPicture.asset(
              path,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              color: AppColors.greyColor,
            ),
            const SizedBox(width: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.greyColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
