import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/person.dart';
import '../../entities/user.dart';
import '../../services/auth_service.dart';
import '../../utils/sign_in_field_enum.dart';
import '../authentication/viewModel/sign_in_fields_view_model.dart';
import '../authentication/viewModel/soft_keyboard_view_model.dart';
import '../common/custom_app_bar.dart';
import '../common/custom_button.dart';
import '../common/custom_colors.dart';
import '../menu/menu.dart';
import '../../../utils/extensions.dart';
import 'profile_screen.dart';

class ProfileLoggedBody extends StatefulWidget {
  static const routeName = "/profile-screen";
  final bool backOption;
  const ProfileLoggedBody(this.backOption, {Key? key}) : super(key: key);

  @override
  State<ProfileLoggedBody> createState() => _ProfileLoggedBodyState();
}

class _ProfileLoggedBodyState extends State<ProfileLoggedBody> {
  var currentUser = AuthService.currentUser;
  AuthService authService = AuthService();

  final SoftKeyboardViewModel _softKeyboardVm = SoftKeyboardViewModel();
  final SignInFieldsViewModel _signInFieldsVm = SignInFieldsViewModel();
  // ignore: non_constant_identifier_names
  final background_color = CustomColors.lightGrey3;

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _firstnameFocusNode = FocusNode();
  final FocusNode _lastnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void initState() {
    _signInFieldsVm.tFirstnameController.text = currentUser!.user.firstname;
    _signInFieldsVm.tLastnameController.text = currentUser!.user.lastname;
    _signInFieldsVm.tLoginController.text = currentUser!.user.email;
    _signInFieldsVm.tUsernameController.text = currentUser!.user.username;
    super.initState();
  }

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
    final inputTextStyle = Theme.of(context).textTheme.bodyText1!;

