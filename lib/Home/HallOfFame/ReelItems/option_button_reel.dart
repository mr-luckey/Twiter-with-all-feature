import 'package:flutter/material.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/Home/home_widget.dart';

class OptionButtonReels extends StatelessWidget {
  OptionButtonReels({
    required this.listFunction,
    required this.listValue,
    required this.listShow,
    this.isLiked = false,
    this.isSaved = false,
    this.isValorate = false,
  });

  final List<Function()?> listFunction;
  final List<String?> listValue;

  final List<bool?> listShow;
  final bool isLiked;
  final bool isSaved;
  final bool isValorate;

  final String _likeFull = "assets/reels/ic_like_full.png";
  final _iconListButtons = [
    "assets/reels/ic_donate1.png",
    "assets/reels/ic_tickets.png",
    "assets/reels/ic_ads.png",
    //"assets/reels/ic_chat.png",
    "assets/icons/resource_email.png",
    'assets/icons/ic_file.png',
    "assets/reels/ic_valoration_full.png",
    "assets/reels/ic_saved_full.png",
    "assets/reels/ic_comments_full.png",
    "assets/reels/ic_like_full.png",
    "assets/reels/ic_shared.png",
    "assets/reels/ic_settings.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, right: 10, bottom: 5),
      width: 60,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 0, //40,
          ),
          for (var i = 0; i < 5; i++)
            if (listShow[i] ?? false)
              _btnOp(
                assets: iconSelected(i),
                colorIcon: iconColor(i),
                onPressed: listFunction[i],
                title: listValue[i],
              ),
          Spacer(),
          for (var i = 5; i < 11; i++)
            if (listShow[i] ?? false)
              _btnOp(
                assets: iconSelected(i),
                colorIcon: iconColor(i),
                onPressed: listFunction[i],
                title: listValue[i],
              ),
        ],
      ),
    );
  }

  Color? iconColor(int i) {
    if (isValorate && i == 4) return Colors.amber;
    //if (isSaved && i == 5) return Colors.white;
    if (isLiked && i == 8)
      return Colors.red;
    else
      return Colors.white;
  }

  String iconSelected(int i) {
    if (isValorate && i == 4) return _iconListButtons[i];
    if (isSaved && i == 5) return _iconListButtons[i];
    if (isLiked && i == 8)
      return _likeFull;
    else
      return _iconListButtons[i];
  }

  Widget _btnOp({
    Function()? onPressed,
    String assets = '',
    double sizeIcon = 21,
    Color? colorIcon = Colors.white,
    String? title,
    Color? colorBG,
  }) {
    // print('title: $title');
    final double ww = 42.5;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: ww),
        GestureDetector(
          onTap: onPressed,
          child: ContainerBGDecoration(
            padding: const EdgeInsets.all(12.5),
            radius: 9999,
            width: ww,
            height: ww,
            child: Image.asset(
              assets,
              width: sizeIcon,
              height: sizeIcon,
              color: colorIcon,
            ),
          ),
        ),
        if (title != null) SizedBox(height: 3),
        if (title != null)
          Container(
            //width: ww,
            height: 15,

            decoration: boxDecoration(Colors.black26, 4),
            child: Container(
              //width: ww,
              height: 15,
              padding: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 1),
              decoration: boxDecoration(colorBG, 4),
              child: FittedBox(
                child: Text(
                  title,
                  style: styleMin,
                ),
              ),
            ),
          ),
        SizedBox(height: 12.5),
      ],
    );
  }

  BoxDecoration boxDecoration([Color? color, double radius = 200.0]) =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color ?? Color.fromARGB(50, 255, 255, 255),
      );
}
