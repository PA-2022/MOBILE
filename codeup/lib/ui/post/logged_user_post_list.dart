import 'package:codeup/ui/common/custom_app_bar.dart';
import 'package:codeup/ui/home/viewModel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/custom_colors.dart';
import 'post_box.dart';

class LoggedUserPostList extends StatelessWidget with ChangeNotifier {
  final int id;
  final CustomAppBar forumPageTop;

  LoggedUserPostList(this.id, this.forumPageTop, {Key? key}) : super(key: key);

  HomeViewModel homeViewModel = HomeViewModel();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => forumPageTop,
      child: FutureBuilder(
        future: homeViewModel.fetchLoggedUserPosts(id),
        builder: (BuildContext context, AsyncSnapshot<List<PostBox>> snapshot) {
          return snapshot.data != null
              ? (snapshot.data!.isNotEmpty ?
                Consumer<CustomAppBar>(builder: (context, appBar, child) {
                  

                  return RefreshIndicator(
                    onRefresh: () async {
                      await _refreshPosts();
                    },
                    child: ListView(
                      children: [
                        for (PostBox post in snapshot.data as List<PostBox>)
                          (post.post.title.toLowerCase().contains(
                                      appBar.valueSearch.toLowerCase()) ||
                                  post.post.content.toLowerCase().contains(
                                      appBar.valueSearch.toLowerCase()))
                              ? post
                              : Container()
                      ],
                    ),
                  );
                }) :const Center(
                    child: Text(
                        "No posts to show",
                        style: TextStyle(
                            color: CustomColors.darkText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                  ))
              : Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: CustomColors.mainYellow,
                  ));
        },
      ),
    );
  }

  Future<List<PostBox>> _refreshPosts() {
    return homeViewModel.fetchLoggedUserPosts(id);
  }
}