    const InputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
      ),
      borderRadius: BorderRadius.all(Radius.circular(6)),
    );

    const InputBorder enabledBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: CustomColors.defaultGrey),
      borderRadius: BorderRadius.all(Radius.circular(6)),
    );

    const InputBorder errorBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.red),
      borderRadius: BorderRadius.all(Radius.circular(6)),
    );

    InputBorder focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(6)),
    );

    InputBorder focusedBorderError = const OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.redAccent,
      ),
      borderRadius: BorderRadius.all(Radius.circular(6)),
    );
    return CustomScrollView(
      slivers: [
        CustomAppBar("My Profile", false, null),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.network(
                      currentUser!.user.profilePictureUrl,
                      height: 120,
                    ),
                  ),
                  const Text("Username"),
                  _buildUsername(
                      context,
                      inputTextStyle,
                      border,
                      enabledBorder,
                      errorBorder,
                      focusedBorder,
                      focusedBorderError,
                      textFieldHeight),
                  const Text("Firstname"),
                  _buildFirstname(
                      context,
                      inputTextStyle,
                      border,
                      enabledBorder,
                      errorBorder,
                      focusedBorder,
                      focusedBorderError,
                      textFieldHeight),
                  const Text("Lastname"),
                  _buildLastname(
                      context,
                      inputTextStyle,
                      border,
                      enabledBorder,
                      errorBorder,
                      focusedBorder,
                      focusedBorderError,
                      textFieldHeight),
                  const Text("Email"),
                  _buildEmail(
                      context,
                      inputTextStyle,
                      border,
                      enabledBorder,
                      errorBorder,
                      focusedBorder,
                      focusedBorderError,
                      textFieldHeight),
                  CustomButton(CustomColors.mainYellow, "Update my account",
                      () => _updateProfile())
                ],
              ),
            )
          ]),
        ),
      ],
    );
  }

  Widget _buildUsername(
      BuildContext context,
      TextStyle inputTextStyle,
      InputBorder mBorder,
      InputBorder mEnabledBorder,
      InputBorder mErrorBorder,
      InputBorder mFocusedBorder,
      InputBorder mFocusedBorderError,
      double textFieldHeight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: textFieldHeight,
      child: Material(
        //Necessary when rendered in a Cupertino widget
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignInFocusNodes(signInFieldsVm);
          return TextField(
            showCursor:
                signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.username],
            readOnly: !softKeyboardVm.isSoftKeyboardOpened,
            focusNode: _usernameFocusNode,
            style: inputTextStyle,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => {
              signInFieldsVm.updateMapSignUpFieldsFocus(
                  false, false, false, false, false),
              signInFieldsVm.showPwdCursor = true,
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15.0),
              hintStyle: const TextStyle(
                color: CustomColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              errorText: signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.username)
                      .isNullOrEmpty()
                  ? null
                  : signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.username),
              border: mBorder,
              enabledBorder: signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.username)
                      .isEmptyNonNull()
                  ? mErrorBorder
                  : mEnabledBorder,
              errorBorder: mErrorBorder,
              focusedBorder: signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.username)
                      .isEmptyNonNull()
                  ? mFocusedBorderError
                  : mFocusedBorder,
            ),
            controller: signInFieldsVm.tUsernameController,
            onTap: () {
              signInFieldsVm.updateMapSignUpFieldsFocus(
                  true, false, false, false, false);
              signInFieldsVm.showPwdCursor = false;

              if (!softKeyboardVm.isSoftKeyboardOpened) {
                softKeyboardVm.isSoftKeyboardOpened = true;
              }
            },
          );
        }),
      ),
    );
  }

  Widget _buildFirstname(
      BuildContext context,
      TextStyle inputTextStyle,
      InputBorder mBorder,
      InputBorder mEnabledBorder,
      InputBorder mErrorBorder,
      InputBorder mFocusedBorder,
      InputBorder mFocusedBorderError,
      double textFieldHeight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: textFieldHeight,
      child: Material(
        //Necessary when rendered in a Cupertino widget
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignInFocusNodes(signInFieldsVm);
          return TextField(
            showCursor:
                signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.firstname],
            readOnly: !softKeyboardVm.isSoftKeyboardOpened,
            focusNode: _firstnameFocusNode,
            style: inputTextStyle,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => {
              signInFieldsVm.updateMapSignUpFieldsFocus(
                  false, false, false, false, false),
              signInFieldsVm.showPwdCursor = true,
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15.0),
              hintStyle: const TextStyle(
                color: CustomColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              errorText: signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.firstname)
                      .isNullOrEmpty()
                  ? null
                  : signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.firstname),
              border: mBorder,
              enabledBorder: signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.firstname)
                      .isEmptyNonNull()
                  ? mErrorBorder
                  : mEnabledBorder,
              errorBorder: mErrorBorder,
              focusedBorder: signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.firstname)
                      .isEmptyNonNull()
                  ? mFocusedBorderError
                  : mFocusedBorder,
            ),
            controller: signInFieldsVm.tFirstnameController,
            onTap: () {
              signInFieldsVm.updateMapSignUpFieldsFocus(
                  false, true, false, false, false);
              signInFieldsVm.showPwdCursor = false;

              if (!softKeyboardVm.isSoftKeyboardOpened) {
                softKeyboardVm.isSoftKeyboardOpened = true;
              }
            },
          );
        }),
      ),
    );
  }

  Widget _buildLastname(
      BuildContext context,
      TextStyle inputTextStyle,
      InputBorder mBorder,
      InputBorder mEnabledBorder,
      InputBorder mErrorBorder,
      InputBorder mFocusedBorder,
      InputBorder mFocusedBorderError,
      double textFieldHeight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: textFieldHeight,
      child: Material(
        //Necessary when rendered in a Cupertino widget
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignInFocusNodes(signInFieldsVm);
          return TextField(
            showCursor:
                signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.lastname],
            readOnly: !softKeyboardVm.isSoftKeyboardOpened,
            focusNode: _lastnameFocusNode,
            style: inputTextStyle,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => {
              signInFieldsVm.updateMapSignUpFieldsFocus(
                  false, false, false, false, false),
              signInFieldsVm.showPwdCursor = true,
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15.0),
              hintStyle: const TextStyle(
                color: CustomColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              errorText: signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.lastname)
                      .isNullOrEmpty()
                  ? null
                  : signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.lastname),
              border: mBorder,
              enabledBorder: signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.lastname)
                      .isEmptyNonNull()
                  ? mErrorBorder
                  : mEnabledBorder,
              errorBorder: mErrorBorder,
              focusedBorder: signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.lastname)
                      .isEmptyNonNull()
                  ? mFocusedBorderError
                  : mFocusedBorder,
            ),
            controller: signInFieldsVm.tLastnameController,
            onTap: () {
              signInFieldsVm.updateMapSignUpFieldsFocus(
                  false, false, true, false, false);
              signInFieldsVm.showPwdCursor = false;

              if (!softKeyboardVm.isSoftKeyboardOpened) {
                softKeyboardVm.isSoftKeyboardOpened = true;
              }
            },
          );
        }),
      ),
    );
  }

  Widget _buildEmail(
      BuildContext context,
      TextStyle inputTextStyle,
      InputBorder mBorder,
      InputBorder mEnabledBorder,
      InputBorder mErrorBorder,
      InputBorder mFocusedBorder,
      InputBorder mFocusedBorderError,
      double textFieldHeight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: textFieldHeight,
      child: Material(
        //Necessary when rendered in a Cupertino widget
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignInFocusNodes(signInFieldsVm);
          return TextField(
            showCursor:
                signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.email],
            readOnly: !softKeyboardVm.isSoftKeyboardOpened,
            focusNode: _emailFocusNode,
            style: inputTextStyle,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => {
              signInFieldsVm.updateMapSignUpFieldsFocus(
                  false, false, false, false, false),
              signInFieldsVm.showPwdCursor = true,
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15.0),
              hintStyle: const TextStyle(
                color: CustomColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              errorText: signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.email)
                      .isNullOrEmpty()
                  ? null
                  : signInFieldsVm.getSignUpFieldError(SignUpFieldEnum.email),
              border: mBorder,
              enabledBorder: signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.email)
                      .isEmptyNonNull()
                  ? mErrorBorder
                  : mEnabledBorder,
              errorBorder: mErrorBorder,
              focusedBorder: signInFieldsVm
                      .getSignUpFieldError(SignUpFieldEnum.email)
                      .isEmptyNonNull()
                  ? mFocusedBorderError
                  : mFocusedBorder,
            ),
            controller: signInFieldsVm.tLoginController,
            onTap: () {
              signInFieldsVm.updateMapSignUpFieldsFocus(
                  false, false, false, true, false);
              signInFieldsVm.showPwdCursor = false;

              if (!softKeyboardVm.isSoftKeyboardOpened) {
                softKeyboardVm.isSoftKeyboardOpened = true;
              }
            },
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

  _updateProfile() async {
    User userUpdated = User(
        currentUser!.user.id,
        _signInFieldsVm.tLoginController.text,
        currentUser!.user.password,
        _signInFieldsVm.tUsernameController.text,
        _signInFieldsVm.tFirstnameController.text,
        _signInFieldsVm.tLastnameController.text,
        currentUser!.user.profilePictureUrl,
        currentUser!.user.profilePictureName
        );

    print(userUpdated.id.toString() +
        " " +
        userUpdated.email +
        " " +
        userUpdated.password +
        " " +
        userUpdated.username +
        " " +
        userUpdated.firstname +
        " " +
        userUpdated.lastname);

    final response =
        await authService.updateAccount(_signInFieldsVm, userUpdated);

    if (response.statusCode == 200 || response.statusCode == 201) {
      {
        AuthService.setCurrentUser(Person(userUpdated, currentUser!.user.profilePictureUrl));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProfileScreen(AuthService.currentUser!, false)));
        const snackBar = SnackBar(
          content: Text('Changes have been saved'),
          backgroundColor: CustomColors.orange,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
