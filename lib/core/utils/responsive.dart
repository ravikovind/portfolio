import 'package:flutter/material.dart';

/// list of all devices
enum DeviceType {
  desktop,
  handset,
}

/// breakpoints for desktop, tablet and handset
const desktop = 520;
const handset = 280;

/// [_displayTypeOf] returns the device type
DeviceType _displayTypeOf(BuildContext context) {
  /// Use shortestSide to detect device type regardless of orientation
  double deviceWidth = MediaQuery.of(context).size.shortestSide;
  if (deviceWidth > desktop) {
    return DeviceType.desktop;
  } else {
    return DeviceType.handset;
  }
}

/// [isDeviceDesktop] returns true if the device is desktop
bool isDeviceDesktop(BuildContext context) {
  return _displayTypeOf(context) == DeviceType.desktop;
}

/// [isDeviceMobile] returns true if the device is mobile
bool isDeviceMobile(BuildContext context) {
  return _displayTypeOf(context) == DeviceType.handset;
}
