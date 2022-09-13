import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:kronosss/mConstants.dart';
import 'package:kronosss/utils.dart';

class ImageNetworkWidgets extends StatefulWidget {
  ImageNetworkWidgets({
    required this.src,
    this.boxfit,
    this.placeHolderImage = LOADING_GIF2,
    this.width = 100.0,
    this.height = 100.0,
    this.sizeIconError = 40.0,
    this.isExpand = false,
    this.resolution,
  });

  final String src;
  final String placeHolderImage;
  final double width;
  final double height;
  final double sizeIconError;
  final BoxFit? boxfit;
  final bool isExpand;
  final Size? resolution;

  @override
  _ImageNetworkWidgetsState createState() => _ImageNetworkWidgetsState();
}

class _ImageNetworkWidgetsState extends State<ImageNetworkWidgets> {
  String? src = '';
  String placeHolderImage = '';
  late double width;
  late double height;
  late double sizeIconError;
  late BoxFit fit;

  @override
  void initState() {
    super.initState();
    fit = widget.boxfit ?? BoxFit.contain;
    src = widget.src;
    width = widget.width;
    height = widget.height;
    sizeIconError = widget.sizeIconError;
  }

  // lo quito si no funciona con la carga inicial (carga demasiado larga)
  // tambien quito el FutureBuilder<BoxFit>
  Future<BoxFit> getDimention() async {
    if (widget.isExpand) return BoxFit.cover;
    try {
      var size = await Utils.getSizeFromImage(widget.src, debug: false);

      var _scale = Utils.getScaleFromSize(size, debug: false);
      var scaleDouble = _scale[0] >= _scale[1];
      //print('valueeeee: $scaleDouble');
      fit = (scaleDouble ? BoxFit.contain : BoxFit.cover);
      return fit;
    } catch (_) {
      return BoxFit.cover;
    }
  }

  BoxFit getOriginDimen(Size size) {
    var _scale = Utils.getScaleFromSize(size);
    var scaleDouble = _scale[0] >= _scale[1];
    fit = (scaleDouble ? BoxFit.contain : BoxFit.cover);
    return fit;
  }

  Widget _image(String src, BoxFit fit) {
    return CachedNetworkImage(
      imageUrl: src,
      /* placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()), */
      errorWidget: (context, url, error) => Image.network(
        src,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, o, t) => SizedBox() /* Image.asset(NOT_IMAGE) */,
      ),
      width: width - 2,
      height: height - 2,
      fit: fit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BoxFit>(
        future: getDimention(),
        initialData: BoxFit.cover,
        builder: (context, snap) {
          //return imageOld(snap);
          return _image(
            src ?? NOT_IMAGE,
            widget.resolution != null
                ? getOriginDimen(widget.resolution!)
                : snap.data!,
          );
        });
  }

  Container imageOld(AsyncSnapshot<BoxFit> snap) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: FadeInImage.assetNetwork(
        placeholder: placeHolderImage,
        image: src ?? NOT_IMAGE,
        fit: widget.resolution != null
            ? getOriginDimen(widget.resolution!)
            : snap.data,
        placeholderErrorBuilder: (_, obj, s) => Container(
          width: width,
          height: height,
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
        imageErrorBuilder: (context, url, error) => Image.asset(
          "assets/no_available.png",
          width: width,
          height: height,
          fit: fit,
          color: Colors.transparent,
        ),
        width: width,
        height: height,
      ),
    );
  }
}
