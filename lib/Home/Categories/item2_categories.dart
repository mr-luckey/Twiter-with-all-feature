import 'package:flutter/material.dart';
import 'package:kronosss/Home/Categories/categories_model.dart';
import 'package:kronosss/Home/home_page.dart';

class Item2Categories extends StatelessWidget {
  final void Function() onPressed;
  final CategoriesModel categories;
  final Color? color;

  const Item2Categories(
      {required this.categories, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            margin: EdgeInsets.all(11),
            child: categories.iconWidget ??
                Image.network(
                  categories.icon,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  color: color,
                ),
          ),
          SizedBox(width: 2),
          Text(categories.name, style: style.copyWith(color: color)),
        ],
      ),
    );
  }
}
