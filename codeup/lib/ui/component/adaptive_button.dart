import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/sign_in_state_enum.dart';
import '../../utils/pair.dart';
import '../common/custom_colors.dart';

enum ButtonType { primary, secondary }

class AdaptiveButton extends StatelessWidget {
  final String btnLabel;
  final double btnWidth;
  final SignInState signInState;
  final ButtonType type;

  final void Function() btnHandler;

  const AdaptiveButton(
      {Key? key,
      required this.type,
      required this.btnLabel,
      required this.btnWidth,
      required this.btnHandler,
      this.signInState = SignInState.signedOut})
      : assert((type != ButtonType.primary)
            ? signInState == SignInState.signedOut
            : true),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadiusBtn = BorderRadius.circular(2.0);

    const processingIcon = SizedBox(
      width: 15,
      height: 15,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2.0,
      ),
    );

    final btnColors = _getBtnColors(context);

    final mBtnHandler = (signInState == SignInState.processing ||
            signInState == SignInState.signedIn)
        ? null
        : btnHandler;

    final btnText = Text(
      btnLabel,
      style: Theme.of(context)
          .textTheme
          .button
          ?.merge(TextStyle(color: btnColors.second)),
      overflow: TextOverflow.ellipsis,
    );

    final btnSubChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                right: (signInState == SignInState.processing) ? 15 : 0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: (signInState == SignInState.processing)
                      ? btnWidth * 0.6
                      : btnWidth),
              child: btnText,
            ),
          ),
          if (signInState == SignInState.processing)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: btnWidth * 0.2),
              child: processingIcon,
            ),
        ]);

    final androidBtn = ElevatedButton(
      style: ButtonStyle(
        overlayColor: (type == ButtonType.secondary)
            ? MaterialStateProperty.resolveWith(
                (states) {
                  return states.contains(MaterialState.pressed)
                      ? CustomColors.whiteOpacity40
                      : null;
                },
              )
            : null,
        elevation: type != ButtonType.primary
            ? MaterialStateProperty.all<double>(0.0)
            : null,
        backgroundColor: MaterialStateProperty.all<Color>(btnColors.first),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: borderRadiusBtn,
            side: type == ButtonType.secondary
                ? const BorderSide(
                    color: CustomColors.mainYellow,
                  )
                : BorderSide.none,
          ),
        ),
      ),
      child: btnSubChild,
      onPressed: mBtnHandler,
    );

    final iosBtn = GestureDetector(
      onTap: mBtnHandler,
      child: Container(
        padding: EdgeInsets.all(type == ButtonType.secondary ? 1 : 0),
        decoration: BoxDecoration(
          color: type == ButtonType.secondary
              ? CustomColors.mainPurple
              : Colors.transparent,
          borderRadius: borderRadiusBtn,
        ),
        child: CupertinoButton(
          child: btnSubChild,
          pressedOpacity: 0.9,
          disabledColor: type == ButtonType.primary
              ? CustomColors.pressedPurple
              : CupertinoColors.quaternaryLabel,
          color: btnColors.first,
          borderRadius: borderRadiusBtn,
          onPressed: mBtnHandler,
        ),
      ),
    );

    return !Platform.isIOS ? androidBtn : iosBtn;
  }

  Pair<Color, Color> _getBtnColors(BuildContext context) {
    Color bckgColor;
    Color labelColor;

    switch (type) {
      case ButtonType.secondary:
        bckgColor = Colors.white;
        labelColor = CustomColors.mainYellow;
        break;

      case ButtonType.primary:
      default:
        bckgColor = (signInState == SignInState.processing ||
                signInState == SignInState.signedIn)
            ? CustomColors.pressedPurple
            : CustomColors.mainYellow;
        labelColor = Colors.white;
        break;
    }

    return Pair(bckgColor, labelColor);
  }
}
