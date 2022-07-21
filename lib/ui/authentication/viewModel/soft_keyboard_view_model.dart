import 'package:flutter/material.dart';

class SoftKeyboardViewModel with ChangeNotifier{
  bool _isSoftKeyboardOpened = false; //default

  bool get isSoftKeyboardOpened => _isSoftKeyboardOpened;

  set isSoftKeyboardOpened(bool isSoftKeyboardOpened) {
    _isSoftKeyboardOpened = isSoftKeyboardOpened;
    notifyListeners();
  }
}