import 'dart:developer';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:music_plyr/infrastructure/provider/song_model_provider.dart';
import 'package:music_plyr/presentation/main_page/widgets/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();

  List<SongModel> allSongs = [];

  playSong(String? uri) {
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
    } catch (_) {
      log("error parsing song");
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() {
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: FutureBuilder<List<SongModel>>(
              future: _audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, item) {
                if (item.hasError) {
                  return Text(item.error.toString());
                }
                if (item.data == null) {
                  return const Center(
                      child: CircularProgressIndicator(
                    value: 2,
                  ));
                }
                if (item.data!.isEmpty) {
                  return const Text("Nothig Found!");
                }
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      elevation: 0,
                      backgroundColor: Colors.grey[400],
                      toolbarHeight: 63,
                      pinned: true,
                      expandedHeight: 380,
                      flexibleSpace: Stack(
                        children: [
                          FlexibleSpaceBar(
                            titlePadding:
                                const EdgeInsets.only(left: 1, bottom: 7),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.only(
                                            left: 21, right: 21)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromARGB(255, 219, 51, 39)),
                                    iconColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NowPlaying(
                                            songModelList: allSongs,
                                            audioPlayer: audioPlayer),
                                      ),
                                    );
                                  },
                                  icon: const FaIcon(
                                    FontAwesomeIcons.play,
                                    size: 13,
                                  ),
                                  label: const Text(
                                    "PLAY",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                StreamBuilder<bool>(
                                  builder: (context, snapshot) {
                                    final shuffleModeEnabled =
                                        snapshot.data ?? false;
                                    return TextButton.icon(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromARGB(
                                                    255, 0, 0, 0)),
                                        iconColor: MaterialStateProperty.all(
                                            Colors.white),
                                      ),
                                      onPressed: () async {
                                        final enable = !shuffleModeEnabled;
                                        if (enable) {
                                          allSongs.shuffle();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NowPlaying(
                                                  songModelList: allSongs,
                                                  audioPlayer: audioPlayer,
                                                ),
                                              ));
                                        }
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.shuffle,
                                        size: 13,
                                      ),
                                      label: const Text(
                                        "SHUFFLE",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                            background: const HomeScreenArtWorkWidget(),
                          ),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          allSongs.addAll(item.data!);
                          return ListTile(
                            shape: Border.all(color: Colors.transparent),
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: Text(
                              item.data![index].displayNameWOExt,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle:
                                Text(item.data![index].artist ?? "No Artist"),
                            trailing: const Icon(Icons.more_horiz),
                            leading: QueryArtworkWidget(
                              id: item.data![index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const FaIcon(
                                FontAwesomeIcons.music,
                              ),
                            ),
                            onTap: () {
                              context
                                  .read<SongModelProvider>()
                                  .setId(item.data![index].id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NowPlaying(
                                        songModelList: [item.data![index]],
                                        audioPlayer: audioPlayer),
                                  ));
                            },
                          );
                        },
                        childCount: item.data!.length,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}

class HomeScreenArtWorkWidget extends StatelessWidget {
  const HomeScreenArtWorkWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      artworkBorder: BorderRadius.zero,
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      artworkQuality: FilterQuality.high,
      artworkHeight: 250,
      artworkWidth: 250,
      artworkFit: BoxFit.fill,
      nullArtworkWidget: Container(
        height: 250,
        width: 250,
        color: Colors.grey[400],
        child: const Center(
          child: FaIcon(
            FontAwesomeIcons.music,
            size: 160,
          ),
        ),
      ),
    );
  }
}
