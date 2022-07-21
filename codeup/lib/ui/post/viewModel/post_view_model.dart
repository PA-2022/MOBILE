import 'dart:convert';
import 'dart:math';

import 'package:codeup/services/post_vote_service.dart';
import 'package:flutter/material.dart';

import '../../../entities/person.dart';
import '../../../entities/post.dart';
import '../../../entities/post_vote.dart';
import '../../../entities/user.dart';
import '../../../services/auth_service.dart';
import '../../common/test_data.dart';

class PostViewModel with ChangeNotifier {
  AuthService authService = AuthService();

  PostVoteService postVoteService = PostVoteService();
  User? commiter;
  final _random = Random();

  Future<Person> getCommiter(Post post) async {
    return Person(await authService.getUserById(post.userId),
        TestData.photos[randomNumber(0, 3)]);
  }

  Future<bool> userHasVoted(Post post) async {
    var hasVoted = false;
    await postVoteService.fetchUserVoteByPostId(post.id).then((data) {
      var postVote = jsonDecode(data.body);
      if (postVote != null) {
        hasVoted = true;
      }
    });
    return hasVoted;
  }

  Future<bool> userHasUpVoted(Post post) async {
    var hasUpVoted = false;
    await postVoteService.fetchUserVoteByPostId(post.id).then((data) {
      if (jsonDecode(data.body) != null) {
        PostVote postVote = PostVote.fromJson(jsonDecode(data.body));
        if (postVote.upvote == true) {
          hasUpVoted = true;
        }
      }
    });
    return hasUpVoted;
  }

  /* Future<List<PostBox>> fetchPosts() async {
    List<PostBox> allPosts = [];
    await postService.fetchPosts().then((data) async {
      for (dynamic element in jsonDecode(data.body)) {
        Post post = Post.fromJson(element);
        PostBox postBoxWidget = PostBox(
            post,
            const [LanguageValue.C, LanguageValue.JAVA],
            post.userId,
            false,
            await postViewModel.getCommiter(post),
            true);
        allPosts.add(postBoxWidget);
      }
    });
    return allPosts;
  } */

  Future<PostVote> fetchUserVoteByPostId(int postId) async {
    PostVote postVote = const PostVote(-1,true, -1,-1);
    await postVoteService.fetchUserVoteByPostId(postId).then((data) async {
      if (jsonDecode(data.body) != null) {
        postVote = PostVote.fromJson(jsonDecode(data.body));
      }
    });
    return postVote;
   
  }

  int randomNumber(int min, int max) => min + _random.nextInt(max - min);
}
