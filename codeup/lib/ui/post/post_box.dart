import 'package:codeup/services/post_service.dart';
import 'package:codeup/ui/home/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:codeup/ui/home/viewModel/home_view_model.dart';
import 'package:flutter/material.dart';

import '../../entities/person.dart';
import '../../entities/post.dart';
import '../../entities/post_content.dart';
import '../../entities/post_vote.dart';
import '../../services/auth_service.dart';
import '../../services/post_vote_service.dart';
import '../../utils/date_helper.dart';
import '../comment/comment_list_screen.dart';
import '../comment/viewModel/comment_view_model.dart';
import '../common/language_enum.dart';
import '../profile/profile_screen.dart';
import '../saved_posts/saved_post_list.dart';
import 'edit_post_screen.dart';
import 'post_language_text.dart';
import 'post_box_action.dart';
import 'text_viewer.dart';
import 'viewModel/post_view_model.dart';
import 'post_votes_counter.dart';

class PostBox extends StatefulWidget {
  PostContent postContent;
  final List<LanguageValue> languages;
  int votes;
  bool isSaved;
  Person commiter;
  bool areCommentsVisible;
  PostBox(this.postContent, this.languages, this.votes, this.isSaved, this.commiter,
      this.areCommentsVisible,
      {Key? key})
      : super(key: key);

  @override
  _PostBoxState createState() => _PostBoxState();
}

class _PostBoxState extends State<PostBox> {
  AuthService authService = AuthService();
  PostViewModel postViewModel = PostViewModel();
  PostVoteService postVoteService = PostVoteService();
  HomeViewModel homeViewModel = HomeViewModel();

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CommentViewModel commentViewModel = CommentViewModel();
    commentViewModel.getCommentCount(widget.postContent.post);
    //var response = postViewModel.userHasVoted(widget.postContent.post);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _getCommiterProfile(context, widget.commiter),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, bottom: 10, right: 10),
                            child:  SizedBox(
                                  height: 55,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(widget.commiter.user.profilePictureUrl!= null ? widget.commiter.user.profilePictureUrl : dotenv.env["DEFAULT_PP"].toString()
                                        ),
                                  )),
                            
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.commiter.user.username,
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                DateHelper.formatDate(
                                    widget.postContent.post.creationDate.toString()),
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (AuthService.currentUser != null &&
                        AuthService.currentUser!.user.id == widget.postContent.post.userId)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                            onPressed: () => _editPost(),
                            icon: const Icon(Icons.edit_outlined)),
                      )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  widget.postContent.post.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(children: [
                  //for (LanguageValue language in widget.languages)
                    PostLanguageText(widget.postContent.post.forumId),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    VotesCounter(widget.postContent.post.note, widget.postContent.post),
                    Flexible(child:  TextViewer(widget.postContent.contentPost[0].content)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: <Widget>[
                    if (widget.areCommentsVisible)
                      GestureDetector(
                        child: FutureBuilder(
                            future:
                                commentViewModel.getCommentCount(widget.postContent.post),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              return PostBoxAction(
                                  Icons.comment_outlined,
                                  snapshot.data != null
                                      ? snapshot.data.toString() +
                                          ((snapshot.data.toString() != "1" &&
                                                  snapshot.data.toString() !=
                                                      "0")
                                              ? " Comments"
                                              : " Comment")
                                      : "...",
                                  () => _openComments(context));
                            }),
                        onTap: () => _openComments(context),
                      ),
                    
                    /* GestureDetector(
                        child: PostBoxAction(
                            Icons.share_outlined, "Share", () => _share()),
                        onTap: () => _share()), */
                  ],
                ),
              ),
            ],
          )),
    );
  }

  _upvote() async {
    final response = await postVoteService.editUserVoteForPost
    (PostVote(-1,true,widget.postContent.post.id, AuthService.currentUser!.user.id ));
    if(response.statusCode == 200 || response.statusCode == 201) {
      
    }
  }

  _downvote() async {
    
  }

  _editPost() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return EditPostScreen(widget);
    }));
  }

  _share() {
    //TODO implement share function
    print("write share function");
  }

  _save() {
    setState(() {
      if (widget.isSaved) {
        widget.isSaved = false;
        SavedPostList.savedPosts.remove(widget);
      } else {
        widget.isSaved = true;
        if (!SavedPostList.savedPosts.contains(widget)) {
          SavedPostList.savedPosts.add(widget);
        }
      }
    });
  }

  _openComments(BuildContext context) async {
    Post newPost = await homeViewModel.fetchPostById(widget.postContent.post.id);
    widget.postContent.post = newPost;
    
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return CommentListScreen(widget);
    }));
  }

  _getCommiterProfile(BuildContext context, Person friend) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ProfileScreen(friend, true)));
  }
}
