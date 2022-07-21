
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/post_service.dart';
import '../common/custom_app_bar.dart';
import '../common/custom_colors.dart';
import '../common/search_bar_type.dart';
import '../menu/menu.dart';
import 'logged_user_post_list.dart';

class LoggedUserPostScreen extends StatefulWidget {
  static const routeName = "/loggedUserPosts-screen";
  const LoggedUserPostScreen({Key? key}) : super(key: key);

  @override
  _LoggedUserPostScreenState createState() => _LoggedUserPostScreenState();
}

class _LoggedUserPostScreenState extends State<LoggedUserPostScreen> {
  final PostService postService = PostService();
  // ignore: non_constant_identifier_names
  final background_color = CustomColors.lightGrey3;
  CustomAppBar homeTop = CustomAppBar("My Posts", true, SearchBarType.POST);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_color,
      drawer: const Menu(),
      body: CustomScrollView(
        slivers: [
          homeTop,
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                
                decoration: BoxDecoration(color: background_color),
                height: MediaQuery.of(context).size.height * 8 / 10,
                child: LoggedUserPostList(AuthService.currentUser!.user.id, homeTop)
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
