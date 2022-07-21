import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../authentication/sign_in/sign_in_screen.dart';
import '../common/custom_app_bar.dart';
import '../common/custom_colors.dart';
import '../common/search_bar_type.dart';
import '../menu/menu.dart';
import 'forums_list.dart';

class ForumsScreen extends StatefulWidget {
  static const routeName = "/forum-screen";
  const ForumsScreen({Key? key}) : super(key: key);

  @override
  State<ForumsScreen> createState() => _ForumsScreenState();
}

class _ForumsScreenState extends State<ForumsScreen> {
  // ignore: non_constant_identifier_names
  final background_color = CustomColors.lightGrey3;
  bool isChecked = false;
  CustomAppBar forumsTop = CustomAppBar("Forums", true, SearchBarType.FORUM);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (() => _createForum()),
        child: const Icon(Icons.add),
        backgroundColor: CustomColors.mainYellow,
      ),
      backgroundColor: background_color,
      drawer: const Menu(),
      body: CustomScrollView(
        slivers: [
          forumsTop,
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: BoxDecoration(color: background_color),
                height: MediaQuery.of(context).size.height * 8 / 10,
                child: ForumList(forumsTop),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _createForum() async {
    if (AuthService.currentUser != null) {
      Navigator.of(context).pushNamed("/createForum-screen");
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return const SignInScreen(true);
      }));
    }
  }
}
