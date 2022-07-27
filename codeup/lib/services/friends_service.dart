import 'dart:convert';
import 'package:codeup/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../entities/Friend.dart';
import '../entities/forum.dart';
import '../entities/user_and_friend.dart';
import 'secure_storage.dart';

class FriendService {
  static String apiUrl = "https://" +
      (dotenv.env.keys.contains("HOST") ? dotenv.env["HOST"]! : "localhost") +
      ":" +
      (dotenv.env.keys.contains("SERVER_PORT")
          ? dotenv.env["SERVER_PORT"]!
          : "8080") +
      "/friends";

  Future<http.Response> fetchForums() async {
    final response =
        await http.get(Uri.parse(apiUrl + "forums/all/limit/20/offset/0"));
    return response;
  }

  Future<http.Response> fetchFriendsById(int userId) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'cookie': token,
    };
    final response =
        await http.get(Uri.parse(apiUrl + "/list/" + userId.toString()), headers: headers);
    return response;
  }

  Future<http.Response> addFriend(int friendId) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());
    return await http.post(
      Uri.parse(apiUrl + '/add-friend/' + friendId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'cookie': token,
      },
      body: jsonEncode({
        'user_id': AuthService.currentUser!.user.id,
        'friend_id': friendId,
        "is_accepted": false
      }),
    );
  }

  Future<http.Response> acceptFriend(int friendId) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());
    return await http.post(
      Uri.parse(apiUrl + '/accept-friend/' + friendId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'cookie': token,
      },
      body: jsonEncode({
        'user_id': friendId,
        'friend_id': AuthService.currentUser!.user.id,
        "is_accepted": true
      }),
    );
  }

  Future<http.Response> deleteFriend(String friendId) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());
    final response = http.delete(Uri.parse(apiUrl + "/delete-friend/" + friendId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'cookie': token,
        });

    return response;
  }
}
