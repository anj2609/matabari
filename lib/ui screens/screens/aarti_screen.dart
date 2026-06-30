import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AartiScreen extends StatefulWidget {
  const AartiScreen({super.key});

  @override
  State<AartiScreen> createState() => _AartiScreenState();
}

class _AartiScreenState extends State<AartiScreen> {

  final AudioPlayer player = AudioPlayer();

  final List<Map<String, String>> songs = [
    {
      "title": "Mata Tripura Sundari Aarti",
      "sub": "Morning Aarti",
      "image": "assets/images/maa1.png",
      "audio": "assets/audio/laximimata.mp3",
    },
    {
      "title": "Jai Ambe Gauri Aarti",
      "sub": "Evening Aarti",
      "image": "assets/images/maa1.png",
      "audio": "assets/audio/laximimata.mp3",
    },
    {
      "title": "Durga Aarti",
      "sub": "Festive Special",
      "image": "assets/images/maa1.png",
      "audio": "assets/audio/laximimata.mp3",
    },
    {
      "title": "Om Jai Jagdish Hare",
      "sub": "Popular Aarti",
      "image": "assets/images/maa1.png",
      "audio": "assets/audio/laximimata.mp3",
    },
  ];

  Future<void> playSong(String path) async {
    await player.stop();
    await player.play(AssetSource(path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F4EE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// HEADER
              Container(
                height: 220,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff9C1A0B),
                      Color(0xffC7441B),
                    ],
                  ),
                ),
                child: Column(
                  children: [

                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          Icon(Icons.arrow_back_ios,
                              color: Colors.white),

                          Spacer(),

                          Text(
                            "Aarti/Chalisa/Bhajan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Spacer(),

                          Icon(Icons.search,
                              color: Colors.white),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Listen pray and feel the divine",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          tabButton("AARTI", true),
                          tabButton("CHALISA", false),
                          tabButton("BHAJAN", false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// CATEGORY GRID

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    categoryItem(Icons.self_improvement,
                        "Morning\nAarti"),
                    categoryItem(Icons.wb_sunny,
                        "Evening\nAarti"),
                    categoryItem(Icons.calendar_month,
                        "Festival\nSpecial"),
                    categoryItem(Icons.favorite,
                        "My\nFavourite"),
                    categoryItem(Icons.history,
                        "Recently\nPlayed"),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// TRENDING

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      "Trending Aartis",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "View All",
                      style: TextStyle(
                        color: Colors.red.shade700,
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: songs.length,
                itemBuilder: (context, index) {

                  var song = songs[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10),
                        child: Image.asset(
                          song["image"]!,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        song["title"]!,
                        maxLines: 2,
                      ),
                      subtitle: Text(song["sub"]!),
                      trailing: InkWell(
                        onTap: () {
                          playSong(song["audio"]!);
                        },
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabButton(String text, bool active) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: active
              ? const Color(0xff8E160C)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color:
                  active ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget categoryItem(IconData icon, String title) {
    return Column(
      children: [
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11),
        )
      ],
    );
  }
}