import 'package:flutter/material.dart';
import 'package:kronosss/DialogSheet/dialog_utils.dart';

class DialogCreationGlossa {
  final BuildContext context;

  DialogCreationGlossa(this.context, [Map<String, dynamic>? data]);

  show({
    void Function()? onFama,
    void Function()? onGlossa,
    void Function()? onGlossa2,
    void Function()? onNFT,
  }) {
    DialogsUtils(context, title: 'Elige el tipo de publicación')
        .showDialogChildWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          ListTile(
            title: Text('NFT'),
            leading: Image.asset(
              'assets/payments/ic_ethereum.png',
              width: 25,
              height: 25,
            ),
            onTap: onNFT,
          ),
          ListTile(
            title: Text('Glossa | 160 Caracteres'),
            leading: Image.asset(
              'assets/icons/ic_glossas.png',
              width: 25,
              height: 25,
            ),
            onTap: onGlossa,
          ),
          ListTile(
            title: Text('Noticia | 2.5K Caracteres'),
            leading: Image.asset(
              'assets/icons/ic_glossas.png',
              width: 25,
              height: 25,
            ),
            onTap: onGlossa2,
          ),
          ListTile(
            title: Text('Fama | Diavasi'),
            leading: Image.asset(
              'assets/icons/ic_menu_1.png',
              width: 25,
              height: 25,
            ),
            onTap: onFama,
          ),
        ],
      ),
    );
    /*  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => Creation2Page())); */
  }
}
