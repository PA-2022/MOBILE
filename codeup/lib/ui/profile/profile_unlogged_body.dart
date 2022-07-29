import 'package:codeup/services/auth_service.dart';
import 'package:codeup/services/friends_service.dart';
import 'package:codeup/ui/friends/friends_screen.dart';
import 'package:codeup/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/person.dart';
import '../../utils/sign_in_field_enum.dart';
import '../authentication/viewModel/sign_in_fields_view_model.dart';
import '../authentication/viewModel/soft_keyboard_view_model.dart';
import '../common/custom_app_bar.dart';
import '../common/custom_button.dart';
import '../common/custom_colors.dart';
import '../friends/friends_list_item.dart';
import '../friends/viewModel/friend_view_model.dart';
import '../menu/menu.dart';

class ProfileUnLoggedBody extends StatefulWidget {
  static const routeName = "/profile-screen";

  final bool backOption;
  final Person wantedUser;
  const ProfileUnLoggedBody(this.wantedUser, this.backOption, {Key? key})
      : super(key: key);

  @override
  State<ProfileUnLoggedBody> createState() => _ProfileUnLoggedBodyState();
}

class _ProfileUnLoggedBodyState extends State<ProfileUnLoggedBody> {
  final SoftKeyboardViewModel _softKeyboardVm = SoftKeyboardViewModel();
  final SignInFieldsViewModel _signInFieldsVm = SignInFieldsViewModel();
  final FriendService friendService = FriendService();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _firstnameFocusNode = FocusNode();
  final FocusNode _lastnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  // ignore: non_constant_identifier_names
  final background_color = CustomColors.white;

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _firstnameFocusNode.dispose();
    _lastnameFocusNode.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
        child: MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInFieldsViewModel>(
            create: (_) => _signInFieldsVm),
        ChangeNotifierProvider<SoftKeyboardViewModel>(
            create: (_) => _softKeyboardVm),
      ],
      child: Consumer<SoftKeyboardViewModel>(
          builder: (context, softKeyBoardVm, child) {
        return _getBody();
      }),
    ));
    return Scaffold(
        backgroundColor: background_color,
        drawer: !widget.backOption ? const Menu() : null,
        body: body);
  }

  Widget _getBody() {
    const textFieldHeight = 50.0;

    return CustomScrollView(
      slivers: [
        CustomAppBar(
            widget.wantedUser.user.firstname +
                " " +
                widget.wantedUser.user.lastname,
            false,
            null),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: FutureBuilder(
                  future: FriendViewModel().fetchFriendsOfUser(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<FriendsListItem>> snapshot) {
                    return FutureBuilder(
                        future: FriendViewModel()
                            .isAFriend(widget.wantedUser.user.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> isAFriend) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.network(
                                  widget.wantedUser.user.profilePictureUrl,
                                  height: 120,
                                ),
                              ),
                              const Text("Username"),
                              _buildUsername(textFieldHeight),
                              const Text("Firstname"),
                              _buildFirstname(textFieldHeight),
                              const Text("Lastname"),
                              _buildLastname(textFieldHeight),
                              const Text("Email"),
                              _buildEmail(textFieldHeight),
                              if (snapshot.data != null && isAFriend != null)
                                _getAction(isAFriend.data!, snapshot.data!)
                            ],
                          );
                        });
                  }),
            )
          ]),
        ),
      ],
    );
  }

  Widget _buildUsername(double textFieldHeight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: textFieldHeight,
      child: Material(
        //Necessary when rendered in a Cupertino widget
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignInFocusNodes(signInFieldsVm);
          return TextField(
            enabled: false,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15.0),
              hintText: widget.wantedUser.user.username,
              hintStyle: const TextStyle(
                color: CustomColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFirstname(double textFieldHeight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: textFieldHeight,
      child: Material(
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignInFocusNodes(signInFieldsVm);
          return TextField(
            enabled: false,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15.0),
              hintText: widget.wantedUser.user.firstname,
              hintStyle: const TextStyle(
                color: CustomColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLastname(double textFieldHeight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: textFieldHeight,
      child: Material(
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignInFocusNodes(signInFieldsVm);
          return TextField(
            enabled: false,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15.0),
              hintText: widget.wantedUser.user.lastname,
              hintStyle: const TextStyle(
                color: CustomColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmail(double textFieldHeight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: textFieldHeight,
      child: Material(
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignInFocusNodes(signInFieldsVm);
          return TextField(
            enabled: false,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15.0),
              hintText: widget.wantedUser.user.email,
              hintStyle: const TextStyle(
                color: CustomColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }),
      ),
    );
  }

  void _updateSignInFocusNodes(SignInFieldsViewModel signInFieldsVm) {
    if (signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.email] != null &&
        signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.email]!) {
      _emailFocusNode.requestFocus();
    } else if (signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.firstname] !=
            null &&
        signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.firstname]!) {
      _firstnameFocusNode.requestFocus();
    } else if (signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.username] !=
            null &&
        signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.username]!) {
      _firstnameFocusNode.requestFocus();
    } else if (signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.lastname] !=
            null &&
        signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.lastname]!) {
      _lastnameFocusNode.requestFocus();
    }
  }

  Widget _getAction(bool isAfriend, List<FriendsListItem> friends) {
    if (friends.map((e) => e.userAndFriend.user.id).contains(widget.wantedUser.user.id)) {
      
      if (friends
          .firstWhere(
              (e) => e.userAndFriend.user.id == widget.wantedUser.user.id)
          .userAndFriend
          .friend
          .is_accepted) {
            
        return Padding(
          padding: const EdgeInsets.only(right: 17.0, top: 25),
          child: Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.person_add,
                  color: CustomColors.redText,
                  size: 19,
                ),
                TextButton(
                    onPressed: () => _deleteFriend(),
                    child: const Text(
                      "Delete friend",
                      style: TextStyle(
                          color: CustomColors.redText, fontSize: 15),
                    )),
              ],
            ),
          ),
        );
      } else {

        if(friends.firstWhere((element) => element.userAndFriend.user.id == widget.wantedUser.user.id).userAndFriend.friend.user_id == AuthService.currentUser!.user.id) {
          return Padding(
          padding:  EdgeInsets.only(right: 17.0, top: 25),
          child: Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:  EdgeInsets.only(right:8.0),
                  child:  Icon(
                    Icons.timer_rounded,
                    color: CustomColors.darkText,
                    size: 19,
                  ),
                ),
                Text("Request sent", style: TextStyle(fontSize: 16),)
              ],
            ),
          ),
        );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(CustomColors.mainYellow, "Accept", ()=> _acceptAfriend()),
            ],
          );
        }

        
      }
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 17.0, top: 25),
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.person_add,
                color: CustomColors.mainYellow,
                size: 19,
              ),
              TextButton(
                  onPressed: () => _addAfriend(),
                  child: const Text(
                    "Add as friend",
                    style:
                        TextStyle(color: CustomColors.mainYellow, fontSize: 15),
                  )),
            ],
          ),
        ),
      );
    }
  }

  _deleteFriend() async {
    final response =
        await friendService.deleteFriend(widget.wantedUser.user.id.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => FriendsScreen()));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => ProfileUnLoggedBody(widget.wantedUser, true)));
    }
  }

  _addAfriend() async {
    final response = await friendService.addFriend(widget.wantedUser.user.id);
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {});
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => FriendsScreen()));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => ProfileUnLoggedBody(widget.wantedUser, true)));
    }
  }

   _acceptAfriend() async {
 final response = await friendService.acceptFriend(widget.wantedUser.user.id);
    if(response.statusCode == 200 || response.statusCode == 201) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) =>FriendsScreen()));
  
    }
  }
}
