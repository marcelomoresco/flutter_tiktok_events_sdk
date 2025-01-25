import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        title: GestureDetector(
          onTap: onTapText,
          child: const Text('Example TikTok SDK'),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: onTapLogout,
            child: const Text('Logout'),
          ),
          GestureDetector(
            onTap: onTapIdentify,
            child: const Text('Identify'),
          ),
          GestureDetector(
            onTap: onTapLogEventWithId,
            child: const Text('Log event with id'),
          ),
        ],
      ),
    );
  }

  void onTapText() {
    TikTokService.logEvent();
  }

  void onTapLogout() {
    TikTokService.logout();
  }

  void onTapIdentify() {
    TikTokService.identify();
  }

  void onTapLogEventWithId() {
    TikTokService.logEvent();
  }
}
