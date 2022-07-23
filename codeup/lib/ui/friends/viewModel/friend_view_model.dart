import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../entities/Friend.dart';
import '../../../services/auth_service.dart';
import '../../../services/friends_service.dart';
import '../friends_list_item.dart';

class FriendViewModel with ChangeNotifier {
  FriendViewModel();
  FriendService friendService = FriendService();
  
  //final _random = new Random();

  Future<List<FriendsListItem>> fetchFriendsOfUser() async {
    List<FriendsListItem> allFriends = [];
    //await userFriendRelationService.fetchRelationsOfUser().then((data) async {
      
       FriendsListItem friend1= FriendsListItem(Friend(AuthService.currentUser!.user.id, 1, true));
       FriendsListItem friend2= FriendsListItem(Friend(AuthService.currentUser!.user.id, 1, true));
        
        allFriends.add(friend1);
        allFriends.add(friend2);

    //}); 
    return allFriends..toList();
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
