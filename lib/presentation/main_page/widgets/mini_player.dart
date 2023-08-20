import 'package:flutter/material.dart';
import 'package:music_plyr/presentation/main_page/widgets/now_playing.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../controllers/get_all_controllers.dart';
import '../../../controllers/get_recent_controllers.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({
    Key? key,
  }) : super(key: key);
  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

bool firstSong = false;

bool isPlaying = false;

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  void initState() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          index == 0 ? firstSong = true : firstSong = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NowPlaying(
          songModelList: GetAllSongController.playingSong,
          audioPlayer: GetAllSongController.audioPlayer),
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[700],
      ),
    );
  }
}
