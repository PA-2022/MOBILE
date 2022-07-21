import 'package:flutter/material.dart';

import '../common/custom_app_bar.dart';
import '../common/custom_colors.dart';
import '../common/search_bar_type.dart';
import '../menu/menu.dart';
import 'saved_post_list.dart';

class SavedPostsScreen extends StatefulWidget {
  static const routeName = "/savedPosts-screen";
  const SavedPostsScreen({Key? key}) : super(key: key);

  @override
  State<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  // ignore: non_constant_identifier_names
  final background_color = CustomColors.lightGrey3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_color,
      drawer: const Menu(),
      body: CustomScrollView(
        slivers: [
          CustomAppBar("Saved Posts", true, SearchBarType.POST),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: BoxDecoration(color: background_color),
                height: MediaQuery.of(context).size.height * 8 / 10,
                child: const SavedPostList(),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
