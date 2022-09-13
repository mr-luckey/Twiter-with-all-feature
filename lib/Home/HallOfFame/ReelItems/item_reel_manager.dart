import 'package:flutter/material.dart';
import 'package:kronosss/Home/HallOfFame/ReelItems/item_audio.dart';
import 'package:kronosss/Home/HallOfFame/ReelItems/item_image.dart';
import 'package:kronosss/Home/HallOfFame/ReelItems/item_video.dart';
import 'package:kronosss/mConstants.dart';

class ItemReelManagerScreen extends StatefulWidget {
  final String src;
  final Size? resolution;
  final bool isEnableVolume;
  final bool isNetwork;
  final bool isExpandImage;
  final bool isCaratulaAudio;
  final bool isCaratulaVideo;
  final int isLiked;
  final bool isStopedVideo;
  final void Function(bool)? onDoubleTap;

  ItemReelManagerScreen(
      {required this.src,
      this.isNetwork = true,
      this.isEnableVolume = true,
      this.isExpandImage = false,
      this.isCaratulaAudio = false,
      this.isCaratulaVideo = false,
      this.isLiked = -1,
      this.resolution,
      this.onDoubleTap,
      this.isStopedVideo = false,
      Key? key})
      : super(key: key);

  @override
  State<ItemReelManagerScreen> createState() => _ItemReelManagerScreenState();
}

class _ItemReelManagerScreenState extends State<ItemReelManagerScreen> {
  // ignore: unused_field
  bool _liked = false, _rotate = false;
  final List<String> _extImage = ['png', 'jpg', 'jpeg', 'gif'];

  final List<String> _extAudio = ['mp3', 'aac'];

  final List<String> _extVideo = ['mp4', 'mkv', 'avi'];

  bool mCompare(String value, List<String> list) {
    bool resp = false;
    for (var item in list) {
      resp = value.endsWith(item);
      if (resp) break;
    }
    return resp;
  }

/*   Future<void> tempFuture() async {
    setState(() => _liked = true);
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() => _liked = false);
  }
 */
  @override
  Widget build(BuildContext context) {
    //print('FILE MANAGER: ${widget.src}');
    return Scaffold(
      backgroundColor: Colorskronoss.background_application_dark,
      body: GestureDetector(
        onDoubleTap: () async {
          if (widget.onDoubleTap != null) {
            widget.onDoubleTap!(true);
            setState(() => _liked = true);
            await Future.delayed(Duration(milliseconds: 1000));
            setState(() => _liked = false);
          }
          //debugPrint('double tap');
        },
        /* onLongPress: () {
          setState(() => _rotate = !_rotate);
        }, */
        child: RotatedBox(
          quarterTurns: _rotate ? 1 : 0,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (mCompare(widget.src, _extImage)) // compare IMAGE
                ItemImageReel(
                  widget.src,
                  resolution: widget.resolution,
                  isNetwork: widget.isNetwork,
                  isExpand: widget.isExpandImage,
                ),
              if (mCompare(widget.src, _extAudio)) // compare AUDIO
                widget.isCaratulaAudio
                    ? Container(
                        color: Colorskronoss.background_application_dark,
                        child: Icon(
                          Icons.audio_file_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                      )
                    : ItemAudioReel(
                        widget.src,
                        isNetwork: widget.isNetwork,
                        isEnableVolume: widget.isEnableVolume,
                      ),
              if (mCompare(widget.src, _extVideo)) // compare VIDEO
                widget.isCaratulaVideo
                    ? Container(
                        color: Colorskronoss.background_application_dark,
                        child: Icon(
                          Icons.local_movies_sharp,
                          color: Colors.white,
                          size: 50,
                        ),
                      )
                    : ItemVideoReel(
                        widget.src,
                        isNetwork: widget.isNetwork,
                        isEnableVolume: widget.isEnableVolume,
                      ),
              /* if (_liked && widget.isLiked != -1)
                Center(
                  child: Icon(
                    widget.isLiked == 1
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.isLiked == 1 ? Colors.red : Colors.white,
                    size: 110,
                  ),
                ), */
            ],
          ),
        ),
      ),
    );
  }
}
