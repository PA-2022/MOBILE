import 'user.dart';
import 'comment.dart';

class CommentGlobal {
  final Comment comment;
  final User user;
  CommentGlobal(this.comment,  this.user);
 
factory CommentGlobal.fromJson(Map<String, dynamic> json) {
    return CommentGlobal(
      Comment.fromJson(json['comment']),
      User.fromJson(json['user'])
    );
  }

 /*  @override
  String toString() {
    return "{id: $id, content: $content, commentParentId: $commentParentId, userId: $userId, code: $code, postId: $postId, creationDate: $creationDate}";
  } */
}