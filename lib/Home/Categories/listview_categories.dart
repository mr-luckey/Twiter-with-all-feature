import 'package:flutter/material.dart';

import 'package:kronosss/Home/Categories/categories_model.dart';
import 'package:kronosss/Home/home_page.dart';

class ListViewCategories extends StatefulWidget {
  final void Function(int) itemSelected;
  final List<CategoriesModel> listCategories;
  final bool showIcon;
  final int? current;

  const ListViewCategories(
      {required this.listCategories,
      this.current,
      this.showIcon = false,
      required this.itemSelected});

  @override
  State<ListViewCategories> createState() => _ListViewCategoriesState();
}

class _ListViewCategoriesState extends State<ListViewCategories> {
  int selected = -1;

  @override
  void initState() {
    super.initState();
    selected = widget.current ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: _size.height * 0.5,
      child: Center(
        child: ListView.builder(
          //scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.listCategories.length,
          itemBuilder: (_, index) {
            var item = widget.listCategories[index];
            return GestureDetector(
              onTap: () {
                widget.itemSelected(index);
                setState(() {
                  selected = index;

                  /* Utils.toast(context, item.name,
                      position: Utils.positionedCenter); */
                });
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  if (widget.showIcon)
                    Container(
                      width: 23.0,
                      height: 23.0,
                      margin: EdgeInsets.only(
                          left: 15, right: 15, top: 11, bottom: 11),
                      child: Image.network(
                        item.icon,
                        width: 23,
                        height: 23,
                        fit: BoxFit.cover,
                        color: selected == index ? Colors.green : null,
                      ),
                    ),
                  SizedBox(width: 2),
                  Container(
                    margin: EdgeInsets.only(
                        left: 15, right: 15, top: 12, bottom: 12),
                    child: Text(item.name,
                        style: style.copyWith(
                            color: selected == index ? Colors.green : null)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
