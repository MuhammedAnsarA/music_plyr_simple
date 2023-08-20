import 'package:flutter/material.dart';
import 'package:music_plyr/presentation/settings/widgets/screen_about_widget.dart';
import 'package:music_plyr/presentation/settings/widgets/screen_privacy_widget.dart';
import 'package:music_plyr/presentation/settings/widgets/screen_terms_widget.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.grey[300],
                  height: 800,
                  width: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          style: ButtonStyle(
                            iconSize: MaterialStateProperty.all(27),
                            iconColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 7, 108, 3)),
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AboutWidget(),
                                ));
                          },
                          icon: const Icon(Icons.info),
                          label: Text(
                            "About Us",
                            style: TextStyle(
                              color: Colors.grey[850],
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        TextButton.icon(
                          style: ButtonStyle(
                            iconSize: MaterialStateProperty.all(27),
                            iconColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 13, 2, 112)),
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                          label: Text(
                            "Share",
                            style: TextStyle(
                              color: Colors.grey[850],
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        TextButton.icon(
                          style: ButtonStyle(
                            iconSize: MaterialStateProperty.all(27),
                            iconColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 167, 153, 4)),
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyWidget(),
                                ));
                          },
                          icon: const Icon(Icons.lock),
                          label: Text(
                            "Privacy Policy",
                            style: TextStyle(
                              color: Colors.grey[850],
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        TextButton.icon(
                          style: ButtonStyle(
                            iconSize: MaterialStateProperty.all(27),
                            iconColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 46, 109, 157)),
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TermesWidget(),
                                ));
                          },
                          icon: const Icon(Icons.description),
                          label: Text(
                            "Terms and Conditions",
                            style: TextStyle(
                              color: Colors.grey[850],
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        TextButton.icon(
                          style: ButtonStyle(
                            iconSize: MaterialStateProperty.all(30),
                            iconColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 170, 9, 9)),
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.autorenew),
                          label: Text(
                            "Reset",
                            style: TextStyle(
                              color: Colors.grey[850],
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
