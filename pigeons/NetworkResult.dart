// // import 'package:pigeon/pigeon_lib.dart';
//
// class NetworkResult {
//   String? wifi;
//   String? wifi_tether;
//   String? wifiboth;
//   String? private;
//   String? cellular;
//   String? Usb;
//   String? Bluethooth;
//   bool? IsWifiConnected;
//   bool? IsHotspotEnabled;
//   bool? IsWifiEnabled;
// }
//
// @HostApi()
// abstract class Api2Host {
//   @async
//   NetworkResult result(NetworkResult result);
// }
// // flutter pub run pigeon \--input pigeons/NetworkResult.dart \--dart_out lib/NetworkResult.dart \--objc_header_out ios/Runner/NetworkResult.h \--objc_source_out ios/Runner/NetworkResult.m \--java_out ./android/app/src/main/java/dev/flutter/pigeon/NetworkResult.java \--java_package "dev.flutter.pigeon"
// // flutter pub run pigeon--input pigeons\NetworkResult.dart--dart_out lib\pigeon.dart--objc_header_out ios\Runner\pigeon.h--objc_source_out ios\Runner\pigeon.m--java_out .\android\src\main\java\dev\flutter\pigeon\Pigeon.java--java_package "dev.flutter.pigeon"
// // --java_out .\android\src\main\java\dev\flutter\pigeon\Pigeon.java --java_package "dev.flutter.pigeon"