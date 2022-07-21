import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../entities/post_vote.dart';
import 'secure_storage.dart';

class PostVoteService {
  static String apiUrl = "http://" +
      (dotenv.env.keys.contains("HOST") ? dotenv.env["HOST"]! : "localhost") +
      ":" +
      (dotenv.env.keys.contains("SERVER_PORT")
          ? dotenv.env["SERVER_PORT"]!
          : "8080") +
      "/posts-vote";
  PostVoteService();

  Future<http.Response> fetchUserVoteByPostId(int postId) async {

    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'cookie': token,
    };
final response = await http.get(
        Uri.parse(apiUrl + "/post/" + postId.toString()),
        headers: headers);
    return response;
  }

  Future<http.Response> editUserVoteForPost(PostVote postVote) async {
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
        'upvote': postVote.upvote,
        'userId': postVote.user_id,
        'postId': postVote.post_id
      }),
    );
   
    
    return response;
  }


  Future<http.Response> deleteUserVoteForPost(PostVote postVote) async {
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
        'id':postVote.id,
        'upvote': postVote.upvote,
        'userId': postVote.user_id,
        'postId': postVote.post_id
      }),);
    return response;
  }
}
