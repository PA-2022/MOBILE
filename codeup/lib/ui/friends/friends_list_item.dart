import 'package:codeup/services/auth_service.dart';
import 'package:codeup/services/friends_service.dart';
import 'package:codeup/ui/common/test_data.dart';
import 'package:codeup/ui/friends/friends_screen.dart';
import 'package:codeup/ui/friends/viewModel/friend_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../entities/Friend.dart';
import '../../entities/person.dart';
import '../../entities/user.dart';
import '../../entities/user_and_friend.dart';
import '../common/custom_button.dart';
import '../common/custom_colors.dart';
import '../profile/profile_screen.dart';


class FriendsListItem extends StatefulWidget {
final UserAndFriend userAndFriend;
  const FriendsListItem(this.userAndFriend, {Key? key}) : super(key: key);

  @override
  State<FriendsListItem> createState() => _FriendsListItemState();
}

class _FriendsListItemState extends State<FriendsListItem> {
FriendService friendService = FriendService();
FriendViewModel friendViewModel = FriendViewModel();

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return FutureBuilder(
      future: authService.getUserById(widget.userAndFriend.friend.user_id),
      builder: (BuildContext context, AsyncSnapshot<User> user) {
        return FutureBuilder(
          future: authService.getUserById(widget.userAndFriend.friend.friend_id),
          builder: (BuildContext context, AsyncSnapshot<User> friend) {
           
            return friend.data != null && user.data != null ? Center(
              child: ListTile(
                title: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: FutureBuilder(
                    future:friendViewModel.fetchFriendsOfUser(),
                        builder: (BuildContext context, AsyncSnapshot<List<FriendsListItem>> friendsOfUser) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(40)),),
                                  child: SizedBox(
                                    
                                    height: 30,
                                    child: Image(
                                      image: NetworkImage(widget.userAndFriend.user.profilePictureUrl),
                                    ),
                                  ),
                                ),
                              ), Text(widget.userAndFriend.user.username),
                            ],
                          ),
                          friendsOfUser.data != null ? 
                           _getAction(friendsOfUser.data!) : Container()
                          
                         
                        ],
                      );
                    }
                  ),
                ),
                onTap: () => _getFriendPage(context, Person(widget.userAndFriend.user, widget.userAndFriend.user.profilePictureUrl)),
              ),
            ): Container();
          }
        );
      }
    );
  }
  _getAction( List<FriendsListItem> friendsOfUser) {
    if(widget.userAndFriend.friend.user_id == AuthService.currentUser!.user.id) {
      return 
      widget.userAndFriend.friend.is_accepted ? Container() :
      const Padding(
          padding: EdgeInsets.all(18.0),
          child: Text("Request sent", style: TextStyle(),),
        );
      
    } else  {
      if(!widget.userAndFriend.friend.is_accepted) {
        return CustomButton(CustomColors.mainYellow, "Accept", ()=> _acceptAfriend());
      } 
    }
    return Container();
    
         /*  for (var friend in friendsOfUser) {
            if (friend.userAndFriend.friend.user_id == widget.userAndFriend.user.id) {// si il a envoyé la demande 
            
               if(!friend.userAndFriend.friend.is_accepted) {
                
                 return CustomButton(
                    CustomColors.mainYellow, "Accept", () => _acceptAfriend());
                  
               } else {
                 return  Container();
               }
            } else if(friend.userAndFriend.friend.friend_id == widget.userAndFriend.user.id) { //si c'est moi
              if (!friend.userAndFriend.friend.is_accepted) {
                return const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                        "Request sent",
                        style: TextStyle(),
                      ),
                    );
              }
            } else { Container();}
          } */
        

    
  }

  _addAfriend() async {
    final response = await friendService.addFriend(widget.userAndFriend.user.id);
    if(response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
      });
    }
  }

  _acceptAfriend() async {
 final response = await friendService.acceptFriend(widget.userAndFriend.user.id);
    if(response.statusCode == 200 || response.statusCode == 201) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) =>FriendsScreen()));
  
    }
  }

  _getFriendPage(BuildContext context, Person friend) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ProfileScreen(friend, true)));
  }
}
