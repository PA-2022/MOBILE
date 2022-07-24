import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/Friend.dart';
import '../../entities/user.dart';
import '../../services/auth_service.dart';
import '../common/custom_app_bar.dart';
import '../common/custom_colors.dart';
import 'friends_list_item.dart';
import 'user_list_item.dart';
import 'viewModel/friend_view_model.dart';

class UserList extends StatefulWidget {
  final CustomAppBar friendsTop;
  const UserList(this.friendsTop, {Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  FriendViewModel friendViewModel = FriendViewModel();
  // ignore: non_constant_identifier_names
  Color background_color = CustomColors.lightGrey3;
  bool isChecked = false;
  late Future<List<UserListItem>> friends;
  Color getColor(Set<MaterialState> states) {
    return CustomColors.mainYellow;
  }

  @override
  Widget build(BuildContext context) {
    friends = friendViewModel.fetchUsers();
    return ChangeNotifierProvider(
      create: (context) => widget.friendsTop,
      child: FutureBuilder(
          future: friends,
          builder: (BuildContext context,
              AsyncSnapshot<List<UserListItem>> snapshot) {
            return snapshot.data != null
                ? (snapshot.data!.isNotEmpty
                    ? Consumer<CustomAppBar>(builder: (context, appBar, child) {
                        return Builder(builder: (context) {
                          return Column(
                            children: [
                              for (UserListItem friend
                                  in snapshot.data as List<UserListItem>)
                                  (friend.userAndFriend.user.firstname
                                                  .toLowerCase()
                                                  .contains(appBar.valueSearch
                                                      .toLowerCase()) ||
                                              friend.userAndFriend.user.lastname
                                                  .toLowerCase()
                                                  .contains(appBar.valueSearch
                                                      .toLowerCase()) ||
                                              friend.userAndFriend.user.username
                                                  .toLowerCase()
                                                  .contains(appBar.valueSearch
                                                      .toLowerCase()) ? friend : Container()) 
                            ],
                          );
                        });
                      })
                    : const Center(
                        child: Text(
                          "No users to show",
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
