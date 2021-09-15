
import 'dart:async';

import 'package:flutter/services.dart';

class Shareapks {
  static const MethodChannel _channel = MethodChannel('shareapks');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
