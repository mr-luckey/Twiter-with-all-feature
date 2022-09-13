import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/mConstants.dart';

class RichTextWidget extends StatefulWidget {
  final String text;
  final List<String>? listText;
  final TextAlign textAlign;
  final TextStyle? styleDefault;
  final TextStyle? styleTypeHashtag;
  final TextStyle? styleTypeMention;
  final TextStyle? styleTypeWeb;

  final void Function()? onTapHashtag;
  final void Function()? onTapMention;
  final void Function()? onTapWeb;
  final void Function()? onTap;

  const RichTextWidget(
      {required this.text,
      this.listText,
      this.textAlign = TextAlign.start,
      this.styleDefault,
      this.styleTypeHashtag,
      this.styleTypeMention,
      this.styleTypeWeb,
      this.onTap,
      this.onTapHashtag,
      this.onTapMention,
      this.onTapWeb,
      Key? key})
      : super(key: key);

  @override
  State<RichTextWidget> createState() => _RichTextWidgetState();
}

class _RichTextWidgetState extends State<RichTextWidget> {
  List<String> listText = [];
  late TextStyle style1O, style2H, style3M, style4W;
  bool hasShort = true;

  @override
  void initState() {
    style1O = widget.styleDefault ?? style17;
    style2H = widget.styleTypeHashtag ??
        style17.copyWith(
          color: Colorskronoss.primary2,
        );
    style3M = widget.styleTypeMention ??
        style17.copyWith(
          color: Colorskronoss.primary,
        );
    style4W = widget.styleTypeWeb ??
        style17.copyWith(
          color: Colorskronoss.secundary3,
        );
    listText = widget.listText ?? widget.text.split(' ');
    var x = listText.indexOf(".");
    var max = listText.length <= 80 ? listText.length : (x < 0 ? 80 : x);
    if (hasShort) listText = listText.sublist(0, max);
    super.initState();
  }

  init() {}

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: widget.textAlign,
      text: TextSpan(
        style: style1O,
        children: [
          for (var text in listText)
            TextSpan(
              text: '$text ',
              style: getStyle(text),
              recognizer: TapGestureRecognizer()..onTap = getFun(text),
            ),
        ],
      ),
    );
  }

  TextStyle getStyle(String text) {
    if (text.contains("#")) {
      return style2H.copyWith(height: 1.35);
    } else if (text.contains("@")) {
      return style3M.copyWith(height: 1.35);
    } else if (text.contains("http")) {
      return style4W.copyWith(height: 1.35);
    } else {
      return style1O.copyWith(height: 1.35);
    }
  }

  getFun(String text) {
    if (text.contains("#")) {
      return widget.onTapHashtag;
    } else if (text.contains("@")) {
      return widget.onTapMention;
    } else if (text.contains("http")) {
      return widget.onTapWeb;
    } else {
      return widget.onTap;
    }
  }
}
