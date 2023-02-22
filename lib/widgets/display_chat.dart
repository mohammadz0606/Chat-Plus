import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../helper/message_enum.dart';
import 'video_player.dart';

class DisplayChat extends StatelessWidget {
  const DisplayChat({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);
  final String message;
  final String type;

  @override
  Widget build(BuildContext context) {
    final AudioPlayer  audioPlayer = AudioPlayer();
    return type == MessageEnum.text.toString()
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          )
        : type == MessageEnum.image.toString()
            ? FadeInImage(
                fit: BoxFit.cover,
                placeholder: const AssetImage("asset/placeholder.gif"),
                image: NetworkImage(message),
              )
            : type == MessageEnum.audio.toString()
                ? IconButton(
                    onPressed: () {
                      audioPlayer.play(UrlSource(message));
                    },
                    color: Colors.grey,
                    icon: const Icon(Icons.play_circle_filled_sharp))
                : VideoPlayerWidget(videoUrl: message);
  }
}
