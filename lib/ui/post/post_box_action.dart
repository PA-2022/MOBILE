import 'package:flutter/material.dart';

import '../common/custom_colors.dart';

class PostBoxAction extends StatelessWidget {
  final IconData icon;
  final String text;
  final dynamic action;
  const PostBoxAction(this.icon, this.text, this.action, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(
                  icon,
                  color: CustomColors.darkText,
                ),
              ),
              Text(
                text,
                style: const TextStyle(
                    color: CustomColors.lightGrey6, fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }
}
