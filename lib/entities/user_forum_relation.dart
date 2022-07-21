class UserForumRelation {
  final int userId;
  final int forumId;

  const UserForumRelation(this.userId, this.forumId);

factory UserForumRelation.fromJson(Map<String, dynamic> json) {
    return UserForumRelation(
      json['userId'],
      json['forumId'],
    );
  }
 @override
  String toString() {
    return "{id: $userId, title: $forumId}";
  }
}