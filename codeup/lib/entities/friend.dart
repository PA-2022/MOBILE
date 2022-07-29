class Friend {
  final int user_id;
  final int friend_id;
  final bool is_accepted;

  const Friend(this.user_id, this.friend_id, this.is_accepted);

factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      json['userId'],
      json['friendId'],
      json['accepted']
    );
  }
 @override
  String toString() {
    return "{user_id: $user_id, friend_id: $friend_id, is_accepted: $is_accepted}";
  }
}