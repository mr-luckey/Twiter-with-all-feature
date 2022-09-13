import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/Auth/user_model.dart';
import 'package:kronosss/DialogSheet/dialog_utils.dart';
import 'package:kronosss/Home/HallOfFame/ReelItems/item_comment.dart';
import 'package:kronosss/Home/HallOfFame/comment_model.dart';
import 'package:kronosss/Home/Profile/profile_page.dart';
import 'package:kronosss/Home/Publications/publication_model.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';
import 'package:kronosss/utils.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CommentPubicationPage extends StatefulWidget {
  final PublicationModel? publication;
  CommentPubicationPage({Key? key, this.title = "", this.publication})
      : super(key: key);

  final String title;

  @override
  _CommentPubicationPageState createState() => _CommentPubicationPageState();
}

class _CommentPubicationPageState extends State<CommentPubicationPage> {
  final _stream_loading = StreamController<bool>();
  final scrollDirection = Axis.vertical;
  TextEditingController _ctr_text = TextEditingController();

  String myEMAIL = '';
  bool hasMoreToLoad = false;

  late AutoScrollController controller;
  List<CommentModel> list = [];

  bool enableSend = true, isRespond = false;
  int indexRespond = -1;
  int PAGE = 0;

  @override
  void initState() {
    PAGE = 0;
    hasMoreToLoad = false;
    _ctr_text = TextEditingController();
    _getCommentList();

    // fake
    // list = CommentModel.getListFake();
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    controller.addListener(() {
      if (controller.position.pixels >= controller.position.maxScrollExtent &&
          !hasMoreToLoad) {
        //debugPrint('--------- FINAL LISTO PARA CARGAR  ($PAGE)----------');

        setState(() => hasMoreToLoad = true);
        _getCommentListQuery(isNextPage: true);
      }
    });
    isRespond = false;
    indexRespond = -1;
  }

  @override
  void dispose() {
    _ctr_text.dispose();
    _stream_loading.close();
    controller.dispose();
    super.dispose();
  }

  _getCommentList() async {
    setState(() => PAGE = 0);
    var email = await SharedPrefs.getString(shared_email) ?? '';
    setState(() => myEMAIL = email);
    list = await CommentModel.getComment(widget.publication!.id);
    //print(list.length);
    setState(() => PAGE = 1);
  }

  _getCommentListQuery({bool isNextPage = false}) async {
    var aux = isNextPage ? '?skip=$PAGE' : null;
    var _list =
        await CommentModel.getComment(widget.publication!.id, query: aux);

    print('PAGE: $PAGE - Counter: ${list.length}');
    setState(() {
      if (_list.length > 0) list.addAll(_list);
      PAGE++;
      hasMoreToLoad = true;
    });
  }

