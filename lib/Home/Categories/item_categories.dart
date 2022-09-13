import 'package:flutter/material.dart';
import 'package:kronosss/Home/Categories/categories_model.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/mConstants.dart';

class ItemCategories extends StatefulWidget {
  final CategoriesModel model;
  final Function()? onPressed;
  final Color? color;
  final bool noIcon;
  final double sizeIcon;
  final BoxFit? fit;
  final bool selected;
  final Widget? iconWidget;

  ItemCategories(this.model,
      {this.onPressed,
      this.color,
      this.iconWidget,
      this.noIcon = false,
      this.selected = false,
      this.fit,
      this.sizeIcon = 30.0});

  @override
  _ItemCategoriesState createState() => _ItemCategoriesState();
}

class _ItemCategoriesState extends State<ItemCategories> {
  late CategoriesModel model;
  Function()? onPressed;
  Color? color;
  Widget? iconWidget;

  final List<String> icons = [
    "assets/icons/ic_null_circle.png",
    "assets/icons/ic_green_circle.png",
  ];

  @override
  void initState() {
    super.initState();
    model = widget.model;
    onPressed = widget.onPressed;
    color = widget.color;
    iconWidget = widget.iconWidget;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        model.name,
        style: style.copyWith(color: color),
      ),
      subtitle: model.decription.isNotEmpty
          ? Text(model.decription, style: style14)
          : null,
      iconColor: color ?? Colors.white,
      leading: widget.noIcon
          ? iconWidget
          : GestureDetector(
              onTap: onPressed,
              child: Container(
                width: widget.sizeIcon,
                height: widget.sizeIcon,
                child: cacheImageNetwork(
                  model.icon,
                  size: widget.sizeIcon,
                  assetError: NOT_IMAGE,
                  colorError: Colors.black,
                  colorBG: Colors.black,
                  radius: 0,
                ),
                /* child: circularImage2(model.icon,
                    assetError: NOT_IMAGE,
                    colorBG: Colors.transparent,
                    colorImageError: Colors.transparent,
                    fit: widget.fit ?? BoxFit.cover,
                    size: widget.sizeIcon,
                    radius: 0), */
              ),
            ),
      trailing: Image.asset(
        widget.selected ? icons[1] : icons[0],
        width: 20,
      ),
      onTap: onPressed,
    );
  }
}
