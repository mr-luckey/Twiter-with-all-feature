import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kronosss/Common/compare_extentions.dart';
import 'package:kronosss/Common/loading_view.dart';
import 'package:kronosss/DialogSheet/Creation/dialog_creation_glossa.dart';
import 'package:kronosss/Home/Categories/categories_model.dart';
import 'package:kronosss/Home/Categories/list_categories2.dart';
import 'package:kronosss/Home/Creation/widgets/button_circular.dart';
import 'package:kronosss/Home/HallOfFame/ReelItems/item_reource_grid_hof.dart';
import 'package:kronosss/Home/HallOfFame/ReelItems/item_video_widget.dart';
import 'package:kronosss/Home/HallOfFame/hof_reel_page.dart';
import 'package:kronosss/Home/Profile/profile_model.dart';
import 'package:kronosss/Home/Publications/publication_model.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';
import 'package:kronosss/utils.dart';
// ignore: unused_import
import 'package:provider/provider.dart';

const int crossAxisCount = 2;
final StreamController<int> ctr_fama_list = StreamController<int>.broadcast();

class HoFPage extends StatefulWidget {
  final ScrollController controller;

  HoFPage({required this.controller});

  @override
  State<HoFPage> createState() => _HoFPageState();
}

class _HoFPageState extends State<HoFPage> {
  // ignore: unused_field
  int _indexCategory = -1;
  // ignore: unused_field
  CategoriesModel? _categorySelected;
  List<PublicationModel> listPublications = [];
  List<PublicationModel> listSearch = [];
  String _categories = "";
  // ignore: unused_field
  String _categories_name = "GENERAL";
  late CategoriesModel categoriesModel;
  List<CategoriesModel> _listCategories = [];

  final _streamPublications = StreamController<int>();
  double heightVideo = 100.0;

  var _searchview = new TextEditingController();

  bool hasMoreToLoad = false;
  int PAGE = -1;

