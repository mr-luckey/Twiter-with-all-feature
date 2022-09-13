import 'package:flutter/material.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/mConstants.dart';

class HallOfFameWidgets {
// edittext search
  static Widget editTextGeneric({
    TextEditingController? controller,
    double width = 270,
    double height = 40,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool alignLabelWithHint = true,
    BoxDecoration? decoration,
    String hintText = "",
    TextStyle? styles,
    TextStyle? hintStyle,
    TextInputType inputType = TextInputType.name,
    int maxLength = 99999,
    EdgeInsets? contentPadding,
    EdgeInsets? margin,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 5, right: 5, top: 2),
      margin: margin ?? EdgeInsets.zero,
      decoration: decoration ??
          BoxDecoration(
            color: Color(0x3DFFFFFF),
            borderRadius: BorderRadius.circular(12),
          ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        /* maxLength: maxLength,
      maxLengthEnforced: false, */
        keyboardType: inputType,
        style: styles ??
            style.copyWith(
              letterSpacing: 1,
              fontSize: 16.5,
            ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              contentPadding ?? EdgeInsets.only(left: 15, top: 5, right: 15),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          alignLabelWithHint: true,
          hintText: hintText,
          hintStyle: hintStyle ?? style.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//image circular
  static Widget circularImage(
    String src, {
    double size = 30,
    BoxFit fit = BoxFit.cover,
    double radius = 200.0,
  }) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            width: size,
            height: size,
            color: Colors.white,
          ),
        ),
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: mImageIconNetwork(
              src,
              ww: size,
              hh: size,
              boxfit: fit,
              sizeIconError: size,
            ),
          ),
        ),
      ],
    );
  }

  static Widget mImageIconNetwork(String? uriImage,
      {String placeHolderImage = LOADING_GIF,
      double ww = 100.0,
      double hh = 100.0,
      double sizeIconError = 40.0,
      BoxFit boxfit = BoxFit.contain}) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: FadeInImage.assetNetwork(
        placeholder: placeHolderImage,
        image: uriImage ?? NOT_IMAGE,
        fit: boxfit,
        imageErrorBuilder: (context, url, error) => Image.asset(
          "assets/no_available.png",
          width: ww,
          height: hh,
          fit: BoxFit.cover,
        ),
        width: ww,
        height: hh,
      ),
    );
  }

  static Widget topNavBar(
      {required Size size,
      String src = '',
      TextEditingController? controller,
      Widget? suffixIcon,
      Widget? prefixIcon,
      Function()? onPressedSponsor,
      Function()? onPressedCat,
      Color? colorIcon}) {
    return Row(
      children: [
        //patrocinador
        /* GestureDetector(
          onTap: onPressedSponsor,
          child: Container(
            padding: const EdgeInsets.only(right: 5, left: 5),
            child: circularImage(src, size: 33),
          ),
        ), */
        //search
        Flexible(
          flex: 8,
          child: editTextGeneric(
              controller: controller,
              width: size.width,
              margin: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
              hintText: "Buscar"),
        ),

        // tematicas
        /* GestureDetector(
          child: Icon(
            Icons.child_care_sharp,
            color: colorIcon??Colors.grey,
          ),
        ), */
        SizedBox(width: 5),
        //categorias
        GestureDetector(
          onTap: onPressedCat,
          child: Padding(
            padding: const EdgeInsets.only(right: 5, left: 5),
            child: Image.asset(
              'assets/creations/g2.png',
              width: 36,
              height: 36,
            ),
          ),
        ),
        SizedBox(width: 5),
      ],
    );
  }

  static Widget dataUserReelss({
    String src = "n/a",
    String text1 = "",
    String text2 = "",
    String text3 = "",
    Function()? onPressed,
    double size = 37.0,
  }) {
    final style = TextStyle(color: Colors.white, fontSize: 10);
    return Container(
        margin: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  text1,
                  style: style,
                ),
                /* Text(
                  text2,
                  style: style,
                ), */
                Row(
                  children: [
                    Text(text3, style: style),
                    Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 12,
                    )
                    /* Image.asset(
                      'assets/creations/g6.png',
                      width: 10,
                      color: Colors.white,
                    ), */
                  ],
                ),
              ],
            ),
            SizedBox(width: 3),
            GestureDetector(
              onTap: onPressed,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      'assets/icons/profile.png',
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    ),
                  ),
                  cacheImageNetwork(src, size: size),
                ],
              ),
            ),
          ],
        ));
  }

  static Widget buttonReelsItem(
      {Function()? onPressed,
      String title = "",
      Widget? icon,
      double sizeIcon = 30,
      Color? colorIcon,
      String assets = "assets/icons/logo_google.png"}) {
    return GestureDetector(
        onTap: onPressed ?? () {},
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon ??
                  Image.asset(
                    assets,
                    width: sizeIcon,
                    height: sizeIcon,
                    color: colorIcon,
                  ),
              SizedBox(height: 5),
              Container(
                width: 40,
                height: 15,
                child: FittedBox(
                  child: Text(
                    title,
                    style: style,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}//----
