import 'package:flutter/material.dart';
import 'package:kronosss/Home/home_page.dart';

class ButtonCircular extends StatelessWidget {
  final void Function()? onPressed;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double size;
  final Widget child;
  final bool hasAssetIcon;
  final bool hasDecoration;
  final BoxDecoration? decoration;

  ButtonCircular({
    required this.child,
    this.onPressed,
    this.size = 40.0,
    this.padding,
    this.margin,
    this.hasAssetIcon = false,
    this.hasDecoration = true,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: onPressed,
        child: hasAssetIcon
            ? Container(
                decoration: hasDecoration
                    ? decoration ?? decoCircle
                    : BoxDecoration(
                        color: Colors.transparent, shape: BoxShape.circle),
                width: size,
                height: size,
                child: child,
              )
            : Container(
                decoration: hasDecoration
                    ? decoration ?? decoCircle
                    : BoxDecoration(
                        color: Colors.transparent, shape: BoxShape.circle),
                padding: padding ?? EdgeInsets.all(10),
                width: size,
                height: size,
                child: child,
              ),
      ),
    );
  }
}
