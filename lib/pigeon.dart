// Autogenerated from Pigeon (v1.0.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name
// @dart = 2.12
import 'dart:async';
import 'dart:typed_data' show Uint8List, Int32List, Int64List, Float64List;

import 'package:flutter/foundation.dart' show WriteBuffer, ReadBuffer;
import 'package:flutter/services.dart';

class NetworkResult {
  String? wifi;
  String? wifi_tether;
  String? wifiboth;
  String? private;
  String? cellular;
  String? Usb;
  String? Bluethooth;
  bool? IsWifiConnected;
  bool? IsHotspotEnabled;
  bool? IsWifiEnabled;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['wifi'] = wifi;
    pigeonMap['wifi_tether'] = wifi_tether;
    pigeonMap['wifiboth'] = wifiboth;
    pigeonMap['private'] = private;
    pigeonMap['cellular'] = cellular;
    pigeonMap['Usb'] = Usb;
    pigeonMap['Bluethooth'] = Bluethooth;
    pigeonMap['IsWifiConnected'] = IsWifiConnected;
    pigeonMap['IsHotspotEnabled'] = IsHotspotEnabled;
    pigeonMap['IsWifiEnabled'] = IsWifiEnabled;
    return pigeonMap;
  }

  static NetworkResult decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return NetworkResult()
      ..wifi = pigeonMap['wifi'] as String?
      ..wifi_tether = pigeonMap['wifi_tether'] as String?
      ..wifiboth = pigeonMap['wifiboth'] as String?
      ..private = pigeonMap['private'] as String?
      ..cellular = pigeonMap['cellular'] as String?
      ..Usb = pigeonMap['Usb'] as String?
      ..Bluethooth = pigeonMap['Bluethooth'] as String?
      ..IsWifiConnected = pigeonMap['IsWifiConnected'] as bool?
      ..IsHotspotEnabled = pigeonMap['IsHotspotEnabled'] as bool?
      ..IsWifiEnabled = pigeonMap['IsWifiEnabled'] as bool?;
  }
}

class _Api2HostCodec extends StandardMessageCodec {
  const _Api2HostCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is NetworkResult) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else 
{
      super.writeValue(buffer, value);
    }
  }
  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:       
        return NetworkResult.decode(readValue(buffer)!);
      
      default:      
        return super.readValueOfType(type, buffer);
      
    }
  }
}

class Api2Host {
  /// Constructor for [Api2Host].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  Api2Host({BinaryMessenger? binaryMessenger}) : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _Api2HostCodec();

  Future<NetworkResult> result(NetworkResult arg_result) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.Api2Host.result', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_result]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as NetworkResult?)!;
    }
  }
}
