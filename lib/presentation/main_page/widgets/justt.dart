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
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NowPlaying(
                  songModelList: GetAllSongController.playingSong,
                  audioPlayer: GetAllSongController.audioPlayer),
            ));
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.purpleAccent, width: 2),
                color: const Color.fromARGB(255, 2, 3, 61)),
            height: 60,
            child: Stack(
              children: [
                Positioned(
                  child: SizedBox(
                    width: size.width * 0.95,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width * 0.5,
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StreamBuilder<bool>(
                                  stream: GetAllSongController
                                      .audioPlayer.playingStream,
                                  builder: (context, snapshot) {
                                    bool? playingStage = snapshot.data;
                                    if (playingStage != null && playingStage) {
                                      return TextScroll(
                                        GetAllSongController
                                            .playingSong[GetAllSongController
                                                .audioPlayer.currentIndex!]
                                            .displayNameWOExt,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      );
                                    } else {
                                      return Text(
                                        GetAllSongController
                                            .playingSong[GetAllSongController
                                                .audioPlayer.currentIndex!]
                                            .displayNameWOExt,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                            fontSize: 14),
                                      );
                                    }
                                  },
                                ),
                                TextScroll(
                                  GetAllSongController
                                              .playingSong[GetAllSongController
                                                  .audioPlayer.currentIndex!]
                                              .artist
                                              .toString() ==
                                          "<unknown>"
                                      ? "Unknown Artist"
                                      : GetAllSongController
                                          .playingSong[GetAllSongController
                                              .audioPlayer.currentIndex!]
                                          .artist
                                          .toString(),
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.blueGrey),
                                  mode: TextScrollMode.endless,
                                ),
                              ],
                            ),
                          ),
                          firstSong
                              ? SizedBox(
                                  width: 45,
                                )
                              : IconButton(
                                  iconSize: 32,
                                  onPressed: () async {
                                    GetRecentSongController.addRecentlyPlayed(
                                        GetAllSongController
                                            .playingSong[GetAllSongController
                                                .audioPlayer.currentIndex!]
                                            .id);
                                    if (GetAllSongController
                                        .audioPlayer.hasPrevious) {
                                      await GetAllSongController.audioPlayer
                                          .seekToPrevious();
                                      await GetAllSongController.audioPlayer
                                          .play();
                                    } else {
                                      await GetAllSongController.audioPlayer
                                          .play();
                                    }
                                  },
                                  icon: const Icon(Icons.skip_previous),
                                  color: Colors.white,
                                ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 2, 3, 61),
                                shape: const CircleBorder()),
                            onPressed: () async {
                              setState(() {
                                isPlaying = !isPlaying;
                              });
                              if (GetAllSongController.audioPlayer.playing) {
                                await GetAllSongController.audioPlayer.pause();
                                setState(() {});
                              } else {
                                await GetAllSongController.audioPlayer.play();
                                setState(() {});
                              }
                            },
                            child: StreamBuilder<bool>(
                              stream: GetAllSongController
                                  .audioPlayer.playingStream,
                              builder: (context, snapshot) {
                                bool? playingStage = snapshot.data;
                                if (playingStage != null && playingStage) {
                                  return const Icon(
                                    Icons.pause_circle,
                                    color: Colors.white,
                                    size: 35,
                                  );
                                } else {
                                  return const Icon(
                                    Icons.play_circle,
                                    color: Colors.white,
                                    size: 35,
                                  );
                                }
                              },
                            ),
                          ),
                          IconButton(
                            iconSize: 35,
                            onPressed: () async {
                              GetRecentSongController.addRecentlyPlayed(
                                  GetAllSongController
                                      .playingSong[GetAllSongController
                                          .audioPlayer.currentIndex!]
                                      .id);
                              if (GetAllSongController.audioPlayer.hasNext) {
                                await GetAllSongController.audioPlayer
                                    .seekToNext();
                                await GetAllSongController.audioPlayer.play();
                              } else {
                                await GetAllSongController.audioPlayer.play();
                              }
                            },
                            icon: const Icon(
                              Icons.skip_next,
                              size: 32,
                            ),
                            color: Colors.white,
                          )
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
