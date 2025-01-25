import 'package:flutter/material.dart';
import 'package:tiktok_events_sdk_example/services/tiktok_services.dart';
import 'package:tiktok_events_sdk_example/page/tiktok_events_screen.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    TikTokService.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TikTokEventsPage(),
    );
  }
}
