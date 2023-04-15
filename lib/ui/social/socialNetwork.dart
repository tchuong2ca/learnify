import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/colors.dart';

class SocialNetworkPage extends StatefulWidget {
  const SocialNetworkPage({Key? key}) : super(key: key);

  @override
  State<SocialNetworkPage> createState() => _SocialNetworkPageState();
}

class _SocialNetworkPageState extends State<SocialNetworkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: CommonColor.transparent
      ),
      body: Center(
        child: Text("Social Network Page"),
      ),
    );
  }
}
