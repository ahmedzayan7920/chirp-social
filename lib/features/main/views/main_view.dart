import 'package:flutter/material.dart';
import 'package:twitter_clone/core/constants/app_constants.dart';
import 'package:twitter_clone/core/widgets/custom_app_bar.dart';
import 'package:twitter_clone/routes_manager.dart';

import '../widgets/custom_drawer.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  void onTap(index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == 0 ? const CustomAppBar() : null,
      body: AppConstants.mainViewPages[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createTweet),
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: AppConstants.bottomNavBarItems,
      ),
      drawer: const CustomDrawer(),
    );
  }
}




