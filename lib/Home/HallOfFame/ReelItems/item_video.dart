import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:video_player/video_player.dart';

class ItemVideoReel extends StatefulWidget {
  final String src;
  final bool isNetwork;
  final bool isEnableVolume;
  final bool keepAspectRatio;
  final double aspectRatio;
  final bool showIcons;
  final void Function(VideoViewController)? funController;
  const ItemVideoReel(this.src,
      {this.funController,
      this.keepAspectRatio = true,
      this.isNetwork = true,
      this.aspectRatio = 9 / 16,
      this.showIcons = true,
      this.isEnableVolume = true});

  @override
  State<ItemVideoReel> createState() => _ItemVideoReelState();
}

class _ItemVideoReelState extends State<ItemVideoReel> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  double volumeLevel = 1.0;
  bool isInitialized = false;

  @override
  void initState() {
    setState(() => volumeLevel = widget.isEnableVolume ? 1.0 : 0.0);
    initializePlayer();
    super.initState();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src);
    await Future.wait([_videoPlayerController!.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: widget.keepAspectRatio
          ? _videoPlayerController!.value.aspectRatio
          : widget.aspectRatio,
      autoPlay: true,
      showControlsOnInitialize: false,
      showControls: false,
      looping: true,
      //fullScreenByDefault: true,
      playbackSpeeds: [1.0],
      /* deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
      ], */
    );
    setState(() {
      isInitialized =
          _chewieController!.videoPlayerController.value.isInitialized;
      try {
        _chewieController!.setVolume(volumeLevel);
        // _chewieController!.enterFullScreen();
      } on Exception catch (_) {}
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          volumeLevel = (volumeLevel == 1.0) ? 0.0 : 1.0;
          try {
            _chewieController!.setVolume(volumeLevel);
          } on Exception catch (_) {}
        });
      },
      onLongPress: () {
        try {
          var isPlaying = _chewieController!.isPlaying;
          isPlaying ? _chewieController!.pause() : _chewieController!.play();
        } on Exception catch (_) {}
        setState(() {});
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          _chewieController != null && isInitialized
              //_chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: _chewieController!,
                )
              : SizedBox(height: 10.0),
          /* Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10.0),
                    Text('Cargando...', style: style),
                  ],
                ), */
          if (widget.showIcons)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black12,
                ),
                child: Icon(
                  volumeLevel == 1.0 ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          if (_chewieController != null && !_chewieController!.isPlaying)
            Positioned(
              bottom: 0,
              right: 25,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.pause,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
