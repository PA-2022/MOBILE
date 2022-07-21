import 'package:codeup/entities/comment_vote.dart';
import 'package:codeup/services/comment_vote_service.dart';
import 'package:codeup/services/post_vote_service.dart';
import 'package:codeup/ui/comment/viewModel/comment_view_model.dart';
import 'package:codeup/ui/post/viewModel/post_view_model.dart';
import 'package:flutter/material.dart';

import '../../entities/comment.dart';
import '../../entities/post.dart';
import '../../entities/post_vote.dart';
import '../../services/auth_service.dart';
import '../authentication/sign_in/sign_in_screen.dart';

class CommentVotesCounter extends StatefulWidget {
  int counter;
  Comment comment;

  CommentVotesCounter(this.counter, this.comment, {Key? key}) : super(key: key);
  @override
  _CommentVotesCounterState createState() => _CommentVotesCounterState();
}

class _CommentVotesCounterState extends State<CommentVotesCounter> {
  int _initialCounter = 0;
  CommentViewModel commentViewModel = CommentViewModel();
  CommentVoteService commentVoteService = CommentVoteService();

  @override
  void initState() {
    super.initState();
   int initial_note = widget.counter;
    _initialCounter = widget.counter;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: commentViewModel.userHasVoted(widget.comment),
        builder: (BuildContext context, AsyncSnapshot<bool> hasVoted) {
          return FutureBuilder(
              future: commentViewModel.userHasUpVoted(widget.comment),
              builder: (BuildContext context, AsyncSnapshot<bool> hasUpVoted) {
                return InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: AuthService.currentUser != null
                            ? (hasVoted.data != null &&
                                    hasVoted.data! == true
                                ?  () => _resetCounter(true)
                                : _incrementCounter)
                            : () => _getSignInScreen(context),
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          size: 28,
                          color:
                              hasVoted.data != null && hasVoted.data! == true
                                  ? (hasUpVoted.data != null &&
                                          hasUpVoted.data! == true
                                      ? Colors.green
                                      : Colors.black)
                                  : Colors.black,
                        ),
                      ),
                      Text(
                        widget.counter.toString(),
                        style:
                            TextStyle(fontSize: 17, color: _getCounterColor()),
                      ),
                      GestureDetector(
                        onTap: AuthService.currentUser != null
                            ? (hasVoted.data != null &&
                                    hasVoted.data! == true 
                                ? () => _resetCounter(false)
                                : _decrementCounter)
                            : () => _getSignInScreen(context),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 28,
                          color:
                              AuthService.currentUser != null && hasVoted.data != null && hasVoted.data! != false 
                                  ? (hasUpVoted.data != null &&
                                          hasUpVoted.data! == false
                                      ? Colors.red
                                      : Colors.black)
                                  : Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  

  Color _getCounterColor() {
    if (widget.counter > 0) return Colors.green;
    if (widget.counter < 0) return Colors.red;
    return Colors.black;
  }

  void _incrementCounter() async {
    print("incr");
    final response = await commentVoteService.editUserVoteForComment(
        CommentVote(-1, true, AuthService.currentUser!.user.id, widget.comment.id));

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        widget.counter++;
      });
    }
  }

  void _decrementCounter() async {
    print("decr");
    final response = await commentVoteService.editUserVoteForComment(
        CommentVote(-1, false, AuthService.currentUser!.user.id, widget.comment.id));
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        widget.counter--;
      });
    }
  }

  void _resetCounter(bool up) async {
    int first = widget.comment.note;
    print("reset");
   final commentVote = await commentViewModel.fetchUserVoteByCommentId(widget.comment.id);
    //print(commentVote);
   final response = await commentVoteService.deleteUserVoteForComment(commentVote);
  
   print(response.statusCode);
   if(response.statusCode == 200 || response.statusCode == 201) {
     setState(() {
       widget.counter = first;
     });
   }
  }

  void _getSignInScreen(BuildContext context) {
    Navigator.of(context).pushNamed(SignInScreen.routeName);
  }
}
