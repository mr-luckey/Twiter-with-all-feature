import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kronosss/Common/compare_extentions.dart';
import 'package:kronosss/Home/HallOfFame/ReelItems/item_video_widget.dart';
import 'package:kronosss/Home/home_page.dart';

class ItemResourceGridHoF extends StatefulWidget {
  final String src;
  final BoxFit fit;

  ItemResourceGridHoF({required this.src, required this.fit});

  @override
  State<ItemResourceGridHoF> createState() => _ItemResourceGridHoFState();
}

class _ItemResourceGridHoFState extends State<ItemResourceGridHoF> {
  double heightVideo = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _image(widget.src, widget.fit),
    );
  }

  Widget _image(String src, BoxFit fit) {
    if (CompareExtentionsFiles.isAudio(src)) {
      return SizedBox(
        height: 100,
        width: double.infinity,
        child: Stack(
          children: [
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
                  //Utils.getScaleFromSize(ar.size);
                  setState(() {
                    heightVideo = ar.size.height > 300 ? 300 : ar.size.height;
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: src,
              errorWidget: (context, url, error) => Image.network(
                src,
                fit: BoxFit.cover,
                errorBuilder: (_, o, t) =>
                    SizedBox() /* Image.asset(NOT_IMAGE) */,
              ),
              fit: fit,
            ),
            Positioned(
              top: 5,
              left: 5,
              child: childText(''),
            ),
          ],
        ),
      );
    }
  }

  Widget childText(String text) {
    final child = Text(text, style: styleMin);
    final padding = EdgeInsets.symmetric(horizontal: 5, vertical: 2.5);
    final borderRadius = BorderRadius.circular(9999);
    if (text.isEmpty) return SizedBox();
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: borderRadius,
          ),
          padding: padding,
          child: child,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: borderRadius,
          ),
          padding: padding,
          child: child,
        ),
      ],
    );
  }
}
