
import 'package:flutter/material.dart';

/// Converts an IconData to a Map.
/// Useful for saving IconData for further retreivement.
Map<String, dynamic> IconDataToMap(IconData iconData) {
  Map<String, dynamic> result = new Map<String, dynamic>.from({
    'codePoint': iconData.codePoint,
    'fontFamily': iconData.fontFamily,
    'fontPackage': iconData.fontPackage,
    'matchTextDirection': iconData.matchTextDirection
  });
  return result;
}

/// Converts a Map to IconData.
IconData MapToIconData(var code,font,package) {
  var map = {'codePoint': code, 'fontFamily': font, 'fontPackage': package, 'matchTextDirection': false};

  return new IconData(map['codePoint'],
      fontFamily: map['fontFamily'],
      fontPackage: map['fontPackage'],
      matchTextDirection: map['matchTextDirection']);
}
