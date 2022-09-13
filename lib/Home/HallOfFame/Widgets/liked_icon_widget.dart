import 'package:flutter/material.dart';

class LikedIcon extends StatelessWidget {
  final int time;
  final Color color;

  LikedIcon({this.time = 1500, this.color = Colors.red});

  Future<int> tempFuture() async {
    return Future.delayed(Duration(milliseconds: time));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: tempFuture(),
        builder: (context, snapshot) =>
            snapshot.connectionState != ConnectionState.done
                ? Icon(
                    Icons.favorite,
                    color: color,
                    size: 110,
                  )
                : SizedBox(),
      ),
    );
  }
}
