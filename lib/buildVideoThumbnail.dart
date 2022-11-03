import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BuildVideoThumbnail extends StatelessWidget {
  File fileParameter;
  BuildVideoThumbnail({required this.fileParameter});

  VideoPlayerController? videoPlayerController;
  @override
  Widget build(BuildContext context) {
    videoPlayerController = VideoPlayerController.file(
      fileParameter,
    )
      ..addListener(() {})
      ..initialize().then((_) => videoPlayerController?.play());
    return SizedBox(
      height: 300,
      child: VideoPlayer(videoPlayerController!),
    );
  }
}
