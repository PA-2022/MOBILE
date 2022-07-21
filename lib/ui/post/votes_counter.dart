import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../authentication/sign_in/sign_in_screen.dart';

class VotesCounter extends StatefulWidget {
  int counter;

  VotesCounter(this.counter, {Key? key}) : super(key: key);
  @override
  _VotesCounterState createState() => _VotesCounterState();
}

class _VotesCounterState extends State<VotesCounter> {
  int _initialCounter = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          GestureDetector(
            onTap: AuthService.currentUser != null
                ? (_initialCounter < widget.counter
                    ? _resetCounter
                    : _incrementCounter)
                : () => _getSignInScreen(context),
            child: Icon(
              Icons.keyboard_arrow_up,
              size: 28,
              color: _initialCounter < widget.counter
                  ? Colors.green
                  : Colors.black,
            ),
          ),
          Text(
            widget.counter.toString(),
            style: TextStyle(fontSize: 17, color: _getCounterColor()),
          ),
          GestureDetector(
            onTap: AuthService.currentUser != null
                ? (_initialCounter > widget.counter
                    ? _resetCounter
                    : _decrementCounter)
                : () => _getSignInScreen(context),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 28,
              color:
                  _initialCounter > widget.counter ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initialCounter = widget.counter;
  }

  Color _getCounterColor() {
    if (widget.counter > 0) return Colors.green;
    if (widget.counter < 0) return Colors.red;
    return Colors.black;
  }

  void _incrementCounter() {
    setState(() {
      _initialCounter >= widget.counter
          ? widget.counter++
          : widget.counter = widget.counter;
    });
  }

  void _decrementCounter() {
    setState(() {
      _initialCounter <= widget.counter
          ? widget.counter--
          : widget.counter = widget.counter;
    });
  }

  void _resetCounter() {
    setState(() {
      widget.counter = _initialCounter;
    });
  }

  void _getSignInScreen(BuildContext context) {
    Navigator.of(context).pushNamed(SignInScreen.routeName);
  }
}
