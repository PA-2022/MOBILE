import 'dart:convert';

import 'package:codeup/entities/user_and_friend.dart';
import 'package:codeup/services/friends_service.dart';
import 'package:codeup/ui/forums/forum_list_item.dart';
import 'package:codeup/ui/forums/viewModel/forum_view_model.dart';
import 'package:flutter/material.dart';

import '../../../entities/content_post.dart';
import '../../../entities/post.dart';
import '../../../entities/post_content.dart';
import '../../../entities/user.dart';
import '../../../services/post_service.dart';
import '../../common/language_enum.dart';
import '../../friends/viewModel/friend_view_model.dart';
import '../../post/post_box.dart';
import '../../post/viewModel/post_view_model.dart';

class HomeViewModel with ChangeNotifier {
  PostViewModel postViewModel = PostViewModel();
  PostService postService = PostService();
  ForumViewModel forumViewModel = ForumViewModel();

  Future<List<PostBox>> fetchPosts() async {
    List<PostBox> allPosts = [];
    
    
            
    await forumViewModel.fetchForums().then((data) async {
      for (ForumListItem forumListItem in data) {
        await postService
            .fetchPostsByForumId(forumListItem.forum.id)
            .then((data) async {
          for (dynamic element in jsonDecode(data.body)) {
            Post post = Post.fromJson(element);

    
            List<ContentPost> contentPosts =
                await postViewModel.fetchContentByPostId(post.id);

            PostContent postContent = PostContent(post, contentPosts);

            PostBox postBoxWidget = PostBox(
                postContent,
                const [LanguageValue.C, LanguageValue.JAVA],
                post.userId,
                false,
                await postViewModel.getCommiter(post),
                true);
            allPosts.add(postBoxWidget);
          }
        });
      }
    });
    allPosts
        .sort((a, b) => a.postContent.post.id.compareTo(b.postContent.post.id));
    return allPosts.reversed.toList();
  }

  

  Future<Post> fetchPostById(int postId) async {
    Post post = Post(-1, "", "", "", -1, -1, null, -1);

    await forumViewModel.fetchForums().then((data) async {
      await postService.fetchPostById(postId).then((data) async {
        post = Post.fromJson(jsonDecode(data.body));
      });
    });
    return post;
  }

  

  Future<List<PostBox>> fetchHomePosts() async {
    List<PostBox> allPosts = [];
    await forumViewModel.fetchForumsOfUser().then((data) async {
      for (ForumListItem forumListItem in data) {
        await postService
            .fetchPostsByForumId(forumListItem.forum.id)
            .then((data) async {
          for (dynamic element in jsonDecode(data.body)) {
            Post post = Post.fromJson(element);
            List<ContentPost> contentPosts =
                await postViewModel.fetchContentByPostId(post.id);

            PostContent postContent = PostContent(post, contentPosts);

            PostBox postBoxWidget = PostBox(
                postContent,
                const [LanguageValue.C, LanguageValue.JAVA],
                post.userId,
                false,
                await postViewModel.getCommiter(post),
                true);
            allPosts.add(postBoxWidget);
          }
        });
      }
    });
    List<User> allFriends = [];
    var friends = await FriendViewModel().fetchUsersAndFriends();
    for(UserAndFriend userAndFriend in friends) {
      if(userAndFriend.friend.is_accepted) {
        allFriends.add(userAndFriend.user);
      }
    }
    


    var allPostsInDb = await fetchPosts();
    for(var post in allPostsInDb) {
      if(allFriends.map((e) => e.id).contains(post.postContent.post.userId) &&  !allPosts.map((e) => e.postContent.post.id).contains(post.postContent.post.id)) {
        allPosts.add(post);
      }
    }


        allPosts
        .sort((a, b) => a.postContent.post.id.compareTo(b.postContent.post.id));
        
    return allPosts.reversed.toList();
  }

  Future<List<PostBox>> fetchWantedPosts(String searchBarValue) async {
    List<PostBox> allPosts = [];
    await postService.fetchPosts().then((data) async {
      for (dynamic element in jsonDecode(data.body)) {
        Post post = Post.fromJson(element);

        List<ContentPost> contentPosts =
            await postViewModel.fetchContentByPostId(post.id);

        PostContent postContent = PostContent(post, contentPosts);

        PostBox postBoxWidget = PostBox(
            postContent,
            const [LanguageValue.C, LanguageValue.JAVA],
            post.userId,
            false,
            await postViewModel.getCommiter(post),
            true);

        if (post.title.toLowerCase().contains(searchBarValue.toLowerCase())) {
          allPosts.add(postBoxWidget);
        }
      }
    });
    return allPosts;
  }

  Future<List<PostBox>> fetchLoggedUserPosts(int id) async {
    List<PostBox> allPosts = [];
    await HomeViewModel().fetchPosts().then((posts) {
      for (PostBox post in posts) {
        if (post.postContent.post.userId == id) {
          allPosts.add(post);
        }
      }
    });

    return allPosts;
  }
}
