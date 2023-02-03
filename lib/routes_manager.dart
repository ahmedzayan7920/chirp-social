import 'package:flutter/material.dart';
import 'package:twitter_clone/features/auth/views/login_view.dart';
import 'package:twitter_clone/features/auth/views/sign_up_view.dart';
import 'package:twitter_clone/features/main/views/main_view.dart';
import 'package:twitter_clone/features/splash/splash_view.dart';
import 'package:twitter_clone/features/tweet/views/create_tweet_view.dart';
import 'package:twitter_clone/features/tweet/views/hashtag_tweets_view.dart';
import 'package:twitter_clone/features/user_profile/views/user_profile_view.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';

import 'core/constants/app_strings.dart';
import 'features/tweet/views/tweet_replay_view.dart';
import 'features/user_profile/views/edit_profile_view.dart';

abstract class AppRoutes {
  static const String splash = "/";
  static const String signUp = "/signUp";
  static const String login = "/login";
  static const String main = "/main";
  static const String createTweet = "/createTweet";
  static const String tweetReplay = "/tweetReplay";
  static const String userProfile = "/userProfile";
  static const String editProfile = "/editProfile";
  static const String hashtagTweets = "/hashtagTweets";
}

abstract class RouteGenerator {
  static Route getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpView());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppRoutes.main:
        return MaterialPageRoute(builder: (_) => const MainView());
      case AppRoutes.createTweet:
        return MaterialPageRoute(builder: (_) => const CreateTweetView());
      case AppRoutes.tweetReplay:
        TweetModel tweet = settings.arguments as TweetModel;
        return MaterialPageRoute(builder: (_) => TweetReplayView(tweet: tweet));
      case AppRoutes.userProfile:
        UserModel user = settings.arguments as UserModel;
        return MaterialPageRoute(builder: (_) => UserProfileView(user: user));
      case AppRoutes.editProfile:
        UserModel currentUser = settings.arguments as UserModel;
        return MaterialPageRoute(builder: (_) =>  EditProfileView(currentUser: currentUser));
      case AppRoutes.hashtagTweets:
        String hashtag = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => HashtagTweetsView(hashtag: hashtag));
      default:
        return unDefinedRoute();
    }
  }

  static Route unDefinedRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(AppStrings.noRouteFound),
          ),
        ),
      );
    });
  }
}
