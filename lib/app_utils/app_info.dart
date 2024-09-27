

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<String> getDeviceName() async {

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String deviceName = "";
  if (Platform.isAndroid) {
    final device = await deviceInfoPlugin.androidInfo;
    deviceName = "${device.manufacturer} ${device.model}";
  } else if (Platform.isIOS) {
    final device = await deviceInfoPlugin.iosInfo;
      deviceName = device.name;
  }
  return deviceName;
}

// Future<PackageInfo> getDeviceInfo() async {
//   final info = await PackageInfo.fromPlatform();
//   return info;
// }