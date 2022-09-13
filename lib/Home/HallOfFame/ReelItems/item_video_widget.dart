import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ItemVideo extends StatefulWidget {
  final String src;
  final void Function(VideoPlayerValue) getAspectRatio;
  final double volume;
  final bool autoPlay;

  const ItemVideo(
    this.src, {
    required this.getAspectRatio,
    this.autoPlay = false,
    this.volume = 0.0,
  });

  @override
  State<ItemVideo> createState() => _ItemVideoState();
}

class _ItemVideoState extends State<ItemVideo> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  double _volumeLevel = 1.0;
  bool _isInitialized = false;

  @override
  void initState() {
    setState(() => _volumeLevel = widget.volume);
    initializePlayer();
    super.initState();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src);
    await Future.wait([_videoPlayerController!.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      autoPlay: widget.autoPlay,
      showControlsOnInitialize: false,
      showControls: false,
      looping: true,
      fullScreenByDefault: true,
      playbackSpeeds: [1.0],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
      ],
    );

    try {
      var value = _videoPlayerController!.value;

      widget.getAspectRatio(value);
    } catch (_) {}
    setState(() {
      _isInitialized =
          _chewieController!.videoPlayerController.value.isInitialized;
      try {
        _chewieController!.setVolume(_volumeLevel);
        _chewieController!.enterFullScreen();
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
    return Stack(
      fit: StackFit.expand,
      children: [
        _chewieController != null && _isInitialized
            //_chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(
                controller: _chewieController!,
              )
            : SizedBox(height: 10.0),
      ],
    );
  }
}
