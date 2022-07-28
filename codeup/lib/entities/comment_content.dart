import 'package:codeup/entities/content_post.dart';

import 'post.dart';

class CommentContent {
  late Post post;
  final List<ContentPost> contentPost;

  CommentContent(this.post, this.contentPost);

factory CommentContent.fromJson(Map<String, dynamic> json) {
    return CommentContent(
      json['post'],
      json['contentPost']
    );
  }
 @override
  String toString() {
    return "{post: $post, contentPost: $contentPost}";
  }
}