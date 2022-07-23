import 'dart:convert';

import 'package:codeup/ui/forums/forum_list_item.dart';
import 'package:codeup/ui/forums/viewModel/forum_view_model.dart';
import 'package:flutter/material.dart';

import '../../../entities/post.dart';
import '../../../services/post_service.dart';
import '../../common/language_enum.dart';
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
        await postService.fetchPostsByForumId(forumListItem.forum.id).then((data) async {
          for (dynamic element in jsonDecode(data.body)) {
            Post post = Post.fromJson(element);
            PostBox postBoxWidget = PostBox(
                post,
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
    return allPosts;
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
            print("element");

        await postService.fetchPostsByForumId(forumListItem.forum.id).then((data) async {

          for (dynamic element in jsonDecode(data.body)) {
            Post post = Post.fromJson(element);
            PostBox postBoxWidget = PostBox(
                post,
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
    return allPosts;
  }

  Future<List<PostBox>> fetchWantedPosts(String searchBarValue) async {
    List<PostBox> allPosts = [];
    await postService.fetchPosts().then((data) async {
      for (dynamic element in jsonDecode(data.body)) {
        Post post = Post.fromJson(element);
        PostBox postBoxWidget = PostBox(
            post,
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
    await postService.fetchPosts().then((data) async {
      for (dynamic element in jsonDecode(data.body)) {
        Post post = Post.fromJson(element);
        PostBox postBoxWidget = PostBox(
            post,
            const [LanguageValue.C, LanguageValue.JAVA],
            post.userId,
            true,
            await postViewModel.getCommiter(post),
            true);
        if (post.userId == id) allPosts.add(postBoxWidget);
      }
    });
    return allPosts;
  }
}
