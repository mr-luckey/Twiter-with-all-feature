import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_textfield/flutter_social_textfield.dart';
import 'package:kronosss/Common/compare_extentions.dart';
import 'package:kronosss/Home/HallOfFame/ReelItems/item_reel_manager.dart';
import 'package:kronosss/Home/HallOfFame/reel_screen.dart';
import 'package:kronosss/Home/Publications/publication_model.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/mConstants.dart';

class ItemGridHomeHof extends StatefulWidget {
  final int index;
  final PublicationModel model;
  final Function()? onPressed;
  final Function()? onLongPressed;
  const ItemGridHomeHof(
      {required this.index,
      required this.model,
      this.onPressed,
      this.onLongPressed,
      Key? key})
      : super(key: key);

  @override
  _ItemGridHomeHofState createState() => _ItemGridHomeHofState();
}

class _ItemGridHomeHofState extends State<ItemGridHomeHof> {
  var _textEditingController = SocialTextEditingController();
  late final StreamSubscription<SocialContentDetection> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _textEditingController = SocialTextEditingController()
      ..text = widget.model.desciption
      ..setTextStyle(DetectedType.mention, Colorskronoss.styleMention)
      ..setTextStyle(DetectedType.hashtag, Colorskronoss.styleHashtag)
      ..setTextStyle(DetectedType.url,
          TextStyle(color: Colors.blue, decoration: TextDecoration.underline));

    //Subscribe to events
    _streamSubscription =
        _textEditingController.subscribeToDetection(onDetectContent);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  void onDetectContent(SocialContentDetection detection) {
    if (detection.type == DetectedType.mention) {
      // AQUI LIBRE DE HACER LO QUE QUIERA CON EL CLICK
      debugPrint("click en ${detection.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final i = widget.index;

    return GestureDetector(
      onLongPress: widget.onLongPressed ?? () {},
      onTap: widget.onPressed ??
          () {
            print("object #$i");
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (c) => Reel2Screen(
                  widget.model,
                ),
              ),
            );
          },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.white24,
                  offset: Offset(-1, 1),
                  blurRadius: 1.0,
                ),
                BoxShadow(
                  color: Colors.white24,
                  offset: Offset(1, 3),
                  blurRadius: 1.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: widget.model.resource.isEmpty
                  ? SizedBox()
                  : ItemReelManagerScreen(
                      src: widget.model.resource,
                      isEnableVolume: false,
                      isExpandImage: true,
                      isCaratulaAudio: true,
                      isCaratulaVideo: true,
                    ),
            ),
          ),
          //title
          /*  if (widget.model.title.trim().isNotEmpty)
            Positioned(
              top: 2.5,
              left: 2.5,
              child: Container(
                  padding: EdgeInsets.all(3),
                  margin: EdgeInsets.zero,
                  //width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colorskronoss.black_semi_transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        //topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      )),
                  child: Text(widget.model.title,
                      style: style.copyWith(fontSize: 10))),
            ) */
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _itemResource(String src) {
    if (CompareExtentionsFiles.isVideo(src) ||
        CompareExtentionsFiles.isAudio(src)) {
      return Container(
        color: Colorskronoss.background_application_dark,
        child: Center(
          child: Icon(
              CompareExtentionsFiles.isAudio(src)
                  ? Icons.audio_file
                  : Icons.play_arrow,
              size: 35,
              color: Colors.white),
        ),
      );
    } else {
      return cacheImageNetwork(
        src,
        fit: BoxFit.cover,
        size: double.infinity,
        assetError: NOT_IMAGE,
        colorBG: Colors.transparent,
        padding: EdgeInsets.zero,
        radius: 7,
      );
    }
  }
}
