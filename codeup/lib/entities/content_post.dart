class ContentPost {
  final int id;
  final String content;
  final int postId;
  final int type;
  final int position;

  const ContentPost(this.id, this.content, this.postId, this.type, this.position);

factory ContentPost.fromJson(Map<String, dynamic> json) {
    return ContentPost(
      json['id'],
      json['content'],
      json['postId'],
      json['type'],
      json['position']
    );
  }
 @override
  String toString() {
    return "{id: $id, content: $content, postId: $postId, type: $type, position: $position}";
  }
}