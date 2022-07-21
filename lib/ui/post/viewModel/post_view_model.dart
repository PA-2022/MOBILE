import 'dart:math';

import 'package:flutter/material.dart';

import '../../../entities/person.dart';
import '../../../entities/post.dart';
import '../../../entities/user.dart';
import '../../../services/auth_service.dart';
import '../../common/test_data.dart';

class PostViewModel with ChangeNotifier {
  AuthService authService = AuthService();
  User? commiter;
  final _random = Random();

  Future<Person> getCommiter(Post post) async {
    return Person(await authService.getUserById(post.userId),
        TestData.photos[randomNumber(0, 3)]);
  }

  int randomNumber(int min, int max) => min + _random.nextInt(max - min);
}
