import 'package:flutter/material.dart';

import '../../entities/person.dart';
import '../profile/profile_screen.dart';

class FriendsListItem extends StatelessWidget {
  final Person friend;
  const FriendsListItem(this.friend, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  backgroundImage: NetworkImage(friend.photoUrl),
                  radius: 20,
                ),
              ),
              Text(friend.user.username),
            ],
          ),
        ),
        onTap: () => _getFriendPage(context, friend),
      ),
    );
  }

  _getFriendPage(BuildContext context, Person friend) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ProfileScreen(friend, true)));
  }
}
