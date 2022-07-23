import 'package:codeup/services/auth_service.dart';
import 'package:codeup/ui/common/test_data.dart';
import 'package:flutter/material.dart';

import '../../entities/Friend.dart';
import '../../entities/person.dart';
import '../../entities/user.dart';
import '../profile/profile_screen.dart';

class FriendsListItem extends StatelessWidget {
  final Friend friend;

  const FriendsListItem(this.friend, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return FutureBuilder(
      future: authService.getUserById(friend.friend_id),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {

        return snapshot.data != null ? Center(
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
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(TestData.photos[0]),
                      radius: 20,
                    ),
                  ),
                  Text(snapshot.data!.username),
                ],
              ),
            ),
            onTap: () => _getFriendPage(context, Person(snapshot.data!, TestData.photos[0])),
          ),
        ): Container();
      }
    );
  }

  _getFriendPage(BuildContext context, Person friend) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ProfileScreen(friend, true)));
  }
}
