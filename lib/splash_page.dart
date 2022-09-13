import 'package:flutter/material.dart';
import 'package:kronosss/Auth/auth_widget.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(20),
      height: size.height - 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 24),
          logokronoss(),
          Spacer(),
          Center(
            child: CircularProgressIndicator(),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
