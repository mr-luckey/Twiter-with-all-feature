import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/mShared.dart';
import 'package:kronosss/main.dart';

class ProfilePage extends StatefulWidget {
  final ScrollController? controller;
  final String userEmail;
  final bool isShowBack;
  final bool isShowSecundary;

  ProfilePage({
    this.controller,
    this.userEmail = '',
    this.isShowBack = true,
    this.isShowSecundary = false,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () async {
          await SharedPrefs.clear();
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => MyApp()));
        },
        child: Text('LogOut'),
      )),
    );
  }
}
