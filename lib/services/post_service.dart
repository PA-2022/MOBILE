import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../entities/person.dart';
import '../entities/post.dart';
import 'secure_storage.dart';

class PostService {
  static String apiUrl = "http://" +
      (dotenv.env.keys.contains("HOST") ? dotenv.env["HOST"]! : "localhost") +
      ":" +
      (dotenv.env.keys.contains("SERVER_PORT")
          ? dotenv.env["SERVER_PORT"]!
          : "8080") +
      "/";
  PostService();

  Future<http.Response> fetchPosts() async {

    final response =
        await http.get(Uri.parse(apiUrl + "posts/all/limit/100/offset/0"));

    return response;
  }

  Future<http.Response> fetchPostsByForumId(int forumId) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'cookie': token,
    };
    final response = await http.get(
        Uri.parse(apiUrl + "posts/forum/" + forumId.toString()),
        headers: headers);
        print(response.body);
    return response;
  }

  Future<http.Response> addPost(Post post, Person user) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());
    final response = http.post(
      Uri.parse(apiUrl + 'posts/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'cookie': token,
      },
      body: jsonEncode({
        'title': post.title,
        'content': post.content,
        'forumId': post.forumId,
        'code': post.code,
        'userId': user.user.id
      }),
    );
    return response;
  }

  Future<http.Response> updatePost(Post post, Person user) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());
    final response = http.put(
      Uri.parse(apiUrl + "posts"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'cookie': token,
      },
      body: jsonEncode({
        'id': post.id,
        'title': post.title,
        'content': post.content,
        'forumId': post.forumId,
        'code': post.code,
        'creationDate': post.creationDate,
        'userId': user.user.id
      }),
    );
    return response;
  }

  Future<http.Response> deletePost(String postId) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());
    final response = http.delete(Uri.parse(apiUrl + "posts/" + postId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'cookie': token,
        });

    return response;
  }
}
