
import 'dart:async';

import 'package:android_util/android_ip.dart';
import 'package:flutter/services.dart';

class Shareapks {
  static const MethodChannel _channel = MethodChannel('shareapks');
  Stream<String>? _onShareProcess;

  static Future<String?> get platformVersion async {
    var data = await rootBundle.load("packages/shareapks/asset/index.html");
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Stream<String>? get onShared {
    var androidIp = new AndroidIp();
    return androidIp.onShared;
  }
}
