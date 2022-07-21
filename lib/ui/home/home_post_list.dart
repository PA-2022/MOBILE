import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/custom_app_bar.dart';
import '../common/custom_colors.dart';
import '../post/post_box.dart';
import 'home_screen.dart';
import 'viewModel/home_view_model.dart';

class PostBoxList extends StatefulWidget {
  final CustomAppBar homeTop;
  PostBoxList(this.homeTop, {Key? key}) : super(key: key);

  @override
  _PostBoxListState createState() => _PostBoxListState();

  HomeViewModel homeViewModel = HomeViewModel();
}

class _PostBoxListState extends State<PostBoxList> {
  HomeViewModel homeViewModel = HomeViewModel();
  late Future<List<PostBox>> posts;
  Color getColor(Set<MaterialState> states) {
    return CustomColors.mainYellow;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => widget.homeTop,
      child: FutureBuilder(
        future: homeViewModel.fetchHomePosts(), //posts,
        builder: (BuildContext context, AsyncSnapshot<List<PostBox>> snapshot) {
          return snapshot.data != null
              ? (snapshot.data!.length != 0
                  ? Consumer<CustomAppBar>(builder: (context, appBar, child) {
                      return RefreshIndicator(
                        onRefresh: () {
                          return Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => HomeScreen()));
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
                    })
                  : const Center(
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
}
