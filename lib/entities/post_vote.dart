class PostVote {
  final bool upvote;
  final int user_id;
  final int post_id;

  const PostVote(this.upvote, this.user_id, this.post_id);

factory PostVote.fromJson(Map<String, dynamic> json) {
    return PostVote(
      json['upvote'],
      json['user_id'],
      json['post_id']
    );
  }
 @override
  String toString() {
    return "{upvote: $upvote, user_id: $user_id, post_id: $post_id}";
  }
}