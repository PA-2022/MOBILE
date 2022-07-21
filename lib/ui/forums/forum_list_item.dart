import 'package:flutter/material.dart';

import '../../entities/forum.dart';
import '../../services/auth_service.dart';
import '../authentication/sign_in/sign_in_screen.dart';
import '../common/custom_button.dart';
import '../common/custom_colors.dart';
import 'forum_page/forum_page_screen.dart';
import 'viewModel/forum_view_model.dart';

class ForumListItem extends StatefulWidget {
  final String name;
  final IconData icon;
  Forum forum;
  bool isJoined;
  int number;
  ForumListItem(this.forum, this.name, this.icon, this.isJoined, this.number,
      {Key? key})
      : super(key: key);

  @override
  State<ForumListItem> createState() => _ForumListItemState();
}

class _ForumListItemState extends State<ForumListItem> {
  ForumViewModel forumViewModel = ForumViewModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isJoined(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return ListTile(
            title: Container(
              margin: const EdgeInsets.only(
                bottom: 5,
              ),
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.forum.title,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    snapshot.data != null
                        ? (!snapshot.data!
                            ? CustomButton(CustomColors.mainYellow, "Join",
                                () => joinForum())
                            : const Padding(
                                padding: EdgeInsets.only(
                                    right: 30.0, top: 15, bottom: 15),
                                child: Text(
                                  "Joined",
                                  style: TextStyle(
                                      color: CustomColors.darkText,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16),
                                ),
                              ))
                        : const SizedBox(
                            height: 48,
                          )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
            ),
            onTap: () => _getForumPage(context, widget),
          );
        });
  }

  joinForum() async {
    if (AuthService.currentUser != null) {
      await forumViewModel.joinForum(
          AuthService.currentUser!.user.id, widget.forum.id);
      setState(() {
        widget.isJoined = true;
      });
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

    return forumsIdOfUser.contains(widget.forum.id);
  }

  _getForumPage(BuildContext context, ForumListItem forumListItem) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ForumPageScreen(forumListItem)));
  }
}
