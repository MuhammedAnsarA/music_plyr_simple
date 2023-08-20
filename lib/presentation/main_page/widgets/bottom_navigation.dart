import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_plyr/core/colors.dart';
import 'package:sweet_nav_bar/sweet_nav_bar.dart';

ValueNotifier<int> indexChangeNotifier = ValueNotifier(0);

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: indexChangeNotifier,
      builder: (context, int newIndex, _) {
        return SweetNavBar(
          paddingGradientColor: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.bottomLeft,
              colors: [
                Colors.black,
                Colors.black,
              ]),
          currentIndex: newIndex,
          onTap: (index) {
            indexChangeNotifier.value = index;
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            SweetNavBarItem(
                sweetBackground: Colors.grey[400],
                sweetActive: const Icon(
                  Icons.library_music,
                  size: 28,
                  color: kIconRedColor,
                ),
                sweetIcon: const Icon(
                  Icons.library_music_outlined,
                  size: 26,
                  color: kIconBlackColor,
                ),
                sweetLabel: "Music List"),
            SweetNavBarItem(
              sweetBackground: Colors.grey[400],
              sweetActive: const FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                size: 24,
                color: kIconRedColor,
              ),
              sweetIcon: const FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                size: 22,
                color: kIconBlackColor,
              ),
              sweetLabel: 'Search',
            ),
            SweetNavBarItem(
                sweetBackground: Colors.grey[400],
                sweetActive: const Icon(
                  Icons.favorite,
                  size: 28,
                  color: kIconRedColor,
                ),
                sweetIcon: const FaIcon(
                  FontAwesomeIcons.heart,
                  size: 22,
                  color: kIconBlackColor,
                ),
                sweetLabel: "Favorite"),
            SweetNavBarItem(
                sweetBackground: Colors.grey[400],
                sweetActive: const Icon(
                  Icons.settings,
                  size: 28,
                  color: kIconRedColor,
                ),
                sweetIcon: const Icon(
                  Icons.settings_outlined,
                  size: 26,
                  color: kIconBlackColor,
                ),
                sweetLabel: "Settings"),
          ],
        );
      },
    );
  }
}
