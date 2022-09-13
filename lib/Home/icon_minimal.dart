import 'package:flutter/material.dart';

class IconMinimal extends StatelessWidget {
  final double height, width;
  final Color? color;
  final String srcAssets;
  final EdgeInsets? padding;
  final BoxFit? fit;

  const IconMinimal(this.srcAssets,
      {this.width = 15.0,
      this.height = 15.0,
      this.color,
      this.padding,
      this.fit,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      child: Image.asset(
        srcAssets,
        color: color,
        fit: fit,
      ),
    );
  }
}
