import 'package:flutter/material.dart';

import '../common/custom_app_bar.dart';
import '../common/search_bar_type.dart';

class HomeTop extends StatefulWidget with ChangeNotifier {
  HomeTop({Key? key}) : super(key: key);

  @override
  _HomeTopState createState() => _HomeTopState();
}

class _HomeTopState extends State<HomeTop> {
  @override
  Widget build(BuildContext context) {
    return CustomAppBar("Posts", true, SearchBarType.POST);
  }
}
