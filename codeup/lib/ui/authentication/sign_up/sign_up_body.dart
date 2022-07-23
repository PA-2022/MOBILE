import 'package:codeup/ui/common/image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/auth_service.dart';
import '../../../utils/sign_in_field_enum.dart';
import '../../common/custom_colors.dart';
import '../viewModel/sign_in_fields_view_model.dart';
import '../viewModel/soft_keyboard_view_model.dart';
import '../../../utils/extensions.dart';
import 'sign_up_bottom.dart';

class SignUpBody extends StatefulWidget {
  final ImagePickerWidget imagePickerWidget;
  const SignUpBody(this.imagePickerWidget, {Key? key}) : super(key: key);

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _firstnameFocusNode = FocusNode();
  final FocusNode _lastnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _pwdVisibilityToggled = false;

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _firstnameFocusNode.dispose();
    _lastnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[widget.imagePickerWidget,
        _buildUsername(context, inputTextStyle, border, enabledBorder,
            errorBorder, focusedBorder, focusedBorderError, textFieldHeight),
        _buildFirstname(context, inputTextStyle, border, enabledBorder,
            errorBorder, focusedBorder, focusedBorderError, textFieldHeight),
        _buildLastname(context, inputTextStyle, border, enabledBorder,
            errorBorder, focusedBorder, focusedBorderError, textFieldHeight),
        _buildEmail(context, inputTextStyle, border, enabledBorder, errorBorder,
            focusedBorder, focusedBorderError, textFieldHeight),
        _buildPassword(context, inputTextStyle, border, enabledBorder,
            errorBorder, focusedBorder, focusedBorderError, textFieldHeight),
            SignUpBottom(ancestorContext: context, authService: AuthService(signInFieldsVm: SignInFieldsViewModel()), photos : widget.imagePickerWidget.galleryItems)
                
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
      margin: const EdgeInsets.only(top: 24),
      height: textFieldHeight,
      child: Material(
        //Necessary when rendered in a Cupertino widget
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignUpFocusNodes(signInFieldsVm);
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
              hintText: "Username",
              hintStyle: const TextStyle(
                color: CustomColors.lightGrey1,
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
      margin: const EdgeInsets.only(top: 24),
      height: textFieldHeight,
      child: Material(
        //Necessary when rendered in a Cupertino widget
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignUpFocusNodes(signInFieldsVm);
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
              hintText: "Firstname",
              hintStyle: const TextStyle(
                color: CustomColors.lightGrey1,
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
      margin: const EdgeInsets.only(top: 24),
      height: textFieldHeight,
      child: Material(
        //Necessary when rendered in a Cupertino widget
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignUpFocusNodes(signInFieldsVm);
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
              hintText: "Lastname",
              hintStyle: const TextStyle(
                color: CustomColors.lightGrey1,
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
      margin: const EdgeInsets.only(top: 24),
      height: textFieldHeight,
      child: Material(
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignUpFocusNodes(signInFieldsVm);
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
              hintText: "Email",
              hintStyle: const TextStyle(
                color: CustomColors.lightGrey1,
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

  Widget _buildPassword(
      BuildContext context,
      TextStyle inputTextStyle,
      InputBorder mBorder,
      InputBorder mEnabledBorder,
      InputBorder mErrorBorder,
      InputBorder mFocusedBorder,
      InputBorder mFocusedBorderError,
      double textFieldHeight) {
    return Container(
      height: textFieldHeight,
      margin: const EdgeInsets.only(top: 24),
      child: Material(
        //Necessary when rendered in a Cupertino widget
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
          builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
            _updateSignUpFocusNodes(signInFieldsVm);
            return TextField(
              textAlignVertical: TextAlignVertical.center,
              showCursor: signInFieldsVm.showPwdCursor,
              readOnly: !softKeyboardVm.isSoftKeyboardOpened,
              focusNode: _passwordFocusNode,
              obscureText: !signInFieldsVm.isPasswordVisible,
              style: inputTextStyle,
              textInputAction: TextInputAction
                  .done, //Login request logic is handled via the custom sign in button widget
              onSubmitted: (value) {
                softKeyboardVm.isSoftKeyboardOpened = false;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 15.0),
                errorText: signInFieldsVm
                        .getSignUpFieldError(SignUpFieldEnum.password)
                        .isNullOrEmpty()
                    ? null
                    : signInFieldsVm
                        .getSignUpFieldError(SignUpFieldEnum.password),
                hintText: "Password",
                hintStyle: const TextStyle(
                  color: CustomColors.lightGrey1,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: mBorder,
                enabledBorder: signInFieldsVm
                        .getSignUpFieldError(SignUpFieldEnum.password)
                        .isEmptyNonNull()
                    ? mErrorBorder
                    : mEnabledBorder,
                errorBorder: mErrorBorder,
                focusedBorder: signInFieldsVm
                        .getSignUpFieldError(SignUpFieldEnum.password)
                        .isEmptyNonNull()
                    ? mFocusedBorderError
                    : mFocusedBorder,
                suffixIcon: IconButton(
                  icon: Icon(
                    signInFieldsVm.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _pwdVisibilityToggled = true;
                      signInFieldsVm.isPasswordVisible =
                          !signInFieldsVm.isPasswordVisible;
                    });
                  },
                ),
              ),
              controller: signInFieldsVm.tPasswordController,
              onTap: () {
                bool isCursorShown = signInFieldsVm.showPwdCursor;
                signInFieldsVm.updateMapSignUpFieldsFocus(
                    false, false, false, false, false);

                if (!_pwdVisibilityToggled) {
                  signInFieldsVm.showPwdCursor = true;

                  if (!softKeyboardVm.isSoftKeyboardOpened) {
                    softKeyboardVm.isSoftKeyboardOpened = true;
                  }
                } else {
                  setState(() {
                    _pwdVisibilityToggled = false; //Reset
                  });

                  signInFieldsVm.showPwdCursor = isCursorShown;
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _updateSignUpFocusNodes(SignInFieldsViewModel signInFieldsVm) {
    if (signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.email] != null &&
        signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.email]!) {
      _emailFocusNode.requestFocus();
    } else if (signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.password] !=
            null &&
        signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.password]!) {
      _passwordFocusNode.requestFocus();
    } else if (signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.password] !=
            null &&
        signInFieldsVm.mapSignInFieldFocus[SignUpFieldEnum.password]!) {
      _passwordFocusNode.requestFocus();
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
}
