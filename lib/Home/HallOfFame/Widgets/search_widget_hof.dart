import 'package:flutter/material.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/Home/icon_minimal.dart';

/**
 SearchWidgetHoF(
              controller: _ctr_email,
              onPressedCategories: () {
                print('categories');
              },
            ),
 */

class SearchWidgetHoF extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onSubmitted;
  final bool showSearch;
  final double height;
  final Widget? widgetSponsor;
  final Function()? onPressedCategories;
  final Function()? onOpen;
  final Function(bool)? onChanged;
  final String assetsButton;

  const SearchWidgetHoF({
    Key? key,
    required this.controller,
    this.onPressedCategories,
    this.onChanged,
    this.onOpen,
    this.onSubmitted,
    this.showSearch = true,
    this.widgetSponsor,
    this.height = 51,
    this.assetsButton = 'assets/creations/g2.png',
  }) : super(key: key);

  @override
  State<SearchWidgetHoF> createState() => _SearchWidgetHoFState();
}

class _SearchWidgetHoFState extends State<SearchWidgetHoF> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.only(left: 5, right: 5),
      color: Colors.black45,
      child: expanded
          ? _ayuda(controller: widget.controller)
          : Row(
              children: [
                //_button(), // sponsor
                if (widget.widgetSponsor != null) widget.widgetSponsor!,
                Spacer(),
                if (widget.showSearch)
                  _button(
                    assets: "assets/icons/ic_search.png",
                    ontap: () {
                      setState(() {
                        expanded = true;
                        if (widget.onChanged != null)
                          widget.onChanged!(expanded);
                      });
                    },
                  ),
                if (widget.onPressedCategories != null)
                  _button(
                    ontap: widget.onPressedCategories,
                    assets: widget.assetsButton,
                  ),
              ],
            ),
    );
  }

//-----
  _button(
      {String assets = 'assets/creations/g2.png',
      Function()? ontap,
      Widget? child}) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.only(right: 12, left: 12, top: 7, bottom: 7),
        child: child ??
            Image.asset(
              assets,
              width: 26,
              height: 26,
            ),
      ),
    );
  }

  _ayuda({
    double height = 56,
    required TextEditingController controller,
    EdgeInsetsGeometry? contentPadding,
    String hintText = 'Buscar',
    TextStyle? hintStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 5),
        /* _button(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          ontap: () {
            setState(() {
              expanded = false;
              widget.controller.clear();
            });
          },
        ), */
        if (widget.showSearch)
          Flexible(
            child: Container(
              margin: EdgeInsets.all(5),
              height: height,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller,
                style: style,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onSubmitted: widget.onSubmitted,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: contentPadding ??
                      EdgeInsets.only(left: 10, top: 10.5, right: 10),
                  prefixIcon: Container(
                    child: expanded
                        ? _button(
                            child: Container(
                              height: height,
                              width: 40,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 5),
                              child: Image.asset(
                                'assets/icons/cancel.png',
                                width: 20,
                              ),
                            ),
                            ontap: () {
                              setState(() {
                                expanded = false;
                                if (widget.onChanged != null)
                                  widget.onChanged!(expanded);
                                widget.controller.clear();
                              });
                            },
                          )
                        : IconMinimal(
                            "assets/icons/ic_search.png",
                            color: Colors.white,
                            padding: EdgeInsets.only(top: 7, bottom: 5),
                          ),
                  ),
                  alignLabelWithHint: true,
                  hintText: hintText,
                  hintStyle: hintStyle ??
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
        if (widget.onPressedCategories != null)
          _button(
            ontap: widget.onPressedCategories,
            assets: widget.assetsButton,
          ),
      ],
    );
  }
}
