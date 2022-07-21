import 'package:flutter/material.dart';
import './custom_colors.dart';

class CustomButton extends StatelessWidget {
  final dynamic color, text, action;
  const CustomButton(this.color, this.text, this.action, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20),
      child: ElevatedButton(
          onPressed: action,
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
          child: Text(
            text,
            style: const TextStyle(color: CustomColors.white),
          )),
    );
  }
}
