import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class MicService {
  static const MethodChannel _channel = MethodChannel('mic_service_channel');

  static Future<String> startMicStream() async {
    var micStatus = await Permission.microphone.status;
    var notificationStatus = await Permission.notification.status;

    if (!micStatus.isGranted) micStatus = await Permission.microphone.request();
    if (!notificationStatus.isGranted) notificationStatus = await Permission.notification.request();

    if (micStatus.isGranted && notificationStatus.isGranted) {
      try {
        final result = await _channel.invokeMethod('startMicStream');
        return 'Mic streaming started';
      } catch (e) {
        return 'Error starting mic service: $e';
      }
    } else {
      return 'Permissions denied: Mic=${micStatus.isGranted}, Notifications=${notificationStatus.isGranted}';
    }
  }

  static Future<String> stopMicStream() async {
    try {
      await _channel.invokeMethod('stopMicStream');
      return 'Mic stream stopped and Firestore data deleted';
    } catch (e) {
      return 'Error stopping mic stream: $e';
    }
  }
}
