import 'package:codeup/services/post_vote_service.dart';
import 'package:codeup/ui/post/viewModel/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../entities/post.dart';
import '../../entities/post_vote.dart';
import '../../services/auth_service.dart';
import '../authentication/sign_in/sign_in_screen.dart';

class VotesCounter extends StatefulWidget {
  int counter;
  late 
  Post post;

  VotesCounter(this.counter, this.post, {Key? key}) : super(key: key);
  @override
  _VotesCounterState createState() => _VotesCounterState();
}

class _VotesCounterState extends State<VotesCounter> {
  int _initialCounter = 0;
  PostViewModel postViewModel = PostViewModel();
  PostVoteService postVoteService = PostVoteService();

  @override
  void initState() {
    super.initState();
   int initial_note = widget.counter;
    _initialCounter = widget.counter;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: postViewModel.userHasVoted(widget.post),
        builder: (BuildContext context, AsyncSnapshot<bool> hasVoted) {
          return FutureBuilder(
              future: postViewModel.userHasUpVoted(widget.post),
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
                              hasVoted.data != null && hasVoted.data! != false && AuthService.currentUser != null
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
    final response = await postVoteService.editUserVoteForPost(
        PostVote(-1, true, AuthService.currentUser!.user.id, widget.post.id));

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        widget.counter++;
      });
    }
  }

  void _decrementCounter() async {
    final response = await postVoteService.editUserVoteForPost(
        PostVote(-1, false, AuthService.currentUser!.user.id, widget.post.id));
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        widget.counter--;
      });
      
    }
  }

  void _resetCounter(bool up) async {
   final postVote = await postViewModel.fetchUserVoteByPostId(widget.post.id);
   final response = await postVoteService.deleteUserVoteForPost(postVote);
   if(response.statusCode == 200 || response.statusCode == 201) {
     setState(() {
       widget.counter = postVote.upvote ? widget.counter - 1 : widget.counter + 1;
     });
   }
  }

  void _getSignInScreen(BuildContext context) {
    Navigator.of(context).pushNamed(SignInScreen.routeName);
  }
}
