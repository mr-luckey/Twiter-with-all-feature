import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kronosss/Common/compare_extentions.dart';
import 'package:kronosss/DialogSheet/Reels/dialog_actions_reel.dart';
import 'package:kronosss/DialogSheet/dialog_download.dart';
import 'package:kronosss/DialogSheet/dialog_utils.dart';
import 'package:kronosss/Home/HallOfFame/Pages/comment_publication_pages.dart';
import 'package:kronosss/Home/HallOfFame/ReelItems/item_reource_grid_hof.dart';
import 'package:kronosss/Home/HallOfFame/Widgets/rich_text.widget.dart';
import 'package:kronosss/Home/HallOfFame/comment_model.dart';
import 'package:kronosss/Home/HallOfFame/complaint_reel_screen.dart';
import 'package:kronosss/Home/HallOfFame/details_reel_screen.dart';
import 'package:kronosss/Home/Profile/profile_page.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/apiServices.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';
import 'package:kronosss/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:kronosss/Home/Publications/publication_model.dart';
import 'package:kronosss/Home/Profile/profile_model.dart';

import '../reel_screen.dart';

class GlossaItem extends StatefulWidget {
  final PublicationModel publication;
  final bool isLiked;

  final void Function()? onTapValoration;
  final void Function()? onTapComment;
  final void Function()? onTapGlossear;
  final void Function()? onTapLike;
  final void Function()? onTapShare;

  const GlossaItem(
      {required this.publication,
      this.onTapComment,
      this.onTapGlossear,
      this.onTapLike,
      this.onTapShare,
      this.isLiked = false,
      this.onTapValoration,
      Key? key})
      : super(key: key);

  @override
  State<GlossaItem> createState() => _GlossaItemState();
}

class _GlossaItemState extends State<GlossaItem> {
  late PublicationModel publication;
  List<bool> show_hide = [true, true, false, true];
  late ProfileModel profile;
  bool hasShort = true, isLiked = false;

  int counter_valoration = 0,
      counter_comment = 0,
      counter_like = 0,
      counter_glossear = 0;

  @override
  void initState() {
    publication = widget.publication;
    isLiked = widget.isLiked;
    profile = ProfileModel(
      name: 'User Demo',
      nickname: 'userDemo',
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSppkoKsaYMuIoNLDH7O8ePOacLPG1mKXtEng&usqp=CAU',
    );
    super.initState();
    // infoPublication();
  }

