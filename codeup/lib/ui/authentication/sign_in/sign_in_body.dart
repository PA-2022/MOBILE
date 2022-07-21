import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/sign_in_field_enum.dart';
import '../../common/custom_colors.dart';
import '../viewModel/sign_in_fields_view_model.dart';
import '../viewModel/soft_keyboard_view_model.dart';
import '../../../utils/extensions.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({Key? key}) : super(key: key);

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final FocusNode _loginFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _pwdVisibilityToggled = false;

  @override
  void dispose() {
    _loginFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textFieldHeight = 80.0;
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
      children: <Widget>[
        _buildEmail(context, inputTextStyle, border, enabledBorder, errorBorder,
            focusedBorder, focusedBorderError, textFieldHeight),
        _buildPassword(context, inputTextStyle, border, enabledBorder,
            errorBorder, focusedBorder, focusedBorderError, textFieldHeight),
      ],
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
      margin: const EdgeInsets.only(top: 36, bottom: 0),
      height: textFieldHeight,
      child: Material(
        //Necessary when rendered in a Cupertino widget
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
            builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
          _updateSignInFocusNodes(signInFieldsVm);
          return TextField(
            showCursor:
                signInFieldsVm.mapSignInFieldFocus[SignInFieldEnum.email],
            readOnly: !softKeyboardVm.isSoftKeyboardOpened,
            focusNode: _loginFocusNode,
            style: inputTextStyle,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => {
              signInFieldsVm.updateMapSignInFieldsFocus(false, false),
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
                      .getSignInFieldError(SignInFieldEnum.email)
                      .isNullOrEmpty()
                  ? null
                  : signInFieldsVm.getSignInFieldError(SignInFieldEnum.email),
              border: mBorder,
              enabledBorder: signInFieldsVm
                      .getSignInFieldError(SignInFieldEnum.email)
                      .isEmptyNonNull()
                  ? mErrorBorder
                  : mEnabledBorder,
              errorBorder: mErrorBorder,
              focusedBorder: signInFieldsVm
                      .getSignInFieldError(SignInFieldEnum.email)
                      .isEmptyNonNull()
                  ? mFocusedBorderError
                  : mFocusedBorder,
            ),
            controller: signInFieldsVm.tLoginController,
            onTap: () {
              signInFieldsVm.updateMapSignInFieldsFocus(true, false);
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
    return SizedBox(
      height: textFieldHeight,
      child: Material(
        //Necessary when rendered in a Cupertino widget
        child: Consumer2<SignInFieldsViewModel, SoftKeyboardViewModel>(
          builder: (ctx, signInFieldsVm, softKeyboardVm, child) {
            _updateSignInFocusNodes(signInFieldsVm);
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
                        .getSignInFieldError(SignInFieldEnum.password)
                        .isNullOrEmpty()
                    ? null
                    : signInFieldsVm
                        .getSignInFieldError(SignInFieldEnum.password),
                hintText: "Password",
                hintStyle: const TextStyle(
                  color: CustomColors.lightGrey1,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: mBorder,
                enabledBorder: signInFieldsVm
                        .getSignInFieldError(SignInFieldEnum.password)
                        .isEmptyNonNull()
                    ? mErrorBorder
                    : mEnabledBorder,
                errorBorder: mErrorBorder,
                focusedBorder: signInFieldsVm
                        .getSignInFieldError(SignInFieldEnum.password)
                        .isEmptyNonNull()
                    ? mFocusedBorderError
                    : mFocusedBorder,
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    signInFieldsVm.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
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
                signInFieldsVm.updateMapSignInFieldsFocus(false, false);

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

  void _updateSignInFocusNodes(SignInFieldsViewModel signInFieldsVm) {
    if (signInFieldsVm.mapSignInFieldFocus[SignInFieldEnum.email] != null &&
        signInFieldsVm.mapSignInFieldFocus[SignInFieldEnum.email]!) {
      _loginFocusNode.requestFocus();
    } else if (signInFieldsVm.mapSignInFieldFocus[SignInFieldEnum.password] !=
            null &&
        signInFieldsVm.mapSignInFieldFocus[SignInFieldEnum.password]!) {
      _passwordFocusNode.requestFocus();
    }
  }
}
