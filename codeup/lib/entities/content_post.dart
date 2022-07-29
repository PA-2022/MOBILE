class ContentPost {
  final int id;
  final String content;
  final int postId;
  final int commentId;
  final int type;
  final int position;
  final String language;

  const ContentPost(this.id, this.content, this.postId, this.commentId, this.type, this.position, this.language);

factory ContentPost.fromJson(Map<String, dynamic> json) {
    return ContentPost(
      json['id'],
      json['content'],
      json['postId'],
      json['comment_id'],
      json['type'],
      json['position'],
      json['language']
    );
  }
 @override
  String toString() {
    return "{id: $id, content: $content, postId: $postId, commentId: $commentId, type: $type, position: $position, position: $language}";
  }
}