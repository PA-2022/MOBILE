import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import 'secure_storage.dart';

class UserForumRelationService {
  static String apiUrl = "http://" +
      (dotenv.env.keys.contains("HOST") ? dotenv.env["HOST"]! : "localhost") +
      ":" +
      (dotenv.env.keys.contains("SERVER_PORT")
          ? dotenv.env["SERVER_PORT"]!
          : "8080") +
      "/user-forum-relation";
  UserForumRelationService();

  Future<http.Response> fetchRelationsOfUser() async {String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());
        final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'cookie': token,
    };

    final response = await http.get(Uri.parse(apiUrl + "/all-by-logged-user"), headers: headers); 
    return response;
  }

  Future<http.Response> addRelation(int userId, int forumId) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());

    return await http.post(
      Uri.parse(apiUrl + '/add/forum/' + forumId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'cookie': token,
      },
      body: jsonEncode({
        'userId': userId,
        'forumId': forumId,
      }),
    );
  }

  Future<http.Response> deleteRelation(int forumId) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());
    return await http.delete(
        Uri.parse(apiUrl + '/delete/forum/' + forumId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'cookie': token,
        });
  }
}
