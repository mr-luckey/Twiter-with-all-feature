import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kronosss/DialogSheet/Creation/dialog_creation_glossa.dart';
import 'package:kronosss/Home/Categories/categories_model.dart';
import 'package:kronosss/Home/Categories/list_categories2.dart';
import 'package:kronosss/Home/Creation/widgets/button_circular.dart';
import 'package:kronosss/Home/HallOfFame/GlossaItems/glossa_item.dart';
import 'package:kronosss/Home/HallOfFame/comment_model.dart';
import 'package:kronosss/Home/Publications/publication_model.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';

class GlossasScreen extends StatefulWidget {
  final ScrollController controller;
  final String idCategories;

  GlossasScreen({required this.controller, this.idCategories = ''});

  @override
  State<GlossasScreen> createState() => _GlossasScreenState();
}

class _GlossasScreenState extends State<GlossasScreen> {
  final _streamPublications = StreamController<int>();
  List<PublicationModel> listPublications = [];

  bool hasMoreToLoad = false, alldescrip = false;
  int PAGE = -1;

  String user = '';
  bool heightDescription = false;
  bool isLiked = false;
  int like_count = 0;
  int saved_count = 0;
  int comment_count = 0;
  double donation_count = 0.0;

  String _categories = "";
  // ignore: unused_field
  String _categories_name = "GENERAL";
  late CategoriesModel categoriesModel;
  List<CategoriesModel> _listCategories = [];

