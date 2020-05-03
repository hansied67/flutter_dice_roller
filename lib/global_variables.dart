import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class GlobalVariables extends ChangeNotifier {
  bool _isAndroid;
  bool _isMobile;

  GlobalVariables() {
    try {
      _isAndroid = Platform.isAndroid;
      _isMobile = false;
    } catch (e) {
      _isAndroid = true;
      _isMobile = true;
    }
  }

  bool get isAndroid => _isAndroid;
  bool get isMobile => _isMobile;
}