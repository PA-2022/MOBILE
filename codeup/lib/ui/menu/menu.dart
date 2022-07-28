import 'package:codeup/ui/common/test_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:flutter/material.dart';

import '../../entities/person.dart';
import '../../entities/user.dart';
import '../../services/auth_service.dart';
import '../../services/secure_storage.dart';
import '../authentication/sign_in/sign_in_screen.dart';
import '../authentication/sign_up/sign_up_screen.dart';
import '../common/custom_button.dart';
import '../common/custom_colors.dart';
import '../forums/forums_screen.dart';
import '../friends/friends_screen.dart';
import '../home/home_screen.dart';
import '../post/logged_user_posts_screen.dart';
import '../profile/profile_screen.dart';
import '../saved_posts/saved_posts_screen.dart';
import 'menu_option.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Person? currentUser = AuthService.currentUser;
    return Drawer(
      backgroundColor: Colors.white,
      child: currentUser != null
          ? _loggedMenuOptions(context, currentUser)
          : _unloggedMenuOptions(context),
    );
  }
}

Widget _loggedMenuOptions(BuildContext context, Person currentUser) {
  return FutureBuilder(
    future: AuthService().getUserById(currentUser.user.id),
    builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: GestureDetector(
                onTap: () => _getProfilePage(context, currentUser),
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                                  height: 200,
                                  child: CircleAvatar(
                                    radius:60,
                                    backgroundImage: NetworkImage(snapshot.data != null ? snapshot.data!.profilePictureUrl : dotenv.env["DEFAULT_PP"].toString() 
                                        ),
                                  )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 65.0),
                      child: Align(
                        child: Container(
                          child: const Icon(
                            Icons.edit_outlined,
                            color: CustomColors.darkText,
                            size: 35,
                          ),
                          color: Colors.white,
                        ),
                        alignment: Alignment.bottomRight,
                      ),
                    )
                  ]),
                ),
              )),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              currentUser.user.email,
              style: const TextStyle(fontSize: 15, color: CustomColors.darkText),
            ),
          )),
          MenuOption("Home", Icons.home, () => _getHomePage(context)),
          MenuOption("My Posts", Icons.article,
              () => _getLoggedUserPostsPage(context, AuthService.currentUser!)),
         /*  MenuOption(
              "Saved Posts", Icons.bookmark, () => _getFavoritesPage(context)), */
          MenuOption("Friends", Icons.person, () => _getFriendsPage(context)),
          MenuOption("Forums", Icons.chat_bubble_outline_sharp,
              () => _getForumsPage(context)),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 10, left: 8, right: 8),
            height: 1,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 241, 241, 241)),
          ),
          CustomButton(CustomColors.mainYellow, "Log out", () => _logOut(context))
        ],
      );
    }
  );
}

Widget _unloggedMenuOptions(
  BuildContext context,
) {

  return ListView(
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(color: Colors.white),
        child: SizedBox(
          height: 400,
        ),
      ),
      MenuOption("Home", Icons.home, () => _getHomePage(context)),
      MenuOption("Forums", Icons.chat_bubble_outline_sharp,
          () => _getForumsPage(context)),
      Container(
        margin: const EdgeInsets.only(top: 5, bottom: 10, left: 8, right: 8),
        height: 1,
        width: MediaQuery.of(context).size.width,
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 241, 241, 241)),
      ),
      //MenuOption("Logout", Icons.logout, () => _logOut(context)),
      CustomButton(CustomColors.mainYellow, "Log in", () => _logIn(context)),
      CustomButton(Colors.orange, "Sign up", () => _signUp(context)),
    ],
  );
}

_signUp(BuildContext context) {
  Navigator.of(context).pushNamed(SignUpScreen.routeName);
}

_logIn(BuildContext context) {
  Navigator.of(context).pushNamed(SignInScreen.routeName);
}

_logOut(BuildContext context) async {
  AuthService.setCurrentUser(null);
  await SecureStorageService.getInstance().clear();
  Navigator.of(context).pop();
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
    return const SignInScreen(false);
  }));
}

_getHomePage(BuildContext context) {
  Navigator.of(context).pushNamed(HomeScreen.routeName);
}

_getForumsPage(BuildContext context) {
  Navigator.of(context).pushNamed(ForumsScreen.routeName);
}

_getFavoritesPage(BuildContext context) {
  Navigator.of(context).pushNamed(SavedPostsScreen.routeName);
}

_getFriendsPage(BuildContext context) {
  Navigator.of(context).pushNamed(FriendsScreen.routeName);
}

_getProfilePage(BuildContext context, Person currentUser) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProfileScreen(currentUser, false)));
}

_getLoggedUserPostsPage(BuildContext context, Person currentUser) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => const LoggedUserPostScreen()));
}