  _isRespondComment(bool isResp, int posResp) {
    _scrollToIndex(
        index: posResp, autoScrollPosition: AutoScrollPosition.middle);
    setState(() {
      isRespond = isResp;
      indexRespond = posResp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios_new)),
        backgroundColor: Colors.black,
        actions: [
          Center(
            child: cacheImageNetwork(widget.publication?.resource ?? "",
                size: 40,
                radius: 5,
                margin: EdgeInsets.only(right: 8),
                onTap: () => Utils.dialogBottomGeneral(
                    context: context,
                    isNotImage: true,
                    isNotTitle: true,
                    paddingButtonAdd: true,
                    maxChildSize: 1.0,
                    initialChildSize: 1.0,
                    minChildSize: 1.0,
                    content: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: cacheImageNetwork(
                          widget.publication?.resource ?? "",
                          radius: 5,
                          size: _size.width - 40,
                        ),
                      ),
                    ))),
          ),
          isRespond
              ? IconButton(
                  onPressed: () => _isRespondComment(false, -1),
                  icon: Icon(Icons.cancel))
              : SizedBox(),
        ],
      ),
      body: Container(
        height: _size.height - 135,
        child: ListView.builder(
          scrollDirection: scrollDirection,
          controller: controller,
          itemCount: list.length,
          itemBuilder: (_, index) {
            print(list.length);
            if (list.isEmpty) {
              return Center(
                  child: Text(
                'NO HAY COMETARIOS EN ESTA PUBLICACIÓN',
                style: style.copyWith(fontSize: 20),
              ));
            }
            return AutoScrollTag(
              key: ValueKey(index),
              controller: controller,
              index: index,
              child: Column(
                children: [
                  ItemComment(
                    list[index],
                    onPressed,
                    (pos) {
                      _isRespondComment(true, pos);
                      //Utils.toast(context, "Función no disponible!");
                    },
                    selectedColor: isRespond && index == indexRespond
                        ? Colors.green.withOpacity(0.1)
                        : null,
                    onLongPressed: () {
                      print("borrar $index");
                    },
                    onTapImage: () {
                      if (myEMAIL != list[index].userEmail) {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) =>
                                ProfilePage(userEmail: list[index].userEmail),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomSheet:
          // galeria
          Container(
        color: Colors.black,
        padding: EdgeInsets.only(bottom: 10),
        //height: 56,
        child: Row(
          children: [
            /* IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.image_outlined,
                color: Colorskronoss.green_button,
              ),
            ), */
            SizedBox(width: 10),
            // edittext
            Expanded(
              child: TextField(
                controller: _ctr_text,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                style: style,
                /* onSubmitted: (value) {
                  _onSendText(value);
                }, */
                decoration: InputDecoration(
                  hintText: 'Escribe un comentario...',
                  labelStyle: style,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: style.copyWith(color: Colors.green),
                ),
              ),
            ),
            // enviar
            IconButton(
              color: Colors.white,
              onPressed: enableSend
                  ? () => _onSendText(_ctr_text.text)
                  : () async {
                      await Future.delayed(Duration(seconds: 1));
                      setState(() => enableSend = true);
                    },
              icon: StreamBuilder<bool>(
                  stream: _stream_loading.stream,
                  initialData: false,
                  builder: (context, snapshot) {
                    if (snapshot.data!) {
                      return Container(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSendText(String value) async {
    _stream_loading.sink.add(true);
    setState(() => enableSend = false);
    final json = await SharedPrefs.getString(shared_user) ?? '';
    final model = UserModel.fromStrings(json);
    var user = await SharedPrefs.getString(shared_email) ?? '';
    var userName = await SharedPrefs.getString(shared_name) ?? model['name'];
    var image = await SharedPrefs.getString(shared_image) ?? '';
    if (value.trim().isNotEmpty) {
      //Utils.toast(context, "Enviando...", position: Utils.positionedTop);
      final model = CommentModel(
          id: widget.publication!.id,
          index: list.length,
          message: value,
          userEmail: user,
          userName: userName,
          imageUser: image,
          thread: indexRespond < 0 ? null : list[indexRespond],
          epoch: DateTime.now().millisecondsSinceEpoch ~/ 1000);

      CommentModel.sendComment(model).then((response) {
        if (response != null) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            _isRespondComment(false, -1);
            _ctr_text.clear();
            _getCommentList();
          } else {
            var resp = ApiServices.getBody(response);
            print(resp);
            var msg = resp['message'];
            DialogsUtils(
              context,
              title: 'Envio ha fallado',
              textContent: msg,
            ).showMessageError();
            //Utils.snackBar(context, msg);
          }
        } else {
          DialogsUtils(
            context,
            title: 'Sin respuesta del servidor',
            textContent: 'Ha ocurrido un error, vuelva a intentarlo',
          ).showMessageError();
          /* Utils.toast(
            context,
            'Ha ocurrido un error, vuelva a intentarlo',
            duration: 4000,
            position: Utils.positionedCenter,
            backgroundColor: Colorskronoss.red_snackbar_error,
          ); */
        }
        setState(() => enableSend = true);
      });
    } else {
      /*  Utils.toast(context, 'Escribe un comentario primero...',
          duration: 4000,
          position: Utils.positionedCenter,
          backgroundColor: Colorskronoss.red_snackbar_error.withOpacity(0.6)); */
    }
    _stream_loading.sink.add(false);
  }

  Future _scrollToIndex({
    int index = 0,
    AutoScrollPosition autoScrollPosition = AutoScrollPosition.begin,
  }) async {
    await controller.scrollToIndex(index, preferPosition: autoScrollPosition);
    await controller.highlight(index);
  }

  void onPressed(int p1) {
    print(p1);
    _scrollToIndex(index: p1);
  }
}
