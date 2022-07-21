import 'package:flutter/material.dart';

class MenuOption extends StatelessWidget {
  final String text;
  final IconData icon;
  final dynamic action;
  const MenuOption(this.text, this.icon, this.action, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon),
            ),
            Text(text),
          ],
        ),
        onTap: action,
      ),
    );
  }
}
