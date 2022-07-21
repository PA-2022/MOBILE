import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../../utils/sign_in_field_enum.dart';


class SignInFieldsViewModel with ChangeNotifier {
  final _logger = new Logger('Sign in');
  TextEditingController _tUsernameController = new TextEditingController();
  TextEditingController _tFirstnameController = new TextEditingController();
  TextEditingController _tLastnameController = new TextEditingController();
  TextEditingController _tLoginController = new TextEditingController();
  TextEditingController _tPasswordController = new TextEditingController();
  Map<SignInFieldEnum, bool> _mapTextFieldFocus = { SignInFieldEnum.email:false, SignInFieldEnum.password:false };
  Map<SignInFieldEnum, String?> _mapTextFieldErrorState = { SignInFieldEnum.email:null, SignInFieldEnum.password:null };
  Map<SignUpFieldEnum, bool> _mapTextSignUpFieldFocus = { SignUpFieldEnum.email:false, SignUpFieldEnum.password:false };
  Map<SignUpFieldEnum, String?> _mapTextSignUpFieldErrorState = { SignUpFieldEnum.email:null, SignUpFieldEnum.password:null };
  bool _pwdShowCursor = false; //default
  bool _isPasswordVisible = false; //default

  TextEditingController get tUsernameController => _tUsernameController;

  TextEditingController get tFirstnameController => _tFirstnameController;

  TextEditingController get tLastnameController => _tLastnameController;

  TextEditingController get tLoginController => _tLoginController;

  TextEditingController get tPasswordController => _tPasswordController;

  Map<SignInFieldEnum, bool> get mapSignInFieldFocus => _mapTextFieldFocus;

  bool get showPwdCursor => _pwdShowCursor;

  bool get isPasswordVisible => _isPasswordVisible;

  String? getSignInFieldError(SignInFieldEnum key) {
    String? res;

    if (_mapTextFieldErrorState.containsKey(key))
      res = _mapTextFieldErrorState[key];
    else
      _logger.shout("Error when accessing sign in field error state: Unknown field " + key.toString());

    return res;
  }

  String? getSignUpFieldError(SignUpFieldEnum key) {
    String? res;

    if (_mapTextFieldErrorState.containsKey(key))
      res = _mapTextFieldErrorState[key];
    else
      _logger.shout("Error when accessing sign in field error state: Unknown field " + key.toString());

    return res;
  }

  set tUsernameController(TextEditingController mUsernameController) {
    _tUsernameController = mUsernameController;
    notifyListeners();
  }

  set tLoginController(TextEditingController mLoginController) {
    _tLoginController = mLoginController;
    notifyListeners();
  }

  set tPasswordController(TextEditingController mPasswordController) {
    _tPasswordController = mPasswordController;
    notifyListeners();
  }

  set tFirstnameController(TextEditingController mFirstnameController) {
    _tFirstnameController = mFirstnameController;
    notifyListeners();
  }

  set tLastnameController(TextEditingController mLastnameController) {
    _tLastnameController = mLastnameController;
    notifyListeners();
  }

  set showPwdCursor(bool pwdShowCursor) {
    _pwdShowCursor = pwdShowCursor;
    notifyListeners();
  }

  set isPasswordVisible(bool isPasswordVisible) {
    _isPasswordVisible = isPasswordVisible;
    notifyListeners();
  }

  void setSignInFieldErrorState(SignInFieldEnum key, String? errorMessage) {
    if (_mapTextFieldErrorState.containsKey(key)) {
        _mapTextFieldErrorState[key] = errorMessage;
        notifyListeners();

    } else {
      _logger.shout("Error when updating sign in field error state: Unknown field " + key.toString());
    }
  }

   void setSignUpFieldErrorState(SignUpFieldEnum key, String? errorMessage) {
    if (_mapTextSignUpFieldErrorState.containsKey(key)) {
        _mapTextSignUpFieldErrorState[key] = errorMessage;
        notifyListeners();

    } else {
      _logger.shout("Error when updating sign in field error state: Unknown field " + key.toString());
    }
  }

  void _resetMapTextFieldsFocus() {
    _mapTextFieldFocus.keys.forEach((key) {
      _mapTextFieldFocus[key] = false;
    });

    notifyListeners();
  }

  void updateMapSignInFieldsFocus( bool isEmailFocused, bool isNoneFocused) {
    if (isNoneFocused) {
      _resetMapTextFieldsFocus();

    } else {
      _mapTextFieldFocus[SignInFieldEnum.email] = isEmailFocused;
      _mapTextFieldFocus[SignInFieldEnum.password] = !isEmailFocused;
      notifyListeners();
    }
  }

  void updateMapSignUpFieldsFocus(bool isUsernameFocused, bool isFirstnameFocused, bool isLastnameFocused, bool isEmailFocused, bool isNoneFocused) {
    if (isNoneFocused) {
      _resetMapTextFieldsFocus();

    } else {
      _mapTextSignUpFieldFocus[SignUpFieldEnum.username] = isUsernameFocused;
      _mapTextSignUpFieldFocus[SignUpFieldEnum.firstname] = isFirstnameFocused;
      _mapTextSignUpFieldFocus[SignUpFieldEnum.lastname] = isLastnameFocused;
      _mapTextSignUpFieldFocus[SignUpFieldEnum.email] = isEmailFocused;
      _mapTextSignUpFieldFocus[SignUpFieldEnum.password] = !isEmailFocused && !isFirstnameFocused && !isLastnameFocused && !isUsernameFocused;
      notifyListeners();
    }
  }
}