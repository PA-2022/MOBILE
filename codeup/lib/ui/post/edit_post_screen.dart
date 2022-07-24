import 'package:flutter/material.dart';

import '../../entities/post.dart';
import '../../services/auth_service.dart';
import '../../services/forum_service.dart';
import '../../services/post_service.dart';
import '../comment/comment_list_screen.dart';
import '../common/custom_app_bar.dart';
import '../common/custom_button.dart';
import '../common/custom_colors.dart';
import '../forums/forum_list_item.dart';
import '../forums/viewModel/forum_view_model.dart';
import '../home/home_screen.dart';
import 'post_box.dart';

class EditPostScreen extends StatefulWidget {
  final PostBox post;
  static const routeName = "/editPost-screen";

  const EditPostScreen(this.post, {Key? key}) : super(key: key);
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  // ignore: non_constant_identifier_names
  final background_color = CustomColors.lightGrey3;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String responseContent = "";
  AuthService authService = AuthService();
  PostService postService = PostService();
  ForumService forumService = ForumService();
  ForumViewModel forumViewModel = ForumViewModel();
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(
        child: Text("Select forum.."), value: "empty_response"),
  ];

  String selectedForum = "empty_response";

  _EditPostScreenState();

  @override
  void initState() {
    titleController.text = widget.post.postContent.post.title;
    contentController.text = widget.post.postContent.post.content;
    selectedForum = widget.post.postContent.post.forumId.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_color,
      body: CustomScrollView(
        slivers: [
          CustomAppBar("Edit a post", false, null),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 80,
                        child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(AuthService.currentUser!.user.profilePictureUrl),
                            radius: 50),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, bottom: 8, top: 20),
                      child: TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.darkText, width: 1.0),
                          ),
                          labelText: "Title",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(fontSize: 18),
                          floatingLabelStyle: TextStyle(
                              fontSize: 19,
                              color: CustomColors.darkText,
                              fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.darkText, width: 2.0),
                          ),
                        ),
                        onChanged: (str) {
                          setState(() {
                            responseContent = str;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: contentController,
                          maxLines: 7,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: CustomColors.darkText, width: 1.0),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Your post content...",
                            labelStyle: TextStyle(fontSize: 18),
                            floatingLabelStyle: TextStyle(
                                fontSize: 19,
                                color: CustomColors.darkText,
                                fontWeight: FontWeight.bold),
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: CustomColors.darkText, width: 2.0),
                            ),
                          ),
                          onChanged: (str) {
                            setState(() {
                              responseContent = str;
                            });
                          },
                          onSubmitted: (str) {}),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder(
                    future: forumViewModel.fetchForums(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ForumListItem>> snapshot) {
                      return DropdownButton(
                        value: snapshot.data == null
                            ? "empty_response"
                            : selectedForum,
                        items: snapshot.data != null
                            ? <DropdownMenuItem<String>>[
                                menuItems[0],
                                for (ForumListItem forum in snapshot.data!)
                                  DropdownMenuItem(
                                    child: Text(forum.forum.title.toString()),
                                    value: snapshot.data != null
                                        ? forum.forum.id.toString()
                                        : selectedForum,
                                  )
                              ]
                            : menuItems,
                        onChanged: (String? value) {
                          setState(() {
                            selectedForum = value.toString();
                          });
                        },
                        iconEnabledColor: CustomColors.mainYellow,
                        iconDisabledColor: Colors.grey,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.darkText),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, right: 8),
                child: CustomButton(
                    (contentController.text.isNotEmpty &&
                            titleController.text.isNotEmpty &&
                            selectedForum != "empty_response"
                        ? CustomColors.mainYellow
                        : Colors.grey),
                    "Save",
                    (contentController.text.isNotEmpty &&
                            titleController.text.isNotEmpty &&
                            selectedForum != "empty_response"
                        ? _updatePost
                        : null)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 17.0, top: 25),
                child: Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.delete_outline,
                        color: CustomColors.redText,
                        size: 19,
                      ),
                      TextButton(
                          onPressed: () => _showMyDialog(),
                          child: const Text(
                            "Delete post",
                            style: TextStyle(
                                color: CustomColors.redText, fontSize: 15),
                          )),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete post'),
          content: SingleChildScrollView(
            child: Column(
              children: const [
                Text(
                    'Are you sure you want to delete this post ? This action is irreversible.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                _deletePost();
                Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _deletePost() async {
    final response =
        await postService.deletePost(widget.post.postContent.post.id.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return const HomeScreen();
        }));
      }
    }
  }

  _updatePost() async {
    final forumId = int.parse(selectedForum);
    final response = await postService.updatePost(
        Post(
            widget.post.postContent.post.id,   
            titleController.text,
            contentController.text,
            widget.post.postContent.post.code,
            forumId,
            AuthService.currentUser!.user.id,
            widget.post.postContent.post.creationDate,
            widget.post.postContent.post.note),
        AuthService.currentUser!);

    if (response.statusCode == 200 || response.statusCode == 201) {
      {
        await Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) {
          return const HomeScreen();
        }));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return CommentListScreen(widget.post);
        }));
      }
    }
  }
}
