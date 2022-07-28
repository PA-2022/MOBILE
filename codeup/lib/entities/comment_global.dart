import 'dart:convert';

import 'package:codeup/entities/content_post.dart';

import 'comment_content.dart';
import 'comment_vote.dart';
import 'user.dart';
import 'comment.dart';

class CommentGlobal {
  final Comment comment;
  final User user;
  final List<ContentPost> contents;
  final CommentVote? optionalCommentVote;
   
  CommentGlobal(this.comment,  this.user, this.contents, {this.optionalCommentVote});
 
factory CommentGlobal.fromJson(Map<String, dynamic> json) {
   
    List<ContentPost> contentPosts = [];

    for(dynamic contentPost in json['contents']) {
print(contentPost);
      contentPosts.add(ContentPost.fromJson(contentPost));
    }
    return CommentGlobal(
      Comment.fromJson(json['comment']),
      User.fromJson(json['user']),
      contentPosts, 
      optionalCommentVote: CommentVote.fromJson(json["optionalCommentVote"]));
  }

 /*  @override
  String toString() {
    return "{id: $id, content: $content, commentParentId: $commentParentId, userId: $userId, code: $code, postId: $postId, creationDate: $creationDate}";
  } */
}