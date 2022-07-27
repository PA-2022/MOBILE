import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:http/io_client.dart';

import '../entities/person.dart';
import '../ui/authentication/viewModel/sign_in_fields_view_model.dart';
import '../entities/user.dart';
import 'secure_storage.dart';

class AuthService {
  static String apiUrl = "https://" +
      (dotenv.env.keys.contains("HOST") ? dotenv.env["HOST"]! : "localhost") +
      ":" +
      (dotenv.env.keys.contains("SERVER_PORT")
          ? dotenv.env["SERVER_PORT"]!
          : "8080") +
      "/";
  SignInFieldsViewModel? signInFieldsVm;
  static Person? currentUser;
  static String? photo;

  AuthService({this.signInFieldsVm});

  Future<Person?> getLoggedUser(User userFields) async {
    List<User> users = [];
    final response = await http.get(Uri.parse(apiUrl + "users/users"));

    for (dynamic element in jsonDecode(response.body)) {
      User user = User.fromJson(element);
      users.add(user);
    }

    User loggedUser =
        users.firstWhere((user) => user.username == userFields.username);
    currentUser = Person(loggedUser, ""); // + photo!
    return currentUser;
  }

  Future<http.Response> getUsers() async {
    List<User> users = [];
    final response = await http.get(Uri.parse(apiUrl + "users/users"));

    for (dynamic element in jsonDecode(response.body)) {
      User user = User.fromJson(element);
      users.add(user);
    }
    return response;
  }

  Future<User> getUserById(int id) async {
    User user;
    final response =
        await http.get(Uri.parse(apiUrl + "users/" + id.toString()));
    user = User.fromJson(jsonDecode(response.body));

    return user;
  }

  Future<http.Response> logIn(
      SignInFieldsViewModel signInFieldsVm, User user) async {
    var response = await http.post(
      Uri.parse(apiUrl + "login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': user.username,
        'password': user.password
      }),
    );
    return response;
  }

  Future<http.Response> register(
      SignInFieldsViewModel signInFieldsVm, User user) async {
    final response = await http.post(
      Uri.parse(apiUrl + 'users/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': user.username,
        'password': user.password,
        'email': user.email,
        'firstname': user.firstname,
        'lastname': user.lastname,
        'profilePictureUrl': user.profilePictureUrl + user.profilePictureName,
        'profilePictureName': user.profilePictureName
      }),
    );
    return response;
  }

  Future<http.Response> updateAccount(
      SignInFieldsViewModel signInFieldsVm, User user) async {
        

    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());
    final response = await http.put(
      Uri.parse(apiUrl + "users/" + user.id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'cookie': token,
      },
      body: jsonEncode(<String, String>{
        'id': user.id.toString(),
        'username': user.username,
        'password': user.password,
        'email': user.email,
        'firstname': user.firstname,
        'lastname': user.lastname
      }),
    );
   
    return response;
  }

  Future<http.StreamedResponse> uploadPp(File file) async {
    String token = "";
    token = await SecureStorageService.getInstance()
        .get("token")
        .then((value) => token = value.toString());

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        apiUrl + 'users/profile-picture',
      ),
    );

            
    request.files.add(http.MultipartFile('image',
        File(file.path).readAsBytes().asStream(), File(file.path).lengthSync(),
        filename: file.path.split("/").last));
    request.headers['cookie'] = token;
    var res = await request.send().then((response) {
      if(response.statusCode == 200) {
       /*  AuthService.currentUser!.user.profilePictureUrl = dotenv.env["BUCKET_NAME"].toString();
        AuthService.currentUser!.user.profilePictureName = file.path.split("/").last; */
      }
    });
    return res;
  }

  static void setCurrentUser(Person? user) {
    currentUser = user;
  }
}
