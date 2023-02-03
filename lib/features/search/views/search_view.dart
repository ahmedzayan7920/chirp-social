import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/constants/app_colors.dart';
import 'package:twitter_clone/core/constants/app_strings.dart';
import 'package:twitter_clone/core/widgets/custom_error.dart';
import 'package:twitter_clone/core/widgets/custom_loading.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/routes_manager.dart';

import '../controllers/search_controller.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final TextEditingController searchFieldController = TextEditingController();
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              onSubmitted: (value) => setState(() {
                isSearching = true;
              }),
              controller: searchFieldController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.searchBarColor,
                border: searchFieldBorder,
                focusedBorder: searchFieldBorder,
                enabledBorder: searchFieldBorder,
                hintText: AppStrings.search,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
            Expanded(
              child: isSearching?ref.watch(searchUserByNameProvider(searchFieldController.text)).when(
                    data: (users) {
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          UserModel user = users[index];
                          return ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.userProfile, arguments: user);
                            },
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: CachedNetworkImageProvider(user.profilePicture),
                            ),
                            title:Text(user.name),
                            subtitle: Text("@${user.name}"),
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) => CustomError(error: error.toString()),
                    loading: () => const CustomLoading(),
                  ): const Center(child:Text("Search By User Name")),
            ),
          ],
        ),
      ),
    );
  }

  final searchFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(
      color: AppColors.searchBarColor,
    ),
  );

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }
}
