import 'package:codeup/entities/comment.dart';
import 'package:codeup/services/comment_service.dart';
import 'package:codeup/ui/home/viewModel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:codeup/ui/comment/viewModel/comment_view_model.dart';
import 'package:http/http.dart';

import '../../entities/comment_global.dart';
import '../../entities/content_post.dart';
import '../../entities/post.dart';
import '../../services/auth_service.dart';
import '../authentication/sign_in/sign_in_screen.dart';
import '../common/custom_colors.dart';
import '../post/post_box.dart';
import 'comment_list_item.dart';

class CommentListScreen extends StatefulWidget {
  static const routeName = "/CommentListScreen-screen";
  PostBox post;

  CommentListScreen(this.post, {Key? key}) : super(key: key);

  @override
  _CommentListScreenState createState() => _CommentListScreenState();
}

class _CommentListScreenState extends State<CommentListScreen> {
  HomeViewModel homeViewModel = HomeViewModel();
  CommentService commentService = CommentService();
  CommentViewModel commentViewModel = CommentViewModel();
  final commentController = TextEditingController();
  late String responseContent;

  @override
  void initState()  {
    
    widget.post = PostBox(widget.post.postContent, widget.post.languages,
        0, widget.post.isSaved, widget.post.commiter, false);
    responseContent = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Responses to " + widget.post.commiter.user.firstname),
        ),
        backgroundColor: CustomColors.lightGrey3,
        body: _getBody(),
        bottomSheet: _getResponseArea());
  }

  void sendResponse() async {
Comment comment = Comment(-1, commentController.text, null,
            AuthService.currentUser!.user.id, "?", widget.post.postContent.post.id, null, 0);
    List<ContentPost> contents = [];
  contents.add(ContentPost(-1, comment.content, comment.postId, -1, 0, 0, ""));
  CommentGlobal commentGlobal = CommentGlobal(comment, AuthService.currentUser!.user, contents );
      
    Response response = await commentService.addComment(commentGlobal
        , 
        AuthService.currentUser!,
        widget.post.postContent.post);

    if (response.statusCode == 200 || response.statusCode == 201) {
      FocusScope.of(context).requestFocus(FocusNode());

      commentController.clear();
      setState(() {});
      const snackBar = SnackBar(
        content: Text('Response sent'),
        backgroundColor: CustomColors.mainYellow,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _getResponseArea() {
    return AuthService.currentUser != null
        ? Row(children: [
            Expanded(
              child: SizedBox(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 1),
                  child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a reponse...',
                        border: InputBorder.none,
                      ),
                      onChanged: (str) {
                        setState(() {
                          responseContent = str;
                        });
                      },
                      onSubmitted: (str) {}),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 8),
              child: GestureDetector(
                onTap: responseContent.isNotEmpty
                    ? () => setState(() {
                          sendResponse();
                        })
                    : null,
                child: Icon(
                  Icons.send_rounded,
                  size: 29.0,
                  color: responseContent.isNotEmpty
                      ? CustomColors.mainYellow
                      : Colors.grey,
                ),
              ),
            ),
          ])
        : GestureDetector(
            onTap: () => _goToSignInScreen(context),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: CustomColors.mainYellow,
                child: const Center(
                    child: Text("Log in to answer",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )))));
  }

  Widget _getBody() {
    return FutureBuilder(
        future: commentViewModel.fetchComments(widget.post.postContent.post.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<CommentListItem>> snapshot) {
          return snapshot.data != null
              ? Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, right: 5.0, top: 20.0, bottom: 80.0),
                  child: RefreshIndicator(
                    onRefresh: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return CommentListScreen(widget.post);
    }))  ,
                    child: ListView(
                      children: [
                        SingleChildScrollView(
                          child: Column(children: [
                            GestureDetector(
                              child: widget.post,
                              onTap: null,
                            ),
                            for (CommentListItem comment
                                in snapshot.data as List<CommentListItem>)
                              comment,
                          ]),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: CustomColors.mainYellow,
                  ));
        });
  }

  void _goToSignInScreen(BuildContext context) {
    Navigator.of(context).pushNamed(SignInScreen.routeName);
  }
}
