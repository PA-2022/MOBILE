import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../services/auth_service.dart';
import '../../authentication/sign_in/sign_in_screen.dart';
import '../../common/custom_app_bar.dart';
import '../../common/custom_colors.dart';
import '../../post/create_post_screen.dart';
import '../forum_list_item.dart';
import '../forums_screen.dart';
import '../viewModel/forum_view_model.dart';
import 'forum_posts_list.dart';

class ForumPageScreen extends StatefulWidget {
  ForumListItem forum;

  static const routeName = "/forumPage-screen";
  ForumPageScreen(this.forum, {Key? key}) : super(key: key);

  @override
  State<ForumPageScreen> createState() => _ForumPageScreenState();
}

class _ForumPageScreenState extends State<ForumPageScreen> {
  // ignore: non_constant_identifier_names
  final Color background_color = CustomColors.lightGrey3;
  final Color _randomColor = CustomColors.mainYellow;
  ForumViewModel forumViewModel = ForumViewModel();
  _ForumPageScreenState();

  @override
  Widget build(BuildContext context) {
    CustomAppBar forumPageTop =
        CustomAppBar(widget.forum.forum.title, true, null);
    return FutureBuilder(
        future: _isJoined(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Scaffold(
            
            floatingActionButton: widget.forum.isJoined ? FloatingActionButton(
              onPressed: (() => _createPost()),
              child: const Icon(Icons.add),
              backgroundColor: CustomColors.mainYellow,
            ) : null,
            backgroundColor: background_color,
            //drawer: Menu(),
            body: CustomScrollView(
              slivers: [
                forumPageTop,
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      decoration: BoxDecoration(color: background_color),
                      //height: MediaQuery.of(context).size.height * 1/ 8,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, right: 10, left: 10),
                                    child: Icon(
                                      widget.forum.icon,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Flexible(
                                      child: Text(
                                    widget.forum.forum.description,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )),
                                ],
                              ),
                              if (snapshot.data != null &&
                                  snapshot.data == true)
                                TextButton(
                                    onPressed: () => unjoinForum(context),
                                    child: const Text(
                                      "Quit",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ))
                            ],
                          ),
                          color: _isAColor(widget.forum.forum.color)
                              ? colorFromHex((widget.forum.forum.color))
                              : _randomColor,
                        ),
                      ),
                    ),
                    ForumPostsList(widget.forum.forum.id, forumPageTop)
                  ]),
                ),
              ],
            ),
          );
        });
  }

  bool _isAColor(String value) {
    return value.length == 8 || value.length == 7 || value.length == 10;
  }

  void _createPost() async {
    if (AuthService.currentUser != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return CreatePostScreen(widget.forum.forum.id);
      }));

      //Navigator.of(context).pushNamed("/createPost-screen");
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return const SignInScreen(true);
      }));
    }
  }

  Future<bool> _isJoined() async {
    final response = await forumViewModel.fetchForumsOfUser();
    final forumsIdOfUser =
        response.map((forumListItem) => forumListItem.forum.id).toList();
    if (forumsIdOfUser.contains(widget.forum.forum.id))
      widget.forum.isJoined = true;
    return forumsIdOfUser.contains(widget.forum.forum.id);
  }

  unjoinForum(BuildContext context) async {
    if (widget.forum.isJoined) {
      await forumViewModel.unjoinForum(
          AuthService.currentUser!.user.id, widget.forum.forum.id);
      setState(() {
        widget.forum.isJoined = false;
      });
      Navigator.of(context).pushNamed(ForumsScreen.routeName);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ForumPageScreen(widget.forum)));
    }
  }
}
