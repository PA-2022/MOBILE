import 'dart:convert';

import 'package:codeup/entities/user_and_friend.dart';
import 'package:codeup/ui/friends/user_list_item.dart';
import 'package:flutter/material.dart';

import '../../../entities/Friend.dart';
import '../../../entities/user.dart';
import '../../../services/auth_service.dart';
import '../../../services/friends_service.dart';
import '../friends_list_item.dart';

class FriendViewModel with ChangeNotifier {
  FriendViewModel();
  FriendService friendService = FriendService();
  AuthService authService = AuthService();

  //final _random = new Random();

   Future<List<UserAndFriend>> fetchUsersAndFriends() async {
    List<UserAndFriend> allRelations = [];
    await friendService
        .fetchFriendsById(AuthService.currentUser!.user.id)
        .then((data) {
      for (dynamic element in jsonDecode(data.body)) {
        UserAndFriend userAndFriend = UserAndFriend.fromJson(element);
        User user = userAndFriend.user;
        Friend friend = userAndFriend.friend;
        allRelations.add(userAndFriend);
      }
    });
    return allRelations.toList();
  }

  Future<List<FriendsListItem>> fetchFriendsOfUser() async {
    List<FriendsListItem> allFriends = [];
    await fetchUsersAndFriends().then((relations) {
      for(UserAndFriend userAndFriend in relations) {
        FriendsListItem friendsListItem = FriendsListItem(userAndFriend);
        allFriends.add(friendsListItem);
      }
    });
    /* allFriends.add(FriendsListItem(Friend(16, 11, false)));
    allFriends.add(FriendsListItem(Friend(16, 11, false)));
    allFriends.add(FriendsListItem(Friend(16, 11, true)));
    allFriends.add(FriendsListItem(Friend(11, 16, true))); */
    //allFriends.add(FriendsListItem(Friend(11, 17, false)));
    

    return allFriends.toList();
  }

  Future<List<UserListItem>> fetchUsers() async {
    List<UserListItem> allUsers = [];
    var users = await authService.getUsers().then((data) {
      for (dynamic element in jsonDecode(data.body)) {
        User user = User.fromJson(element);
        UserAndFriend userAndFriend = UserAndFriend(user, Friend(0,0,true ));
        UserListItem userListItem = UserListItem(userAndFriend);
        if(userListItem.userAndFriend.user.id != AuthService.currentUser!.user.id)
        allUsers.add(userListItem);
      }
    });
    return allUsers;
  }

  Future<bool> isAFriend(int otherUserId) async {
    var foundInFriends = false;
    await fetchFriendsOfUser().then((data) {
      for (FriendsListItem friendsListItem in data) {
        if (friendsListItem.userAndFriend.friend.friend_id ==
                AuthService.currentUser!.user.id ||
            friendsListItem.userAndFriend.friend.user_id ==
                AuthService.currentUser!.user.id) {
          foundInFriends = true;
        }
      }
    });

    return foundInFriends;
  }

  /* Future<List<PostBox>> fetchFriendPosts(int id) async {
    List<PostBox> allPosts = [];
    await postService.fetchPostsByFriendId(id).then((data) async {
      for (dynamic element in jsonDecode(data.body)) {
        Post post = Post.fromJson(element);
        PostBox postBoxWidget = PostBox(
            post,
            const [LanguageValue.C, LanguageValue.JAVA],
            post.userId,
            true,
            await postViewModel.getCommiter(post),
            true);
        if (post.FriendId == id) allPosts.add(postBoxWidget);
      }
    });
    return allPosts;
  } */

  /* Future<FriendsListItem> fetchFriendById(int id) async {
    final data = await FriendService.fetchFriendById(id);
    Friend Friend = Friend.fromJson(jsonDecode(data.body));
    return FriendsListItem(Friend, Friend.title, Icons.Friend_outlined, false, 1);
  }
 */
  /*  Future<FriendListItem?> joinFriend(int userId, int FriendId) async {
    final response =
        await userFriendRelationService.addRelation(userId, FriendId);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return fetchFriendById(FriendId);
    } else {
      return null;
    }
  }

  Future<void> unjoinFriend(int userId, int FriendId) async {
    await userFriendRelationService.deleteRelation(FriendId);
  } */
}
