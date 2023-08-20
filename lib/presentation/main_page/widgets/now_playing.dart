import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_plyr/infrastructure/provider/song_model_provider.dart';
import 'package:music_plyr/presentation/home/widgets/neu_box.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'common.dart';

class NowPlaying extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final List<SongModel> songModelList;
  const NowPlaying({
    super.key,
    required this.songModelList,
    required this.audioPlayer,
  });

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  int currentIndx = 0;

  bool isPlaying = false;
  List<AudioSource> songList = [];

  @override
  void initState() {
    super.initState();

    playSong();
  }

  void playSong() {
    try {
      for (var element in widget.songModelList) {
        songList.add(
          AudioSource.uri(
            Uri.parse(element.uri!),
            tag: MediaItem(
              id: element.id.toString(),
              album: element.album ?? "No Album",
              title: element.displayNameWOExt,
              artUri: Uri.parse(element.id.toString()),
            ),
          ),
        );
      }
      widget.audioPlayer
          .setAudioSource(ConcatenatingAudioSource(children: songList));
      widget.audioPlayer.play();
      isPlaying = true;
    } catch (_) {
      log("cannot parse song");
    }
    widget.audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration!;
      });
    });
    widget.audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });
    listenToSongIndex();
  }

  void listenToSongIndex() {
    widget.audioPlayer.currentIndexStream.listen((event) {
      setState(() {
        if (event != null) {
          currentIndx = event;
        }
        context
            .read<SongModelProvider>()
            .setId(widget.songModelList[currentIndx].id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const NeuBox(
                        child: Icon(
                          Icons.expand_more,
                          size: 34,
                        ),
                      ),
                    ),
                    const Text(
                      "P L A Y S O N G",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const NeuBox(
                        child: Icon(
                          Icons.more_vert,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const ArtWorkWidget(),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  widget.songModelList[currentIndx].displayNameWOExt,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    widget.songModelList[currentIndx].artist.toString() ==
                            "<unknown>"
                        ? "<Unknown Artist>"
                        : widget.songModelList[currentIndx].artist.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const InkWell(
                      child: NeuBox(
                        child: Icon(
                          Icons.favorite,
                          size: 26,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showSliderDialog(
                          context: context,
                          title: "Adjust volume",
                          divisions: 10,
                          min: 0.0,
                          max: 1.0,
                          value: widget.audioPlayer.volume,
                          stream: widget.audioPlayer.volumeStream,
                          onChanged: widget.audioPlayer.setVolume,
                        );
                      },
                      child: FaIcon(
                        FontAwesomeIcons.volumeHigh,
                        size: 20,
                        color: Colors.grey[300],
                      ),
                    ),
                    StreamBuilder<double>(
                      stream: widget.audioPlayer.speedStream,
                      builder: (context, snapshot) => IconButton(
                        icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[300],
                                fontSize: 16)),
                        onPressed: () {
                          showSliderDialog(
                            context: context,
                            title: "Adjust speed",
                            divisions: 10,
                            min: 0.5,
                            max: 1.5,
                            value: widget.audioPlayer.speed,
                            stream: widget.audioPlayer.speedStream,
                            onChanged: widget.audioPlayer.setSpeed,
                          );
                        },
                      ),
                    ),
                    const InkWell(
                      child: NeuBox(
                        child: Icon(
                          Icons.playlist_add,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _position.toString().split(".")[0],
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    Expanded(
                      child: Slider(
                        thumbColor: Colors.white,
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey[600],
                        min: const Duration(microseconds: 0)
                            .inSeconds
                            .toDouble(),
                        value: _position.inSeconds.toDouble(),
                        max: _duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            changeToSeconds(value.toInt());
                            value = value;
                          });
                        },
                      ),
                    ),
                    Text(
                      _duration.toString().split(".")[0],
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Center(
                          child: StreamBuilder<bool>(
                            stream: widget.audioPlayer.shuffleModeEnabledStream,
                            builder: (context, snapshot) {
                              final shuffleModeEnabled = snapshot.data ?? false;
                              return IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                icon: shuffleModeEnabled
                                    ? FaIcon(FontAwesomeIcons.shuffle,
                                        size: 20, color: Colors.grey[200])
                                    : FaIcon(FontAwesomeIcons.shuffle,
                                        size: 20, color: Colors.grey[700]),
                                onPressed: () async {
                                  final enable = !shuffleModeEnabled;
                                  if (enable) {
                                    await widget.audioPlayer.shuffle();
                                  }
                                  await widget.audioPlayer
                                      .setShuffleModeEnabled(enable);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          widget.audioPlayer.seekToPrevious();
                        },
                        child: const NeuBox(
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.backward,
                              size: 21,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isPlaying) {
                                widget.audioPlayer.pause();
                              } else {
                                widget.audioPlayer.play();
                              }
                              isPlaying = !isPlaying;
                            });
                          },
                          child: NeuBox(
                            child: Center(
                              child: FaIcon(
                                isPlaying
                                    ? FontAwesomeIcons.pause
                                    : FontAwesomeIcons.play,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          widget.audioPlayer.seekToNext();
                        },
                        child: const NeuBox(
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.forward,
                              size: 21,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Center(
                        child: StreamBuilder<LoopMode>(
                          stream: widget.audioPlayer.loopModeStream,
                          builder: (context, snapshot) {
                            final loopMode = snapshot.data ?? LoopMode.off;
                            final icons = [
                              FaIcon(FontAwesomeIcons.repeat,
                                  size: 20, color: Colors.grey[700]),
                              FaIcon(FontAwesomeIcons.repeat,
                                  size: 20, color: Colors.grey[200]),
                              Icon(Icons.repeat_one,
                                  size: 27, color: Colors.grey[200]),
                            ];
                            const cycleModes = [
                              LoopMode.off,
                              LoopMode.all,
                              LoopMode.one,
                            ];
                            final index = cycleModes.indexOf(loopMode);
                            return IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: icons[index],
                              onPressed: () {
                                widget.audioPlayer.setLoopMode(cycleModes[
                                    (cycleModes.indexOf(loopMode) + 1) %
                                        cycleModes.length]);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      artworkQuality: FilterQuality.high,
      artworkHeight: 300,
      artworkWidth: 300,
      artworkFit: BoxFit.cover,
      nullArtworkWidget: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 300,
          width: 300,
          color: const Color.fromARGB(255, 230, 223, 223),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.music,
              size: 200,
            ),
          ),
        ),
      ),
    );
  }
}
