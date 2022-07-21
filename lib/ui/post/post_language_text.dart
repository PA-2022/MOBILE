import 'package:codeup/ui/forums/forum_page/forum_page_screen.dart';
import 'package:codeup/ui/forums/viewModel/forum_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../common/custom_colors.dart';
import '../forums/forum_list_item.dart';

class PostLanguageText extends StatelessWidget {
  final int forumId;
  PostLanguageText(this.forumId, {Key? key}) : super(key: key);
  ForumViewModel forumViewModel = ForumViewModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: forumViewModel.fetchForumById(forumId),
      builder: (BuildContext context, AsyncSnapshot<ForumListItem> snapshot) {
        return GestureDetector(
          onTap: () =>  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ForumPageScreen(snapshot.data!))),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  snapshot.data != null ? snapshot.data!.forum.title : "...",
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(
                  color:  snapshot.data != null && _isAColor(snapshot.data!.forum.color) ? colorFromHex(snapshot.data!.forum.color) : CustomColors.mainYellow,
                  borderRadius: BorderRadius.circular(6)),
            ),
          ),
        );
      }
    );
  }

  bool _isAColor(String value) {
    return value.length == 8 || value.length == 7 || value.length == 10;
  }
}
