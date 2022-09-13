import 'package:flutter/material.dart';
import 'package:kronosss/DialogSheet/dialog_utils.dart';
import 'package:kronosss/Home/home_page.dart';

class DialogActionReel {
  final BuildContext context;
  final bool isUserCreate;
  final bool hasFollow;
  final List<bool> show_hide;
  final void Function(String)? onSelected;

  DialogActionReel(this.context,
      {this.isUserCreate = false,
      this.hasFollow = false,
      required this.show_hide,
      this.onSelected});

  List<Widget> _generateList(void Function(String)? onSelected,
      [bool isMe = true]) {
    List<Widget> list = [];
    final textFollow = hasFollow ? 'Dejar de seguir' : '';
    final titles = [
      'Descargar recurso',
      show_hide[1] ? 'Información' : '',
      "", //'Compartir en un chat',
      isMe ? '' : textFollow,
      'Copiar enlace',
      "", //'Guardar',
      isMe ? '${show_hide[0] ? "Ocultar" : "Mostrar"} Interacciones' : '',
      isMe ? '${show_hide[1] ? "Ocultar" : "Mostrar"} Información' : '',
      isMe ? '${show_hide[2] ? "Desactivar" : "Activar"} Chat' : '',
      isMe ? '${show_hide[3] ? "Desactivar" : "Activar"} Comentarios' : '',
      isMe ? 'Editar recurso' : "", //'Bloquear',
      isMe ? 'Eliminar recurso' : "", //'Silenciar',
      isMe ? '' : 'Denunciar',
    ];
    final images = [
      "assets/reels/ic_descarga.png",
      'assets/icons/ic_info2.png',
      'assets/reels/ic_shared.png',
      isMe ? 'assets/icons/ic_follow.png' : "assets/icons/ic_unfollow.png",
      "assets/icons/ic_porta.png",
      "assets/reels/ic_saved_full.png",
      isMe ? 'assets/reels/ic_hide.png' : "",
      isMe ? 'assets/reels/ic_hide.png' : "",
      isMe ? 'assets/reels/ic_disabled.png' : "",
      isMe ? 'assets/reels/ic_disabled.png' : "",
      isMe ? 'assets/icons/ic_pencil.png' : "assets/reels/ic_block.png",
      isMe ? 'assets/icons/cancel2.png' : "assets/reels/ic_silent.png",
      isMe ? 'assets/icons/ic_voice.png' : "assets/reels/ic_denuncia.png",
    ];

    for (var i = 0; i < titles.length; i++) {
      Widget row = _rows(
        titles[i],
        images[i],
        onSelected,
        i,
      );

      list.add(row);
    }

    return list;
  }

  Widget _rows(
      String title, String images, void Function(String)? onSelected, i) {
    if (title.isEmpty) return SizedBox();
    return ListTile(
      onTap: () {
        //print('xxx: $title');
        if (onSelected != null) onSelected(title);
      },
      title: Text(title, style: style),
      leading: (images.isNotEmpty)
          ? Image.asset(
              images,
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            )
          : SizedBox(),
    );
  }

  void show() {
    var list = _generateList(onSelected, isUserCreate);
    _showDialogListWidget(
      context,
      onSelected: onSelected,
      isUserCreate: isUserCreate,
      list: list,
    );
  }
}

_showDialogListWidget(
  BuildContext context, {
  required void Function(String)? onSelected,
  required List<Widget> list,
  bool isUserCreate = false,
}) {
  /* DialogsUtils(context).showDialogChildWidget(
      child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      //SizedBox(height: 30),
      ...list,
    ],
  )); */
  // mas altos
  DialogsUtils(context).showDialogScrolletWidget(
      enabledSize: true,
      initialChildSize: isUserCreate ? 0.65 : 0.38,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //SizedBox(height: 30),
          ...list,
        ],
      ));
  // ?????
  /* DialogGenerics(context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 30),
          ...list,
        ],
      )).show2(); */
}
