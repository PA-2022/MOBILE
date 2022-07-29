class CommentVote {
  final int id;
  final bool upvote;
  final int user_id;
  final int comment_id;

  const CommentVote(this.id,this.upvote, this.user_id, this.comment_id);

factory CommentVote.fromJson(Map<String, dynamic> json) {
  
    return json != null ? CommentVote(
      json['id'],
      json['upvote'],
      json['userId'],
      json['commentId']
    ) : CommentVote(-1, false, 1, 1);
  }
 @override
  String toString() {
    return "{upvote: $upvote, user_id: $user_id, comment_id: $comment_id}";
  }
}