  final _deco = BoxDecoration(
    borderRadius: BorderRadius.circular(80),
    color: Colors.black,
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

  // ignore: unused_field
  bool _firstSearch = true;
  String _query = "";

  _HoFPageState() {
    //Register a closure to be called when the object changes.
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        //Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearch = true;
          _query = "";
          listSearch = [];
        });
      } else {
        for (PublicationModel item in listPublications) {
          var tt = item.title.toLowerCase();
          var dd = item.desciption.toLowerCase();
          var qq = _query.toLowerCase();
          if (tt.contains(qq) || dd.contains(qq)) {
            listSearch.add(item);
          }
        }
        // HERE get api publications
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
          print(_query);
        });
      }
    });
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
  void initState() {
    categoriesModel = CategoriesModel(
      id: '',
      name: 'General',
      icon:
          'http://192.99.167.185:5000/uploads/categories/0.6607388104691143-40.png',
    );
    getGeneralCategory();
    // here inizialice
    ProfileModel.getProfile().then((value) {
      //
    });
    PAGE = 0;
    hasMoreToLoad = false;
    _getListPublications(PAGE);
    widget.controller.addListener(() {
      if (widget.controller.position.pixels >=
              widget.controller.position.maxScrollExtent &&
          !hasMoreToLoad) {
        //debugPrint('--------- FINAL LISTO PARA CARGAR  ($PAGE)----------');

        setState(() => hasMoreToLoad = true);
        _getListPublications(PAGE, showLoading: false);
      }
    });
    super.initState();
    ctr_fama_list.stream.listen((_) {
      debugPrint('UPDATE!!!');
      onRefresh();
    });
  }

  Future<void> _getListPublications(int page, {bool showLoading = true}) async {
    if (showLoading) _streamPublications.sink.add(-1);
    List<PublicationModel> list = [];
    list = await PublicationModel.getPublications(page: page);

    // data dake
    /* for (var i = 0; i < 10; i++) {
      list.add(PublicationModel(
          id: "1234567",
          title: "ice",
          donation: true,
          desciption: "test dialog",
          nameUser: 'name user',
          userCreate: 'user@create.com',
          price: 12.99876789,
          resource: 'https://source.unsplash.com/random?sig=$i'));
    } */

    //por revisar
    setState(() {
      listPublications.addAll(list);
      if (list.isNotEmpty || PAGE == 0) PAGE++;
      if (showLoading) _streamPublications.sink.add(list.length > 0 ? 1 : 0);
      hasMoreToLoad = false;
    });
  }

  // ignore: unused_element
  Future<List<PublicationModel>> _getListPublicationsQuery(String query) async {
    _streamPublications.sink.add(-1);

    List<PublicationModel> list = [];
    list = await PublicationModel.getListPublicationForText(query: query);

    /* setState(() {
      listSearch.addAll(list);
      _streamPublications.sink.add(list.length > 0 ? 1 : 0);
      hasMoreToLoad = false;
    }); */
    return list;
  }

  Future<void> _getListPublicationForId(String idCategory) async {
    _streamPublications.sink.add(-1);

    List<PublicationModel> list = [];
    list = await PublicationModel.getPublicationForCategories(
        idCategory: idCategory);

    setState(() {
      listPublications.addAll(list);
      _streamPublications.sink.add(list.length > 0 ? 1 : 0);
      hasMoreToLoad = false;
    });
  }

  @override
  void dispose() {
    // close
    // ignore: unnecessary_null_comparison
    if (ctr_fama_list != null) ctr_fama_list.close();
    _streamPublications.close();
    super.dispose();
  }

  void onRefresh() {
    setState(() {
      listPublications = [];
      PAGE = 0;
      hasMoreToLoad = false;
    });

    _getListPublications(PAGE);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final showSearch = true;
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    //final size = MediaQuery.of(context).size;
    //final _colorIcon = Colors.white;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colorskronoss.background_application_dark,
        body: Stack(
          children: [
            CustomScrollView(
              controller: widget.controller,
              slivers: [
                // appbar
                SliverList(
                  delegate: SliverChildListDelegate([SizedBox(height: 51)]),
                ),
                // lista
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      //...TOP_WIDGET(_size, _colorIcon),
                      StreamBuilder<int>(
                          stream: _streamPublications.stream,
                          initialData: -1,
                          builder: (context, snap) {
                            if (snap.data == -1) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                alignment: Alignment.center,
                                child: LoadingView(),
                              );
                            } else if (snap.data == 0) {
                              var cat = _categorySelected?.name ?? "";
                              var aux_cat = cat.isEmpty ? cat : '\nde "$cat"';
                              return Container(
                                margin: EdgeInsets.only(top: 50),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('No Hay Publicaciones $aux_cat',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        )),
                                    GestureDetector(
                                      child: Container(
                                        decoration: _deco,
                                        margin: const EdgeInsets.all(10.0),
                                        padding: const EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.refresh,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: onRefresh,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              if (!_firstSearch) {
                                return listDataView(listSearch);
                              }
                              return listDataView(listPublications);
                            }
                          }),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([SizedBox(height: 46)]),
                ),
              ],
            ),
            SizedBox(
              height: 51,
              child: appbarTrans(
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
            Positioned(
              bottom: 60,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  DialogCreationGlossa(context).show(
                    onNFT: () {
                      Navigator.pop(context);
                      /* Navigator.of(context)
                          .push(CupertinoPageRoute(
                              builder: (context) => CryptoWalletCreate()))
                          .then((value) {
                        if (value != null) onRefresh();
                      }); */
                    },
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
              /*  child: ButtonCircular(
                child: Image.asset('assets/icons/ic_gallery.png',
                    width: 25, height: 25),
                    onPressed: (){

                    },
              ), */
            ),
          ],
        ),
      ),
    );
  }

  Widget listDataView(List<PublicationModel> list) {
    return StaggeredGridView.countBuilder(
      staggeredTileBuilder: (index) =>
          StaggeredTile.fit(1), //cross axis cell count
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 0, // vertical spacing between items
      crossAxisSpacing: 8, // horizontal spacing between items
      crossAxisCount: 2, // no. of virtual columns in grid
      itemCount: list.length + 1,
      itemBuilder: (context, index) {
        if (index == list.length) {
          return SizedBox(height: 46);
        } else {
          if (listPublications[index].resource.isEmpty) {
            return Container(
              child: SizedBox(height: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 300,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(CupertinoPageRoute(
                        builder: (c) => HofReelScreen(
                              listPublications: listPublications,
                              page: PAGE,
                              index: index,
                            )))
                    .then((value) async {
                  var toEliminateHOF =
                      await SharedPrefs.getString('toEliminateHOF') ?? '';
                  if (toEliminateHOF.isNotEmpty) {
                    for (var item in listPublications) {
                      if (item.id == toEliminateHOF) {
                        listPublications.remove(item);
                        await SharedPrefs.setString('toEliminateHOF', '');
                        break;
                      }
                    }
                    setState(() {});
                  }
                  print(' return reels $value');
                });
              },
              child: Container(
                // clip the image to a circle
                //padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: deco8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ItemResourceGridHoF(
                      src: list[index].resource, fit: BoxFit.cover),
                  //child: _image(list[index].resource, BoxFit.cover),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // ignore: unused_element
  Widget _image(String src, BoxFit fit) {
    if (CompareExtentionsFiles.isAudio(src)) {
      return SizedBox(
        height: 100,
        width: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              'assets/ic_front_audio.png',
              color: Colors.black,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Icon(
                Icons.audio_file_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
          ],
        ),
      );
    } else if (CompareExtentionsFiles.isVideo(src)) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: heightVideo,
          maxHeight: heightVideo,
        ),
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              ItemVideo(
                //'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
                src,
                getAspectRatio: (ar) {
                  //debugPrint('aspectRatio: $ar');
                  Utils.getScaleFromSize(ar.size);
                  setState(() {
                    heightVideo = ar.size.height;
                  });
                },
              ),
              /* ItemVideoReel(
                src,
                isEnableVolume: false,
                keepAspectRatio: false,
                showIcons: false,
                aspectRatio: 20 / 9,
              ), */
              Image.asset(
                'assets/ic_front_audio.png',
                color: Colors.black12,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  Icons.local_movies_sharp,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 300,
        ),
        child: CachedNetworkImage(
          imageUrl: src,
          errorWidget: (context, url, error) => Image.network(
            src,
            fit: BoxFit.cover,
            errorBuilder: (_, o, t) => SizedBox() /* Image.asset(NOT_IMAGE) */,
          ),
          fit: fit,
        ),
      );
    }
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
  //----
}
