import 'dart:io';

import 'package:codeup/ui/common/gallery_item.dart';
import 'package:codeup/ui/common/image_picker_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../entities/user.dart';
import '../../../services/auth_service.dart';
import '../../../utils/sign_in_field_enum.dart';
import '../../common/custom_colors.dart';
import '../../common/adaptive_button.dart';
import '../sign_in/sign_in_screen.dart';
import '../viewModel/sign_in_fields_view_model.dart';
import '../viewModel/soft_keyboard_view_model.dart';

class SignUpBottom extends StatefulWidget {
  final AuthService authService;
  final BuildContext ancestorContext;

  const SignUpBottom(
      {Key? key, required this.ancestorContext, required this.authService})
      : super(key: key);

  @override
  _SignUpBottomState createState() => _SignUpBottomState();
}

class _SignUpBottomState extends State<SignUpBottom> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildSignUp(context),
          Padding(
            padding: const EdgeInsets.only(left: 80.0),
            child: Row(
              children: [
                Text(
                  "Already have an account ? ",
                  style: theme.textTheme.button?.copyWith(
                    color: CustomColors.darkGrey3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                    onPressed: _logIn,
                    child: Text(
                      "Log in",
                      style: theme.textTheme.button?.copyWith(
                        color: CustomColors.mainYellow,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    )),
              ],
            ),
          ),
        ]);
  }

  Widget _buildSignUp(BuildContext context) {
    final signInFieldsProperties =
        Provider.of<SignInFieldsViewModel>(context, listen: false);
    final buttonWidth = MediaQuery.of(context).size.width * 0.5;

    return Container(
      margin: const EdgeInsets.only(top: 24),
      width: buttonWidth,
      child: AdaptiveButton(
        type: ButtonType.primary,
        btnLabel: "Create an account",
        btnWidth: buttonWidth,
        btnHandler: () {
          _submitAuthentication(signInFieldsProperties);
        },
      ),
    );
  }

  bool _isFieldNotNullOrEmptyOrBlank(
      SignUpFieldEnum signInField, SignInFieldsViewModel signInFieldsVm) {
    final TextEditingController tController =
        (signInField == SignInFieldEnum.email)
            ? signInFieldsVm.tLoginController
            : signInFieldsVm.tPasswordController;
    bool isNotNullOrEmpty = false;

    if (tController.text.isNotEmpty && tController.text.trim().isNotEmpty) {
      isNotNullOrEmpty = true;
      signInFieldsVm.setSignUpFieldErrorState(signInField, null);
    } else {
      signInFieldsVm.setSignUpFieldErrorState(
          signInField, _getSignUpErrorMessage(signInField));
    }

    return isNotNullOrEmpty;
  }

  String? _getSignUpErrorMessage(SignUpFieldEnum signInField) {
    switch (signInField) {
      case SignUpFieldEnum.firstname:
        return "Empty firstname";

      case SignUpFieldEnum.lastname:
        return "Empty lastname";

      case SignUpFieldEnum.email:
        return "Empty email";

      case SignUpFieldEnum.password:
        return "Empty password";

      default:
        return null;
    }
  }

  bool _validateSignUpFields(SignInFieldsViewModel signInFieldsVm) {
    bool res = false;

    res = _isFieldNotNullOrEmptyOrBlank(SignUpFieldEnum.email, signInFieldsVm);
    res = _isFieldNotNullOrEmptyOrBlank(
            SignUpFieldEnum.password, signInFieldsVm) &&
        res;
    res = _isFieldNotNullOrEmptyOrBlank(
            SignUpFieldEnum.username, signInFieldsVm) &&
        res;
    res = _isFieldNotNullOrEmptyOrBlank(
            SignUpFieldEnum.firstname, signInFieldsVm) &&
        res;
    res = _isFieldNotNullOrEmptyOrBlank(
            SignUpFieldEnum.lastname, signInFieldsVm) &&
        res;

    return res;
  }

  void _submitAuthentication(SignInFieldsViewModel signInFieldsVm) async {
    //AuthService.photo = widget.photos[0].name;
    final user = User(
        -1,
        signInFieldsVm.tLoginController.text,
        signInFieldsVm.tPasswordController.text,
        signInFieldsVm.tUsernameController.text,
        signInFieldsVm.tFirstnameController.text,
        signInFieldsVm.tLastnameController.text,
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png",
        ""
        );


    if (_validateSignUpFields(signInFieldsVm)) {
      final response = await widget.authService.register(signInFieldsVm, user);

      if (response.statusCode == 200 || response.statusCode == 201) {
        //widget.authService.logIn(signInFieldsVm, user);

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return const SignInScreen(false);
        }));
      } else {
        signInFieldsVm.setSignUpFieldErrorState(SignUpFieldEnum.username, "");
        signInFieldsVm.setSignUpFieldErrorState(SignUpFieldEnum.email, "");
        signInFieldsVm.setSignUpFieldErrorState(SignUpFieldEnum.password, "");
        signInFieldsVm.setSignUpFieldErrorState(SignUpFieldEnum.firstname, "");
        signInFieldsVm.setSignUpFieldErrorState(SignUpFieldEnum.lastname, "");

        const snackBar = SnackBar(
          content: Text('Email or Username already token'),
          backgroundColor: CustomColors.redText,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void _logIn() {
    final softKeyboardVm =
        Provider.of<SoftKeyboardViewModel>(context, listen: false);
    softKeyboardVm.isSoftKeyboardOpened = false;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return const SignInScreen(true);
    }));
  }
}
