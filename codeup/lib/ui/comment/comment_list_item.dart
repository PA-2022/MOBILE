import 'package:codeup/services/comment_service.dart';
import 'package:codeup/ui/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../entities/comment.dart';
import '../../entities/person.dart';
import '../../services/auth_service.dart';
import '../../utils/date_helper.dart';
import '../common/custom_colors.dart';
import '../post/post_votes_counter.dart';
import '../profile/profile_screen.dart';
import 'comment_votes_counter.dart';

class CommentListItem extends StatefulWidget {

final Comment comment;
  Person commiter;
  final int _votes = 0;

  CommentListItem(this.comment, this.commiter, {Key? key}) : super(key: key);


  @override
  State<CommentListItem> createState() => _CommentListItemState();
}

class _CommentListItemState extends State<CommentListItem> {

  
  bool editMode = false;
  String responseContent = "";
  TextEditingController contentController = TextEditingController();
  CommentService commentService = CommentService();

  @override
  void initState() {
    contentController.text = widget.comment.content;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(2.0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF656565).withOpacity(0.15),
              blurRadius: 4.0,
              spreadRadius: 1.0,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
        child: Row(
         
          children: [
            CommentVotesCounter(widget.comment.note, widget.comment),
            Expanded(
                child: Column(
              children: [
              /*if (AuthService.currentUser != null &&
                      AuthService.currentUser!.user.id == widget.comment.userId)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: IconButton(
                            onPressed: () => setState(() {
                              editMode = true;
                            }),
                            icon: editMode ? IconButton(onPressed: () => _editComment(context), icon: Icon(Icons.save), color: CustomColors.mainYellow,): const Icon(Icons.edit_outlined)),
                      ),
                    ), */
                Padding(
                  padding: const EdgeInsets.only(top:10.0, left: 10.0),
                  child: Align(
                    child: editMode ? TextFormField(
                        controller: contentController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.darkText, width: 1.0),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(fontSize: 18),
                          floatingLabelStyle: TextStyle(
                              fontSize: 19,
                              color: CustomColors.darkText,
                              fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.darkText, width: 2.0),
                          ),
                        ),
                        onChanged: (str) {
                          setState(() {
                            responseContent = str;
                          });
                        },
                      ) : Text(
                      widget.comment.content,
                      style: const TextStyle(fontSize: 17),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
  
                
                    GestureDetector(
                      onTap: () => _getCommiterProfile(context, widget.commiter),
                      child: Align(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            children: [
                              
                              Row(
                                children: [
                                  
                                  SizedBox(
                                    height: 25,
                                    child: Image(
                                        image: NetworkImage(widget.commiter.user.profilePictureUrl)),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: Text(
                                        widget.commiter.user.firstname +
                                            " " +
                                            widget.commiter.user.lastname,
                                        style: const TextStyle(
                                            color: CustomColors.mainPurple)),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.end,
                              ),
                               if (widget.comment.creationDate != null)
                               Align(
                                alignment: Alignment.bottomRight,
                                 child: Text(
                                      DateHelper.formatDate(widget.comment.creationDate.toString()),
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    ),
                               ),
                               
                            ],
                          ),
                        ),
                        alignment: Alignment.bottomRight,
                      ),
                    ),
                ],
            )),
            
          ],
        ),
      ),
    );
  }

  _getCommiterProfile(BuildContext context, Person user) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ProfileScreen(user, true)));
  }

  _editComment(BuildContext context) async {
    Comment comment = Comment(widget.comment.id, responseContent, null,
            AuthService.currentUser!.user.id, "?", widget.comment.postId, widget.comment.creationDate, widget.comment.note);
     Response response = await commentService.updateComment(
        comment, 
        AuthService.currentUser!);
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
      editMode = false;
    });
     /*  {
        await Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) {
          return const HomeScreen();
        }));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return CommentListScreen(widget.post);
        }));
      } */
    }
    
  }
}
