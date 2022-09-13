import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kronosss/Home/HallOfFame/comment_model.dart';
import 'package:kronosss/Home/Profile/profile_model.dart';
import 'package:kronosss/Home/Publications/publication_model.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';

class DetailsReelScreen extends StatefulWidget {
  final PublicationModel publication;
  DetailsReelScreen({required this.publication});

  @override
  State<DetailsReelScreen> createState() => _DetailsReelScreenState();
}

class _DetailsReelScreenState extends State<DetailsReelScreen> {
  bool isLiked = false;
  List<ProfileModel> listUserLike = [];
  List<Widget> listUser = [];
  String category = '';
  int like_count = 0, comment_count = 0, saved_count = 0, views = 0;

  @override
  void initState() {
    _getInfoFilter();
    infoPublication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appbar(context),
        body: ListView(
          children: [
            ...createListTile(),
            ...listUser,
            /*  for (var i = 0; i < 20; i++)
              listTile(
                title: 'title is long publication',
                subtitle: 'descripcion by publicacions',
              ), */
          ],
        ),
      ),
    );
  }

  ListTile listTile(
      {String title = '', String subtitle = '', Widget? trailing}) {
    return ListTile(
      // onTap: () {},
      title: title.isEmpty
          ? null
          : Text(
              title,
              style: style.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
      subtitle: subtitle.isEmpty
          ? null
          : Text(
              subtitle,
              style: style.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
            ),
    );
  }

  List<Widget> createListTile() {
    List<Widget> list = [];
    var pub = widget.publication;

    list.add(
      listTile(
        title: 'Titulo de la publicación',
        subtitle: pub.title.isEmpty ? 'Sin Titulo' : pub.title,
      ),
    );
    list.add(
      listTile(
        title: 'Descripción de la publicación',
        subtitle: pub.desciption.isEmpty ? 'Sin Descripción' : pub.desciption,
      ),
    );
    list.add(
      listTile(
        title: 'Persona que Creo la publicación',
        subtitle: pub.nameUser,
      ),
    );
    list.add(
      listTile(
        title: 'Ubicación',
        subtitle: pub.ubication ?? 'Sin Ubicación',
      ),
    );
    list.add(
      listTile(
        title: 'Habilitada las donaciones',
        subtitle: pub.donation ? 'Sí' : 'No',
      ),
    );
    list.add(
      listTile(
        title: 'Habilitada los pagos',
        subtitle: pub.price > 0.00 ? 'Sí, Valor: ${pub.price}' : 'No',
      ),
    );
    list.add(
      listTile(
        title: 'Vistas:',
        subtitle: '$views',
      ),
    );
    /* list.add(
      listTile(
        title: 'Detalles de los "Me gusta"',
        subtitle:
            'Número: ${pub.like} \nAuto Me gusta: ${isLiked ? "Sí" : "No"}',
      ),
    ); */
    list.add(ListTile(
      title: Text(
        'Detalles de los "Me gusta"',
        style: style.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Número: ${pub.like} ',
            style: style.copyWith(
              fontWeight: FontWeight.normal,
              fontSize: 13,
            ),
          ),
          /* Text(
            'Auto Me gusta: ${isLiked ? "Sí" : "No"}',
            style: style.copyWith(
              fontWeight: FontWeight.normal,
              fontSize: 13,
            ),
          ), */
          Row(
            children: [
              if (listUserLike.length > 1)
                cacheImageNetwork(listUserLike[0].image, size: 20),
              if (listUserLike.length > 1)
                Text(
                  ' y otras ${listUserLike.length} más les gusta',
                  style: style.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              if (listUserLike.length == 1)
                cacheImageNetwork(listUserLike[0].image, size: 20),
              if (listUserLike.length == 1)
                Text(
                  ' ${listUserLike[0].name.trim()} le gusta',
                  style: style.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
            ],
          ),
        ],
      ),
    ));
    list.add(
      listTile(
        title: 'Categoria de la publicación',
        subtitle: category,
      ),
    );
    list.add(
      listTile(
        title: 'Publicación con Copyright',
        subtitle: pub.copyR ? 'Sí' : 'No',
      ),
    );
    list.add(
      listTile(
        title: 'Stock de producto:',
        subtitle: '${pub.stock}',
      ),
    );

    return list;
  }

  _getInfoFilter() async {
    final response = await PublicationModel.getInfoFilterPublications(
        widget.publication.id,
        filter: 'userLike');

    if (response != null) {
      List list = jsonDecode(response.body);
      for (var item in list) {
        var json = item['dataUser'];
        var profile = ProfileModel(
          email: json['email'],
          name: json['name'] + ' ' + json['lastname'],
          image: json['resource']['url'],
        );

        listUserLike.add(profile);
      }
      setState(() {});
    }
  }

  Future infoPublication() async {
    final email = await SharedPrefs.getString(shared_email);
    final cm = await CommentModel.getComment(widget.publication.id);
    bool myLike = false;
    await PublicationModel.getInfoPublications(widget.publication.id)
        .then((response) {
      if (response != null) {
        final body = ApiServices.getBody(response);

        final List userLike = body['userLike'] ?? [];

        final String categ = body['publication']['Categories'][0]['name'] ?? '';

        final int likes = body['like'] ?? 0;
        final int _views = body['views'] ?? 0;
        final int saveds = body['numberSave'] ?? 0;

        for (var item in userLike) {
          if (item == email) myLike = true;
        }

        setState(() {
          isLiked = myLike;
          like_count = likes;
          comment_count = cm.length;
          category = categ;
          views = _views;
          saved_count = saveds;
        });
      }
    });
  }

  AppBar _appbar(BuildContext context) {
    return appbar(
      'Detalles de la publicación',
      leading: () => Navigator.of(context).pop(),
    );
  }
}
