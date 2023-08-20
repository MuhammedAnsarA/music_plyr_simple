// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
// import 'package:music_plyr/presentation/main_page/widgets/now_playing.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:permission_handler/permission_handler.dart';

import '../../core/colors.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key});
  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
//   final OnAudioQuery _audioQuery = OnAudioQuery();
//   final AudioPlayer audioPlayer = AudioPlayer();

//   playSong(String? uri) {
//     try {
//       audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
//       audioPlayer.play();
//     } catch (_) {
//       log("error parsing song");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     requestPermission();
//   }

//   void requestPermission() {
//     Permission.storage.request();
//   }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: FutureBuilder<List<SongModel>>(
//               future: _audioQuery.querySongs(
//                 sortType: null,
//                 orderType: OrderType.ASC_OR_SMALLER,
//                 uriType: UriType.EXTERNAL,
//                 ignoreCase: true,
//               ),
//               builder: (context, item) {
//                 if (item.hasError) {
//                   return Text(item.error.toString());
//                 }
//                 if (item.data == null) {
//                   return const Center(
//                       child: CircularProgressIndicator(
//                     value: 2,
//                   ));
//                 }
//                 if (item.data!.isEmpty) {
//                   return const Text("Nothig Found!");
//                 }
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: item.data!.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: ListTile(
//                         title: Text(
//                           item.data![index].displayNameWOExt,
//                           style: const TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w500,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         subtitle: Text(item.data![index].artist ?? "No Artist"),
//                         leading: QueryArtworkWidget(
//                           id: item.data![index].id,
//                           type: ArtworkType.AUDIO,
//                           nullArtworkWidget: const Icon(Icons.music_note),
//                         ),
//                         trailing: const Icon(Icons.more_horiz),
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => NowPlaying(
//                                     songModel: item.data![index],
//                                     audioPlayer: audioPlayer),
//                               ));
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
      // ),
    );
  }
}
