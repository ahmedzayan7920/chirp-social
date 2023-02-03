import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/routes_manager.dart';

import '../../../core/constants/app_colors.dart';

class HashtagText extends StatelessWidget {
  const HashtagText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    text.split(" ").forEach((word) {
      if (word.startsWith("#")) {
        textSpans.add(
          TextSpan(
            text: "$word ",
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.blueColor,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {
              Navigator.pushNamed(context, AppRoutes.hashtagTweets, arguments: word);
            },
          ),
        );
      } else if (word.startsWith("www.") || word.startsWith("https://")) {
        textSpans.add(
          TextSpan(
            text: "$word ",
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.blueColor,
            ),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: "$word ",
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        );
      }
    });
    return RichText(text: TextSpan(children: textSpans));
  }
}
