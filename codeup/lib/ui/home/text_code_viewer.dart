import 'package:flutter/material.dart';

import '../common/custom_colors.dart';

class TextCodeViewer extends StatelessWidget {
  final String text;
  const TextCodeViewer(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        2.0,
      ),
      child: Container(
        color: CustomColors.darkText,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
          child: RichText(
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
