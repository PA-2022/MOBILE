import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import 'entities/person.dart';
import 'services/auth_service.dart';
import 'ui/authentication/sign_in/sign_in_screen.dart';
import 'ui/authentication/sign_up/sign_up_screen.dart';
import 'ui/common/custom_colors.dart';
import 'ui/forums/create_forum_screen.dart';
import 'ui/forums/forums_screen.dart';
import 'ui/friends/friends_screen.dart';
import 'ui/home/home_screen.dart';
import 'ui/post/create_post_screen.dart';
import 'ui/profile/profile_screen.dart';
import 'ui/saved_posts/saved_posts_screen.dart';

//TODO:
/*


Recherche amis

Pull to refresh posts/forums
*/

void main() async {
  await dotenv.load();
  runApp(MyApp("sign-in"));
}

class MyApp extends StatelessWidget {
  final String launchRoute;
  Person? currentUser = AuthService.currentUser;

  MyApp(this.launchRoute, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CodeUp',
        theme: ThemeData(
          primarySwatch: CustomColors.darkText,
          secondaryHeaderColor: CustomColors.mainYellow,
        ),
        home: const HomeScreen(),
        initialRoute: launchRoute,
        routes: {
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          SignInScreen.routeName: (ctx) => const SignInScreen(false),
          SignUpScreen.routeName: (ctx) => const SignUpScreen(),
          ForumsScreen.routeName: (ctx) => const ForumsScreen(),
          FriendsScreen.routeName: (ctx) => const FriendsScreen(),
          SavedPostsScreen.routeName: (ctx) => const SavedPostsScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(currentUser!, true),
          CreatePostScreen.routeName: (ctx) => const CreatePostScreen(),
          CreateForumScreen.routeName: (ctx) => const CreateForumScreen()
        });
  }
}
