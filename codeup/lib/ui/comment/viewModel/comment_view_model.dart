import 'dart:convert';
import 'dart:math';

import 'package:codeup/entities/comment_global.dart';
import 'package:codeup/entities/comment_response.dart';
import 'package:codeup/services/comment_service.dart';
import 'package:codeup/services/comment_vote_service.dart';
import 'package:codeup/ui/comment/comment_list_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../entities/comment.dart';
import '../../../entities/comment_vote.dart';
import '../../../entities/person.dart';
import '../../../entities/post.dart';
import '../../../entities/user.dart';
import '../../../services/auth_service.dart';
import '../../common/test_data.dart';

class CommentViewModel with ChangeNotifier {
  final CommentService commentService = CommentService();
  final CommentVoteService commentVoteService = CommentVoteService();
  final AuthService authService = AuthService();

  User? commiter;
  final _random = Random();

  Future<Person> getCommiter(Comment comment) async {
    return Person(await authService.getUserById(comment.userId),
        TestData.photos[randomNumber(0, 3)]);
  }

  int randomNumber(int min, int max) => min + _random.nextInt(max - min);

  Future<List<CommentListItem>> fetchComments(int postId) async {
    List<CommentListItem> allComments = [];
    await commentService.fetchCommentsOfPost(postId).then((data) async {
      for (dynamic element in jsonDecode(data.body)) {
        CommentResponse commentResponse = CommentResponse.fromJson(element);
        
        CommentGlobal commentGlobal = commentResponse.commentGlobal;
        Comment comment = commentGlobal.comment;
        
        CommentListItem commentListItem = CommentListItem(
            comment, await getCommiter(comment));
        allComments.add(commentListItem);
      }
    });
    
    return allComments.reversed.toList();
  }

  Future<Comment?> insertComment(
      Comment comment, Person user, Post post) async {
    final Response response =
        await commentService.addComment(comment, user, post);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return comment;
    } else {
      return null;
    }
  }

  Future<String> getCommentCount(Post post) async {
    final response = await commentService.getCommentsCount(post.id);
    return response.body.length == 1 ? response.body : "1";
  }

  Future<bool> userHasVoted(Comment comment) async {
    var hasVoted = false;
    await commentVoteService.fetchUserVoteByCommentId(comment.id).then((data) {
      var commentVote = jsonDecode(data.body);
      if (commentVote != null) {
        hasVoted = true;
      }
    });
    return hasVoted;
  }

  Future<bool> userHasUpVoted(Comment comment) async {
    var hasUpVoted = false;
    await commentVoteService.fetchUserVoteByCommentId(comment.id).then((data) {
      if (jsonDecode(data.body) != null) {
        CommentVote commentVote = CommentVote.fromJson(jsonDecode(data.body));
        if (commentVote.upvote == true) {
          hasUpVoted = true;
        }
      }
    });
    return hasUpVoted;
  }



  Future<CommentVote> fetchUserVoteByCommentId(int commentId) async {
    CommentVote commentVote = const CommentVote(-1,true, -1,-1);
    await commentVoteService.fetchUserVoteByCommentId(commentId).then((data) async {
      if (jsonDecode(data.body) != null) {
        commentVote = CommentVote.fromJson(jsonDecode(data.body));
        print(data.body);
      }
    });
    //print(commentVote);
    return commentVote;
   
  }
}
