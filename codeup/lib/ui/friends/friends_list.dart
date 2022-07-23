import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/Friend.dart';
import '../../entities/user.dart';
import '../../services/auth_service.dart';
import '../common/custom_app_bar.dart';
import '../common/custom_colors.dart';
import 'friends_list_item.dart';
import 'viewModel/friend_view_model.dart';

class FriendsList extends StatefulWidget {
  final CustomAppBar friendsTop;
  const FriendsList(this.friendsTop, {Key? key}) : super(key: key);

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  FriendViewModel friendViewModel = FriendViewModel();
  // ignore: non_constant_identifier_names
  Color background_color = CustomColors.lightGrey3;
  bool isChecked = false;
  late Future<List<FriendsListItem>> friends;
  Color getColor(Set<MaterialState> states) {
    return CustomColors.mainYellow;
  }

  @override
  Widget build(BuildContext context) {
    friends = friendViewModel.fetchFriendsOfUser();
    return ChangeNotifierProvider(
      create: (context) => widget.friendsTop,
      child: FutureBuilder(
          future: friends,
          builder: (BuildContext context,
              AsyncSnapshot<List<FriendsListItem>> snapshot) {
            return snapshot.data != null
                ? (snapshot.data!.isNotEmpty
                    ? Consumer<CustomAppBar>(builder: (context, appBar, child) {
                        return Builder(builder: (context) {
                          return Column(
                            children: [
                              for (FriendsListItem friend
                                  in snapshot.data as List<FriendsListItem>)
                                FutureBuilder(
                                    future: AuthService()
                                        .getUserById(friend.friend.friend_id),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<User> userFriend) {
                                          
                                      return userFriend.data != null ? (userFriend.data!.firstname
                                                  .toLowerCase()
                                                  .contains(appBar.valueSearch
                                                      .toLowerCase()) ||
                                              userFriend.data!.lastname
                                                  .toLowerCase()
                                                  .contains(appBar.valueSearch
                                                      .toLowerCase()) ||
                                              userFriend.data!.username
                                                  .toLowerCase()
                                                  .contains(appBar.valueSearch
                                                      .toLowerCase()) ? friend : Container()) : Container();
                                    })
                            ],
                          );
                        });
                      })
                    : const Center(
                        child: Text(
                          "No friends to show",
                          style: TextStyle(
                              color: CustomColors.darkText,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                : Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: CustomColors.mainYellow,
                    ));
          }),
    );
  }
}