  Future infoPublication() async {
    final email = await SharedPrefs.getString(shared_email);
    final cm = await CommentModel.getComment(widget.publication.id);
    bool myLike = false;
    await PublicationModel.getInfoPublications(widget.publication.id)
        .then((response) {
      if (response != null) {
        final body = ApiServices.getBody(response);
        final int likes = body['like'] ?? 0;
        final List userLike = body['userLike'] ?? [];

        // ignore: unused_local_variable
        final int saveds = body['numberSave'] ?? 0;

        for (var item in userLike) {
          if (item == email) myLike = true;
        }

        setState(() {
          publication.like = likes;
          publication.comment = cm.length;
          publication.like = likes;
          isLiked = myLike;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cates = publication.categories ?? [];
    counter_valoration = publication.valoracion;
    counter_comment = publication.comment;
    counter_like = publication.like;
    counter_glossear = 0;

    return ListView(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.all(22).copyWith(bottom: 0),
      children: [
        // users
        Row(
          children: [
            // user - image
            GestureDetector(
              child: cacheImageNetwork(
                profile.image,
                size: 41,
                assetError: NOT_IMAGE_PROFILE,
              ),
              onTap: funOpenProfile,
            ),
            SizedBox(width: 10),
            // user name and nick
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width - 100,
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: size.width * 0.5 - 50,
                          ),
                          child: Text(
                            profile.name,
                            style: style16H,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onTap: funOpenProfile,
                      ),
                      Spacer(),
                      if (cates.isNotEmpty)
                        Container(
                          height: 30,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 10, top: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: decoCircle,
                          child: Text(cates.first['name'].toString(),
                              style: style14),
                        ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => funSettings(publication),
                        child: Image.asset(
                          'assets/reels/ic_settings.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width - 100,
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Text('@${profile.nickname}', style: style16),
                        onTap: funOpenProfile,
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        // description && mention
        if (publication.desciption.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 12),
            padding: const EdgeInsets.only(left: 21, right: 1),
            child: RichTextWidget(
              text: publication.desciption,
              styleDefault: style17,
              onTap: () => setState(() => hasShort = !hasShort),
            ),
          ),
        // icons
        SizedBox(height: 20),
        // resource
        GestureDetector(
          child: getWidgetResource(publication, size),
          onTap: funOpenReel,
        ),
        // views
        if (publication.views > 0)
          Container(
            margin: EdgeInsets.only(left: 21, top: 10, right: 10),
            child: Text('${publication.views} Views', style: style12),
          ),
        Container(
          padding: const EdgeInsets.only(left: 9),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: buttonOptions("assets/reels/ic_valoration_full.png",
                    counter: counter_valoration.toString(),
                    onTap: funValoration),
              ),
              Expanded(
                child: buttonOptions("assets/reels/ic_comments_full.png",
                    counter: Utils.numberEngeenerFormat(counter_comment),
                    onTap: funComment),
              ),
              Expanded(
                child: buttonOptions("assets/icons/ic_glossear.png",
                    counter: Utils.numberEngeenerFormat(counter_glossear),
                    onTap: widget.onTapGlossear),
              ),
              Expanded(
                child: buttonOptions("assets/reels/ic_like_full.png",
                    colorIcon: isLiked ? Colors.red : Colors.green,
                    counter: Utils.numberEngeenerFormat(counter_like),
                    onTap: funLike),
              ),
              Expanded(
                child: buttonOptions(
                  "assets/reels/ic_shared.png",
                  onTap: funShared,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.grey[900],
          width: size.width,
          height: 1,
        ),
      ],
    );
  }

  funValoration() {
    //DialogValoration(context, title: 'Valoración').show();
  }

  funShared() {
    var value = Constants.urlBase + '/' + publication.id;
    if (value.isNotEmpty) {
      print("Copiado: $value");
      Clipboard.setData(ClipboardData(text: value));
      /* Utils.toast(
        context,
        "Copiado al portapapeles.",
        position: Utils.positionedCenter,
      ); */
      Share.share('check out my pubication $value',
          subject: 'Look what I made!');
    } else {
      /* Utils.toast(
            context,
            "No hay nada que copiar.",
            backgroundColor: Colors.red,
            duration: 4000,
            position: Utils.positionedCenter,
          ); */
    }
  }

  funComment() {
    //
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => CommentPubicationPage(publication: publication),
      ),
    );
  }

  funLike() async {
    var body = {"like": 0};
    if (isLiked) {
      body = {"like": -1};
    } else {
      body = {"like": 1};
    }
    //var mEmail = await SharedPrefs.getString(shared_email) ?? '';
    //var body = {"like": 1};

    // like by publication
    var resp = await PublicationModel.infoPublications(body, publication.id);
    if (resp != null) {
      print('TU LIKE/DISLIKE COMPLETO');
      infoPublication();
    } else {
      print('TU LIKE FALLO');
      /* Utils.toast(
            context,
            'No se guardo el like...',
            position: Utils.positionedCenter,
          ); */
    }
  }

  funOpenProfile() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ProfilePage(userEmail: publication.userCreate),
      ),
    );
  }

  funOpenReel() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => Reel2Screen(publication),
      ),
    );
  }

