import 'package:flutter/material.dart';
import 'package:twitter_clone/core/constants/app_colors.dart';
import 'package:twitter_clone/core/constants/app_colors.dart';

class FollowCount extends StatelessWidget {
  final int count;
  final String text;
  final double fontSize;
  const FollowCount({
    Key? key,
    required this.count,
    required this.text,
     this.fontSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Text(
          '$count',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            color: AppColors.greyColor,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}