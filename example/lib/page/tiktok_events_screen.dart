import 'package:flutter/material.dart';
import 'package:tiktok_events_sdk_example/services/tiktok_services.dart';

class TikTokEventsPage extends StatefulWidget {
  const TikTokEventsPage({super.key});

  @override
  State<TikTokEventsPage> createState() => _TikTokEventsPageState();
}

class _TikTokEventsPageState extends State<TikTokEventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: onTapText, child: const Text('Example TikTok SDK')),
      ),
    );
  }

  void onTapText() {
    TikTokService.identify();
  }
}
