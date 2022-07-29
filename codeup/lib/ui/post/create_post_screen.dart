import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../entities/content_post.dart';
import '../../entities/post.dart';
import '../../entities/post_content.dart';
import '../../services/auth_service.dart';
import '../../services/forum_service.dart';
import '../../services/post_service.dart';
import '../common/custom_app_bar.dart';
import '../common/custom_button.dart';
import '../common/custom_colors.dart';
import '../forums/forum_list_item.dart';
import '../forums/forum_page/forum_page_screen.dart';
import '../forums/viewModel/forum_view_model.dart';
import '../home/home_screen.dart';

class CreatePostScreen extends StatefulWidget {
  final int? choosenForumId;
  static const routeName = "/createPost-screen";

  const CreatePostScreen([this.choosenForumId]);
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
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

  _CreatePostScreenState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const InputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
      ),
      borderRadius: BorderRadius.all(Radius.circular(6)),
    );
    return Scaffold(
      backgroundColor: background_color,
      body: CustomScrollView(
        slivers: [
          CustomAppBar("Add a post", false, null),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                                  height: 110,
                                  child: CircleAvatar(
                                    radius:50,
                                    backgroundImage: NetworkImage(AuthService.currentUser!.user.profilePictureUrl
                                        ),
                                  )),
                    ),
                    if (widget.choosenForumId == null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left:10,top:20.0),
                    child: FutureBuilder(
                        future: forumViewModel.fetchForumsOfUser(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ForumListItem>> snapshot) {
                          return DropdownButton(
                            value: selectedForum,
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
                ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, bottom: 8, top: 20),
                      child: TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: CustomColors.darkText, width: 1.0),
                            ),
                            labelText: 'Title',
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
                            labelText: 'Your post content...',
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
                padding: const EdgeInsets.only(top: 4.0, right: 8, left:8),
                child: CustomButton(
                    widget.choosenForumId == null
                        ? (contentController.text.isNotEmpty &&
                                titleController.text.isNotEmpty &&
                                selectedForum != "empty_response"
                            ? CustomColors.mainYellow
                            : Colors.grey)
                        : (contentController.text.isNotEmpty &&
                                titleController.text.isNotEmpty
                            ? CustomColors.mainYellow
                            : Colors.grey),
                    "Send",
                    widget.choosenForumId == null
                        ? (contentController.text.isNotEmpty &&
                                titleController.text.isNotEmpty &&
                                selectedForum != "empty_response"
                            ? _submitPost
                            : null)
                        : (contentController.text.isNotEmpty &&
                                titleController.text.isNotEmpty
                            ? _submitPost
                            : null)),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  _submitPost() async {

    final forumId = widget.choosenForumId ?? int.parse(selectedForum);

    Post post = Post(-1, titleController.text, contentController.text, "C", forumId,
            AuthService.currentUser!.user.id, null, 0);

    ContentPost contentPost = ContentPost(-1, post.content, post.id, -1, 0, 1, "");
    List<ContentPost> contentPosts = [];
    contentPosts.add(contentPost);
    PostContent postContent = PostContent(post, contentPosts);

    final response = await postService.addPost(postContent,
        AuthService.currentUser!);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (widget.choosenForumId == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return const HomeScreen();
        }));
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return FutureBuilder(
              future: forumViewModel.fetchForumById(forumId),
              builder: (BuildContext context,
                  AsyncSnapshot<ForumListItem> snapshot) {
                return snapshot.data != null
                    ? ForumPageScreen(snapshot.data!)
                    : Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: CustomColors.mainYellow,
                        ));
              });
        }));
      }

    }
  }
}
