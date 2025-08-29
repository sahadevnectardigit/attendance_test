import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';

class DeviceHelper {
  static final _deviceInfo = DeviceInfoPlugin();

  static Future<String> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        return "${info.brand} ${info.model}";
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        return "${info.name} ${info.systemVersion}";
      } else {
        return "Unsupported Platform";
      }
    } catch (e) {
      return "Unknown Device";
    }
  }
}
