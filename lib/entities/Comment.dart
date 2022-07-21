class Comment {
  final int id;
  final String content;
  final dynamic commentParentId;
  final int userId;
  final String code;
  final int postId;
  final creationDate;

  Comment(this.id,  this.content, this.commentParentId,  this.userId,  this.code,  this.postId, this.creationDate);
 
factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      json['id'],
      json['content'],
      json['commentParentId'],
      json['userId'],
      json['code'],
      json['postId'],
      json['creationDate']
    );
  }

  @override
  String toString() {
    return "{id: $id, content: $content, commentParentId: $commentParentId, userId: $userId, code: $code, postId: $postId, creationDate: $creationDate}";
  }
}