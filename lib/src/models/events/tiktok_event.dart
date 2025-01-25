import 'package:tiktok_events_sdk/src/models/events/custom/event_properties.dart';
import 'package:tiktok_events_sdk/src/models/events/tt_event_type.dart';

class TikTokEvent {
  final TTEventType eventType;
  final EventProperties? properties;
  final String? eventId;
  final String eventName;

  TikTokEvent({
    this.eventType = TTEventType.none,
    this.properties,
    this.eventId,
    required this.eventName,
  });

  Map<String, dynamic> toJson() => {
        'event_type_name': eventType.name,
        'parameters': properties?.toJson(),
        'event_id': eventId,
        'event_name': eventName,
      };
}
