import 'dart:convert';
import 'package:codeup/entities/comment_global.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../entities/comment.dart';
import '../entities/person.dart';
import '../entities/post.dart';
import 'secure_storage.dart';

class CommentService {
  static String apiUrl = "https://" +
      (dotenv.env.keys.contains("HOST") ? dotenv.env["HOST"]! : "localhost") +
      ":" +
      (dotenv.env.keys.contains("SERVER_PORT")
          ? dotenv.env["SERVER_PORT"]!
          : "8080") +
      "/comments";
  CommentService();

  Future<http.Response> fetchCommentsOfPost(int postId) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'cookie': token,
    };
    final response = await http.get(
        Uri.parse(apiUrl + "/comment/post/" + postId.toString()),
        headers: headers);

    return response;
  }

  Future<http.Response> getCommentsCount(int postId) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'cookie': token,
    };
    final response = await http.get(
        Uri.parse(apiUrl + "/comment/post/" + postId.toString() + "/count"),
        headers: headers);
    return response;
  }

  Future<http.Response> addComment(
      CommentGlobal comment, Person user, Post post) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'cookie': token,
    };
    return await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode({'comment':{
        'content': "",
        'commentParentId': null,
        'userId': user.user.id,
        'code': comment.comment.code,
        'postId': comment.comment.postId,
        'note': comment.comment.note
      },
      'contentPost': [
        {
            "content": comment.contents[0].content,
            "postId": null,
            "commentId": null,
            "type": 0,
            "position": 0,
            "language": comment.contents[0].language
        }
    ]}),
    );
  }

 


  Future<http.Response> updateComment(Comment comment, Person user) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());
    final response = http.put(
      Uri.parse(apiUrl + "comments"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'cookie': token,
      },
      body: jsonEncode({
        'content': comment.content,
        'commentParentId': null,
        'userId': user.user.id,
        'code': comment.code,
        'postId': comment.postId
      }),
    );
    return response;
  }
}
