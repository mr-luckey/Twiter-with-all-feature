import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/Home/Creation/widgets/button_circular.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/mConstants.dart';

AppBar appbar(String title,
        {void Function()? leading,
        List<Widget>? actions,
        Color? colorAppbar,
        Color? colorLeading,
        bool hideLearing = false,
        PreferredSizeWidget? bottom}) =>
    AppBar(
      backgroundColor: colorAppbar ?? Colors.black,
      automaticallyImplyLeading: false,
      leading: hideLearing
          ? null
          : GestureDetector(
              onTap: leading,
              child: Container(
                padding:
                    EdgeInsets.only(bottom: 15, top: 10, right: 17, left: 17),
                child: Image.asset(
                  'assets/icons/ic_back.png',
                  width: 10,
                  height: 10,
                ),
              ),
            ),
      title: Text(
        title,
        style: styleAppBarTitle,
      ),
      actions: actions,
      bottom: bottom,
    );

Widget appbarTrans(String title,
    {void Function()? leading,
    List<Widget>? actions,
    Color? colors,
    bool hideLearing = false,
    String imageIcon = '',
    double widthSpace = 0.0,
    PreferredSizeWidget? bottom}) {
  final _title = title.length < 20 ? title : title.substring(0, 17) + '...';
  return AppBarTransBlack(
    hideLearing: hideLearing,
    leading: GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: colors ?? Colors.white,
        ),
      ),
      onTap: leading,
    ),
    title: Row(
      children: [
        if (hideLearing) SizedBox(width: 20),
        if (imageIcon.isNotEmpty)
          ButtonCircular(
            hasDecoration: false,
            padding: EdgeInsets.all(9),
            child: cacheImageNetwork(imageIcon, radius: 0, size: 100),
          ),
        if (widthSpace >= 0.0) SizedBox(width: widthSpace),
        // TITLES
        Container(
          padding: const EdgeInsets.only(top: 2.5),
          child: Text(
            _title,
            style: styleAppBarTitle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
    action: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions ?? [],
    ),
  );
}

Widget actionSaved(
        {StreamController<bool>? loading,
        void Function()? onPressed,
        String title = 'Guardar'}) =>
    StreamBuilder<bool>(
        stream: loading?.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data!) {
            return Container(
              width: 55,
              height: 35,
              padding: const EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            );
          }
          return MaterialButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: style.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        });

class AppBarTransBlack extends StatelessWidget {
  final List<Widget>? children;
  final Widget? leading;
  final Widget? title;
  final Widget? action;
  final hideLearing;
  const AppBarTransBlack(
      {this.children,
      this.leading,
      this.title,
      this.action,
      this.hideLearing = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: 50,
      width: size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(
            170, 0, 0, 0), //Color.fromARGB(90, 0, 0, 0), //Color(0xE5000000),
        gradient: gradientHome(),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: hideLearing ? 0 : 10, right: 10),
        child: Row(
          children: children ??
              [
                if (!hideLearing)
                  Container(
                    color: Colors.transparent,
                    width: 39,
                    height: 50,
                    child: leading,
                  ),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width * 0.5 +
                      20 +
                      (hideLearing ? 50 : 0),
                  height: 50,
                  child: title,
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    width: 40,
                    //  height: 50,
                    child: action,
                  ),
                ),
              ],
        ),
      ),
    );
  }
}

class ButtonOutline extends StatefulWidget {
  final Widget? iconWidget;
  final String assetSrc;
  final String text;
  final Size? sizeIcon;
  final void Function()? onPressed;
  const ButtonOutline(
      {required this.text,
      this.assetSrc = 'assets/payments/ic_credit_card.png',
      this.onPressed,
      this.iconWidget,
      this.sizeIcon,
      Key? key})
      : super(key: key);

  @override
  State<ButtonOutline> createState() => _ButtonOutlineState();
}

class _ButtonOutlineState extends State<ButtonOutline> {
  late Size sizeIcon;

  @override
  void initState() {
    super.initState();
    sizeIcon = widget.sizeIcon ?? Size(17.0, 17.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: decoOutline,
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 7),
        padding: EdgeInsets.only(left: 15, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: widget.iconWidget == null ? 10 : 5),
              child: widget.iconWidget ??
                  Image.asset(
                    widget.assetSrc,
                    height: sizeIcon.width,
                    width: sizeIcon.height,
                  ),
            ),
            Spacer(),
            Text(widget.text),
            Spacer(),
          ],
        ),
      ),
      onTap: widget.onPressed,
    );
  }
}

Widget bottonItemNav(
    {required Function()? onPressed,
    Widget? icon,
    String? assetImage,
    Size? size,
    String text = '',
    Color? colorIcon = Colors.white}) {
  return Expanded(
    child: MaterialButton(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: icon ??
                Image.asset(
                  assetImage ?? "assets/icons/ic_menu_1.png",
                  height: size?.height ?? 20,
                  width: size?.width ?? 20,
                  color: colorIcon,
                ),
          ),
          Text(
            text,
            style: style12.copyWith(color: colorIcon),
          ),
          //SizedBox(height: 4),
        ],
      ),
      onPressed: onPressed,
    ),
  );
}

_deco1({Color? color, double radius = 8.0}) => BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: color ?? Colors.black,
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
    );

