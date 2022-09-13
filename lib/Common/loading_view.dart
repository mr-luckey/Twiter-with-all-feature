import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String? text;
  final EdgeInsets? margin;
  const LoadingView({this.text = "Cargando...", this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CircularProgressIndicator.adaptive(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}
