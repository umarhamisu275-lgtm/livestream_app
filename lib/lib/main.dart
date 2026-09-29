import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'video_feed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://YOUR_SUPABASE_URL.supabase.co',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

  runApp(const LiveStreamApp());
}

class LiveStreamApp extends StatelessWidget {
  const LiveStreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveStream',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const VideoFeedScreen(),
    );
  }
}
