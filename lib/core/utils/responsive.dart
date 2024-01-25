import 'package:flutter/material.dart';

/// list of all devices
enum DeviceType {
  compact,
  medium,
  expanded,
}

DeviceType _displayTypeOf(BuildContext context) {
  /// use shortest width to detect device type regardless of orientation.
  double deviceWidth = MediaQuery.of(context).size.width;
  if (deviceWidth >= 840) {
    return DeviceType.expanded;
  } else if (deviceWidth >= 600 && deviceWidth < 840) {
    return DeviceType.medium;
  } else {
    return DeviceType.compact;
  }
}

bool compact(BuildContext context) =>
    _displayTypeOf(context) == DeviceType.compact;

bool medium(BuildContext context) =>
    _displayTypeOf(context) == DeviceType.medium;

bool expanded(BuildContext context) =>
    _displayTypeOf(context) == DeviceType.expanded;
