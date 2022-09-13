import 'package:kronosss/Home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/Auth/auth_widget.dart';

class RegistredCompletedPage extends StatelessWidget {
  final style =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);
  final String message = "Revisa tu bandeja de correo electrónico.";
  final Function()? onPressed;

  RegistredCompletedPage({this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          logokronoss(),
          SizedBox(height: 45),
          Container(
            height: 90,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              message,
              style: style20H,
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          SizedBox(height: 15),
          buttonGeneric(
            'Salir a la pantalla principal',
            width: double.maxFinite,
            onPressed: onPressed ?? () {},
          ),
          Spacer(),
        ],
      ),
    );
  }
}
