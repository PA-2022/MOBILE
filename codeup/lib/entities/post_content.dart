import 'package:codeup/entities/content_post.dart';

import 'post.dart';

class PostContent {
  late Post post;
  final List<ContentPost> contentPost;

  PostContent(this.post, this.contentPost);

factory PostContent.fromJson(Map<String, dynamic> json) {
    return PostContent(
      json['post'],
      json['contentPost']
    );
  }
 @override
  String toString() {
    return "{post: $post, contentPost: $contentPost}";
  }
}