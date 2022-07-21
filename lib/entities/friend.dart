class Friend {
  final int user_id;
  final int friend_id;
  final bool is_accepted;

  const Friend(this.user_id, this.friend_id, this.is_accepted);

factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      json['user_id'],
      json['friend_id'],
      json['is_accepted']
    );
  }
 @override
  String toString() {
    return "{id: $user_id, title: $friend_id, content: $is_accepted}";
  }
}