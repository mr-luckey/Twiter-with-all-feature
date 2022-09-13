import 'package:flutter/material.dart';

import 'package:kronosss/Home/Categories/categories_model.dart';
import 'package:kronosss/Home/Categories/item_categories.dart';

import '../home_widget.dart';

class ListCategories2 extends StatefulWidget {
  final List<CategoriesModel> list;
  final int category;
  final void Function(int, CategoriesModel) onpressed;
  final bool noIcon;

  ListCategories2(
      {required this.list,
      required this.onpressed,
      this.category = -1,
      this.noIcon = true});

  @override
  State<ListCategories2> createState() => _ListCategories2State();
}

class _ListCategories2State extends State<ListCategories2> {
  // ignore: unused_field
  final _catModel = CategoriesModel(id: '', name: '');
  List<CategoriesModel> listCategories = [];
  int selected = -1;

  @override
  void initState() {
    super.initState();
    listCategories = widget.list;
    selected = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appbar(
          'Categorías',
          leading: () => Navigator.of(context).pop(),
          actions: [
            actionSaved(onPressed: () {
              widget.onpressed(selected, listCategories[selected]);
            })
          ],
        ),
        /* appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Categorías',
            style: style.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ), */
        body: ListView.builder(
          shrinkWrap: true,
          //physics: NeverScrollableScrollPhysics(),
          itemCount: listCategories.length,
          itemBuilder: (_, index) {
            return ItemCategories(listCategories[index],
                //noIcon: true,
                selected: selected == index,
                color: widget.category == index ? Colors.green : Colors.white,
                onPressed: () {
              setState(() => selected = index);
              //debugPrint('${_catModel.toJson(listCategories[index])}');
              //Navigator.of(context).pop();
            });
          },
        ),
      ),
    );
  }
}
