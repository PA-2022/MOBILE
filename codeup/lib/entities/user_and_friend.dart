import 'Friend.dart';
import 'user.dart';

class UserAndFriend {
  final User user;
  final Friend friend;

  UserAndFriend(this.user, this.friend);

factory UserAndFriend.fromJson(Map<String, dynamic> json) {
    return UserAndFriend(
      User.fromJson(json['user']),
      Friend.fromJson(json['friend'])
    );
  }
 @override
  String toString() {
    return "{user: $user, friend: $friend}";
  }
}