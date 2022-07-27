import 'package:codeup/services/auth_service.dart';
import 'package:codeup/services/friends_service.dart';
import 'package:codeup/ui/common/test_data.dart';
import 'package:codeup/ui/friends/viewModel/friend_view_model.dart';
import 'package:flutter/material.dart';

import '../../entities/Friend.dart';
import '../../entities/person.dart';
import '../../entities/user.dart';
import '../../entities/user_and_friend.dart';
import '../common/custom_button.dart';
import '../common/custom_colors.dart';
import '../profile/profile_screen.dart';
import 'friends_list_item.dart';
class UserListItem extends StatefulWidget {
UserAndFriend userAndFriend;
UserListItem(this.userAndFriend, {Key? key}) : super(key: key);
  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  Widget action = Container();
  FriendViewModel friendViewModel = FriendViewModel();
  FriendService friendService = FriendService();
  

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return FutureBuilder(
        future: friendViewModel.isAFriend(widget.userAndFriend.user.id),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot)  {
          return snapshot.data != null
              ? Center(
                  child: ListTile(
                    title: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: FutureBuilder(
                        future:friendViewModel.fetchFriendsOfUser(),
                        builder: (BuildContext context, AsyncSnapshot<List<FriendsListItem>> friendsOfUser) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                 onTap: () => _getFriendPage(
                            context, Person(widget.userAndFriend.user, widget.userAndFriend.user.profilePictureUrl)),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(40)),
                                        ),
                                        child: SizedBox(
                                          height: 30,
                                          child: Image(
                                            image:
                                                NetworkImage(widget.userAndFriend.user.profilePictureUrl),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(widget.userAndFriend.user.username),
                                  ],
                                ),
                              ),
                              friendsOfUser.data != null ? 
                               _getAction(snapshot.data!, friendsOfUser.data!) : Container()
                            ],
                          );
                        }
                      ),
                    ),
                   
                  ),
                )
              : Container();
        });
  }

  _getAction(bool isAFriend, List<FriendsListItem> friendsOfUser) {
    if (friendsOfUser.map((e) => e.userAndFriend.user.id).contains(widget.userAndFriend.user.id)) {
      if (widget.userAndFriend.user.id == AuthService.currentUser!.user.id) {
        print("1");
        return const Padding(
          padding: EdgeInsets.only(right:20.0),
          child: Text(
            "Me",
            style: TextStyle(color: Colors.grey),
          ),
        );
      } else {
        
        print("2");
          for (var friend in friendsOfUser) {
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
              } else {
                return Container();
              }
            }
          }
        
      }
      
    
    }
    return  Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: IconButton(icon: Icon(Icons.person_add, color: CustomColors.mainYellow), onPressed:()=> _addAfriend()),
      );

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
      setState(() {
      });
    }
  }

  _getFriendPage(BuildContext context, Person friend) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ProfileScreen(friend, true)));
  }
}
