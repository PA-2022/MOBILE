import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../entities/comment_vote.dart';
import 'secure_storage.dart';

class CommentVoteService {
  static String apiUrl = "https://" +
      (dotenv.env.keys.contains("HOST") ? dotenv.env["HOST"]! : "localhost") +
      ":" +
      (dotenv.env.keys.contains("SERVER_PORT")
          ? dotenv.env["SERVER_PORT"]!
          : "8080") +
      "/comment-votes";
  CommentVoteService();

  Future<http.Response> fetchUserVoteByCommentId(int commentId) async {

    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'cookie': token,
    };
final response = await http.get(
        Uri.parse(apiUrl + "/comment/" + commentId.toString()),
        headers: headers);
    return response;
  }

  Future<http.Response> editUserVoteForComment(CommentVote commentVote) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());

    final response = http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'cookie': token,
      },
      body: jsonEncode({
        'upvote': commentVote.upvote,
        'userId': commentVote.user_id,
        'commentId': commentVote.comment_id
      }),
    );
   
    
    return response;
  }


  Future<http.Response> deleteUserVoteForComment(CommentVote commentVote) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());
    final response = http.delete(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'cookie': token,
        },
      body: jsonEncode({
        'id':commentVote.id,
        'upvote': commentVote.upvote,
        'userId': commentVote.user_id,
        'commentId': commentVote.comment_id
      }),);
    return response;
  }
}
