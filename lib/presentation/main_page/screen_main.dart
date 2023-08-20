import 'package:flutter/material.dart';
import 'package:music_plyr/core/colors.dart';
import 'package:music_plyr/presentation/main_page/widgets/bottom_navigation.dart';
import 'package:music_plyr/presentation/main_page/widgets/mini_player.dart';
import '../favorites/screen_favorites.dart';
import '../home/screen_home.dart';
import '../search/screen_search.dart';
import '../settings/screen_settings.dart';

class ScreenMain extends StatelessWidget {
  ScreenMain({super.key});

  final _pages = [
    const ScreenHome(),
    const ScreenSearch(),
    const ScreenFavorites(),
    const ScreenSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ValueListenableBuilder(
        valueListenable: indexChangeNotifier,
        builder: (context, index, _) {
          return _pages[index];
        },
      ),
      bottomSheet: const MiniPlayer(),
      bottomNavigationBar: const BottomNavigationWidget(),
    );
  }
}
