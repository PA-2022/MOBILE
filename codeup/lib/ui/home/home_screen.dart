import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/post_service.dart';
import '../authentication/sign_in/sign_in_screen.dart';
import '../common/custom_app_bar.dart';
import '../common/custom_colors.dart';
import '../common/search_bar_type.dart';
import './home_post_list.dart';
import '../menu/menu.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService postService = PostService();
  // ignore: non_constant_identifier_names
  final background_color = CustomColors.lightGrey3;
  CustomAppBar homeTop = CustomAppBar("Posts", true, SearchBarType.POST);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (() => _createPost()),
        child: const Icon(Icons.add),
        backgroundColor: CustomColors.mainYellow,
      ),
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
                  child: PostBoxList(homeTop)),

            ]),
          ),
        ],
      ),
    );
  }

  void _createPost() async {
    if (AuthService.currentUser != null) {
      Navigator.of(context).pushNamed("/createPost-screen");
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return const SignInScreen(true);
      }));
    }
  }
}
