import 'package:codeup/ui/common/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/custom_colors.dart';
import '../../post/post_box.dart';
import '../viewModel/forum_view_model.dart';

class ForumPostsList extends StatelessWidget with ChangeNotifier {
  final int id;
  final CustomAppBar forumPageTop;
   ForumPostsList(this.id, this.forumPageTop, {Key? key}) : super(key: key);

  ForumViewModel forumViewModel = ForumViewModel();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => forumPageTop,
      child: FutureBuilder(
        future: forumViewModel.fetchForumPosts(id),
        builder: (BuildContext context, AsyncSnapshot<List<PostBox>> snapshot) {
          return snapshot.data != null
              ? Consumer<CustomAppBar>(
                builder: (context, appBar, child) {
                  return RefreshIndicator(
                    onRefresh: () async { await _refreshPosts(); },
                    child: Column(
                        children: [
                          for (PostBox post in snapshot.data as List<PostBox>) 
                          (post.postContent.post.title.toLowerCase().contains(appBar.valueSearch.toLowerCase()) || post.postContent.post.content.toLowerCase().contains(appBar.valueSearch.toLowerCase())) ? post : Container()
                        ],
                      ),
                  );
                }
              )
              : Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: CustomColors.mainYellow,
            )
          );
        },
      ),
    );
  }

    Future<List<PostBox>> _refreshPosts() {
  return forumViewModel.fetchForumPosts(id);
  }
}