  @override
  void initState() {
    categoriesModel = CategoriesModel(
      id: '',
      name: 'General',
      icon:
          'http://192.99.167.185:5000/uploads/categories/0.6607388104691143-40.png',
    );
    getGeneralCategory();
    PAGE = 0;
    _getListPublications(PAGE, idCategories: widget.idCategories);
    widget.controller.addListener(() {
      if (widget.controller.position.pixels >=
              widget.controller.position.maxScrollExtent &&
          !hasMoreToLoad) {
        //debugPrint('--------- FINAL LISTO PARA CARGAR  ($PAGE)----------');

        setState(() => hasMoreToLoad = true);
        _getListPublications(PAGE,
            showLoading: false, idCategories: widget.idCategories);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _streamPublications.close();
    super.dispose();
  }

  Future<void> getGeneralCategory() async {
    final list = await CategoriesModel.getListCategories();
    for (var item in list) {
      if (item.name.toLowerCase() == 'general') {
        categoriesModel = item;
        break;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        /* appBar: AppBar(
          backgroundColor: Colors.black,
          flexibleSpace: SizedBox(height: 56),
        ), */
        body: Stack(
          children: [
            CustomScrollView(
              controller: widget.controller,
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 51),
                  ]),
                ),
                if (listPublications.isEmpty)
                  SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(height: size.height * 0.25),
                      Center(
                        child: Text('No Hay Publicaciones',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            )),
                      ),
                    ]),
                  ),
                if (listPublications.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var model = listPublications[index];
                        //return Fame3Screen();
                        return GlossaItem(
                          publication: model,
                          //isLiked: isLiked,
                          //onTapComment: () => funComment(model),
                          onTapGlossear: () {},
                          //onTapLike: () => funLike(model),
                          //onTapShare: () => funShared(model),
                          //onTapValoration: () => funValoration(model),
                        );
                        /* return itemTweets(
                        index: index,
                        publication: model,
                        userImage: model.imageUser,
                        nameUser: model.nameUser,
                        nickUser: model.userCreate,
                        description: model.desciption,
                        resource:
                            model.resource.isNotEmpty ? model.resource : null,
                        imageSponsor: null,
                      ); */
                      },
                      childCount: listPublications.length,
                    ),
                  ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 56),
                  ]),
                ),
              ],
            ),
            Positioned(
              child: SizedBox(
                height: 51,
                child: appbarTrans(
                  //'Glossas',
                  categoriesModel.name,
                  imageIcon: categoriesModel.icon,
                  hideLearing: true,
                  actions: [
                    ButtonCircular(
                      hasDecoration: false,
                      child: Image.asset(
                        'assets/creations/g2.png',
                      ),
                      onPressed: getCategories,
                    ),
                    //SizedBox(width: 10),
                    ButtonCircular(
                        hasDecoration: false,
                        child: Image.asset(
                          "assets/icons/ic_menu_2.png",
                        ),
                        onPressed: () {}),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  DialogCreationGlossa(context).show(
                    onGlossa: () {
                      Navigator.pop(context);
                    },
                    onGlossa2: () {
                      Navigator.pop(context);
                    },
                    onFama: () {
                      Navigator.pop(context);
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Color.fromARGB(166, 0, 0, 0),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Image.asset('assets/icons/ic_gallery.png',
                      width: 18, height: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onRefresh() {
    setState(() {
      listPublications = [];
      PAGE = 0;
      hasMoreToLoad = false;
    });

    _getListPublications(PAGE);
  }

  Future<void> _getListPublications(int page,
      {bool showLoading = true, String idCategories = ''}) async {
    if (showLoading) _streamPublications.sink.add(-1);
    List<PublicationModel> list = [];
    Uri url = Uri.parse('https://jsonplaceholder.typicode.com/photos');
    Response? response = await ApiServices.GET(url: url);
    var body = response != null ? ApiServices.getBody(response) : [];

    // data dake
    for (var item in body) {
      list.add(PublicationModel(
        id: "${item['id']}",
        title: item['title'],
        donation: true,
        desciption: item['title'],
        nameUser: 'name user',
        userCreate: 'user@create.com',
        imageUser: item['title'],
        price: 12.99876789,
        resource: item['title'],
        resources: [
          'https://source.unsplash.com/random?sig=${item['id']}',
          'https://source.unsplash.com/random?sig=${item['id']}',
        ],
      ));
    }

    //por revisar
    setState(() {
      listPublications.addAll(list);
      if (list.isNotEmpty || PAGE == 0) PAGE++;
      if (showLoading) _streamPublications.sink.add(list.length > 0 ? 1 : 0);
      hasMoreToLoad = false;
    });
  }

  Future<void> _getListPublicationForId(String idCategory) async {
    _streamPublications.sink.add(-1);

    List<PublicationModel> list = [];
    list = await PublicationModel.getPublicationForCategories(
        idCategory: idCategory);

    setState(() {
      //listPublications.addAll(list);
      listPublications = list;
      _streamPublications.sink.add(list.length > 0 ? 1 : 0);
      hasMoreToLoad = false;
    });
  }

  // code categories
  getCategories() async {
    if (_listCategories.length < 1) {
      _listCategories = await CategoriesModel.getListCategories();
      setState(() {});
    }

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ListCategories2(
          list: _listCategories,
          onpressed: (index, categories) {
            _categories = categories.id;
            _getListPublicationForId(_categories);

            setState(() {
              categoriesModel = categories;
              _categories_name = categories.name;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future infoPublication(PublicationModel publication) async {
    // _loadingInfo.add(true);
    final email = await SharedPrefs.getString(shared_email);
    final cm = await CommentModel.getComment(publication.id);
    bool myLike = false;
    await PublicationModel.getInfoPublications(publication.id).then((response) {
      if (response != null) {
        final body = ApiServices.getBody(response);
        final int likes = body['like'] ?? 0;
        final List userLike = body['userLike'] ?? [];

        final int saveds = body['numberSave'] ?? 0;

        for (var item in userLike) {
          if (item == email) myLike = true;
        }

        setState(() {
          isLiked = myLike;
          like_count = likes;
          comment_count = cm.length;
          saved_count = saveds;
        });
      }
    });
    // _loadingInfo.add(false);
  }

  Widget buttonOptions(String assets,
      {void Function()? onTap, String? counter, double width: 18}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(assets, width: width),
          if (counter != null)
            Container(
              padding: const EdgeInsets.all(5).copyWith(top: 7),
              child: Text(counter, style: styleMin),
            ),
        ],
      ),
    );
  }

  Widget getUrlImage(
    String url, {
    double radius = 200,
    double size = 50,
    EdgeInsets margin = EdgeInsets.zero,
  }) =>
      Container(
        decoration: decoCircle,
        margin: margin,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.asset(radius > size ? NOT_IMAGE_PROFILE : NOT_IMAGE,
                  fit: BoxFit.cover, width: size, height: size),
            ),
            cacheImageNetwork(url, size: size, radius: radius),
          ],
        ),
      );
}
