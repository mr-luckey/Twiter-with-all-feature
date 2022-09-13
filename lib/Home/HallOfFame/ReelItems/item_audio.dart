import 'package:flutter/material.dart';
import 'package:native_video_view/native_video_view.dart';

class ItemAudioReel extends StatefulWidget {
  final String src;
  final bool isNetwork;
  final bool isEnableVolume;
  const ItemAudioReel(this.src,
      {this.isNetwork = true, this.isEnableVolume = true});

  @override
  State<ItemAudioReel> createState() => _ItemAudioReelState();
}

class _ItemAudioReelState extends State<ItemAudioReel> {
  bool enableVolume = false;
  VideoViewController? _controller;
  @override
  void initState() {
    setState(() {
      enableVolume = widget.isEnableVolume;
    });
    super.initState();
    debugPrint(widget.src);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          enableVolume = !enableVolume;
          if (_controller != null)
            _controller!.setVolume(!enableVolume ? 0.0 : 1.0);
        });
      },
      onLongPress: () async {
        if (_controller != null) {
          var isPlaying = await _controller!.isPlaying() ?? false;
          isPlaying ? _controller!.pause() : _controller!.play();
        }
      },
      child: Stack(
        children: [
          Center(
            child: NativeVideoView(
              keepAspectRatio: true,
              showMediaController: true,
              autoHide: false,
              autoHideTime: Duration(seconds: 30),
              onCreated: (controller) {
                _controller = controller;
                if (widget.isNetwork) {
                  controller.setVideoSource(
                    widget.src,
                    sourceType: VideoSourceType.network,
                  );
                } else {
                  controller.setVideoSource(
                    widget.src,
                    sourceType: VideoSourceType.file,
                  );
                }
              },
              onPrepared: (controller, info) async {
                controller.setVolume(!enableVolume ? 0.0 : 1.0);
                controller.play();
              },
              onError: (controller, what, extra, message) {
                print('Player Error ($what | $extra | $message)');
                /* Utils.toast(
                  context,
                  'Player Error ($message)',
                  backgroundColor: Colorskronoss.red_snackbar_error,
                  position: Utils.positionedCenter,
                  duration: 3000,
                ); */
              },
              onCompletion: (controller) {
                print('Audio completed');
              },
              onProgress: (progress, duration) {
                //final val = Utils.limitDecimal((progress / duration) * 100, 2);
                //print('$val %');
              },
            ),
          ),
          // ??
          Center(
            child: Icon(
              Icons.music_video_rounded,
              color: Colors.white70,
              size: 150,
            ),
          ),
          if (!enableVolume)
            Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.volume_mute,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
