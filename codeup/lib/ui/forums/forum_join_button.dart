import 'package:flutter/material.dart';

import '../common/custom_button.dart';
import '../common/custom_colors.dart';

class ForumJoinButton extends StatelessWidget {
  const ForumJoinButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(CustomColors.mainYellow, "Join", () => _joinForum());
  }

  _joinForum() {}
}