Widget buttonStyle2(
    {void Function()? onPressed,
    String title = '',
    Color? color,
    double radius = 8.0,
    TextStyle? styles}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      decoration: _deco1(color: color, radius: radius),
      padding: EdgeInsets.all(8.0),
      child: Text(
        title,
        style: styles ?? style.copyWith(fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget buttonOutline({
  void Function()? onTap,
  Widget? icon,
  String? text,
  TextStyle? styles,
  EdgeInsets? margin,
  EdgeInsets? padding,
  EdgeInsets? paddingIcon,
  double height = 50.0,
  double spaceWidth = 20.0,
  MainAxisAlignment? mainAxisAlignment,
}) {
  final hasCenter = mainAxisAlignment == MainAxisAlignment.center;

  return GestureDetector(
    child: Container(
      decoration: decoOutline,
      height: height,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 20),
      padding: padding ?? EdgeInsets.only(left: 15, right: 20),
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        children: [
          if (hasCenter) SizedBox(width: 5),
          if (icon != null)
            Container(
              padding: paddingIcon,
              child: icon,
            ),
          SizedBox(width: spaceWidth),
          if (hasCenter) Spacer(flex: 1),
          if (text != null)
            Text(
              text,
              style: styles ?? style,
            ),
          if (hasCenter) Spacer(flex: 2),
        ],
      ),
    ),
    onTap: onTap,
  );
}

Widget cacheImageNetwork(
  String? src, {
  double size = 30,
  BoxFit fit = BoxFit.cover,
  Color colorBG = Colors.white,
  Color? colorError,
  double radius = 200.0,
  Size? sizeCustom,
  bool isPlaceHolder = true,
  Widget? child,
  String? assetError,
  Widget? childError,
  Function()? onTap,
  Function()? onDoubleTap,
  Function()? onLongPress,
  EdgeInsets? padding,
  EdgeInsets? paddingError,
  EdgeInsets? margin,
}) {
  final width = sizeCustom?.width ?? size;
  final height = sizeCustom?.height ?? size;

  return GestureDetector(
    onTap: onTap,
    onDoubleTap: onDoubleTap,
    onLongPress: onLongPress,
    child: Container(
      padding: padding,
      margin: margin,
      child: Stack(
        children: [
          if (assetError != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: colorBG,
                  border: Border.all(color: colorBG, width: 2),
                ),
                child: childError ??
                    Container(
                      padding: paddingError ?? EdgeInsets.zero,
                      child: Image.asset(
                        assetError /*  ?? NOT_IMAGE_PROFILE */,
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                        color: colorError,
                      ),
                    ),
              ),
            ),
          Container(
            padding: padding ?? EdgeInsets.all(1),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: CachedNetworkImage(
                imageUrl: src ?? "",
                placeholder: (context, url) {
                  if (isPlaceHolder)
                    return Center(child: CircularProgressIndicator());
                  return SizedBox();
                },
                errorWidget: (context, url, error) => Image.network(
                  src ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, o, t) =>
                      SizedBox() /* Image.asset(NOT_IMAGE) */,
                ),
                width: width - 2,
                height: height - 2,
                fit: fit,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

//image circular
Widget circularImage2(
  String? src, {
  double size = 30,
  BoxFit fit = BoxFit.cover,
  Color colorBG = Colors.white,
  Color? colorImageError,
  double radius = 200.0,
  double anchorBorder = 2.0,
  String? assetError,
  Widget? child,
}) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colorBG,
            border: Border.all(color: colorBG, width: anchorBorder),
          ),
          child: Image.asset(
            assetError ?? NOT_IMAGE_PROFILE,
            width: size,
            height: size,
            color: colorImageError,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: child ??
              networkImageIcon(
                src ?? "",
                ww: size - 2,
                hh: size - 2,
                boxfit: fit,
                sizeIconError: size,
                assetError: assetError ?? NOT_IMAGE_PROFILE,
              ),
        ),
      ),
    ],
  );
}

Widget networkImageIcon(String? uriImage,
    {String placeHolderImage = LOADING_GIF,
    double ww = 100.0,
    double hh = 100.0,
    double sizeIconError = 40.0,
    String? assetError = NOT_IMAGE_PROFILE,
    BoxFit boxfit = BoxFit.contain}) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.circle),
    child: FadeInImage.assetNetwork(
      placeholder: placeHolderImage,
      image: uriImage ?? NOT_IMAGE,
      fit: boxfit,
      imageErrorBuilder: (context, url, error) => Image.asset(
        assetError ?? NOT_IMAGE_PROFILE,
        width: ww,
        height: hh,
        fit: BoxFit.cover,
      ),
      width: ww,
      height: hh,
    ),
  );
}

class ContainerBGDecoration extends StatelessWidget {
  const ContainerBGDecoration(
      {required this.child,
      this.constraints,
      this.margin,
      this.padding,
      this.radius = 6.0,
      this.noDecoration = false,
      this.noEdgeInsets = false,
      this.width,
      this.height,
      Key? key})
      : super(key: key);

  final Widget child;
  final BoxConstraints? constraints;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double radius;
  final bool noDecoration;
  final bool noEdgeInsets;
  final double? width;
  final double? height;

  final Color color1 = Colors.black26;
  final Color color2 = Colors.white12;
  final Color trans = Colors.transparent;

  BoxDecoration _deco(Color color) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      );

  @override
  Widget build(BuildContext context) {
    final _margin = margin ?? EdgeInsets.zero;
    final _padding = padding ?? EdgeInsets.zero;

    return Container(
      decoration: _deco(noDecoration ? trans : color1),
      constraints: constraints,
      margin: noEdgeInsets ? EdgeInsets.zero : _margin,
      child: Container(
        decoration: _deco(noDecoration ? trans : color2),
        padding: noEdgeInsets ? EdgeInsets.zero : _padding,
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
