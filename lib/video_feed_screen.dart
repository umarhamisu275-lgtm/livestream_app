import 'package:flutter/material.dart';

class VideoFeedScreen extends StatefulWidget {
  const VideoFeedScreen({super.key});

  @override
  State<VideoFeedScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoFeedScreen> {
  final PageController _pageController = PageController();

  // Samfurin Bidiyoyi na Gwaji (Dummy Video List)
  final List<Map<String, String>> _videos = [
    {
      'username': '@adam_a_zango',
      'caption': 'Barka da zuwa sabuwar manhajar LiveStream! 🚀',
      'likes': '12.5K',
      'comments': '450',
    },
    {
      'username': '@ali_nuhu',
      'caption': 'Kalla sabon shirinmu na sirri nan ba da jimawa ba. 🎬',
      'likes': '25.8K',
      'comments': '1.2K',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical, // Scrolling sama da kasa kamar TikTok
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return Stack(
            children: [
              // 1. Background na Bidiyo (Placeholder for Video Player)
              Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(Icons.play_circle_fill, size: 80, color: Colors.white54),
                ),
              ),

              // 2. Bayanan Mawaki / Celebrity a kasa
              Positioned(
                bottom: 20,
                left: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['username']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      video['caption']!,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // 3. Maballan 'Like', 'Comment', da 'Gift' a hannun dama
              Positioned(
                right: 15,
                bottom: 50,
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red, size: 35),
                      onPressed: () {},
                    ),
                    Text(video['likes']!, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 20),
                    IconButton(
                      icon: const Icon(Icons.comment, color: Colors.white, size: 35),
                      onPressed: () {},
                    ),
                    Text(video['comments']!, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 20),
                    IconButton(
                      icon: const Icon(Icons.card_giftcard, color: Colors.amber, size: 35),
                      onPressed: () {
                        // Action don aika kyautar kudi (Tip/Gift)
                      },
                    ),
                    const Text('Gift', style: const TextStyle(color: Colors.amber)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
