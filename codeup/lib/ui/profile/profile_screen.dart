import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/person.dart';
import '../../services/auth_service.dart';
import '../authentication/viewModel/sign_in_fields_view_model.dart';
import '../authentication/viewModel/soft_keyboard_view_model.dart';
import '../common/custom_colors.dart';
import '../menu/menu.dart';
import 'profile_logged_body.dart';
import 'profile_unlogged_body.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile-screen";
  final bool backOption;
  final Person wantedUser;
  const ProfileScreen(this.wantedUser, this.backOption, {Key? key})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = AuthService.currentUser;
  final SoftKeyboardViewModel _softKeyboardVm = SoftKeyboardViewModel();
  final SignInFieldsViewModel _signInFieldsVm = SignInFieldsViewModel();
  // ignore: non_constant_identifier_names
  final background_color = CustomColors.lightGrey3;

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _firstnameFocusNode = FocusNode();
  final FocusNode _lastnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

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
        return widget.wantedUser == currentUser
            ? ProfileLoggedBody(widget.backOption)
            : ProfileUnLoggedBody(widget.wantedUser, widget.backOption);
      }),
    ));
    return Scaffold(
        backgroundColor: background_color, drawer: const Menu(), body: body);
  }
}
