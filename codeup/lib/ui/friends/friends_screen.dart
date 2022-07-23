import 'package:codeup/ui/common/search_bar_type.dart';
import 'package:flutter/material.dart';

import '../../entities/person.dart';
import '../common/custom_app_bar.dart';
import '../common/custom_colors.dart';
import '../common/test_data.dart';
import '../menu/menu.dart';
import 'friends_list.dart';
import 'friends_list_item.dart';

class FriendsScreen extends StatefulWidget {
  static const routeName = "/friends-screen";
  const FriendsScreen({ Key? key }) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  // ignore: non_constant_identifier_names
  final background_color = CustomColors.lightGrey3;
  CustomAppBar friendsTop = CustomAppBar("Friends", true, SearchBarType.FRIEND);

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: background_color,
      drawer: const Menu(),
      body: CustomScrollView(
        slivers: [
          friendsTop,
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: BoxDecoration(color: background_color),
                height: MediaQuery.of(context).size.height * 8 / 10,
                child: ListView(children: [
                  FriendsList(friendsTop)],),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}