import 'comment_global.dart';

class CommentResponse {
  final CommentGlobal commentGlobal;
  final List<dynamic> responses;
  CommentResponse(this.commentGlobal,  this.responses);
 
factory CommentResponse.fromJson(Map<String, dynamic> json) {
  
  var res = CommentResponse(
      CommentGlobal.fromJson(json['comment']),
      json['responses']
    );
    
    return res;
  }

 @override
  String toString() {
    return "{comment: $commentGlobal, responses: $responses}";
  } 
}