import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/Home/Profile/profile_model.dart';
import 'package:kronosss/Home/Profile/profile_page.dart';
import 'package:kronosss/Home/Publications/publication_model.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/mShared.dart';

import '../../home_page.dart';

class OptionScreenReel extends StatefulWidget {
  const OptionScreenReel(
      {required this.publication,
      required this.description,
      this.enableButton = true,
      this.title = '',
      this.hasHastags = false,
      this.hasUbication = false,
      Key? key})
      : super(key: key);

  final PublicationModel publication;
  final bool enableButton;
  final String title;
  final String description;
  final bool hasUbication;
  final bool hasHastags;

  @override
  State<OptionScreenReel> createState() => _OptionScreenReelState();
}

class _OptionScreenReelState extends State<OptionScreenReel> {
  bool isOpen = false, follow = false, isMe = false, openDesp = false;
  late int length;
  double addHeigth = 0;

  late PersistentBottomSheetController bottomSheetController;

  TextOverflow? textOverflow = TextOverflow.clip;
  int? maxLine = 2;

  @override
  void initState() {
    super.initState();
    shared();
    length = widget.description.length;
    final double a1 = widget.hasUbication ? 10 : 0;
    final double a2 = widget.hasHastags ? 10 : 0;
    addHeigth = a1 + a2;
  }

  void shared() async {
    var email = widget.publication.userCreate;
    await ProfileModel.getFollowToEmail(email).then((value) {
      debugPrint('Is Follow: $value');
      setState(() => follow = value);
    });
    var myEmail = await SharedPrefs.getString(shared_email) ?? '';
    setState(() {
      isMe = myEmail.isNotEmpty && (email != myEmail);
    });
  }

  void openned() => setState(() => isOpen = !isOpen);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: !widget.enableButton
          ? null
          : () {
              openned();

              if (isOpen &&
                  (widget.description.split("\n").length > 3 || length > 99)) {
                bottomSheetController = showBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (ctx) {
                      return MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          bottomSheetController.close();
                        },
                        child: Container(
                          //height: size.height * 0.8,
                          width: size.width,
                          padding: EdgeInsets.only(
                              left: 10, right: 50, bottom: 35 + addHeigth),
                          margin: EdgeInsets.only(
                              top: size.height * 0.15, right: 10),
                          child: SingleChildScrollView(
                            child: _content(),
                          ),
                        ),
                      );
                    });
                bottomSheetController.closed.then((value) {
                  openned();
                });
              } else {
                // Navigator.of(context).pop();
                openned();
              }
            },
      child: isOpen
          ? SizedBox()
          : Container(
              width: size.width,
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(right: 10),
              /* decoration: BoxDecoration(
                color: Color.fromARGB(12, 0, 0, 0),
              ), */
              child:
                  _content(/* textOverflow: TextOverflow.clip, maxLine: 2 */),
            ),
    );

    return Container(
      padding: EdgeInsets.all(5),
      child: _content(),
    );
  }

  goProfile() async {
    //Utils.toast(context, 'Funcion no disponible');
    var email = widget.publication.userCreate;
    var myEmail = await SharedPrefs.getString(shared_email) ?? '';

    if (email != myEmail) {
      debugPrint('no soy yo');
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => ProfilePage(
            userEmail: email,
            isShowBack: true,
            isShowSecundary: false,
          ),
        ),
      );
    }
  }

  Widget _content() {
    final size = MediaQuery.of(context).size;
    final description = widget.description.trim();
    //final hashtags = widget.publication.hashtags ?? [];

    textOverflow = openDesp ? null : TextOverflow.ellipsis;
    maxLine = openDesp ? null : 2;

    return AnimatedContainer(
      duration: Duration(milliseconds: 700),
      constraints: BoxConstraints(maxHeight: size.height * 0.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //info profile
          Row(
            children: [
              GestureDetector(
                onTap: goProfile,
                child: Stack(
                  children: [
                    Image.asset(NOT_IMAGE_PROFILE, width: 30, height: 30),
                    cacheImageNetwork(
                      widget.publication.imageUser,
                      size: 30,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
              GestureDetector(
                onTap: goProfile,
                child: ContainerBGDecoration(
                  padding: EdgeInsets.all(5).copyWith(right: 2, left: 7),
                  child: Text(
                    widget.publication.nameUser,
                    style: style.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (isMe && follow) SizedBox(width: 5),
              if (isMe && follow)
                GestureDetector(
                  onTap: isOpen
                      ? () {}
                      : () {
                          //debugPrint(follow  ? "voy a dejar de seguir" : "voy a seguirlo");
                          setState(() => follow = !follow);
                          ProfileModel.putFollow(
                              widget.publication.userCreate, follow);
                        },
                  child: ContainerBGDecoration(
                    padding: EdgeInsets.all(6.3),
                    child: Text('Seguir', style: style13H),
                  ),
                ),
              Spacer(),
            ],
          ),
          // title and description
          ContainerBGDecoration(
            margin: EdgeInsets.only(top: 7.5),
            padding: EdgeInsets.all(5),
            constraints: BoxConstraints(maxHeight: size.height * 0.6),
            noDecoration: description.isEmpty,
            noEdgeInsets: description.isEmpty,
            child: ListView(
              shrinkWrap: true,
              children: [
                // Titulo
                /*  if (widget.title.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: 5, top: 5),
                      child: Wrap(
                        children: [
                          Text(
                            widget.title,
                            style: style.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.black12,
                                    offset: Offset(-1, 1),
                                    //blurRadius: 2.0,
                                  ),
                                  Shadow(
                                    color: Colors.black12,
                                    offset: Offset(1, -1),
                                    //blurRadius: 2.0,
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ), */
                // Descripcion
                if (description.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => openDesp = !openDesp),
                    child: Wrap(
                      children: [
                        Text(
                          description,
                          style: style.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                color: Colors.black12,
                                offset: Offset(-1, 1),
                                //blurRadius: 1.0,
                              ),
                              Shadow(
                                color: Colors.black12,
                                offset: Offset(1, -1),
                                //blurRadius: 1.0,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.start,
                          overflow: textOverflow,
                          maxLines: maxLine,
                        ),
                      ],
                    ),
                  ),
                if (openDesp) SizedBox(height: 10),
                if (openDesp)
                  Wrap(
                    children: [
                      for (var item in widget.publication.hashtags ?? [])
                        Container(
                          padding: const EdgeInsets.only(
                              top: 2, bottom: 2, right: 5),
                          child: Text('#$item'),
                        )
                    ],
                  ),
              ],
            ),
          ),
          /* SizedBox(height: 2),
          Wrap(
            children: [
              for (var item in hashtags)
                Container(
                  decoration: _deco(Colors.black26),
                  margin: EdgeInsets.all(1.5),
                  child: Container(
                    decoration: _deco(Colors.white12),
                    padding: EdgeInsets.all(3),
                    child: Text('# $item', style: styleMin),
                  ),
                )
            ],
          ), */
        ],
      ),
    );
  }
}