  Widget getWidgetResource(PublicationModel publication, Size size) {
    if (CompareExtentionsFiles.isImage(publication.resource))
      return Container(
        margin: EdgeInsets.only(left: 21),
        constraints: BoxConstraints(
          maxHeight: size.height * 0.50,
          maxWidth: size.width,
        ),
        decoration: deco20,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: publication.resource,
            placeholder: (context, url) {
              return SizedBox();
            },
            errorWidget: (context, url, error) => Image.network(
              publication.resource,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, o, t) =>
                  SizedBox() /* Image.asset(NOT_IMAGE) */,
            ),
          ),
        ),
      );
    if (CompareExtentionsFiles.isVideo(publication.resource))
      return ItemResourceGridHoF(
        src: publication.resource,
        fit: BoxFit.contain,
      );
    return SizedBox();
  }

  Widget buttonOptions(String assets,
      {void Function()? onTap,
      String? counter,
      double width: 15,
      Color? colorIcon,
      EdgeInsets? paddingExtra}) {
    return MaterialButton(
      onPressed: onTap,
      color: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(assets, width: width, color: colorIcon ?? Colors.green),
          if (counter != null)
            Container(
              padding: const EdgeInsets.all(4).copyWith(top: 7),
              child: Text(counter, style: styleMin),
            ),
        ],
      ),
    );
  }

  funSettings(PublicationModel publication) async {
    final loginID = await SharedPrefs.getString(shared_email) ?? '';
    final createID = publication.userCreate;
    bool isUserCreated = loginID == createID;
    final hasFollow = await ProfileModel.getFollowToEmail(createID);
    print(hasFollow);
    DialogActionReel(
      context,
      isUserCreate: isUserCreated,
      hasFollow: hasFollow,
      show_hide: show_hide,
      onSelected: (pos) async {
        Navigator.of(context).pop();
        switch (pos) {
          case 'Descargar recurso': // descargar recurso
            debugPrint('descargar');
            DialogDownLoad(
                    context, publication.resources?[0] ?? publication.resource)
                .show();

            break;
          case 'Información':
            debugPrint('Información');
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => DetailsReelScreen(
                  publication: publication,
                ),
              ),
            );
            break;
          case 'Dejar de seguir':
            debugPrint('seguir');
            break;
          case 'Ocultar Interacciones':
          case 'Mostrar Interacciones':
            var body = {
              "configurations": {
                "view": !show_hide[0],
                "info": show_hide[1],
                "chat": show_hide[2],
                "comment": show_hide[3],
              }
            };
            //setState(() => show_hide[0] = !show_hide[0]);

            PublicationModel.enabledDataPublication(publication.id, body)
                .then((hasRespOk) {
              if (hasRespOk) setState(() => show_hide[0] = !show_hide[0]);
            });
            debugPrint('Ocultar views');
            break;
          case 'Ocultar Información':
          case 'Mostrar Información':
            var body = {
              "configurations": {
                "view": show_hide[0],
                "info": !show_hide[1],
                "chat": show_hide[2],
                "comment": show_hide[3],
              }
            };
            //setState(() => show_hide[1] = !show_hide[1]);
            PublicationModel.enabledDataPublication(publication.id, body)
                .then((hasRespOk) {
              if (hasRespOk) setState(() => show_hide[1] = !show_hide[1]);
            });
            debugPrint('Ocultar info');
            break;
          case 'Desactivar Chat':
          case 'Activar Chat':
            var body = {
              "configurations": {
                "view": show_hide[0],
                "info": show_hide[1],
                "chat": !show_hide[2],
                "comment": show_hide[3],
              }
            };
            //setState(() => show_hide[2] = !show_hide[2]);
            PublicationModel.enabledDataPublication(publication.id, body)
                .then((hasRespOk) {
              if (hasRespOk) setState(() => show_hide[2] = !show_hide[2]);
            });
            debugPrint('Desactivar Chat');
            break;
          case 'Desactivar Comentarios':
          case 'Activar Comentarios':
            var body = {
              "configurations": {
                "view": show_hide[0],
                "info": show_hide[1],
                "chat": show_hide[2],
                "comment": !show_hide[3],
              }
            };
            //setState(() => show_hide[3] = !show_hide[3]);
            PublicationModel.enabledDataPublication(publication.id, body)
                .then((hasRespOk) {
              if (hasRespOk) setState(() => show_hide[3] = !show_hide[3]);
            });
            debugPrint('Desactivar Comentarios');
            break;
          case 'Copiar enlace':
            debugPrint('Copiar enlace');
            funCopyClipboard();
            break;
          case 'Editar recurso':
            debugPrint('edicion');
            /* Navigator.of(context)
                .push(CupertinoPageRoute(
              builder: (context) => PublicationEditPage(model: publication),
            ))
                .then((value) {
              //if (value != null) Navigator.of(context).pop();
            }); */
            break;
          case 'Eliminar recurso':
            debugPrint('Eliminar recurso');
            funDeletePublication(publication);
            break;
          case 'Denunciar':
            debugPrint('Denunciar');
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => ComplaintReelScreen(
                publication: publication,
              ),
            ));
            break;
          default:
        }
      },
    ).show();
  }

  void funCopyClipboard() {
    var value = Constants.urlBase + '/' + publication.id;
    if (value.isNotEmpty) {
      print("Copiado: $value");
      Clipboard.setData(ClipboardData(text: value));
      /*  Utils.toast(
        context,
        "Copiado al portapapeles.",
        position: Utils.positionedBottom,
        //duration: 2700,
      ); */
    }
  }

  void funDeletePublication(PublicationModel publication) {
    debugPrint('BORRAR => ${publication.id}');
    DialogsUtils(context,
            title: 'BORRAR PUBLICACIÓN',
            textContent: '¿Está seguro que desea borrar esta publicación?')
        .showMessageError(
            width: MediaQuery.of(context).size.width * 0.9,
            strCancel: 'Elimina',
            onCancel: () async {
              PublicationModel.deletePublication(publication.id)
                  .then((value) async {
                if (value) {
                  await SharedPrefs.setString('toEliminateHOF', publication.id);
                  Navigator.of(context).pop();
                }
              });
              Navigator.of(context).pop();
            });
  }
}
