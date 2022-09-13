import 'package:flutter/material.dart';

class ItemCounterResources extends StatelessWidget {
  final bool selected;
  final double height;
  final double width;
  final EdgeInsets margin;
  ItemCounterResources(
      {this.selected = false,
      this.height = 5.0,
      this.width = 30,
      this.margin = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 3,
        minWidth: 5,
      ),
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: selected ? Colors.green.shade400 : Colors.white60,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.white24,
              offset: Offset(-1, 1),
              blurRadius: 1.0,
            ),
            BoxShadow(
              color: Colors.white24,
              offset: Offset(1, 2),
              blurRadius: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}
